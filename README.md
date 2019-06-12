# AWS Elastic Beanstalk Python worker image
Example Python worker image for AWS Elastic Beanstalk. For more information on EB worker environments: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features-managing-env-tiers.html

This image uses gunicorn and Flask to listen to `localhost:80`, which is where the EB worker daemon sends messages from SQS.
