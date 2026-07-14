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
    [#-- Rebranded auth card: single-column layout --]
    [@helpers.authCard mode="single"]
      <p class="mb-4 pb-4 border-b" style="border-color: #DFD5C34D">
        [@helpers.link url="/oauth2/authorize" redirectUri=helpers.originalRedirectUri!'' class="flex gap-2 items-center uppercase !font-bold !text-xs"]
          <svg width="6" height="8" viewBox="0 0 6 8" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M4.60156 8.10655e-07L0.601563 4L4.60156 8" stroke="#FFFF33" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          ${theme.message('return-to-login')}
        [/@helpers.link]
      </p>

      <h1 class="authcard-heading">${theme.message('forgot-password-title')!"RESET PASSWORD"}</h1>
      <p class="authcard-description">
        ${theme.message('forgot-password')}
      </p>

      <form action="${request.contextPath}/password/forgot" method="POST" class="flex flex-col gap-6 w-full">
        [@helpers.oauthHiddenFields/]

        <fieldset class="flex flex-col gap-4">
          [@helpers.input type="text" name="email" id="email" label=theme.message('email') autocapitalize="none" autofocus=true autocomplete="on" autocorrect="off" placeholder=theme.message('email') required=true/]
          [@helpers.captchaBadge showCaptcha=showCaptcha captchaMethod=tenant.captchaConfiguration.captchaMethod siteKey=tenant.captchaConfiguration.siteKey/]
        </fieldset>

        [@helpers.button text=theme.message('forgot-password-btn') icon="arrow-right"/]
      </form>

      <p class="mt-2 text-center">
        <a href="${helpers.frontendUrl('/help')}" class="uppercase underline text-xs">${theme.message('forgot-password-contact-support')}</a>
      </p>
    [/@helpers.authCard]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]