# 👥 Team Project 카리나 대학교

# 💡 프로젝트 개요.
![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%201.png)
![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled.png)

---

### 🔗 **GitHub**

[mwsun0303 - Repositories](https://github.com/mwsun0303?tab=repositories)

- 기능 별 트래픽 대응을 목적으로 MSA 형태로 분리된 프로젝트 구축
    - **College_Student_Code** : 학생 관리, 관리자 기능 구현 코드
    - **College_Subject_Code** : 수강과목 관리, 수강신청 구현 코드
    - **College_Student_Chart** : 학생 관리 코드 Argo CD 배포 Helm Chart 
    - **College_Subject_Chart** : 수강과목 관리 코드 코드 Argo CD 배포 Helm Chart

---
- 👥 **인원 : 4인**
- **📅  프로젝트 기간 : 2023.12.27 ~ 2024.02.06 (약 6주)**
- **🔎  프로젝트 목적**
    - 대학교 수강신청 기간에 급증하는 대용량 트래픽에 대응하여 정상적인 서비스를 제공할 수 있도록 AWS Cloud와 Kubernetes를 활용한 고가용성 대학교 웹 서비스 구축 프로젝트
- **💡  역할**
    - 기획 (PL)
    - DB Table 설계
    - 개발 (학생 개인 수강 시간표 페이지)
    - Architecture 설계
    - CI/CD 구축
    - Kubernetes 환경 구성



---

# 💡 프로젝트 환경.

## Language.

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/JAVA.jpg" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/JAVA.jpg" width="40px" /> **Java**

</aside>

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/STS.jpg" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/STS.jpg" width="40px" /> **Spring (Maven)**

</aside>

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/JS.png" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/JS.png" width="40px" /> **Java Script**

</aside>

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Terraform.jpg" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Terraform.jpg" width="40px" /> **Terraform**

</aside>

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/VSCode.jpg" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/VSCode.jpg" width="40px" /> **VS Code**

</aside>

## DataBase.

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/MariaDB.jpg" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/MariaDB.jpg" width="40px" /> MariaDB

</aside>

## Tech.

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Git_Action.png" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Git_Action.png" width="40px" /> GitHub Action

</aside>

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/%25EC%25BF%25A0%25EB%25B2%2584%25EB%2584%25A4%25ED%258B%25B0%25EC%258A%25A4.png" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/%25EC%25BF%25A0%25EB%25B2%2584%25EB%2584%25A4%25ED%258B%25B0%25EC%258A%25A4.png" width="40px" /> Kubernetes

</aside>

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Hlem.png" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Hlem.png" width="40px" /> Helm

</aside>

## Tool.

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/AWS.jpg" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/AWS.jpg" width="40px" /> AWS Cloud

</aside>

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Argo_CD.png" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Argo_CD.png" width="40px" /> ArgoCD

</aside>

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Prometheus.png" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Prometheus.png" width="40px" /> **Prometheus**

</aside>

<aside>
<img src="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Grafana.jfif" alt="https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Grafana.jfif" width="40px" /> Grafana

</aside>



---

# 💡Architecture.

![EKS Architecture.drawio.png](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/EKS_Architecture.drawio.png)

| No | 구분 | 사양 | 사용목적 |
| --- | --- | --- | --- |
| 1 | Availability Zone | ap-northeast-2a | 고가용성을 위한 가용 영역 분리 |
| 2 | Availability Zone | ap-northeast-2c | 고가용성을 위한 가용 영역 분리 |
| 3 | Bastion Host | t2.micro | 관리자가 Infra (Kubernetes) 설정 용 가상 Server |
| 4 | Worker node | t3.large | Kubernetes 환경 구동 가상 Server |
| 5 | AWS Certificate Manager | CNAME | HTTPS (SSL) 인증서 |
| 6 | WAF | AWS Managed Rules Anonymous IP List | 익명 IP (VPN) 주소 차단 정책 |
| 7 | WAF | AWS Managed Rules Amazon IP Reputation List | AWS IP 주소 차단 정책 |
| 8 | Bastion Host Auto Scaling | Min 1EA ~ MAX 2EA | 일부 가용 영역 붕괴 시 Bastion Host 복구 용도 |
| 9 | Worker Node Auto Scaling | Min 2EA ~ MAX 4EA | Container 구동하는 Worker Node 수량 조절을 통한 고가용성 유지 |
| 10 | MariaDB | AWS RDS | AWS 완전 관리형 고가용성 DataBase |



---

# 💡 Database.

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%202.png)

### 1). Dark Data 방지 목적 DataBase Table 설계

- 기준이 되는 테이블들의 기본키를 각 테이블의 외래키로 사용
- **최소한의 종속성을 활용하여 DarkData 저장 방지**
    1. 학과 삭제 시 해당 학과의 연관 데이터를 함께 삭제 
        - 학과 게시글
        - 학과 과목
        - 수강 과목 장바구니 내역
        - 수강 스케줄 내역 삭제
    2. 학생 삭제 시 해당 학생의 연관 데이터를 함께 삭제   
        - 수강 과목 장바구니
        - 수강 스케줄 내역 삭제
    

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%203.png)

### 2). 안정적인 고가용성 목적의 DataBase 구축

- **EC2를 활용하고 Master/Slave 구조로 DB 설계하는 방식에서 RDS 사용을 결정**
    1. 스케일 조정을 통한 자동 사용량에 따른 유연한 확장 지원
    2. 완전 관리형 솔루션으로 관리 포인트 감소
    3. 실시간에 가까운 자동 백업으로 재해 복구 솔루션 수립
        - 복구된 데이터의 높은 신뢰도 보장
        - 높은 속도의 재해 복구

- **비용보다 가용성과 안정성에 초점을 둔 구축 진행**



---

# 💡 CI/CD.

### 🔎 CI/CD의 경우 Git Server + Jenkins CI에서 GitHub Action CI를 사용하기까지 과정과 이유를 담고 있습니다.

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%204.png)

---

### 1). Git Server + jenkins CI 사용

1. **Git Server를 선택한 이유**
    - 소스 코드의 외부 노출 방지
    - 소스 코드의 내부 보관
    - 보편적으로 사용되는 Build Tool, Jenkins의 사용 경험
    - On-Premiss 환경의 CI 유사 경험

---

1. **Git Server 구성**
    1. AWS EC2 Instance 사용, VPC내 Git Server 구현
    2. Git 설치 
    3. Jenkins 설치
    4. Git Server와 Jenkins의 권한 인증
        - 소스 코드의 소유는 **GIt Server**
        - Build 진행은 **Jenkins가 진행**
        - Build 진행을 위해선 Jenkins가 Git Server에 존재하는 **소스 코드 사용 사용자 권한이 필요**
        - Jenkins의 공개키를 Git Server의 authorized_keys 등록을 통해 인증
            
            ![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%205.png)
            

---

1. **ECR을 선택한 이유**
    - 보안상 유리한  Repository 사용
    - AWS 계정과 권한 부여 + 인증 후 사용할 수 있는 ECR 선택

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%206.png)

### 2). Git Hub Action을 사용한 이유

1. **불필요한 Resource 사용, 유지 비용 감소**
    - Git과 Jenkins의 설치와 운영을 위한 Instance
        - 2개 이상의 Build를 동시에 진행하기 위해 최소 t3.large 이상의 Instance 사용이 불가피
        - Git Server용 EC2를 사용하지 않기 때문에 **한 달 기준 약 50$의 비용 절감 효과 발생**
    - 소스 코드를 보관할 저장소
        - 소스 코드를 보관하고 관리하기 위한 별도의 저장소 탑재가 불가피

---

1. **편리함 증가**
    - CI 사전 구성 감소, 간단한 CI 구성이 가능
        - Build Tool 불필요
        - WebHook 불필요
        - Plug In 설치 불필요

---

1. **MSA 프로젝트 운영**
    - 소스 코드 Repository별로 동시에 Build하는 병렬 처리가 가능
    - 병렬 처리 시 내부 자원을 활용하지 않음
        - Infra 자체 부하 방지
        - 안정성 증가
    - 부가 기능 개발 프로젝트의 확장이 용이함
        - 여러 프로젝트를 사용할 수 있는 CI/CD 증설 가능

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%207.png)

1. **UI 지원을 통한 가시성 증가**
    - 기존 Git Server는 소스 코드를 압축 파일 형태인 Pack 파일로 저장 → Pull을 받아보기 전까지 Push 상태 확인 불가
    - GitHub에서 Push된 소스 코드 확인 가능
        - 소스 코드가 Push된 상태로 UI에서 수정 후 즉시 Commit이 가능
        - Helm Chart를 활용한 **ArgoCD 연동의 편의성 증가**

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%208.png)

### 3). Git Hub Action 사용

1. **GitHub 사용**
    - 프로젝트 별로 2가지의 Repository 사용
        1. 소스 코드 관리 Repository
        2. ArgoCD 사용을 위한 Helm Chart Repository
    - Git Action Flow
        1. Git Push
        2. jar image Build
        3. docker image Build
        4. Image to ECR Deploy
        5. Helm Chart 업데이트
        6. ArgoCD Synk

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%209.png)

1. **보안을 위한 Git Hub Secrets 사용** 
    - **Secrets 변수를 활용해 인증에 필요한 Access Key를 암호화 + 외부 노출 방지**
        1. AWS Access Key
            - AWS ECR Access 용도
        2. AWS Secret Key
            - AWS ECR Access 용도
        3. Git Hub Access Token
            - Helm Chart Replostory Access 용도
            - **Access Key 외부 노출 방지**

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2010.png)

1. **Build Image Version 관리 목적 Action Script 작성**
    - Image Build
        1. jar image Build
        2. Docker Image Build
            - Build Success 시 Helm Chart Update 호출
    - Helm Chart Update
        1. **Image Build 성공 시 Image Tag 생성**
        2. Git Action Image Build 과정에서 무작위 Hash값을 추출
        3.  [Project Type - Version (Hash값)] 형태로 Image Tag 생성
        4. Image Tag로 Build Image 생성
        5. Image를 ECR로 배포
    - **Values.yaml 파일 Replace**
        1. Pull Request로 Helm Chart Repository Action 진행
        2. 현재 생성된 Image Tag로 Replace (Auto Merge)
        3. 가장 최근에 Build된 Image를 배포
    
- **고유한 Tag명을 통해 배포된 Image Version 관리가 가능**

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2011.png)

### 4). ArgoCD

1. **ArgoCD 구성**
    - 옵션을 사용하여 Helm Chart의 내용을 절대적으로 유지할 수 있게 구성
        1. Prune Resource
            - Helm Chart의 구성을 유지하기 위해 증가된 Resource를 삭제할 수 있는 기능
        2. Self Heal
            - Helm Chart의 구성을 유지하기 위해 삭제된 Resource를 복원할 수 있는 기능 ****
    - Deployment strategy를 Rolling Update로 설정
        - **무중단 배포가 가능하게 설정**
            
            ![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2012.png)
            
    

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2013.png)

### 2. 배포 구성

1. **Service 이하 배포 자동화 구성**
    - Ingress는 정책의 일부라고 판단
    - 자동화보다 **관리자가 직접 설정하는 방향으로 구성**

---

1. **Service (Replicas (Pod)) 구성**
    - 학생 관리 측 대비 수강 신청 기능에 트래픽 집중을 예상하고 대비
    - 수강 관리 프로젝트 배포 Service의 Replicas (Pod)의 수량을 여유롭게 설정

---

1. **hpa (Horizontal Pod Autoscaling) 구성**
    - 수강 관리 Service의 hpa의 범위를 넓게 설정
    



---

# 💡 Kubernetes.

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2014.png)

### 1). AWS EKS를 활용한 Kubernetes 환경 구축

1. **Container Orchestration** 
    - Cluster : AWS EKS
    - Terraform의 외부 모듈을 사용하여 구현
        - VPC의 Private Subnet 사용
        - **IRSA (IAM Roles for Service Accounts)를 true로 설정**
    

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2015.png)

1. **IRSA** 
    - **IAM Roles for Service Accounts**
    - AWS Resource를 사용하기 위해서 Resource 권한과 역할이 존재하는 AWS 계정과 Service Account의 연동 필요
    - AWS의 ‘Sun_User’ 계정과 Kubernetes ‘admin’ Service Account 연동

 

💡 **Kubernetes에서 Sun_User 권한으로 AWS Resource 사용**

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2016.png)

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2017.png)

1. **Ingress** 
    - Ingress 구현
        - 설정한 Ingress의 정책을 기능으로 구현하고 적용하기 위해 별도의 LoadBalancer가 필요
        - AWS의 alb를 사용하여 구현
    - HTTPS 접속 설정
        - Route53의 Domain과 ACM 활용, HTTPS 인증 구성
        - HTTP (80번 Port) 접근 시 HTTPS(443번 Port)로 Redirect 규칙 적용
    - Domain 접속 정책 설정
        - Domain 주소의 Prefix에 따라 지정된 Service에 접속하는 Roututing 정책 설정
        1. Prefix가 다음과 같을 경우 **Student Service**로 접속
            - 기본 접속 경로
            - /student/~ 경로
            - /admin/~ 경로
        2. Prefix가 다음과 같을 경우 **Subject Service**로 접속
            - /sugang/~ 경로
        



---

# 🔧 Improvement.

### 🔎 프로젝트 종료 후 개인적으로 개선한 부분입니다.

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2018.png)

### 1). Kubernetes를 활용한 모니터링 도구의 활용도 개선

- 프로젝트 기간 시간 부족으로 인해 급하게 구성한 모니터링 구조의 아쉬움이 남았습니다.
- 프로젝트 종료 후, Kubernetes를 활용하여 Grafana의 구조를 변경해서 구성했습니다.

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2019.png)

### 2). Kubernetes, EFS를 활용한 Prometheus, Grafana 구성

1. **Kubernetes를 사용한 이유**
    - 비용 절약 효과
        - t3.large → t3.small Instance 사양으로 Bastion Host EC2 사용
        - 한 달 기준 약 40$의 비용 절약 효과 발생
    - 신속한 스케일 조정 및 재해 복구
        - EC2 대비 Pod의 신속한 재해 복구
        - EC2 대비 Pod의 신속한 스케일 조정

---

1. **EFS를 사용한 이유**
    - EBS의 한계
        - EKS의 WorkerNode, EC2의 EBS는 단일 AZ의 저장 제한이 존재
        - Multi AZ를 사용하는 현재 구성에서 **모든 AZ의 지표를 수집하고 저장하기 위해 EFS 사용을 결정**
        
        ---
        
    - 내구성이 뛰어난 File System의 필요성
        - Prometheus Pod 단절 시에도 이전에 수집한 지표의 보존이 가능

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2020.png)

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2021.png)

1. **EFS 구현**
    - Pod의 Master Node (EC2 WorkerNode)가 EFS를 접근해야 하기 때문에 동일한 Subnet, 보안 그룹 설정 필요
        - Subent, Security Group 설정
            - Worker Node와 동일한 Subnet 사용
            - Worker Node와 동일한 Security Group 사용
    
    ---
    
    - Worker Node의 Master Node (EKS)가 EFS를 관리해야 하기 때문에 EFS CSI 드라이버 설치
        - CSI Driver 설치
            - Worker Node에 EFS를 탑재
            - EKS Cluster에서 관리하기 위한 추가 기능
    

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2022.png)

1. **Prometheus, Grafana 구현**
    - 별도 namespace 생성
    - Helm Chart 활용하여 구성

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2023.png)

1. **PV, PVC 설정**
- **PV** (Persistent Volume)
    - Prometheus, Grafana 사용 목적의 Kubernetes Cluster 자체 저장 공간 (볼륨) 설정
- **PVC** (Persistent Volume Claim)
    - Cluster PV의 저장된 지표를 Read, Write 권한으로 EFS에 Mount
    - 다중 가용 영역의 지표를 모두 기록

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2024.png)

1. **Prometheus Service 노출, Grafana 연동**
- Prometheus
    - Ingress Domain 경로를 활용한 Service 노출
    - Port-Foward 사용의 경우
        - Port-Foward 설정 장비 연결 단절 시, 모니터링과 지표 수집 공백 발생 가능성 존재
        - 지속적인 지표 수집을 위해 domain 경로로 Prometheus Service 접근 구성
- Grafana
    - 시각화 자료의 외부 노출을 방지하기 위해 Port-Foward 활용
    

---

![Untitled](https://mwsun0303.s3.ap-northeast-2.amazonaws.com/Untitled%2025.png)

1. **Grafana를 활용한 시각화**
    - Prometheus가 실시간으로 수집한 지표를 Template을 활용하여 시각화 자료로 제공



---

# 💡 프로젝트 후기.

### 프로젝트의 결과보단 시도와 과정에 중점을 둔 기획

프로젝트를 시작하고 기획 단계부터 프로젝트가 끝날 때까지 팀원들에게 꾸준하게 한 말이 있습니다.

**이번 프로젝트에서는 우리가 직접 해보는 경험보다 더 높은 가치는 없다.**

단순히 인터넷 검색을 통한 구성과 구현의 결과보다 과정과 이유에 중점을 둔 프로젝트를 진행했습니다. 

다양한 CI/CD 방법을 비롯한 프로젝트 과정에서 더 나은 방법을 추구했고 실제로 여러 시도를 통해 시행착오를 겪고 성공을 하면서 초기 기획 의도와 부합하게 프로젝트를 마무리했습니다.

 

목표를 달성하고 성공적으로 프로젝트가 완료했다는 성취감을 함께 고생한 팀원들과 나눌 수 있어서 뿌듯했지만 한정된 시간에 구현하지 못한 기능에 대한 아쉬움도 남았습니다.

1. S3를 활용한 정적 파일들 보관, image 경량화
    
    jpg, css 등 총 20MB 정적 파일들을 Project의 static 경로를 사용하지 않고 AWS S3에 저장 후 공유해서 사용했다면 이미지 경량화를 노려볼 수 있다고 생각했습니다.
    
    하지만 모든 jsp의 image 경로를 수정하는 시간 대비 경량화를 기대할 수 있는 용량이 크지 않다고 판단해서 다른 기능 구현에 시간을 집중했습니다. 
    
2. 실시간 로그 수집 기능의 부재
    - Elasticsearch
    - Fluentd
    - Kibana
    
    위 3가지 Tool을 활용한 EFK 기능을 구현하지 못한 부분에 대한 아쉬움이 크게 남았습니다.
    
    엔지니어가 발생한 문제를 가장 빠르게 인지할 수 있는 수단이자 문제 해결 방법이 될 수 있는 핵심 기능이기에 아쉬움으로 남겨두지 않고 꼭 구현해 보자는 다음 목표가 생겼습니다.
    

---

©by.bomd 2024
