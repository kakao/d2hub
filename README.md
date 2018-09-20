# d2hub - kakao Docker Hub #

kakao docker hub 입니다.

## 테스트 돌리기
```
rspec
```

## 개발 환경 (for mac) ##

1. [ruby 2.1.3 설치 (rvm 추천)](http://rvm.io/)
    
        curl -sSL https://get.rvm.io | bash -s stable
        rvm install ruby-2.1.3
        rvm alias create default ruby-2.1.3
    
1. [docker 설치](https://docs.docker.com/docker-for-mac/)
1. [docker-compose 설치](https://docs.docker.com/compose/install/)
1. insecure registries 등록
    
    "{본인 mac IP}:5002"를 insecure registries로 등록 
        
    ![docker_1](https://github.com/kakao/d2hub/raw/master/docker_1.png)
    ![docker_2](https://github.com/kakao/d2hub/raw/master/docker_2.png)
        
1. git clone
	
		git clone git@github.com:kakao/d2hub.git

1. 디렉토리 이동

		cd d2hub
	
1. prepare_for_development.sh 실행 (docker-compose를 통해 개발에 필요한 컨테이너들 실행)

		./prepare_for_development.sh

1. bundle install 실행

		bundle install

1. d2hub 서버 실행

		bundle exec rackup -p 9292

1. localhost:9292 접근

		open http://localhost:9292


## 전체 구조

    ![d2hub](https://github.com/kakao/d2hub/raw/master/d2hub.jpg)


## License

This software is licensed under the [Apache 2 license](LICENSE.txt), quoted below.

Copyright 2018 Kakao Corp. <http://www.kakaocorp.com>

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this project except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
