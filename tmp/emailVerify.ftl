[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="showCaptcha" type="boolean" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="verificationId" type="java.lang.String" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title="Centr | Email Verification"]
    [@helpers.captchaScripts showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Verification uses mainBoost with full background image --]
    [@helpers.mainBoost title=theme.message("email-verification-form-title")!"VERIFY YOUR EMAIL." subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass="text-white"]
      [#-- FusionAuth automatically handles errors that occur during email verification and outputs them in the HTML --]
      <form action="${request.contextPath}/email/verify" method="POST" class="flex flex-col flex-grow justify-start w-full gap-y-4">
        [@helpers.hidden name="captcha_token"/]
        [@helpers.hidden name="client_id"/]
        [@helpers.hidden name="tenantId"/]
        <p class="font-suisseintl-regular text-white">
          ${theme.message("email-verification-form")}
        </p>
        <fieldset class="flex flex-col flex-grow justify-start w-full gap-y-2">
          [@helpers.input type="text" name="email" id="email" autocapitalize="none" autofocus=true autocomplete="on" autocorrect="off" placeholder="${theme.message('email')}" label=theme.message('email')/]
          [@helpers.captchaBadge showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
          [#-- Spacer for fixed footer --]
          <div class="h-24"></div>
        </fieldset>
        [#-- VDB: Fixed footer button --]
        <div class="vdb-fixed-footer">
          [@helpers.button text=theme.message("submit")/]
        </div>
      </form>
    [/@helpers.mainBoost]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]