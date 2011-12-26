
# ami-3c3be421 : sa - Amazon Linux x86_64

ec2-run-instances --region sa-east-1 -z sa-east-1a -g server -k marcus_anirul -t t1.micro ami-3c3be421
ec2-run-instances --region sa-east-1 -z sa-east-1b -g server -k marcus_anirul -t t1.micro ami-3c3be421

# ec2-terminate-instances --region sa-east-1 i-0409aa19 i-3c09aa21

