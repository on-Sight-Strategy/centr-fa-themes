[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.util.UUID" --]
[#-- @ftlvariable name="currentUser" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="passwordValidationRules" type="io.fusionauth.domain.PasswordValidationRules" --]
[#-- @ftlvariable name="showCaptcha" type="boolean" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title="Centr | Reset Password"]
    [@helpers.captchaScripts showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Password change uses mainBoost with full background image --]
    [@helpers.mainBoost title=theme.message('password-change-title')!"CREATE NEW PASSWORD." subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass="text-white"]
      <form action="${request.contextPath}/password/change" method="POST" class="flex flex-col justify-start w-full gap-y-4">
        [@helpers.oauthHiddenFields/]
        [@helpers.hidden name="changePasswordId"/]

        [#-- Show the Password Validation Rules if there is a field error for 'password' --]
        [#if (fieldMessages?keys?seq_contains("password")!false) && passwordValidationRules??]
          [@helpers.passwordRules passwordValidationRules/]
        [/#if]
        <fieldset class="flex flex-col justify-start w-full gap-y-2">
          [@helpers.input type="password" name="password" autocomplete="new-password" id="password" placeholder=theme.message('password') label=theme.message('password') autofocus=true required=true/]
          [@helpers.input type="password" name="passwordConfirm" autocomplete="new-password" id="passwordConfirm" placeholder=theme.message('passwordConfirm') label=theme.message('passwordConfirm') required=true/]
          [@helpers.captchaBadge showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]

          [#-- Show checkbox for remember me - we are in an OAuth2 workflow --]
          [#if client_id?has_content]
            [@helpers.hidden name="rememberDevice" value="false"/]
          [/#if]

          [#-- Spacer for fixed footer --]
          <div class="h-24"></div>
        </fieldset>

        [#-- VDB: Fixed footer button --]
        <div class="vdb-fixed-footer">
          [@helpers.button text=theme.message('submit')/]
        </div>
      </form>
    [/@helpers.mainBoost]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]