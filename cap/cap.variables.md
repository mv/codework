
namespace :info do

  desc "Show cap variables"
  task :show do
    run <<-RUN
      echo "deploy_to         : #{deploy_to}";
      echo "shared_path       : #{shared_path}";
      echo "releases_path     : #{releases_path}";
      echo "releases          : #{releases}";
      echo "release_name      : #{release_name}";
      echo ;
      echo "current_path      : #{current_path}";
      echo "release_path      : #{release_path}";
      echo "current_release   : #{current_release}";
      echo "latest_release    : #{latest_release}";
      echo "previous_release  : #{previous_release}";
      echo ;
      echo "current_revision  : #{current_revision}";
      echo "latest_revision   : #{latest_revision}";
      echo "previous_revision : #{previous_revision}";
    RUN
  end

end # namespace

 ** [out :: web-01b] deploy_to         : /eden/app/dinda
 ** [out :: web-01b] shared_path       : /eden/app/dinda
 ** [out :: web-01b] releases_path     : /eden/app/dinda/releases
 ** [out :: web-01b] releases          : [2013-06-22-190227, 2013-06-23-193122, 2013-06-25-132340]
 ** [out :: web-01b] release_name      : 2013-06-25_14-44-59  # Release.new!
 ** [out :: web-01b]
 ** [out :: web-01b] current_path      : /eden/app/dinda/current
 ** [out :: web-01b] release_path      : /eden/app/dinda/releases/2013-06-25_14-44-59
 ** [out :: web-01b] current_release   : /eden/app/dinda/releases/2013-06-25-132340
 ** [out :: web-01b] latest_release    : /eden/app/dinda/releases/2013-06-25-132340
 ** [out :: web-01b] previous_release  : /eden/app/dinda/releases/2013-06-23-193122
 ** [out :: web-01b]
 ** [out :: web-01b] current_revision  : 6178f0e4592dcbf8af8fdbfef132343fdd51f28f
 ** [out :: web-01b] latest_revision   : 6178f0e4592dcbf8af8fdbfef132343fdd51f28f
 ** [out :: web-01b] previous_revision : c263765a6058a6a2686fa5d26e6ee620c5a09600


{
   "Statement" : {
      "Sid":"ReadFromEdenbrPrd",
      "Effect":"Allow",
      "Principal" : { "AWS":"863257025549" },
      "Action":"s3:*",
      "Resource":"arn:aws:s3:::sp-dinda-deploy/*"
   }
}

{
	"Statement": [
    { "Sid": "ListFromEdenbrPrd",
			"Effect": "Allow",
			"Principal": { "AWS": "arn:aws:iam::863257025549:root" },
			"Action": "s3:List*",
			"Resource": "arn:aws:s3:::sp-dinda-deploy"
		} ,
    { "Sid": "ReadFromEdenbrPrd",
			"Effect": "Allow",
			"Principal": { "AWS": "arn:aws:iam::863257025549:root" },
			"Action": "s3:Get*",
			"Resource": "arn:aws:s3:::sp-dinda-deploy/*"
		}
  ]
}

{
	"Version": "2008-10-17",
	"Statement": [
		{
			"Sid": "ReadFromEdenbrPrd",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::863257025549:root"
			},
			"Action": "s3:*",
			"Resource": ["arn:aws:s3:::sp-dinda-deploy","arn:aws:s3:::sp-dinda-deploy/*"]
		}
	]
}
