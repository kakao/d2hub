var buildTags;
var marathonDeploys;
var imageTags;

$(document).ready(function() {
    var pathname = $(location).attr('pathname');

    $("[rel='tooltip']").tooltip();

    $('#repoTab a').click(function (e) {
        e.preventDefault()
        $(this).tab('show')
    });

    $('#menuTab a').click(function (e) {
        e.preventDefault()
        $(this).tab('show')
    });

    $('.repo-panel').mouseover(function (e) {
        $(this).removeClass('panel-default');
        $(this).addClass('panel-primary');
    }).mouseleave(function (e) {
        $(this).removeClass('panel-primary');
        $(this).addClass('panel-default');
    });

    // $('#public-repo_type').click(function(e) {
    //     $('#private-repo-message').addClass('hide');
    //     $('#public-repo-message').removeClass('hide');
    // });
    // $('#private-repo_type').click(function(e) {
    //     $('#public-repo-message').addClass('hide');
    //     $('#private-repo-message').removeClass('hide');
    // });

    $('.comment-remove').click(function () {
       var commentId = $(this).data('comment-id');
       $('#comment-id').val(commentId);
    });

    // $('#enable_build').click(function(e) {
    //     $('#disable-build-message').addClass('hide');
    //     $('#enable-build-message').removeClass('hide');
    // });
    //
    // $('#disable_build').click(function(e) {
    //     $('#enable-build-message').addClass('hide');
    //     $('#disable-build-message').removeClass('hide');
    // });

    // $('.tag-remove').click(function () {
    //     var tagName = $(this).data('tag-name');
    //     $('#tag-name').val(tagName);
    // });

    $('.dropdown-toggle').dropdown();

    var mainMenuActive = function() {
        if ((/^\/users\/.+\/starred$/).test(pathname)) {
            $('#item_starred').addClass('active');
        } else if ((/^\/users\/.+$/).test(pathname)) {
            $('#item_summary').addClass('active');
        } else if ((/^\/orgs\/.+\/repos$/).test(pathname)) {
            $('#item_repos').addClass('active');
        }
    }();

    var editMenuActive = function() {
        if ((/^\/orgs\/.+\/edit\/member$/).test(pathname)) {
            $('#item-edit-member').addClass('active');
        } else if ((/^\/orgs\/.+\/edit\/profile/).test(pathname)) {
            $('#item-edit-profile').addClass('active');
        }
    }();

    $('.textarea-text').each(function(_index) {
        var new_text = $.trim($(this).text()).replace(/\n/g, '<br/>');
        $(this).replaceWith(new_text);
    });

    marathonDeploys = new Vue({
        el: '#marathonDeploys',
        data: {
            build_tags: [],
            deploys: [],
            selectedBuildTag: null,
            deployObj: {
                marathon_url: '',
                marathon_basic_auth: '',
                marathon_json_path: '',
                env_vars: '',
                label_vars: ''
            },
            newApp: {
                id: '',
                image: '',
                port: 0,
                cpus: 0.1,
                memory: 256,
                healthCheckPath: ''
            },
            appJSON: {
                id: '',
                cmd: null,
                cpus: 0.1,
                mem: 256,
                instances: 1,
                container: {
                    type: "DOCKER",
                    docker: {
                        image: '',
                        network: "BRIDGE",
                        portMappings: [
                            {
                                containerPort: 0,
                                hostPort: 0,
                                servicePort: 0,
                                protocol: "tcp"
                            }
                        ],
                        forcePullImage: true
                    }
                }
            }
        },
        methods: {
            add: function () {
                var pathIndex = pathname.indexOf('/marathon_deploy');
                if (pathIndex > -1) {
                    var url = '/api/' + pathname.substring(0, pathIndex) + '/build_tags/' + this.selectedBuildTag.id + '/marathon_deploys';
                    $.ajax({
                        url: url,
                        type: 'POST',
                        data: this.deployObj
                    }).done(function () {
                        this.deploys.push(this.deployObj);
                        $('#marathonDeployModal').modal('hide');
                    }.bind(this)).fail(function () {
                        alert('Marathon 배포 설정 추가에 실패했습니다.\n관리자에게 문의하세요.');
                        $('#marathonDeployModal').modal('hide');
                    }.bind(this));
                }
            },
            update: function () {
                var pathIndex = pathname.indexOf('/marathon_deploy');
                if (pathIndex > -1) {
                    var url = '/api/' + pathname.substring(0, pathIndex) + '/build_tags/' + this.selectedBuildTag.id + '/marathon_deploys/' + this.deployObj.id;
                    $.ajax({
                        url: url,
                        type: 'PUT',
                        data: this.deployObj
                    }).done(function () {
                        $('#marathonDeployModal').modal('hide');
                    }).fail(function () {
                        alert('Marathon 배포 설정 업데이트에 실패했습니다.\n관리자에게 문의하세요.');
                        $('#marathonDeployModal').modal('hide');
                    });
                }
            },
            remove: function (deploy) {
                if (!confirm('Marathon 배포 설정을 정말 삭제하시겠습니까?')) {
                    return;
                }
                var pathIndex = pathname.indexOf('/marathon_deploy');
                if (pathIndex > -1) {
                    var url = '/api/' + pathname.substring(0, pathIndex) + '/build_tags/' + this.selectedBuildTag.id + '/marathon_deploys/' + deploy.id;
                    $.ajax({
                        url: url,
                        type: 'DELETE'
                    }).done(function () {
                        var rindex = this.deploys.indexOf(deploy)
                        this.deploys.splice(rindex, 1);
                        $('#marathonDeployModal').modal('hide');
                    }.bind(this)).fail(function () {
                        alert('Marathon 배포 설정 삭제에 실패했습니다.\n관리자에게 문의하세요.');
                        $('#marathonDeployModal').modal('hide');
                    }.bind(this));
                }
            },
            initDeployObj: function () {
                this.deployObj = {
                    marathon_url: '',
                    marathon_basic_auth: '',
                    marathon_json_path: '',
                    env_vars: '',
                    label_vars: ''
                }
            },
            isValidDeployObj: function () {
                return this.deployObj.marathon_url != '' && this.deployObj.marathon_json_path != '';
            },
            setDeployObj: function (deploy) {
                this.deployObj = deploy;
            },
            isValidNewApp: function () {
                console.log(this.newApp);
                return this.newApp.id != ''
                    && (this.newApp.port > -1)
                    && (this.newApp.cpus > 0)
                    && (this.newApp.memory > 0);
            },
            selectBuildTag: function(build_tag) {
                this.selectedBuildTag = build_tag;
            }
        }
    });

    kubernetesDeploys = new Vue({
        el: '#kubernetesDeploys',
        data: {
            build_tags: [],
            deploys: [],
            selectedBuildTag: null,
            deployObj: {
                kubernetes_url: '',
                kubernetes_kubeconfig: '',
                kubernetes_yaml_path: '',
                env_vars: ''
            },
            newApp: {
                id: '',
                image: '',
                port: 0,
                cpus: 0.1,
                memory: 256,
                healthCheckPath: ''
            },
            appJSON: {
                id: '',
                cmd: null,
                cpus: 0.1,
                mem: 256,
                instances: 1,
                container: {
                    type: "DOCKER",
                    docker: {
                        image: '',
                        network: "BRIDGE",
                        portMappings: [
                            {
                                containerPort: 0,
                                hostPort: 0,
                                servicePort: 0,
                                protocol: "tcp"
                            }
                        ],
                        forcePullImage: true
                    }
                }
            }
        },
        methods: {
            add: function () {
                var pathIndex = pathname.indexOf('/kubernetes_deploy');
                if (pathIndex > -1) {
                    var url = '/api/' + pathname.substring(0, pathIndex) + '/build_tags/' + this.selectedBuildTag.id + '/kubernetes_deploys';
                    $.ajax({
                        url: url,
                        type: 'POST',
                        data: this.deployObj
                    }).done(function () {
                        this.deploys.push(this.deployObj);
                        $('#kubernetesDeployModal').modal('hide');
                    }.bind(this)).fail(function () {
                        alert('Kubernetes 배포 설정 추가에 실패했습니다.\n관리자에게 문의하세요.');
                        $('#kubernetesDeployModal').modal('hide');
                    }.bind(this));
                }
            },
            update: function () {
                var pathIndex = pathname.indexOf('/kubernetes_deploy');
                if (pathIndex > -1) {
                    var url = '/api/' + pathname.substring(0, pathIndex) + '/build_tags/' + this.selectedBuildTag.id + '/kubernetes_deploys/' + this.deployObj.id;
                    $.ajax({
                        url: url,
                        type: 'PUT',
                        data: this.deployObj
                    }).done(function () {
                        $('#kubernetesDeployModal').modal('hide');
                    }).fail(function () {
                        alert('Kubernetes 배포 설정 업데이트에 실패했습니다.\n관리자에게 문의하세요.');
                        $('#kubernetesDeployModal').modal('hide');
                    });
                }
            },
            remove: function (deploy) {
                if (!confirm('Kubernetes 배포 설정을 정말 삭제하시겠습니까?')) {
                    return;
                }
                var pathIndex = pathname.indexOf('/kubernetes_deploy');
                if (pathIndex > -1) {
                    var url = '/api/' + pathname.substring(0, pathIndex) + '/build_tags/' + this.selectedBuildTag.id + '/kubernetes_deploys/' + deploy.id;
                    $.ajax({
                        url: url,
                        type: 'DELETE'
                    }).done(function () {
                        var rindex = this.deploys.indexOf(deploy)
                        this.deploys.splice(rindex, 1);
                        $('#kubernetesDeployModal').modal('hide');
                    }.bind(this)).fail(function () {
                        alert('Kubernetes 배포 설정 삭제에 실패했습니다.\n관리자에게 문의하세요.');
                        $('#kubernetesDeployModal').modal('hide');
                    }.bind(this));
                }
            },
            initDeployObj: function () {
                this.deployObj = {
                    kubernetes_url: '',
                    kubernetes_kubeconfig: '',
                    kubernetes_yaml_path: '',
                    env_vars: ''
                }
            },
            isValidDeployObj: function () {
                return this.deployObj.kubernetes_url != ''
                    && this.deployObj.kubernetes_yaml_path != ''
                    && this.deployObj.kubernetes_kubeconfig != '';
            },
            setDeployObj: function (deploy) {
                this.deployObj = deploy;
            },
            isValidNewApp: function () {
                console.log(this.newApp);
                return this.newApp.id != ''
                    && (this.newApp.port > -1)
                    && (this.newApp.cpus > 0)
                    && (this.newApp.memory > 0);
            },
            selectBuildTag: function(build_tag) {
                this.selectedBuildTag = build_tag;
            }
        }
    });


    var clipboard = new ClipboardJS('#copyNewAppJSON', { container: document.getElementById('marathonAppJSON'),
            text: function() {
            var newApp = marathonDeploys.newApp;
            marathonDeploys.appJSON.id = newApp.id;
            marathonDeploys.appJSON.container.docker.image = newApp.image;
            marathonDeploys.appJSON.container.docker.portMappings[0].containerPort = newApp.port;
            marathonDeploys.appJSON.cpus = newApp.cpus;
            marathonDeploys.appJSON.mem = newApp.memory;
            if (newApp.healthCheckPath && newApp.healthCheckPath != '') {
                marathonDeploys.appJSON.healthChecks = [
                    {
                        path: newApp.healthCheckPath,
                        protocol: "HTTP",
                        portIndex: 0
                    }

                ]
            }
            return JSON.stringify(marathonDeploys.appJSON, null, '\t');
        }
    });
    clipboard.on("success", function( e ) {
        alert("JSON이 복사되었습니다.");
    });

    $('#marathonDeployModal').on('hide.bs.modal', function(e) {
        marathonDeploys.initDeployObj();
    });

    $('.clickable-table').on('click', '.clickable-row', function(event) {
        $(this).addClass('info').siblings().removeClass('info');

        var index = pathname.indexOf('/marathon_deploy');
        if (index > -1) {
            var url = '/api/' + pathname.substring(0, index) + '/build_tags/' + marathonDeploys.selectedBuildTag.id + '/marathon_deploys';
            $.ajax({
                url: url,
                type: 'GET'
            }).done(function (data) {
                marathonDeploys.deploys = JSON.parse(data);
            }).fail(function (err) {
                console.log(err);
            });
        }
    });

    var index = pathname.indexOf('/marathon_deploy');
    if (index > -1) {
        var url = '/api/' + pathname.substring(0, index) + '/build_tags';
        $.ajax({
            url: url,
            type: 'GET'
        }).done(function(data) {
            marathonDeploys.build_tags = JSON.parse(data);
        }).fail(function () {
            console.log('error');
        });
    }

    var clipboard = new ClipboardJS('#copyNewKubernetesAppJSON', { container: document.getElementById('kubernetesAppJSON'),
        text: function() {
            var newApp = kubernetesDeploys.newApp;
            kubernetesDeploys.appJSON.id = newApp.id;
            kubernetesDeploys.appJSON.container.docker.image = newApp.image;
            kubernetesDeploys.appJSON.container.docker.portMappings[0].containerPort = newApp.port;
            kubernetesDeploys.appJSON.cpus = newApp.cpus;
            kubernetesDeploys.appJSON.mem = newApp.memory;
            if (newApp.healthCheckPath && newApp.healthCheckPath != '') {
                kubernetesDeploys.appJSON.healthChecks = [
                    {
                        path: newApp.healthCheckPath,
                        protocol: "HTTP",
                        portIndex: 0
                    }

                ]
            }
            return JSON.stringify(kubernetesDeploys.appJSON, null, '\t');
        }
    });
    clipboard.on("success", function( e ) {
        alert("JSON이 복사되었습니다.");
    });

    $('#kubernetesDeployModal').on('hide.bs.modal', function(e) {
        kubernetesDeploys.initDeployObj();
    });

    $('.clickable-table').on('click', '.clickable-row', function(event) {
        $(this).addClass('info').siblings().removeClass('info');

        var index = pathname.indexOf('/kubernetes_deploy');
        if (index > -1) {
            var url = '/api/' + pathname.substring(0, index) + '/build_tags/' + kubernetesDeploys.selectedBuildTag.id + '/kubernetes_deploys';
            $.ajax({
                url: url,
                type: 'GET'
            }).done(function (data) {
                kubernetesDeploys.deploys = JSON.parse(data);
            }).fail(function (err) {
                console.log(err);
            });
        }
    });

    var index = pathname.indexOf('/kubernetes_deploy');
    if (index > -1) {
        var url = '/api/' + pathname.substring(0, index) + '/build_tags';
        $.ajax({
            url: url,
            type: 'GET'
        }).done(function(data) {
            kubernetesDeploys.build_tags = JSON.parse(data);
        }).fail(function () {
            console.log('error');
        });
    }

    buildTags = new Vue({
        el: '#buildTags',
        data: { tags: [] },
        methods: {
            addDockerTag: function() {
                var firstDockerTag = buildTags.tags[0];
                buildTags.tags.push({
                    git_type: firstDockerTag.git_type,
                    git_branch_name: firstDockerTag.git_branch_name,
                    dockerfile_location: firstDockerTag.dockerfile_location,
                    dockerfile_name: firstDockerTag.dockerfile_name,
                    dockerbuild_arg: firstDockerTag.dockerbuild_arg,
                    docker_tag_name: firstDockerTag.docker_tag_name,
                    use_regex: firstDockerTag.use_regex
                });
            },
            removeDockerTag: function(index) {
                buildTags.tags.splice(index, 1);
            },
            fillFormValue: function() {
                $('#buildTagsFormValue').attr('value', JSON.stringify(buildTags.tags));
            }
        }
    });

    if (pathname.indexOf('/builds/github/') > -1) {
        buildTags.tags.push({
            git_type: 'Branch',
            git_branch_name: 'master',
            dockerfile_location: '/',
            dockerfile_name: 'Dockerfile',
            docker_tag_name: 'latest',
            dockerbuild_arg: '',
            use_regex: false
        });
    }

    var index = pathname.indexOf('/automated_builds');
    if (index > -1) {
        var url = '/api/' + pathname.substring(0, index) + '/build_tags';
        $.ajax({
            url: url,
            type: 'GET'
        }).done(function(data) {
            buildTags.tags = JSON.parse(data);
        }).fail(function () {
            console.log('error');
        });
    }

    imageTags = new Vue({
        el: '#imageTags',
        data: { tags: [] },
        methods: {
            drscanResultURL: function(ticketID) {
                return 'https://scan.url/' + ticketID + '/'
            }
        }
    });

    if (pathname.indexOf('/repos') > -1 && $(location).attr('hash')) {
        $('#repoTab a[href="' + $(location).attr('hash') + '"]').tab('show');
    }

    if (pathname.indexOf('/orgs/') > -1 && pathname.indexOf('/repos/') > -1) {
        var url = '/api' + pathname + '/tags';
        $.ajax({
            url: url,
            type: 'GET'
        }).done(function(data) {
            imageTags.tags = JSON.parse(data);
        }).fail(function () {
            console.log('error');
        });
    }

    var index = pathname.indexOf('/marathon_deploy');
    if (index > -1) {
        var url = '/api/' + pathname.substring(0, index) + '/build_tags';
        $.ajax({
            url: url,
            type: 'GET'
        }).done(function(data) {
            marathonDeploys.build_tags = JSON.parse(data);
        }).fail(function () {
            console.log('error');
        });
    }
});

var clickStarToRepo = function(orgName, repoName) {
    var isCheckStar = $('#star-disable-icon').hasClass('hide');
    var method = (isCheckStar ? 'DELETE' : 'POST');

    $.ajax({
        url: '/orgs/' + orgName + '/repos/' + repoName + '/star',
        type: method
    }).done(function() {
        var starCountElem = $('#star-count');
        if (method == 'POST') {
            $('#star-disable-icon').addClass('hide');
            $('#star-enable-icon').removeClass('hide');
            starCountElem.text( parseInt(starCountElem.text()) + 1 );
        } else {
            $('#star-disable-icon').removeClass('hide');
            $('#star-enable-icon').addClass('hide');
            starCountElem.text( parseInt(starCountElem.text()) - 1 );
        }
    }).fail(function () {

    });
};

var makeAccessType = function(orgName, repoName, accessType, modalElem) {
    $.ajax({
        url: '/orgs/' + orgName + '/repos/' + repoName,
        type: 'PUT',
        data: { access_type: accessType }
    }).done(function() {
        modalElem.on('hidden.bs.modal', function(e) {
            location.reload();
        });
        modalElem.modal('hide');
    }).fail(function () {
        modalElem.modal('hide');
    });
};

var makePrivate = function(orgName, repoName) {
    makeAccessType(orgName, repoName, 'private', $('#makePrivateModal'));
};

var makePublic = function (orgName, repoName) {
    makeAccessType(orgName, repoName, 'public', $('#makePublicModal'));
};

var deleteRepository = function(userName, orgName, repoName) {
    var modalElem = $('#deleteRepositoryModal');
    $.ajax({
        url: '/orgs/' + orgName + '/repos/' + repoName,
        type: 'DELETE'
    }).done(function() {
        modalElem.on('hidden.bs.modal', function (e) {
            location.href = '/users/' + userName;
        });
        modalElem.modal('hide');
    }).fail(function () {
        modalElem.modal('hide');
    });
};

var deleteOrganization = function(userName, orgName) {
    var modalElem = $('#deleteOrganizationModal');
    $.ajax({
        url: '/orgs/' + orgName,
        type: 'DELETE'
    }).done(function() {
        modalElem.on('hidden.bs.modal', function (e) {
            location.href = '/users/' + userName;
        });
        modalElem.modal('hide');
    }).fail(function () {
        modalElem.modal('hide');
    });
};

var changeLanguage = function () {
    $.ajax({
        url: '/change_language',
        type: 'PUT'
    }).done(function() {
        location.reload();
    }).fail(function () {
    });
};

var deleteComment = function() {
    var commentId = $('#comment-id').val();
    var modalElem = $('#deleteCommentModal');
    $.ajax({
        url: '/comments/' + commentId,
        type: 'DELETE'
    }).done(function() {
        modalElem.on('hidden.bs.modal', function (e) {
            location.reload();
        });
        modalElem.modal('hide');
    }).fail(function () {
        modalElem.modal('hide');
    });
};

var openCommentForm = function() {
    $('#comment-open-btn').addClass('hide');
    $('#comment-close-btn').removeClass('hide');
    $('#comment-form').removeClass('hide');
};

var closeCommentForm = function() {
    $('#comment-close-btn').addClass('hide');
    $('#comment-open-btn').removeClass('hide');
    $('#comment-form').addClass('hide');
};

var checkCommentForm = function() {
    if ($('#comment-contents').val() == '') {
        $('#empty-contents-error').removeClass('hide');
        return false;
    } else {
        return true;
    }
};

var deleteImage = function(orgName, repoName) {
    var tagName = $('#tag-name').val();
    var modalElem = $('#deleteImageModal');
    $.ajax({
        url: '/orgs/' + orgName + '/repos/' + repoName + '/tags/' + tagName,
        type: 'DELETE'
    }).done(function() {
        modalElem.on('hidden.bs.modal', function (e) {
            location.reload();
        });
        modalElem.modal('hide');
    }).fail(function () {
        modalElem.modal('hide');
    });
};

var saveRepo = function() {
    buildTags.fillFormValue();
    return true;
};

var viewPayloadDetail = function(payloadID) {
    $('[id^=payload-detail-]').each(function() {
        $(this).addClass('hidden');
    });

    var elem = $('#payload-detail-' + payloadID);
    if (elem.hasClass('hidden')) {
        elem.removeClass('hidden')
    } else {
        elem.addClass('hidden')
    }
};

var fixRepoTab = function(tabName) {
    location.replace(location.origin + location.pathname + '#' + tabName);
};