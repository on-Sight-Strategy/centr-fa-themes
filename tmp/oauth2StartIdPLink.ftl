[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="currentUser" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="devicePendingIdPLink" type="io.fusionauth.domain.provider.PendingIdPLink" --]
[#-- @ftlvariable name="pendingIdPLink" type="io.fusionauth.domain.provider.PendingIdPLink" --]
[#-- @ftlvariable name="registrationEnabled" type="boolean" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#import "../_helpers.ftl" as helpers/]

[#-- Note in most cases, the currentUser reference will not be available. In the case where the user exceeds the number of
     links allowed for an IdP, the user will be returned here while having an SSO session. In this case, currentUser will
     be available.
--]
[@helpers.html]
  [@helpers.head]
    [#-- Custom <head> code goes here --]
  [/@helpers.head]

  [@helpers.body]
    [@helpers.header]
      [#-- Custom header code goes here --]
    [/@helpers.header]

    [#-- If a pending link will cause us to exceed our linking limit, the next step will be to lgoout. --]
    [#assign logoutToContinue = (devicePendingIdPLink?? && devicePendingIdPLink.linkLimitExceeded) || (pendingIdPLink?? && pendingIdPLink.linkLimitExceeded) /]

    [@helpers.main title=theme.message("start-idp-link-title")]
      [#if pendingIdPLink??]
        <p class="mb-4 text-center">
          ${theme.message('pending-link-info', pendingIdPLink.identityProviderName)}
        </p>
      [/#if]

      [#if logoutToContinue]
        [#-- You may wish to obfuscate a portion of this value for anonymity.. --]
        [#assign currentLoginId = currentUser.login /]
        ${theme.message('logged-in-as', currentLoginId)}
        [#if devicePendingIdPLink?? && devicePendingIdPLink.linkLimitExceeded]
          <p class="text-center">${theme.message('link-count-exceeded-pending-logout', devicePendingIdPLink.identityProviderName)}</p>
        [/#if]
        [#if pendingIdPLink?? && pendingIdPLink.linkLimitExceeded]
          <p class="mb-4 text-center">${theme.message('link-count-exceeded-pending-logout', pendingIdPLink.identityProviderName)}</p>
        [/#if]
        <p class="mb-4 text-center">
          ${theme.message("link-count-exceeded-next-step${registrationEnabled?then('', '-no-registration')}")}
        </p>
      [#else]
        <p class="mb-5 text-center">
        [#if devicePendingIdPLink?? && pendingIdPLink??]
          ${theme.message('pending-device-links', devicePendingIdPLink.identityProviderName, pendingIdPLink.identityProviderName)}
        [#elseif devicePendingIdPLink??]
          ${theme.message('pending-device-link', devicePendingIdPLink.identityProviderName)}
        [/#if]
        ${theme.message("pending-link-next-step${registrationEnabled?then('', '-no-registration')}")}
        </p>
      [/#if]

      <div class="row mt-3 mb-3">
        <div class="col-xs">
          [#if logoutToContinue]
            [@helpers.logoutLink redirectURI="/oauth2/start-idp-link"]
              [@helpers.button text=theme.message("logout")/]
            [/@helpers.logoutLink]
          [#else]
            [@helpers.link url="/oauth2/authorize"]
              [@helpers.button text=theme.message("link-to-existing-user")/]
            [/@helpers.link]
          [/#if]
        </div>
      </div>

      [#-- If self service registration is enabled, we can also provide an option to register. --]
      [#if registrationEnabled && !logoutToContinue]
       <div class="row mb-3">
         <div class="col-xs">
           [@helpers.link url="/oauth2/register"]
             [@helpers.button text=theme.message("link-to-new-user") icon="arrow-right"/]
           [/@helpers.link]
         </div>
       </div>
      [/#if]

      [#if pendingIdPLink??]
      [@helpers.dividerOr/]

      <div class="row mt-3 mb-3">
        <div class="col-xs">
        [@helpers.link url="/oauth2/authorize" extraParameters="&cancelPendingIdpLink=true"]
          [@helpers.button text=theme.message("cancel-link")/]
        [/@helpers.link]
        </div>
      </div>
      [/#if]

    [/@helpers.main]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]