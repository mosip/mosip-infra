# Create Gmail APP Password To Send Mails Via SMTP



1. Remove `management.health.mail.enabled` property from kernel property file in config if the property exists.
2. Create new gmail account via [link](https://accounts.google.com/signup/v2/webcreateaccount?continue=https%3A%2F%2Faccounts.google.com%2F&dsh=S856407536%3A1655162931377859&biz=false&flowName=GlifWebSignIn&flowEntry=SignUp) if email does not exist.
3. Login to the gmail account via [link](https://accounts.google.com/signin) <br>
   Enter your email ID.
   ![create-gmail-app-pwd-1.png](images/create-gmail-app-pwd-1.png)
   Enter your password.
   ![create-gmail-app-pwd-2.png](images/create-gmail-app-pwd-2.png)
4. Goto `security` section and enable `Use your phone to sign in`.
   ![create-gmail-app-pwd-3.png](images/create-gmail-app-pwd-3.png)
   Click on `Next`.
   ![create-gmail-app-pwd-4.png](images/create-gmail-app-pwd-4.png)
   Provide password
   ![create-gmail-app-pwd-2.png](images/create-gmail-app-pwd-2.png)
   Click on `Send` to get OTP to your mobile number
   ![create-gmail-app-pwd-5.png](images/create-gmail-app-pwd-5.png)
   Enter `OTP` which is sent to your mobile number and click on `Next`.
   ![create-gmail-app-pwd-6.png](images/create-gmail-app-pwd-6.png)
   Make sure that you have logged into your mobile with the same Gmail ID used here.
   Select your `phone` and click on `Next`.
   ![create-gmail-app-pwd-7.png](images/create-gmail-app-pwd-7.png)
   Enter your `Gmail-ID` and click on `Next`.
   ![create-gmail-app-pwd-8.png](images/create-gmail-app-pwd-8.png)
   Click on `YES` from your mobile.
   ![create-gmail-app-pwd-9.png](images/create-gmail-app-pwd-9.png)
   Click on `Turn On` to start using your phone to sign in.
   ![create-gmail-app-pwd-10.png](images/create-gmail-app-pwd-10.png)
   `Use your phone to sign in` is enabled for your Gmail-ID.
   ![create-gmail-app-pwd-11.png](images/create-gmail-app-pwd-11.png)
5. Goto `security` section and click on `2-Step Verification`.
   ![create-gmail-app-pwd-12.png](images/create-gmail-app-pwd-12.png)
   Click on 'Get Started' to enable `2-Step Verification`.
   ![create-gmail-app-pwd-13.png](images/create-gmail-app-pwd-13.png)
   You have to use your mobile to allow to signIn and provide OTP for the same.
   Click on `continue`.
   ![create-gmail-app-pwd-14.png](images/create-gmail-app-pwd-14.png)
   Provide your mobile number and click on `Send`.
   ![create-gmail-app-pwd-15.png](images/create-gmail-app-pwd-15.png)
   Enter confirmation `OTP` and click on `Next`.
   ![create-gmail-app-pwd-16.png](images/create-gmail-app-pwd-16.png)
   Click on `Turn On` to enable `Two-step verification`.
   ![create-gmail-app-pwd-17.png](images/create-gmail-app-pwd-17.png)
   Two-step verification has been enabled.
   ![create-gmail-app-pwd-18.png](images/create-gmail-app-pwd-18.png)
6. Click on `App passwords` to generate password for third party apps.
   ![create-gmail-app-pwd-19.png](images/create-gmail-app-pwd-19.png)
   Enter the password of your Gmail account > continue.
   Click on `Select app` > select `Other (Custom name)`
   ![create-gmail-app-pwd-20.png](images/create-gmail-app-pwd-20.png)
   Enter `application name` and click on `Generate`.
   ![create-gmail-app-pwd-21.png](images/create-gmail-app-pwd-21.png)
   Copy the Generated password.
   ![create-gmail-app-pwd-22.png](images/create-gmail-app-pwd-22.png)
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