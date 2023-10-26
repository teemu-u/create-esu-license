# Create ESU licenses for Azure Arc resources

You could have simple mapping CSV file like this:

```csv
"LicenseName";"ResourceGroup";"SubscriptionId";"CoreCount";"CoreType";"OS";"LicenseEdition";"Tags"
"License1";"test";"f492f182-c3b1-416f-b78e-3c0b77375c31";"12";"vCore";"Windows Server 2012";"Standard";"Datacenter=DC1,City=Helsinki"
"License2";"test";"f492f182-c3b1-416f-b78e-3c0b77375c31";"8";"pCore";"Windows Server 2012 R2";"Datacenter";"Datacenter=DC1,City=Helsinki"
"License3";"test";"f492f182-c3b1-416f-b78e-3c0b77375c31";"16";"vCore";"Windows Server 2012 R2";"Standard";"Datacenter=DC1,City=Oulu"
```

You can also use Excel to edit that file content:

![Use Excel to edit mapping file](https://github.com/teemu-u/create-esu-license/assets/24694770/9db5bcc0-b4c0-402a-9af3-d9e216bf3e66)

If no mapping is found or it is empty, the script will exit

Currently the script requires interactive login with your credentials to acquire a token to make API calls.
