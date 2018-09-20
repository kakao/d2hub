require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/kubernetes_deploy'

module D2HUB
  describe UpdateKubernetesDeploy do
    subject { UpdateKubernetesDeploy }

    let(:build_tag_id) { 1 }
    let(:kubernetes_deploy_id) { 1 }
    let(:params) do {
      kubernetes_url:  'test_url',
      kubernetes_kubeconfig:  'test_kubeconfig',
      kubernetes_yaml_path:  'test_yamlpath',
      env_vars:  'ENV01=VAL01',
    }
    end

    let(:update_url) { 'update_url'}
    let(:update_kubeconfig) { 'update_kubeconfig'}
    let(:update_yaml_path) { 'update_yaml_path'}
    let(:update_env_vars) { 'update_env_vars'}

    let(:repo_params) do
      {
          org_name: 'test_user',
          repo_name: 'test_repo',
          description: 'test repository'
      }
    end
    let(:user_name) { 'test_user' }
    before do
      CreateUser.run user_name: user_name
      new_repo = CreateRepository.run repo_params
      new_repo.add_build_tag git_type: 'Branch',
                              git_branch_name: 'master',
                              dockerfile_location: '/',
                              docker_tag_name: 'latest',
                              use_regex: false,
                              dockerfile_name: 'Dockerfile',
                              dockerbuild_arg: ''
    end

    it 'should update kubernetes deploy' do
      kubernetes_deploy = CreateKubernetesDeploy.run build_tag_id: build_tag_id,
                                 kubernetes_url: params[:kubernetes_url],
                                 kubernetes_kubeconfig: params[:kubernetes_kubeconfig],
                                 kubernetes_yaml_path: params[:kubernetes_yaml_path],
                                 env_vars: params[:env_vars]
      expect(kubernetes_deploy[:kubernetes_url]).to eq params[:kubernetes_url]
      expect(kubernetes_deploy[:kubernetes_yaml_path]).to eq params[:kubernetes_yaml_path]

      UpdateKubernetesDeploy.run kubernetes_deploy_id: kubernetes_deploy_id,
                                 kubernetes_url: update_url,
                                 kubernetes_kubeconfig: update_kubeconfig,
                                 kubernetes_yaml_path: update_yaml_path,
                                 env_vars: update_env_vars
      updated_deploy = GetKubernetesDeploy.run kubernetes_deploy_id: kubernetes_deploy_id
      expect(updated_deploy[:kubernetes_url]).to eq update_url
      expect(updated_deploy[:kubernetes_kubeconfig]).to eq update_kubeconfig
      expect(updated_deploy[:kubernetes_yaml_path]).to eq update_yaml_path
      expect(updated_deploy[:env_vars]).to eq update_env_vars
    end
  end
end