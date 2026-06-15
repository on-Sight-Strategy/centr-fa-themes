[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="showCaptcha" type="boolean" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title="Centr | Forgot Password"]
    [@helpers.captchaScripts showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Forgot password uses mainBoost with full background image --]
    [@helpers.mainBoost title="" subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass=""]
      [#-- VDB: Custom title to match other pages styling (no left padding on desktop) --]
      <div class="w-full text-left mb-6">
        <h2 class="font-degular-black vdb-title-white">${theme.message('forgot-password-title')!"RESET PASSWORD"}</h2>
      </div>
      <p class="font-suisseintl-regular text-white mb-4">
        ${theme.message('forgot-password')}
      </p>
      <form action="${request.contextPath}/password/forgot" method="POST" class="flex flex-col flex-grow justify-start w-full gap-y-4">
        [@helpers.oauthHiddenFields/]

        <fieldset class="flex flex-col flex-grow justify-start w-full gap-y-2">
          [@helpers.input type="text" name="email" id="email" label=theme.message('email') autocapitalize="none" autofocus=true autocomplete="on" autocorrect="off" placeholder=theme.message('email') required=true/]
          [@helpers.captchaBadge showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
          <p class="mt-2">[@helpers.link url="/oauth2/authorize"]${theme.message('return-to-login')}[/@helpers.link]</p>
          [#-- Spacer for fixed footer --]
          <div class="h-24"></div>
        </fieldset>
        [#-- VDB: Fixed footer button --]
        <div class="vdb-fixed-footer">
          [@helpers.button text=theme.message('forgot-password-btn')/]
        </div>
      </form>
    [/@helpers.mainBoost]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]