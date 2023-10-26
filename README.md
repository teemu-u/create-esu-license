# Create ESU licenses for Azure Arc resources at scale

Sometimes there is a need to create ESU liceses per environment or even per server.
This can be a daunting task and therefore I created this script to aid you.

You could have simple mapping CSV file like this:

```csv
"LicenseName";"ResourceGroup";"SubscriptionId";"CoreCount";"CoreType";"OS";"LicenseEdition";"Tags"
"License1";"test";"23131saf-c3b1-416f-b78e-3c23451234sd";"12";"vCore";"Windows Server 2012";"Standard";"Datacenter=DC1,City=Helsinki"
"License2";"test";"23131saf-c3b1-416f-b78e-3c23451234sd";"8";"pCore";"Windows Server 2012 R2";"Datacenter";"Datacenter=DC1,City=Helsinki"
"License3";"test";"23131saf-c3b1-416f-b78e-3c23451234sd";"16";"vCore";"Windows Server 2012 R2";"Standard";"Datacenter=DC1,City=Oulu"
```

You can also use Excel to edit that file content:

![Use Excel to edit mapping file](https://github.com/teemu-u/create-esu-license/assets/24694770/9db5bcc0-b4c0-402a-9af3-d9e216bf3e66)

If no mapping is found or it is empty, the script will exit

Currently the script requires interactive login with your credentials to acquire a token to make API calls.
