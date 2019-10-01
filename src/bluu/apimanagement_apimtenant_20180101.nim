
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on tenant entity associated with your Azure API Management deployment. Using this entity you can manage properties and configuration that apply to the entire API Management service instance.
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

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimtenant"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TenantAccessGet_596679 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGet_596681(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGet_596680(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get tenant access information details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596854 = path.getOrDefault("resourceGroupName")
  valid_596854 = validateParameter(valid_596854, JString, required = true,
                                 default = nil)
  if valid_596854 != nil:
    section.add "resourceGroupName", valid_596854
  var valid_596868 = path.getOrDefault("accessName")
  valid_596868 = validateParameter(valid_596868, JString, required = true,
                                 default = newJString("access"))
  if valid_596868 != nil:
    section.add "accessName", valid_596868
  var valid_596869 = path.getOrDefault("subscriptionId")
  valid_596869 = validateParameter(valid_596869, JString, required = true,
                                 default = nil)
  if valid_596869 != nil:
    section.add "subscriptionId", valid_596869
  var valid_596870 = path.getOrDefault("serviceName")
  valid_596870 = validateParameter(valid_596870, JString, required = true,
                                 default = nil)
  if valid_596870 != nil:
    section.add "serviceName", valid_596870
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596871 = query.getOrDefault("api-version")
  valid_596871 = validateParameter(valid_596871, JString, required = true,
                                 default = nil)
  if valid_596871 != nil:
    section.add "api-version", valid_596871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596894: Call_TenantAccessGet_596679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tenant access information details.
  ## 
  let valid = call_596894.validator(path, query, header, formData, body)
  let scheme = call_596894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596894.url(scheme.get, call_596894.host, call_596894.base,
                         call_596894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596894, url, valid)

proc call*(call_596965: Call_TenantAccessGet_596679; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          accessName: string = "access"): Recallable =
  ## tenantAccessGet
  ## Get tenant access information details.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_596966 = newJObject()
  var query_596968 = newJObject()
  add(path_596966, "resourceGroupName", newJString(resourceGroupName))
  add(query_596968, "api-version", newJString(apiVersion))
  add(path_596966, "accessName", newJString(accessName))
  add(path_596966, "subscriptionId", newJString(subscriptionId))
  add(path_596966, "serviceName", newJString(serviceName))
  result = call_596965.call(path_596966, query_596968, nil, nil, nil)

var tenantAccessGet* = Call_TenantAccessGet_596679(name: "tenantAccessGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessGet_596680, base: "", url: url_TenantAccessGet_596681,
    schemes: {Scheme.Https})
type
  Call_TenantAccessUpdate_597007 = ref object of OpenApiRestCall_596457
proc url_TenantAccessUpdate_597009(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessUpdate_597008(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update tenant access information details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597027 = path.getOrDefault("resourceGroupName")
  valid_597027 = validateParameter(valid_597027, JString, required = true,
                                 default = nil)
  if valid_597027 != nil:
    section.add "resourceGroupName", valid_597027
  var valid_597028 = path.getOrDefault("accessName")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = newJString("access"))
  if valid_597028 != nil:
    section.add "accessName", valid_597028
  var valid_597029 = path.getOrDefault("subscriptionId")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "subscriptionId", valid_597029
  var valid_597030 = path.getOrDefault("serviceName")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "serviceName", valid_597030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597031 = query.getOrDefault("api-version")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "api-version", valid_597031
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597032 = header.getOrDefault("If-Match")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "If-Match", valid_597032
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to retrieve the Tenant Access Information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597034: Call_TenantAccessUpdate_597007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tenant access information details.
  ## 
  let valid = call_597034.validator(path, query, header, formData, body)
  let scheme = call_597034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597034.url(scheme.get, call_597034.host, call_597034.base,
                         call_597034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597034, url, valid)

proc call*(call_597035: Call_TenantAccessUpdate_597007; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string; accessName: string = "access"): Recallable =
  ## tenantAccessUpdate
  ## Update tenant access information details.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to retrieve the Tenant Access Information.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597036 = newJObject()
  var query_597037 = newJObject()
  var body_597038 = newJObject()
  add(path_597036, "resourceGroupName", newJString(resourceGroupName))
  add(query_597037, "api-version", newJString(apiVersion))
  add(path_597036, "accessName", newJString(accessName))
  add(path_597036, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597038 = parameters
  add(path_597036, "serviceName", newJString(serviceName))
  result = call_597035.call(path_597036, query_597037, nil, nil, body_597038)

var tenantAccessUpdate* = Call_TenantAccessUpdate_597007(
    name: "tenantAccessUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessUpdate_597008, base: "",
    url: url_TenantAccessUpdate_597009, schemes: {Scheme.Https})
type
  Call_TenantAccessGitGet_597039 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGitGet_597041(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/git")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitGet_597040(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the Git access configuration for the tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597042 = path.getOrDefault("resourceGroupName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "resourceGroupName", valid_597042
  var valid_597043 = path.getOrDefault("accessName")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = newJString("access"))
  if valid_597043 != nil:
    section.add "accessName", valid_597043
  var valid_597044 = path.getOrDefault("subscriptionId")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "subscriptionId", valid_597044
  var valid_597045 = path.getOrDefault("serviceName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "serviceName", valid_597045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597046 = query.getOrDefault("api-version")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "api-version", valid_597046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597047: Call_TenantAccessGitGet_597039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Git access configuration for the tenant.
  ## 
  let valid = call_597047.validator(path, query, header, formData, body)
  let scheme = call_597047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597047.url(scheme.get, call_597047.host, call_597047.base,
                         call_597047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597047, url, valid)

proc call*(call_597048: Call_TenantAccessGitGet_597039; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          accessName: string = "access"): Recallable =
  ## tenantAccessGitGet
  ## Gets the Git access configuration for the tenant.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597049 = newJObject()
  var query_597050 = newJObject()
  add(path_597049, "resourceGroupName", newJString(resourceGroupName))
  add(query_597050, "api-version", newJString(apiVersion))
  add(path_597049, "accessName", newJString(accessName))
  add(path_597049, "subscriptionId", newJString(subscriptionId))
  add(path_597049, "serviceName", newJString(serviceName))
  result = call_597048.call(path_597049, query_597050, nil, nil, nil)

var tenantAccessGitGet* = Call_TenantAccessGitGet_597039(
    name: "tenantAccessGitGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git",
    validator: validate_TenantAccessGitGet_597040, base: "",
    url: url_TenantAccessGitGet_597041, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegeneratePrimaryKey_597051 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGitRegeneratePrimaryKey_597053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/git/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegeneratePrimaryKey_597052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597054 = path.getOrDefault("resourceGroupName")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "resourceGroupName", valid_597054
  var valid_597055 = path.getOrDefault("accessName")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = newJString("access"))
  if valid_597055 != nil:
    section.add "accessName", valid_597055
  var valid_597056 = path.getOrDefault("subscriptionId")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "subscriptionId", valid_597056
  var valid_597057 = path.getOrDefault("serviceName")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "serviceName", valid_597057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597058 = query.getOrDefault("api-version")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "api-version", valid_597058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597059: Call_TenantAccessGitRegeneratePrimaryKey_597051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key for GIT.
  ## 
  let valid = call_597059.validator(path, query, header, formData, body)
  let scheme = call_597059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597059.url(scheme.get, call_597059.host, call_597059.base,
                         call_597059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597059, url, valid)

proc call*(call_597060: Call_TenantAccessGitRegeneratePrimaryKey_597051;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; accessName: string = "access"): Recallable =
  ## tenantAccessGitRegeneratePrimaryKey
  ## Regenerate primary access key for GIT.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597061 = newJObject()
  var query_597062 = newJObject()
  add(path_597061, "resourceGroupName", newJString(resourceGroupName))
  add(query_597062, "api-version", newJString(apiVersion))
  add(path_597061, "accessName", newJString(accessName))
  add(path_597061, "subscriptionId", newJString(subscriptionId))
  add(path_597061, "serviceName", newJString(serviceName))
  result = call_597060.call(path_597061, query_597062, nil, nil, nil)

var tenantAccessGitRegeneratePrimaryKey* = Call_TenantAccessGitRegeneratePrimaryKey_597051(
    name: "tenantAccessGitRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git/regeneratePrimaryKey",
    validator: validate_TenantAccessGitRegeneratePrimaryKey_597052, base: "",
    url: url_TenantAccessGitRegeneratePrimaryKey_597053, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegenerateSecondaryKey_597063 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGitRegenerateSecondaryKey_597065(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/git/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegenerateSecondaryKey_597064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597066 = path.getOrDefault("resourceGroupName")
  valid_597066 = validateParameter(valid_597066, JString, required = true,
                                 default = nil)
  if valid_597066 != nil:
    section.add "resourceGroupName", valid_597066
  var valid_597067 = path.getOrDefault("accessName")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = newJString("access"))
  if valid_597067 != nil:
    section.add "accessName", valid_597067
  var valid_597068 = path.getOrDefault("subscriptionId")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "subscriptionId", valid_597068
  var valid_597069 = path.getOrDefault("serviceName")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "serviceName", valid_597069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597070 = query.getOrDefault("api-version")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "api-version", valid_597070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597071: Call_TenantAccessGitRegenerateSecondaryKey_597063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key for GIT.
  ## 
  let valid = call_597071.validator(path, query, header, formData, body)
  let scheme = call_597071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597071.url(scheme.get, call_597071.host, call_597071.base,
                         call_597071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597071, url, valid)

proc call*(call_597072: Call_TenantAccessGitRegenerateSecondaryKey_597063;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; accessName: string = "access"): Recallable =
  ## tenantAccessGitRegenerateSecondaryKey
  ## Regenerate secondary access key for GIT.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597073 = newJObject()
  var query_597074 = newJObject()
  add(path_597073, "resourceGroupName", newJString(resourceGroupName))
  add(query_597074, "api-version", newJString(apiVersion))
  add(path_597073, "accessName", newJString(accessName))
  add(path_597073, "subscriptionId", newJString(subscriptionId))
  add(path_597073, "serviceName", newJString(serviceName))
  result = call_597072.call(path_597073, query_597074, nil, nil, nil)

var tenantAccessGitRegenerateSecondaryKey* = Call_TenantAccessGitRegenerateSecondaryKey_597063(
    name: "tenantAccessGitRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git/regenerateSecondaryKey",
    validator: validate_TenantAccessGitRegenerateSecondaryKey_597064, base: "",
    url: url_TenantAccessGitRegenerateSecondaryKey_597065, schemes: {Scheme.Https})
type
  Call_TenantAccessRegeneratePrimaryKey_597075 = ref object of OpenApiRestCall_596457
proc url_TenantAccessRegeneratePrimaryKey_597077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegeneratePrimaryKey_597076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597078 = path.getOrDefault("resourceGroupName")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "resourceGroupName", valid_597078
  var valid_597079 = path.getOrDefault("accessName")
  valid_597079 = validateParameter(valid_597079, JString, required = true,
                                 default = newJString("access"))
  if valid_597079 != nil:
    section.add "accessName", valid_597079
  var valid_597080 = path.getOrDefault("subscriptionId")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "subscriptionId", valid_597080
  var valid_597081 = path.getOrDefault("serviceName")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "serviceName", valid_597081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597082 = query.getOrDefault("api-version")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "api-version", valid_597082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597083: Call_TenantAccessRegeneratePrimaryKey_597075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key.
  ## 
  let valid = call_597083.validator(path, query, header, formData, body)
  let scheme = call_597083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597083.url(scheme.get, call_597083.host, call_597083.base,
                         call_597083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597083, url, valid)

proc call*(call_597084: Call_TenantAccessRegeneratePrimaryKey_597075;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; accessName: string = "access"): Recallable =
  ## tenantAccessRegeneratePrimaryKey
  ## Regenerate primary access key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597085 = newJObject()
  var query_597086 = newJObject()
  add(path_597085, "resourceGroupName", newJString(resourceGroupName))
  add(query_597086, "api-version", newJString(apiVersion))
  add(path_597085, "accessName", newJString(accessName))
  add(path_597085, "subscriptionId", newJString(subscriptionId))
  add(path_597085, "serviceName", newJString(serviceName))
  result = call_597084.call(path_597085, query_597086, nil, nil, nil)

var tenantAccessRegeneratePrimaryKey* = Call_TenantAccessRegeneratePrimaryKey_597075(
    name: "tenantAccessRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/regeneratePrimaryKey",
    validator: validate_TenantAccessRegeneratePrimaryKey_597076, base: "",
    url: url_TenantAccessRegeneratePrimaryKey_597077, schemes: {Scheme.Https})
type
  Call_TenantAccessRegenerateSecondaryKey_597087 = ref object of OpenApiRestCall_596457
proc url_TenantAccessRegenerateSecondaryKey_597089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegenerateSecondaryKey_597088(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597090 = path.getOrDefault("resourceGroupName")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "resourceGroupName", valid_597090
  var valid_597091 = path.getOrDefault("accessName")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = newJString("access"))
  if valid_597091 != nil:
    section.add "accessName", valid_597091
  var valid_597092 = path.getOrDefault("subscriptionId")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "subscriptionId", valid_597092
  var valid_597093 = path.getOrDefault("serviceName")
  valid_597093 = validateParameter(valid_597093, JString, required = true,
                                 default = nil)
  if valid_597093 != nil:
    section.add "serviceName", valid_597093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597094 = query.getOrDefault("api-version")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = nil)
  if valid_597094 != nil:
    section.add "api-version", valid_597094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597095: Call_TenantAccessRegenerateSecondaryKey_597087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key.
  ## 
  let valid = call_597095.validator(path, query, header, formData, body)
  let scheme = call_597095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597095.url(scheme.get, call_597095.host, call_597095.base,
                         call_597095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597095, url, valid)

proc call*(call_597096: Call_TenantAccessRegenerateSecondaryKey_597087;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; accessName: string = "access"): Recallable =
  ## tenantAccessRegenerateSecondaryKey
  ## Regenerate secondary access key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597097 = newJObject()
  var query_597098 = newJObject()
  add(path_597097, "resourceGroupName", newJString(resourceGroupName))
  add(query_597098, "api-version", newJString(apiVersion))
  add(path_597097, "accessName", newJString(accessName))
  add(path_597097, "subscriptionId", newJString(subscriptionId))
  add(path_597097, "serviceName", newJString(serviceName))
  result = call_597096.call(path_597097, query_597098, nil, nil, nil)

var tenantAccessRegenerateSecondaryKey* = Call_TenantAccessRegenerateSecondaryKey_597087(
    name: "tenantAccessRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/regenerateSecondaryKey",
    validator: validate_TenantAccessRegenerateSecondaryKey_597088, base: "",
    url: url_TenantAccessRegenerateSecondaryKey_597089, schemes: {Scheme.Https})
type
  Call_TenantConfigurationDeploy_597099 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationDeploy_597101(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/deploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationDeploy_597100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597102 = path.getOrDefault("resourceGroupName")
  valid_597102 = validateParameter(valid_597102, JString, required = true,
                                 default = nil)
  if valid_597102 != nil:
    section.add "resourceGroupName", valid_597102
  var valid_597103 = path.getOrDefault("subscriptionId")
  valid_597103 = validateParameter(valid_597103, JString, required = true,
                                 default = nil)
  if valid_597103 != nil:
    section.add "subscriptionId", valid_597103
  var valid_597104 = path.getOrDefault("configurationName")
  valid_597104 = validateParameter(valid_597104, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597104 != nil:
    section.add "configurationName", valid_597104
  var valid_597105 = path.getOrDefault("serviceName")
  valid_597105 = validateParameter(valid_597105, JString, required = true,
                                 default = nil)
  if valid_597105 != nil:
    section.add "serviceName", valid_597105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597106 = query.getOrDefault("api-version")
  valid_597106 = validateParameter(valid_597106, JString, required = true,
                                 default = nil)
  if valid_597106 != nil:
    section.add "api-version", valid_597106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597108: Call_TenantConfigurationDeploy_597099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  let valid = call_597108.validator(path, query, header, formData, body)
  let scheme = call_597108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597108.url(scheme.get, call_597108.host, call_597108.base,
                         call_597108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597108, url, valid)

proc call*(call_597109: Call_TenantConfigurationDeploy_597099;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string;
          configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationDeploy
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597110 = newJObject()
  var query_597111 = newJObject()
  var body_597112 = newJObject()
  add(path_597110, "resourceGroupName", newJString(resourceGroupName))
  add(query_597111, "api-version", newJString(apiVersion))
  add(path_597110, "subscriptionId", newJString(subscriptionId))
  add(path_597110, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597112 = parameters
  add(path_597110, "serviceName", newJString(serviceName))
  result = call_597109.call(path_597110, query_597111, nil, nil, body_597112)

var tenantConfigurationDeploy* = Call_TenantConfigurationDeploy_597099(
    name: "tenantConfigurationDeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/deploy",
    validator: validate_TenantConfigurationDeploy_597100, base: "",
    url: url_TenantConfigurationDeploy_597101, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSave_597113 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationSave_597115(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/save")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationSave_597114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597116 = path.getOrDefault("resourceGroupName")
  valid_597116 = validateParameter(valid_597116, JString, required = true,
                                 default = nil)
  if valid_597116 != nil:
    section.add "resourceGroupName", valid_597116
  var valid_597117 = path.getOrDefault("subscriptionId")
  valid_597117 = validateParameter(valid_597117, JString, required = true,
                                 default = nil)
  if valid_597117 != nil:
    section.add "subscriptionId", valid_597117
  var valid_597118 = path.getOrDefault("configurationName")
  valid_597118 = validateParameter(valid_597118, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597118 != nil:
    section.add "configurationName", valid_597118
  var valid_597119 = path.getOrDefault("serviceName")
  valid_597119 = validateParameter(valid_597119, JString, required = true,
                                 default = nil)
  if valid_597119 != nil:
    section.add "serviceName", valid_597119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597120 = query.getOrDefault("api-version")
  valid_597120 = validateParameter(valid_597120, JString, required = true,
                                 default = nil)
  if valid_597120 != nil:
    section.add "api-version", valid_597120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597122: Call_TenantConfigurationSave_597113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  let valid = call_597122.validator(path, query, header, formData, body)
  let scheme = call_597122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597122.url(scheme.get, call_597122.host, call_597122.base,
                         call_597122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597122, url, valid)

proc call*(call_597123: Call_TenantConfigurationSave_597113;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string;
          configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationSave
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597124 = newJObject()
  var query_597125 = newJObject()
  var body_597126 = newJObject()
  add(path_597124, "resourceGroupName", newJString(resourceGroupName))
  add(query_597125, "api-version", newJString(apiVersion))
  add(path_597124, "subscriptionId", newJString(subscriptionId))
  add(path_597124, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597126 = parameters
  add(path_597124, "serviceName", newJString(serviceName))
  result = call_597123.call(path_597124, query_597125, nil, nil, body_597126)

var tenantConfigurationSave* = Call_TenantConfigurationSave_597113(
    name: "tenantConfigurationSave", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/save",
    validator: validate_TenantConfigurationSave_597114, base: "",
    url: url_TenantConfigurationSave_597115, schemes: {Scheme.Https})
type
  Call_TenantConfigurationGetSyncState_597127 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationGetSyncState_597129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/syncState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationGetSyncState_597128(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597130 = path.getOrDefault("resourceGroupName")
  valid_597130 = validateParameter(valid_597130, JString, required = true,
                                 default = nil)
  if valid_597130 != nil:
    section.add "resourceGroupName", valid_597130
  var valid_597131 = path.getOrDefault("subscriptionId")
  valid_597131 = validateParameter(valid_597131, JString, required = true,
                                 default = nil)
  if valid_597131 != nil:
    section.add "subscriptionId", valid_597131
  var valid_597132 = path.getOrDefault("configurationName")
  valid_597132 = validateParameter(valid_597132, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597132 != nil:
    section.add "configurationName", valid_597132
  var valid_597133 = path.getOrDefault("serviceName")
  valid_597133 = validateParameter(valid_597133, JString, required = true,
                                 default = nil)
  if valid_597133 != nil:
    section.add "serviceName", valid_597133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597134 = query.getOrDefault("api-version")
  valid_597134 = validateParameter(valid_597134, JString, required = true,
                                 default = nil)
  if valid_597134 != nil:
    section.add "api-version", valid_597134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597135: Call_TenantConfigurationGetSyncState_597127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  let valid = call_597135.validator(path, query, header, formData, body)
  let scheme = call_597135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597135.url(scheme.get, call_597135.host, call_597135.base,
                         call_597135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597135, url, valid)

proc call*(call_597136: Call_TenantConfigurationGetSyncState_597127;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationGetSyncState
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597137 = newJObject()
  var query_597138 = newJObject()
  add(path_597137, "resourceGroupName", newJString(resourceGroupName))
  add(query_597138, "api-version", newJString(apiVersion))
  add(path_597137, "subscriptionId", newJString(subscriptionId))
  add(path_597137, "configurationName", newJString(configurationName))
  add(path_597137, "serviceName", newJString(serviceName))
  result = call_597136.call(path_597137, query_597138, nil, nil, nil)

var tenantConfigurationGetSyncState* = Call_TenantConfigurationGetSyncState_597127(
    name: "tenantConfigurationGetSyncState", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/syncState",
    validator: validate_TenantConfigurationGetSyncState_597128, base: "",
    url: url_TenantConfigurationGetSyncState_597129, schemes: {Scheme.Https})
type
  Call_TenantConfigurationValidate_597139 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationValidate_597141(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationValidate_597140(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597142 = path.getOrDefault("resourceGroupName")
  valid_597142 = validateParameter(valid_597142, JString, required = true,
                                 default = nil)
  if valid_597142 != nil:
    section.add "resourceGroupName", valid_597142
  var valid_597143 = path.getOrDefault("subscriptionId")
  valid_597143 = validateParameter(valid_597143, JString, required = true,
                                 default = nil)
  if valid_597143 != nil:
    section.add "subscriptionId", valid_597143
  var valid_597144 = path.getOrDefault("configurationName")
  valid_597144 = validateParameter(valid_597144, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597144 != nil:
    section.add "configurationName", valid_597144
  var valid_597145 = path.getOrDefault("serviceName")
  valid_597145 = validateParameter(valid_597145, JString, required = true,
                                 default = nil)
  if valid_597145 != nil:
    section.add "serviceName", valid_597145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597146 = query.getOrDefault("api-version")
  valid_597146 = validateParameter(valid_597146, JString, required = true,
                                 default = nil)
  if valid_597146 != nil:
    section.add "api-version", valid_597146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Validate Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597148: Call_TenantConfigurationValidate_597139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  let valid = call_597148.validator(path, query, header, formData, body)
  let scheme = call_597148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597148.url(scheme.get, call_597148.host, call_597148.base,
                         call_597148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597148, url, valid)

proc call*(call_597149: Call_TenantConfigurationValidate_597139;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string;
          configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationValidate
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   parameters: JObject (required)
  ##             : Validate Configuration parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597150 = newJObject()
  var query_597151 = newJObject()
  var body_597152 = newJObject()
  add(path_597150, "resourceGroupName", newJString(resourceGroupName))
  add(query_597151, "api-version", newJString(apiVersion))
  add(path_597150, "subscriptionId", newJString(subscriptionId))
  add(path_597150, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597152 = parameters
  add(path_597150, "serviceName", newJString(serviceName))
  result = call_597149.call(path_597150, query_597151, nil, nil, body_597152)

var tenantConfigurationValidate* = Call_TenantConfigurationValidate_597139(
    name: "tenantConfigurationValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/validate",
    validator: validate_TenantConfigurationValidate_597140, base: "",
    url: url_TenantConfigurationValidate_597141, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
