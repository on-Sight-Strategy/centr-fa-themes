[#ftl/]
[#-- @ftlvariable name="allLogoutURLs" type="java.util.Set<java.lang.String>" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="client_id" type="java.lang.String" --]
[#-- @ftlvariable name="currentUser" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="registeredLogoutURLs" type="java.util.Set<java.lang.String>" --]
[#-- @ftlvariable name="redirectURL" type="java.lang.String" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="tenantId" type="java.util.UUID" --]
[#import "../_helpers.ftl" as helpers/]

[#-- You may adjust the duration before we redirect the user --]
[#assign logoutDurationInSeconds = 2 /]

[@helpers.html]
  [@helpers.head title="Centr | OAuth Logging Out"]
  [#if redirectURL?has_content]
    <meta http-equiv="Refresh" content="${logoutDurationInSeconds}; url=${redirectURL}">
  [/#if]
  [/@helpers.head]
  [@helpers.body]
    [#-- VDB: Logout uses mainBoost with full background image and white title --]
    [@helpers.mainBoost title=theme.message("logging-out") subtitle="" rowClass="row center-xs" colClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4" showCoverImage=true showHeader=false titleClass="vdb-title-white"]
      <div class="vdb-logout-progress">
        <div class="vdb-logout-progress-bar" style="animation-duration: ${logoutDurationInSeconds + 1}s;"></div>
      </div>
    [/@helpers.mainBoost]

    [#-- Use allLogoutURLs to call the logout URL of all applications in the tenant, or use registeredLogoutURLs to log out of just the applications the user is currently registered.
        Note, that just because a user does not currently have a registration, does not necessarily mean the user does not hold a session with an application. It is possible the user has been un-registered
        recently, or an application may have created a session for a user regardless of their registration. In most cases it is safest to simply call all applications and ensure that the Single Logout
        URL can handle logout requests for users that may or may not have a session with that application.
     --]
    [#list allLogoutURLs![] as logoutURL]
      <iframe src="${logoutURL}" style="width:0; height:0; border:0; border:none;"></iframe>
    [/#list]

    [@helpers.footer]
      [#-- Custom footer code goes here --]
    [/@helpers.footer]
  [/@helpers.body]
[/@helpers.html]