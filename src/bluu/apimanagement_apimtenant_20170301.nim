
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  Call_TenantAccessGet_573879 = ref object of OpenApiRestCall_573657
proc url_TenantAccessGet_573881(protocol: Scheme; host: string; base: string;
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

proc validate_TenantAccessGet_573880(path: JsonNode; query: JsonNode;
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
  var valid_574054 = path.getOrDefault("resourceGroupName")
  valid_574054 = validateParameter(valid_574054, JString, required = true,
                                 default = nil)
  if valid_574054 != nil:
    section.add "resourceGroupName", valid_574054
  var valid_574068 = path.getOrDefault("accessName")
  valid_574068 = validateParameter(valid_574068, JString, required = true,
                                 default = newJString("access"))
  if valid_574068 != nil:
    section.add "accessName", valid_574068
  var valid_574069 = path.getOrDefault("subscriptionId")
  valid_574069 = validateParameter(valid_574069, JString, required = true,
                                 default = nil)
  if valid_574069 != nil:
    section.add "subscriptionId", valid_574069
  var valid_574070 = path.getOrDefault("serviceName")
  valid_574070 = validateParameter(valid_574070, JString, required = true,
                                 default = nil)
  if valid_574070 != nil:
    section.add "serviceName", valid_574070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574071 = query.getOrDefault("api-version")
  valid_574071 = validateParameter(valid_574071, JString, required = true,
                                 default = nil)
  if valid_574071 != nil:
    section.add "api-version", valid_574071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574094: Call_TenantAccessGet_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tenant access information details.
  ## 
  let valid = call_574094.validator(path, query, header, formData, body)
  let scheme = call_574094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574094.url(scheme.get, call_574094.host, call_574094.base,
                         call_574094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574094, url, valid)

proc call*(call_574165: Call_TenantAccessGet_573879; resourceGroupName: string;
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
  var path_574166 = newJObject()
  var query_574168 = newJObject()
  add(path_574166, "resourceGroupName", newJString(resourceGroupName))
  add(query_574168, "api-version", newJString(apiVersion))
  add(path_574166, "accessName", newJString(accessName))
  add(path_574166, "subscriptionId", newJString(subscriptionId))
  add(path_574166, "serviceName", newJString(serviceName))
  result = call_574165.call(path_574166, query_574168, nil, nil, nil)

var tenantAccessGet* = Call_TenantAccessGet_573879(name: "tenantAccessGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessGet_573880, base: "", url: url_TenantAccessGet_573881,
    schemes: {Scheme.Https})
type
  Call_TenantAccessUpdate_574207 = ref object of OpenApiRestCall_573657
proc url_TenantAccessUpdate_574209(protocol: Scheme; host: string; base: string;
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

proc validate_TenantAccessUpdate_574208(path: JsonNode; query: JsonNode;
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
  var valid_574227 = path.getOrDefault("resourceGroupName")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "resourceGroupName", valid_574227
  var valid_574228 = path.getOrDefault("accessName")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = newJString("access"))
  if valid_574228 != nil:
    section.add "accessName", valid_574228
  var valid_574229 = path.getOrDefault("subscriptionId")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "subscriptionId", valid_574229
  var valid_574230 = path.getOrDefault("serviceName")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "serviceName", valid_574230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574231 = query.getOrDefault("api-version")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "api-version", valid_574231
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the property to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574232 = header.getOrDefault("If-Match")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "If-Match", valid_574232
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

proc call*(call_574234: Call_TenantAccessUpdate_574207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tenant access information details.
  ## 
  let valid = call_574234.validator(path, query, header, formData, body)
  let scheme = call_574234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574234.url(scheme.get, call_574234.host, call_574234.base,
                         call_574234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574234, url, valid)

proc call*(call_574235: Call_TenantAccessUpdate_574207; resourceGroupName: string;
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
  var path_574236 = newJObject()
  var query_574237 = newJObject()
  var body_574238 = newJObject()
  add(path_574236, "resourceGroupName", newJString(resourceGroupName))
  add(query_574237, "api-version", newJString(apiVersion))
  add(path_574236, "accessName", newJString(accessName))
  add(path_574236, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574238 = parameters
  add(path_574236, "serviceName", newJString(serviceName))
  result = call_574235.call(path_574236, query_574237, nil, nil, body_574238)

var tenantAccessUpdate* = Call_TenantAccessUpdate_574207(
    name: "tenantAccessUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessUpdate_574208, base: "",
    url: url_TenantAccessUpdate_574209, schemes: {Scheme.Https})
type
  Call_TenantAccessGitGet_574239 = ref object of OpenApiRestCall_573657
proc url_TenantAccessGitGet_574241(protocol: Scheme; host: string; base: string;
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

proc validate_TenantAccessGitGet_574240(path: JsonNode; query: JsonNode;
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
  var valid_574242 = path.getOrDefault("resourceGroupName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "resourceGroupName", valid_574242
  var valid_574243 = path.getOrDefault("accessName")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = newJString("access"))
  if valid_574243 != nil:
    section.add "accessName", valid_574243
  var valid_574244 = path.getOrDefault("subscriptionId")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "subscriptionId", valid_574244
  var valid_574245 = path.getOrDefault("serviceName")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "serviceName", valid_574245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574246 = query.getOrDefault("api-version")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "api-version", valid_574246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574247: Call_TenantAccessGitGet_574239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Git access configuration for the tenant.
  ## 
  let valid = call_574247.validator(path, query, header, formData, body)
  let scheme = call_574247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574247.url(scheme.get, call_574247.host, call_574247.base,
                         call_574247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574247, url, valid)

proc call*(call_574248: Call_TenantAccessGitGet_574239; resourceGroupName: string;
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
  var path_574249 = newJObject()
  var query_574250 = newJObject()
  add(path_574249, "resourceGroupName", newJString(resourceGroupName))
  add(query_574250, "api-version", newJString(apiVersion))
  add(path_574249, "accessName", newJString(accessName))
  add(path_574249, "subscriptionId", newJString(subscriptionId))
  add(path_574249, "serviceName", newJString(serviceName))
  result = call_574248.call(path_574249, query_574250, nil, nil, nil)

var tenantAccessGitGet* = Call_TenantAccessGitGet_574239(
    name: "tenantAccessGitGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git",
    validator: validate_TenantAccessGitGet_574240, base: "",
    url: url_TenantAccessGitGet_574241, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegeneratePrimaryKey_574251 = ref object of OpenApiRestCall_573657
proc url_TenantAccessGitRegeneratePrimaryKey_574253(protocol: Scheme; host: string;
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

proc validate_TenantAccessGitRegeneratePrimaryKey_574252(path: JsonNode;
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
  var valid_574254 = path.getOrDefault("resourceGroupName")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "resourceGroupName", valid_574254
  var valid_574255 = path.getOrDefault("accessName")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = newJString("access"))
  if valid_574255 != nil:
    section.add "accessName", valid_574255
  var valid_574256 = path.getOrDefault("subscriptionId")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "subscriptionId", valid_574256
  var valid_574257 = path.getOrDefault("serviceName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "serviceName", valid_574257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574258 = query.getOrDefault("api-version")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "api-version", valid_574258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574259: Call_TenantAccessGitRegeneratePrimaryKey_574251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key for GIT.
  ## 
  let valid = call_574259.validator(path, query, header, formData, body)
  let scheme = call_574259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574259.url(scheme.get, call_574259.host, call_574259.base,
                         call_574259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574259, url, valid)

proc call*(call_574260: Call_TenantAccessGitRegeneratePrimaryKey_574251;
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
  var path_574261 = newJObject()
  var query_574262 = newJObject()
  add(path_574261, "resourceGroupName", newJString(resourceGroupName))
  add(query_574262, "api-version", newJString(apiVersion))
  add(path_574261, "accessName", newJString(accessName))
  add(path_574261, "subscriptionId", newJString(subscriptionId))
  add(path_574261, "serviceName", newJString(serviceName))
  result = call_574260.call(path_574261, query_574262, nil, nil, nil)

var tenantAccessGitRegeneratePrimaryKey* = Call_TenantAccessGitRegeneratePrimaryKey_574251(
    name: "tenantAccessGitRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git/regeneratePrimaryKey",
    validator: validate_TenantAccessGitRegeneratePrimaryKey_574252, base: "",
    url: url_TenantAccessGitRegeneratePrimaryKey_574253, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegenerateSecondaryKey_574263 = ref object of OpenApiRestCall_573657
proc url_TenantAccessGitRegenerateSecondaryKey_574265(protocol: Scheme;
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

proc validate_TenantAccessGitRegenerateSecondaryKey_574264(path: JsonNode;
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
  var valid_574266 = path.getOrDefault("resourceGroupName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "resourceGroupName", valid_574266
  var valid_574267 = path.getOrDefault("accessName")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = newJString("access"))
  if valid_574267 != nil:
    section.add "accessName", valid_574267
  var valid_574268 = path.getOrDefault("subscriptionId")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "subscriptionId", valid_574268
  var valid_574269 = path.getOrDefault("serviceName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "serviceName", valid_574269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574270 = query.getOrDefault("api-version")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "api-version", valid_574270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574271: Call_TenantAccessGitRegenerateSecondaryKey_574263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key for GIT.
  ## 
  let valid = call_574271.validator(path, query, header, formData, body)
  let scheme = call_574271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574271.url(scheme.get, call_574271.host, call_574271.base,
                         call_574271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574271, url, valid)

proc call*(call_574272: Call_TenantAccessGitRegenerateSecondaryKey_574263;
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
  var path_574273 = newJObject()
  var query_574274 = newJObject()
  add(path_574273, "resourceGroupName", newJString(resourceGroupName))
  add(query_574274, "api-version", newJString(apiVersion))
  add(path_574273, "accessName", newJString(accessName))
  add(path_574273, "subscriptionId", newJString(subscriptionId))
  add(path_574273, "serviceName", newJString(serviceName))
  result = call_574272.call(path_574273, query_574274, nil, nil, nil)

var tenantAccessGitRegenerateSecondaryKey* = Call_TenantAccessGitRegenerateSecondaryKey_574263(
    name: "tenantAccessGitRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git/regenerateSecondaryKey",
    validator: validate_TenantAccessGitRegenerateSecondaryKey_574264, base: "",
    url: url_TenantAccessGitRegenerateSecondaryKey_574265, schemes: {Scheme.Https})
type
  Call_TenantAccessRegeneratePrimaryKey_574275 = ref object of OpenApiRestCall_573657
proc url_TenantAccessRegeneratePrimaryKey_574277(protocol: Scheme; host: string;
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

proc validate_TenantAccessRegeneratePrimaryKey_574276(path: JsonNode;
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
  var valid_574278 = path.getOrDefault("resourceGroupName")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = nil)
  if valid_574278 != nil:
    section.add "resourceGroupName", valid_574278
  var valid_574279 = path.getOrDefault("accessName")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = newJString("access"))
  if valid_574279 != nil:
    section.add "accessName", valid_574279
  var valid_574280 = path.getOrDefault("subscriptionId")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "subscriptionId", valid_574280
  var valid_574281 = path.getOrDefault("serviceName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "serviceName", valid_574281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574282 = query.getOrDefault("api-version")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "api-version", valid_574282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574283: Call_TenantAccessRegeneratePrimaryKey_574275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key.
  ## 
  let valid = call_574283.validator(path, query, header, formData, body)
  let scheme = call_574283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574283.url(scheme.get, call_574283.host, call_574283.base,
                         call_574283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574283, url, valid)

proc call*(call_574284: Call_TenantAccessRegeneratePrimaryKey_574275;
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
  var path_574285 = newJObject()
  var query_574286 = newJObject()
  add(path_574285, "resourceGroupName", newJString(resourceGroupName))
  add(query_574286, "api-version", newJString(apiVersion))
  add(path_574285, "accessName", newJString(accessName))
  add(path_574285, "subscriptionId", newJString(subscriptionId))
  add(path_574285, "serviceName", newJString(serviceName))
  result = call_574284.call(path_574285, query_574286, nil, nil, nil)

var tenantAccessRegeneratePrimaryKey* = Call_TenantAccessRegeneratePrimaryKey_574275(
    name: "tenantAccessRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/regeneratePrimaryKey",
    validator: validate_TenantAccessRegeneratePrimaryKey_574276, base: "",
    url: url_TenantAccessRegeneratePrimaryKey_574277, schemes: {Scheme.Https})
type
  Call_TenantAccessRegenerateSecondaryKey_574287 = ref object of OpenApiRestCall_573657
proc url_TenantAccessRegenerateSecondaryKey_574289(protocol: Scheme; host: string;
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

proc validate_TenantAccessRegenerateSecondaryKey_574288(path: JsonNode;
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
  var valid_574290 = path.getOrDefault("resourceGroupName")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "resourceGroupName", valid_574290
  var valid_574291 = path.getOrDefault("accessName")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = newJString("access"))
  if valid_574291 != nil:
    section.add "accessName", valid_574291
  var valid_574292 = path.getOrDefault("subscriptionId")
  valid_574292 = validateParameter(valid_574292, JString, required = true,
                                 default = nil)
  if valid_574292 != nil:
    section.add "subscriptionId", valid_574292
  var valid_574293 = path.getOrDefault("serviceName")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "serviceName", valid_574293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574294 = query.getOrDefault("api-version")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "api-version", valid_574294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574295: Call_TenantAccessRegenerateSecondaryKey_574287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key.
  ## 
  let valid = call_574295.validator(path, query, header, formData, body)
  let scheme = call_574295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574295.url(scheme.get, call_574295.host, call_574295.base,
                         call_574295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574295, url, valid)

proc call*(call_574296: Call_TenantAccessRegenerateSecondaryKey_574287;
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
  var path_574297 = newJObject()
  var query_574298 = newJObject()
  add(path_574297, "resourceGroupName", newJString(resourceGroupName))
  add(query_574298, "api-version", newJString(apiVersion))
  add(path_574297, "accessName", newJString(accessName))
  add(path_574297, "subscriptionId", newJString(subscriptionId))
  add(path_574297, "serviceName", newJString(serviceName))
  result = call_574296.call(path_574297, query_574298, nil, nil, nil)

var tenantAccessRegenerateSecondaryKey* = Call_TenantAccessRegenerateSecondaryKey_574287(
    name: "tenantAccessRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/regenerateSecondaryKey",
    validator: validate_TenantAccessRegenerateSecondaryKey_574288, base: "",
    url: url_TenantAccessRegenerateSecondaryKey_574289, schemes: {Scheme.Https})
type
  Call_TenantConfigurationDeploy_574299 = ref object of OpenApiRestCall_573657
proc url_TenantConfigurationDeploy_574301(protocol: Scheme; host: string;
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

proc validate_TenantConfigurationDeploy_574300(path: JsonNode; query: JsonNode;
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
  var valid_574302 = path.getOrDefault("resourceGroupName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "resourceGroupName", valid_574302
  var valid_574303 = path.getOrDefault("subscriptionId")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "subscriptionId", valid_574303
  var valid_574304 = path.getOrDefault("configurationName")
  valid_574304 = validateParameter(valid_574304, JString, required = true,
                                 default = newJString("configuration"))
  if valid_574304 != nil:
    section.add "configurationName", valid_574304
  var valid_574305 = path.getOrDefault("serviceName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "serviceName", valid_574305
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574306 = query.getOrDefault("api-version")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "api-version", valid_574306
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

proc call*(call_574308: Call_TenantConfigurationDeploy_574299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  let valid = call_574308.validator(path, query, header, formData, body)
  let scheme = call_574308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574308.url(scheme.get, call_574308.host, call_574308.base,
                         call_574308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574308, url, valid)

proc call*(call_574309: Call_TenantConfigurationDeploy_574299;
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
  var path_574310 = newJObject()
  var query_574311 = newJObject()
  var body_574312 = newJObject()
  add(path_574310, "resourceGroupName", newJString(resourceGroupName))
  add(query_574311, "api-version", newJString(apiVersion))
  add(path_574310, "subscriptionId", newJString(subscriptionId))
  add(path_574310, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_574312 = parameters
  add(path_574310, "serviceName", newJString(serviceName))
  result = call_574309.call(path_574310, query_574311, nil, nil, body_574312)

var tenantConfigurationDeploy* = Call_TenantConfigurationDeploy_574299(
    name: "tenantConfigurationDeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/deploy",
    validator: validate_TenantConfigurationDeploy_574300, base: "",
    url: url_TenantConfigurationDeploy_574301, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSave_574313 = ref object of OpenApiRestCall_573657
proc url_TenantConfigurationSave_574315(protocol: Scheme; host: string; base: string;
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

proc validate_TenantConfigurationSave_574314(path: JsonNode; query: JsonNode;
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
  var valid_574316 = path.getOrDefault("resourceGroupName")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "resourceGroupName", valid_574316
  var valid_574317 = path.getOrDefault("subscriptionId")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "subscriptionId", valid_574317
  var valid_574318 = path.getOrDefault("configurationName")
  valid_574318 = validateParameter(valid_574318, JString, required = true,
                                 default = newJString("configuration"))
  if valid_574318 != nil:
    section.add "configurationName", valid_574318
  var valid_574319 = path.getOrDefault("serviceName")
  valid_574319 = validateParameter(valid_574319, JString, required = true,
                                 default = nil)
  if valid_574319 != nil:
    section.add "serviceName", valid_574319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574320 = query.getOrDefault("api-version")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "api-version", valid_574320
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

proc call*(call_574322: Call_TenantConfigurationSave_574313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  let valid = call_574322.validator(path, query, header, formData, body)
  let scheme = call_574322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574322.url(scheme.get, call_574322.host, call_574322.base,
                         call_574322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574322, url, valid)

proc call*(call_574323: Call_TenantConfigurationSave_574313;
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
  var path_574324 = newJObject()
  var query_574325 = newJObject()
  var body_574326 = newJObject()
  add(path_574324, "resourceGroupName", newJString(resourceGroupName))
  add(query_574325, "api-version", newJString(apiVersion))
  add(path_574324, "subscriptionId", newJString(subscriptionId))
  add(path_574324, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_574326 = parameters
  add(path_574324, "serviceName", newJString(serviceName))
  result = call_574323.call(path_574324, query_574325, nil, nil, body_574326)

var tenantConfigurationSave* = Call_TenantConfigurationSave_574313(
    name: "tenantConfigurationSave", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/save",
    validator: validate_TenantConfigurationSave_574314, base: "",
    url: url_TenantConfigurationSave_574315, schemes: {Scheme.Https})
type
  Call_TenantConfigurationGetSyncState_574327 = ref object of OpenApiRestCall_573657
proc url_TenantConfigurationGetSyncState_574329(protocol: Scheme; host: string;
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

proc validate_TenantConfigurationGetSyncState_574328(path: JsonNode;
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
  var valid_574330 = path.getOrDefault("resourceGroupName")
  valid_574330 = validateParameter(valid_574330, JString, required = true,
                                 default = nil)
  if valid_574330 != nil:
    section.add "resourceGroupName", valid_574330
  var valid_574331 = path.getOrDefault("subscriptionId")
  valid_574331 = validateParameter(valid_574331, JString, required = true,
                                 default = nil)
  if valid_574331 != nil:
    section.add "subscriptionId", valid_574331
  var valid_574332 = path.getOrDefault("configurationName")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = newJString("configuration"))
  if valid_574332 != nil:
    section.add "configurationName", valid_574332
  var valid_574333 = path.getOrDefault("serviceName")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "serviceName", valid_574333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574334 = query.getOrDefault("api-version")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "api-version", valid_574334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574335: Call_TenantConfigurationGetSyncState_574327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  let valid = call_574335.validator(path, query, header, formData, body)
  let scheme = call_574335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574335.url(scheme.get, call_574335.host, call_574335.base,
                         call_574335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574335, url, valid)

proc call*(call_574336: Call_TenantConfigurationGetSyncState_574327;
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
  var path_574337 = newJObject()
  var query_574338 = newJObject()
  add(path_574337, "resourceGroupName", newJString(resourceGroupName))
  add(query_574338, "api-version", newJString(apiVersion))
  add(path_574337, "subscriptionId", newJString(subscriptionId))
  add(path_574337, "configurationName", newJString(configurationName))
  add(path_574337, "serviceName", newJString(serviceName))
  result = call_574336.call(path_574337, query_574338, nil, nil, nil)

var tenantConfigurationGetSyncState* = Call_TenantConfigurationGetSyncState_574327(
    name: "tenantConfigurationGetSyncState", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/syncState",
    validator: validate_TenantConfigurationGetSyncState_574328, base: "",
    url: url_TenantConfigurationGetSyncState_574329, schemes: {Scheme.Https})
type
  Call_TenantConfigurationValidate_574339 = ref object of OpenApiRestCall_573657
proc url_TenantConfigurationValidate_574341(protocol: Scheme; host: string;
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

proc validate_TenantConfigurationValidate_574340(path: JsonNode; query: JsonNode;
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
  var valid_574342 = path.getOrDefault("resourceGroupName")
  valid_574342 = validateParameter(valid_574342, JString, required = true,
                                 default = nil)
  if valid_574342 != nil:
    section.add "resourceGroupName", valid_574342
  var valid_574343 = path.getOrDefault("subscriptionId")
  valid_574343 = validateParameter(valid_574343, JString, required = true,
                                 default = nil)
  if valid_574343 != nil:
    section.add "subscriptionId", valid_574343
  var valid_574344 = path.getOrDefault("configurationName")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = newJString("configuration"))
  if valid_574344 != nil:
    section.add "configurationName", valid_574344
  var valid_574345 = path.getOrDefault("serviceName")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "serviceName", valid_574345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574346 = query.getOrDefault("api-version")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "api-version", valid_574346
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

proc call*(call_574348: Call_TenantConfigurationValidate_574339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  let valid = call_574348.validator(path, query, header, formData, body)
  let scheme = call_574348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574348.url(scheme.get, call_574348.host, call_574348.base,
                         call_574348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574348, url, valid)

proc call*(call_574349: Call_TenantConfigurationValidate_574339;
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
  var path_574350 = newJObject()
  var query_574351 = newJObject()
  var body_574352 = newJObject()
  add(path_574350, "resourceGroupName", newJString(resourceGroupName))
  add(query_574351, "api-version", newJString(apiVersion))
  add(path_574350, "subscriptionId", newJString(subscriptionId))
  add(path_574350, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_574352 = parameters
  add(path_574350, "serviceName", newJString(serviceName))
  result = call_574349.call(path_574350, query_574351, nil, nil, body_574352)

var tenantConfigurationValidate* = Call_TenantConfigurationValidate_574339(
    name: "tenantConfigurationValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/validate",
    validator: validate_TenantConfigurationValidate_574340, base: "",
    url: url_TenantConfigurationValidate_574341, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
