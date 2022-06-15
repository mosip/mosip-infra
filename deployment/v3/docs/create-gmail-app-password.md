# Create Gmail APP Password To Send Mails Via SMTP



1. Remove below properties from kernel-default.properties or kernel-*.properties file in config if the property exists.
   ```
   management.health.mail.enabled
   mosip.kernel.sms.proxy-sms
   mosip.kernel.mail.proxy-mail
   ```
2. Create new gmail account via [link](https://accounts.google.com/signup/v2/webcreateaccount?continue=https%3A%2F%2Faccounts.google.com%2F&dsh=S856407536%3A1655162931377859&biz=false&flowName=GlifWebSignIn&flowEntry=SignUp) if email does not exist.
3. Login to the gmail account via [link](https://accounts.google.com/signin) <br>
   Enter your email ID.<br>
   ![create-gmail-app-pwd-1.png](images/create-gmail-app-pwd-1.png)<br>
   Enter your password.<br>
   ![create-gmail-app-pwd-2.png](images/create-gmail-app-pwd-2.png)<br>
4. Goto `security` section and enable `Use your phone to sign in`.<br>
   ![create-gmail-app-pwd-3.png](images/create-gmail-app-pwd-3.png)<br>
   Click on `Next`.<br>
   ![create-gmail-app-pwd-4.png](images/create-gmail-app-pwd-4.png)<br>
   Provide password<br>
   ![create-gmail-app-pwd-2.png](images/create-gmail-app-pwd-2.png)<br>
   Click on `Send` to get OTP to your mobile number<br>
   ![create-gmail-app-pwd-5.png](images/create-gmail-app-pwd-5.png)<br>
   Enter `OTP` which is sent to your mobile number and click on `Next`.<br>
   ![create-gmail-app-pwd-6.png](images/create-gmail-app-pwd-6.png)<br>
   Make sure that you have logged into your mobile with the same Gmail ID used here.<br>
   Select your `phone` and click on `Next`.<br>
   ![create-gmail-app-pwd-7.png](images/create-gmail-app-pwd-7.png)<br>
   Enter your `Gmail-ID` and click on `Next`.<br>
   ![create-gmail-app-pwd-8.png](images/create-gmail-app-pwd-8.png)<br>
   Click on `YES` from your mobile.<br>
   ![create-gmail-app-pwd-9.png](images/create-gmail-app-pwd-9.png)<br>
   Click on `Turn On` to start using your phone to sign in.<br>
   ![create-gmail-app-pwd-10.png](images/create-gmail-app-pwd-10.png)<br>
   `Use your phone to sign in` is enabled for your Gmail-ID.<br>
   ![create-gmail-app-pwd-11.png](images/create-gmail-app-pwd-11.png)<br>
5. Goto `security` section and click on `2-Step Verification`.<br>
   ![create-gmail-app-pwd-12.png](images/create-gmail-app-pwd-12.png)<br>
   Click on 'Get Started' to enable `2-Step Verification`.<br>
   ![create-gmail-app-pwd-13.png](images/create-gmail-app-pwd-13.png)<br>
   You have to use your mobile to allow to signIn and provide OTP for the same.<br>
   Click on `continue`.<br>
   ![create-gmail-app-pwd-14.png](images/create-gmail-app-pwd-14.png)<br>
   Provide your mobile number and click on `Send`.<br>
   ![create-gmail-app-pwd-15.png](images/create-gmail-app-pwd-15.png)<br>
   Enter confirmation `OTP` and click on `Next`.<br>
   ![create-gmail-app-pwd-16.png](images/create-gmail-app-pwd-16.png)<br>
   Click on `Turn On` to enable `Two-step verification`.<br>
   ![create-gmail-app-pwd-17.png](images/create-gmail-app-pwd-17.png)<br>
   Two-step verification has been enabled.<br>
   ![create-gmail-app-pwd-18.png](images/create-gmail-app-pwd-18.png)<br>
6. Click on `App passwords` to generate password for third party apps.<br>
   ![create-gmail-app-pwd-19.png](images/create-gmail-app-pwd-19.png)<br>
   Enter the password of your Gmail account > continue.<br>
   Click on `Select app` > select `Other (Custom name)`<br>
   ![create-gmail-app-pwd-20.png](images/create-gmail-app-pwd-20.png)<br>
   Enter `application name` and click on `Generate`.<br>
   ![create-gmail-app-pwd-21.png](images/create-gmail-app-pwd-21.png)<br>
   Copy the Generated password.<br>
   ![create-gmail-app-pwd-22.png](images/create-gmail-app-pwd-22.png)<br>
7. Pass the Generated password to while running `msg-gateway/install.sh` bash script.
   ```
   techno-384@techno384-Latitude-3410:~/Desktop/MOSIP/mosip-infra/deployment/v3/external/msg-gateway$ ./install.sh 
   Create msg-gateways namespace
   ....
   ....
   Please enter the SMTP host smtp.gmail.com
   Please enter the SMTP user dev3.mosip.net
   Please enter the SMTP secret key fuxxxxxxxxxxx
   ...
   ...
   ```
8. Make sure config-server's configmap `email-gateway` and secrets `email-gateway` are update to date,
   if not update it and restart config-server.
9. Restart kernel notification service.
10. After restart, we will get notification from Google on our mobile regarding whether to allow to signIn or not.
    we allow to click on `Yes it was me`.

# References

1. [support.teamgate.com](https://support.teamgate.com/hc/en-us/articles/115002064229-How-to-create-a-password-to-connect-email-while-using-2-step-verification-in-Gmail-)