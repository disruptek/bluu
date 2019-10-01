
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionsManagementClient
## version: 2015-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Subscriptions Management Client.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "azsadmin-DirectoryTenant"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DirectoryTenantsList_574663 = ref object of OpenApiRestCall_574441
proc url_DirectoryTenantsList_574665(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/directoryTenants")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryTenantsList_574664(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the directory tenants under the current subscription and given resource group name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574825 = path.getOrDefault("resourceGroupName")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "resourceGroupName", valid_574825
  var valid_574826 = path.getOrDefault("subscriptionId")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "subscriptionId", valid_574826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574840 = query.getOrDefault("api-version")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574840 != nil:
    section.add "api-version", valid_574840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574867: Call_DirectoryTenantsList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the directory tenants under the current subscription and given resource group name.
  ## 
  let valid = call_574867.validator(path, query, header, formData, body)
  let scheme = call_574867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574867.url(scheme.get, call_574867.host, call_574867.base,
                         call_574867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574867, url, valid)

proc call*(call_574938: Call_DirectoryTenantsList_574663;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## directoryTenantsList
  ## Lists all the directory tenants under the current subscription and given resource group name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574939 = newJObject()
  var query_574941 = newJObject()
  add(path_574939, "resourceGroupName", newJString(resourceGroupName))
  add(query_574941, "api-version", newJString(apiVersion))
  add(path_574939, "subscriptionId", newJString(subscriptionId))
  result = call_574938.call(path_574939, query_574941, nil, nil, nil)

var directoryTenantsList* = Call_DirectoryTenantsList_574663(
    name: "directoryTenantsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/directoryTenants",
    validator: validate_DirectoryTenantsList_574664, base: "",
    url: url_DirectoryTenantsList_574665, schemes: {Scheme.Https})
type
  Call_DirectoryTenantsCreateOrUpdate_575000 = ref object of OpenApiRestCall_574441
proc url_DirectoryTenantsCreateOrUpdate_575002(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "tenant" in path, "`tenant` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/directoryTenants/"),
               (kind: VariableSegment, value: "tenant")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryTenantsCreateOrUpdate_575001(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or updates a directory tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   tenant: JString (required)
  ##         : Directory tenant name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575003 = path.getOrDefault("resourceGroupName")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "resourceGroupName", valid_575003
  var valid_575004 = path.getOrDefault("subscriptionId")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "subscriptionId", valid_575004
  var valid_575005 = path.getOrDefault("tenant")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "tenant", valid_575005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575006 = query.getOrDefault("api-version")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575006 != nil:
    section.add "api-version", valid_575006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   newTenant: JObject (required)
  ##            : New directory tenant properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575008: Call_DirectoryTenantsCreateOrUpdate_575000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or updates a directory tenant.
  ## 
  let valid = call_575008.validator(path, query, header, formData, body)
  let scheme = call_575008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575008.url(scheme.get, call_575008.host, call_575008.base,
                         call_575008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575008, url, valid)

proc call*(call_575009: Call_DirectoryTenantsCreateOrUpdate_575000;
          resourceGroupName: string; subscriptionId: string; tenant: string;
          newTenant: JsonNode; apiVersion: string = "2015-11-01"): Recallable =
  ## directoryTenantsCreateOrUpdate
  ## Create or updates a directory tenant.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   tenant: string (required)
  ##         : Directory tenant name.
  ##   newTenant: JObject (required)
  ##            : New directory tenant properties.
  var path_575010 = newJObject()
  var query_575011 = newJObject()
  var body_575012 = newJObject()
  add(path_575010, "resourceGroupName", newJString(resourceGroupName))
  add(query_575011, "api-version", newJString(apiVersion))
  add(path_575010, "subscriptionId", newJString(subscriptionId))
  add(path_575010, "tenant", newJString(tenant))
  if newTenant != nil:
    body_575012 = newTenant
  result = call_575009.call(path_575010, query_575011, nil, nil, body_575012)

var directoryTenantsCreateOrUpdate* = Call_DirectoryTenantsCreateOrUpdate_575000(
    name: "directoryTenantsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/directoryTenants/{tenant}",
    validator: validate_DirectoryTenantsCreateOrUpdate_575001, base: "",
    url: url_DirectoryTenantsCreateOrUpdate_575002, schemes: {Scheme.Https})
type
  Call_DirectoryTenantsGet_574980 = ref object of OpenApiRestCall_574441
proc url_DirectoryTenantsGet_574982(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "tenant" in path, "`tenant` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/directoryTenants/"),
               (kind: VariableSegment, value: "tenant")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryTenantsGet_574981(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get a directory tenant by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   tenant: JString (required)
  ##         : Directory tenant name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574992 = path.getOrDefault("resourceGroupName")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "resourceGroupName", valid_574992
  var valid_574993 = path.getOrDefault("subscriptionId")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "subscriptionId", valid_574993
  var valid_574994 = path.getOrDefault("tenant")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "tenant", valid_574994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574995 = query.getOrDefault("api-version")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574995 != nil:
    section.add "api-version", valid_574995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574996: Call_DirectoryTenantsGet_574980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a directory tenant by name.
  ## 
  let valid = call_574996.validator(path, query, header, formData, body)
  let scheme = call_574996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574996.url(scheme.get, call_574996.host, call_574996.base,
                         call_574996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574996, url, valid)

proc call*(call_574997: Call_DirectoryTenantsGet_574980; resourceGroupName: string;
          subscriptionId: string; tenant: string; apiVersion: string = "2015-11-01"): Recallable =
  ## directoryTenantsGet
  ## Get a directory tenant by name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   tenant: string (required)
  ##         : Directory tenant name.
  var path_574998 = newJObject()
  var query_574999 = newJObject()
  add(path_574998, "resourceGroupName", newJString(resourceGroupName))
  add(query_574999, "api-version", newJString(apiVersion))
  add(path_574998, "subscriptionId", newJString(subscriptionId))
  add(path_574998, "tenant", newJString(tenant))
  result = call_574997.call(path_574998, query_574999, nil, nil, nil)

var directoryTenantsGet* = Call_DirectoryTenantsGet_574980(
    name: "directoryTenantsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/directoryTenants/{tenant}",
    validator: validate_DirectoryTenantsGet_574981, base: "",
    url: url_DirectoryTenantsGet_574982, schemes: {Scheme.Https})
type
  Call_DirectoryTenantsDelete_575013 = ref object of OpenApiRestCall_574441
proc url_DirectoryTenantsDelete_575015(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "tenant" in path, "`tenant` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/directoryTenants/"),
               (kind: VariableSegment, value: "tenant")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DirectoryTenantsDelete_575014(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a directory tenant under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   tenant: JString (required)
  ##         : Directory tenant name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575016 = path.getOrDefault("resourceGroupName")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "resourceGroupName", valid_575016
  var valid_575017 = path.getOrDefault("subscriptionId")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "subscriptionId", valid_575017
  var valid_575018 = path.getOrDefault("tenant")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "tenant", valid_575018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575019 = query.getOrDefault("api-version")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575019 != nil:
    section.add "api-version", valid_575019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575020: Call_DirectoryTenantsDelete_575013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a directory tenant under a resource group.
  ## 
  let valid = call_575020.validator(path, query, header, formData, body)
  let scheme = call_575020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575020.url(scheme.get, call_575020.host, call_575020.base,
                         call_575020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575020, url, valid)

proc call*(call_575021: Call_DirectoryTenantsDelete_575013;
          resourceGroupName: string; subscriptionId: string; tenant: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## directoryTenantsDelete
  ## Delete a directory tenant under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   tenant: string (required)
  ##         : Directory tenant name.
  var path_575022 = newJObject()
  var query_575023 = newJObject()
  add(path_575022, "resourceGroupName", newJString(resourceGroupName))
  add(query_575023, "api-version", newJString(apiVersion))
  add(path_575022, "subscriptionId", newJString(subscriptionId))
  add(path_575022, "tenant", newJString(tenant))
  result = call_575021.call(path_575022, query_575023, nil, nil, nil)

var directoryTenantsDelete* = Call_DirectoryTenantsDelete_575013(
    name: "directoryTenantsDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/directoryTenants/{tenant}",
    validator: validate_DirectoryTenantsDelete_575014, base: "",
    url: url_DirectoryTenantsDelete_575015, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
