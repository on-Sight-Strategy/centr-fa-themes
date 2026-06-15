[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="completedLinks" type="java.util.List<io.fusionauth.domain.provider.PendingIdPLink>" --]
[#-- @ftlvariable name="currentUser" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#import "../_helpers.ftl" as helpers/]

[@helpers.html]
  [@helpers.head title=theme.message("device-title")/]
  [@helpers.body]
    [#-- VDB: Device complete uses mainBoost with full background image --]
    [@helpers.mainBoost title="" subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass=""]

      [#-- VDB: Custom title --]
      <div class="w-full text-left mb-6">
        <h2 class="font-degular-black vdb-title-white">${theme.message("device-complete-title-line1")!"DEVICE"}</h2>
        <h2 class="font-degular-black vdb-title-brand">${theme.message("device-complete-title-line2")!"CONNECTED"}</h2>
      </div>

      [#-- Success message --]
      <div class="w-full">
        [#if completedLinks?has_content]
          <p class="font-suisseintl-regular text-white/80 text-lg mb-4">
            [#if completedLinks?size == 1]
              ${theme.message('completed-link', completedLinks.get(0).identityProviderType)}
            [#elseif completedLinks?size == 2]
              ${theme.message('completed-links', completedLinks.get(0).identityProviderType.name(), completedLinks.get(1).identityProviderType.name())}
            [/#if]
          </p>
        [/#if]
        <p class="font-suisseintl-regular text-white/80 text-lg">
          ${theme.message('device-login-complete')}
        </p>
      </div>

    [/@helpers.mainBoost]

    [@helpers.footer]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]