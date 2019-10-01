
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
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
  Call_TenantAccessGetEntityTag_596998 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGetEntityTag_597000(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_TenantAccessGetEntityTag_596999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tenant access metadata
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
  var valid_597001 = path.getOrDefault("resourceGroupName")
  valid_597001 = validateParameter(valid_597001, JString, required = true,
                                 default = nil)
  if valid_597001 != nil:
    section.add "resourceGroupName", valid_597001
  var valid_597002 = path.getOrDefault("accessName")
  valid_597002 = validateParameter(valid_597002, JString, required = true,
                                 default = newJString("access"))
  if valid_597002 != nil:
    section.add "accessName", valid_597002
  var valid_597003 = path.getOrDefault("subscriptionId")
  valid_597003 = validateParameter(valid_597003, JString, required = true,
                                 default = nil)
  if valid_597003 != nil:
    section.add "subscriptionId", valid_597003
  var valid_597004 = path.getOrDefault("serviceName")
  valid_597004 = validateParameter(valid_597004, JString, required = true,
                                 default = nil)
  if valid_597004 != nil:
    section.add "serviceName", valid_597004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597005 = query.getOrDefault("api-version")
  valid_597005 = validateParameter(valid_597005, JString, required = true,
                                 default = nil)
  if valid_597005 != nil:
    section.add "api-version", valid_597005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597006: Call_TenantAccessGetEntityTag_596998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tenant access metadata
  ## 
  let valid = call_597006.validator(path, query, header, formData, body)
  let scheme = call_597006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597006.url(scheme.get, call_597006.host, call_597006.base,
                         call_597006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597006, url, valid)

proc call*(call_597007: Call_TenantAccessGetEntityTag_596998;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; accessName: string = "access"): Recallable =
  ## tenantAccessGetEntityTag
  ## Tenant access metadata
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
  var path_597008 = newJObject()
  var query_597009 = newJObject()
  add(path_597008, "resourceGroupName", newJString(resourceGroupName))
  add(query_597009, "api-version", newJString(apiVersion))
  add(path_597008, "accessName", newJString(accessName))
  add(path_597008, "subscriptionId", newJString(subscriptionId))
  add(path_597008, "serviceName", newJString(serviceName))
  result = call_597007.call(path_597008, query_597009, nil, nil, nil)

var tenantAccessGetEntityTag* = Call_TenantAccessGetEntityTag_596998(
    name: "tenantAccessGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessGetEntityTag_596999, base: "",
    url: url_TenantAccessGetEntityTag_597000, schemes: {Scheme.Https})
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
  ## Get tenant access information details
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
  var valid_596841 = path.getOrDefault("resourceGroupName")
  valid_596841 = validateParameter(valid_596841, JString, required = true,
                                 default = nil)
  if valid_596841 != nil:
    section.add "resourceGroupName", valid_596841
  var valid_596855 = path.getOrDefault("accessName")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = newJString("access"))
  if valid_596855 != nil:
    section.add "accessName", valid_596855
  var valid_596856 = path.getOrDefault("subscriptionId")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "subscriptionId", valid_596856
  var valid_596857 = path.getOrDefault("serviceName")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "serviceName", valid_596857
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596858 = query.getOrDefault("api-version")
  valid_596858 = validateParameter(valid_596858, JString, required = true,
                                 default = nil)
  if valid_596858 != nil:
    section.add "api-version", valid_596858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596885: Call_TenantAccessGet_596679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tenant access information details
  ## 
  let valid = call_596885.validator(path, query, header, formData, body)
  let scheme = call_596885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596885.url(scheme.get, call_596885.host, call_596885.base,
                         call_596885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596885, url, valid)

proc call*(call_596956: Call_TenantAccessGet_596679; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          accessName: string = "access"): Recallable =
  ## tenantAccessGet
  ## Get tenant access information details
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
  var path_596957 = newJObject()
  var query_596959 = newJObject()
  add(path_596957, "resourceGroupName", newJString(resourceGroupName))
  add(query_596959, "api-version", newJString(apiVersion))
  add(path_596957, "accessName", newJString(accessName))
  add(path_596957, "subscriptionId", newJString(subscriptionId))
  add(path_596957, "serviceName", newJString(serviceName))
  result = call_596956.call(path_596957, query_596959, nil, nil, nil)

var tenantAccessGet* = Call_TenantAccessGet_596679(name: "tenantAccessGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessGet_596680, base: "", url: url_TenantAccessGet_596681,
    schemes: {Scheme.Https})
type
  Call_TenantAccessUpdate_597010 = ref object of OpenApiRestCall_596457
proc url_TenantAccessUpdate_597012(protocol: Scheme; host: string; base: string;
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

proc validate_TenantAccessUpdate_597011(path: JsonNode; query: JsonNode;
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
  var valid_597030 = path.getOrDefault("resourceGroupName")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "resourceGroupName", valid_597030
  var valid_597031 = path.getOrDefault("accessName")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = newJString("access"))
  if valid_597031 != nil:
    section.add "accessName", valid_597031
  var valid_597032 = path.getOrDefault("subscriptionId")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "subscriptionId", valid_597032
  var valid_597033 = path.getOrDefault("serviceName")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "serviceName", valid_597033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597034 = query.getOrDefault("api-version")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "api-version", valid_597034
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597035 = header.getOrDefault("If-Match")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "If-Match", valid_597035
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

proc call*(call_597037: Call_TenantAccessUpdate_597010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tenant access information details.
  ## 
  let valid = call_597037.validator(path, query, header, formData, body)
  let scheme = call_597037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597037.url(scheme.get, call_597037.host, call_597037.base,
                         call_597037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597037, url, valid)

proc call*(call_597038: Call_TenantAccessUpdate_597010; resourceGroupName: string;
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
  var path_597039 = newJObject()
  var query_597040 = newJObject()
  var body_597041 = newJObject()
  add(path_597039, "resourceGroupName", newJString(resourceGroupName))
  add(query_597040, "api-version", newJString(apiVersion))
  add(path_597039, "accessName", newJString(accessName))
  add(path_597039, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597041 = parameters
  add(path_597039, "serviceName", newJString(serviceName))
  result = call_597038.call(path_597039, query_597040, nil, nil, body_597041)

var tenantAccessUpdate* = Call_TenantAccessUpdate_597010(
    name: "tenantAccessUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessUpdate_597011, base: "",
    url: url_TenantAccessUpdate_597012, schemes: {Scheme.Https})
type
  Call_TenantAccessGitGet_597042 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGitGet_597044(protocol: Scheme; host: string; base: string;
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

proc validate_TenantAccessGitGet_597043(path: JsonNode; query: JsonNode;
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
  var valid_597045 = path.getOrDefault("resourceGroupName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "resourceGroupName", valid_597045
  var valid_597046 = path.getOrDefault("accessName")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = newJString("access"))
  if valid_597046 != nil:
    section.add "accessName", valid_597046
  var valid_597047 = path.getOrDefault("subscriptionId")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "subscriptionId", valid_597047
  var valid_597048 = path.getOrDefault("serviceName")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "serviceName", valid_597048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597049 = query.getOrDefault("api-version")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "api-version", valid_597049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597050: Call_TenantAccessGitGet_597042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Git access configuration for the tenant.
  ## 
  let valid = call_597050.validator(path, query, header, formData, body)
  let scheme = call_597050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597050.url(scheme.get, call_597050.host, call_597050.base,
                         call_597050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597050, url, valid)

proc call*(call_597051: Call_TenantAccessGitGet_597042; resourceGroupName: string;
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
  var path_597052 = newJObject()
  var query_597053 = newJObject()
  add(path_597052, "resourceGroupName", newJString(resourceGroupName))
  add(query_597053, "api-version", newJString(apiVersion))
  add(path_597052, "accessName", newJString(accessName))
  add(path_597052, "subscriptionId", newJString(subscriptionId))
  add(path_597052, "serviceName", newJString(serviceName))
  result = call_597051.call(path_597052, query_597053, nil, nil, nil)

var tenantAccessGitGet* = Call_TenantAccessGitGet_597042(
    name: "tenantAccessGitGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git",
    validator: validate_TenantAccessGitGet_597043, base: "",
    url: url_TenantAccessGitGet_597044, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegeneratePrimaryKey_597054 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGitRegeneratePrimaryKey_597056(protocol: Scheme; host: string;
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

proc validate_TenantAccessGitRegeneratePrimaryKey_597055(path: JsonNode;
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
  var valid_597057 = path.getOrDefault("resourceGroupName")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "resourceGroupName", valid_597057
  var valid_597058 = path.getOrDefault("accessName")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = newJString("access"))
  if valid_597058 != nil:
    section.add "accessName", valid_597058
  var valid_597059 = path.getOrDefault("subscriptionId")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "subscriptionId", valid_597059
  var valid_597060 = path.getOrDefault("serviceName")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "serviceName", valid_597060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597061 = query.getOrDefault("api-version")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "api-version", valid_597061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597062: Call_TenantAccessGitRegeneratePrimaryKey_597054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key for GIT.
  ## 
  let valid = call_597062.validator(path, query, header, formData, body)
  let scheme = call_597062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597062.url(scheme.get, call_597062.host, call_597062.base,
                         call_597062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597062, url, valid)

proc call*(call_597063: Call_TenantAccessGitRegeneratePrimaryKey_597054;
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
  var path_597064 = newJObject()
  var query_597065 = newJObject()
  add(path_597064, "resourceGroupName", newJString(resourceGroupName))
  add(query_597065, "api-version", newJString(apiVersion))
  add(path_597064, "accessName", newJString(accessName))
  add(path_597064, "subscriptionId", newJString(subscriptionId))
  add(path_597064, "serviceName", newJString(serviceName))
  result = call_597063.call(path_597064, query_597065, nil, nil, nil)

var tenantAccessGitRegeneratePrimaryKey* = Call_TenantAccessGitRegeneratePrimaryKey_597054(
    name: "tenantAccessGitRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git/regeneratePrimaryKey",
    validator: validate_TenantAccessGitRegeneratePrimaryKey_597055, base: "",
    url: url_TenantAccessGitRegeneratePrimaryKey_597056, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegenerateSecondaryKey_597066 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGitRegenerateSecondaryKey_597068(protocol: Scheme;
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

proc validate_TenantAccessGitRegenerateSecondaryKey_597067(path: JsonNode;
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
  var valid_597069 = path.getOrDefault("resourceGroupName")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "resourceGroupName", valid_597069
  var valid_597070 = path.getOrDefault("accessName")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = newJString("access"))
  if valid_597070 != nil:
    section.add "accessName", valid_597070
  var valid_597071 = path.getOrDefault("subscriptionId")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "subscriptionId", valid_597071
  var valid_597072 = path.getOrDefault("serviceName")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "serviceName", valid_597072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597073 = query.getOrDefault("api-version")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "api-version", valid_597073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597074: Call_TenantAccessGitRegenerateSecondaryKey_597066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key for GIT.
  ## 
  let valid = call_597074.validator(path, query, header, formData, body)
  let scheme = call_597074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597074.url(scheme.get, call_597074.host, call_597074.base,
                         call_597074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597074, url, valid)

proc call*(call_597075: Call_TenantAccessGitRegenerateSecondaryKey_597066;
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
  var path_597076 = newJObject()
  var query_597077 = newJObject()
  add(path_597076, "resourceGroupName", newJString(resourceGroupName))
  add(query_597077, "api-version", newJString(apiVersion))
  add(path_597076, "accessName", newJString(accessName))
  add(path_597076, "subscriptionId", newJString(subscriptionId))
  add(path_597076, "serviceName", newJString(serviceName))
  result = call_597075.call(path_597076, query_597077, nil, nil, nil)

var tenantAccessGitRegenerateSecondaryKey* = Call_TenantAccessGitRegenerateSecondaryKey_597066(
    name: "tenantAccessGitRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git/regenerateSecondaryKey",
    validator: validate_TenantAccessGitRegenerateSecondaryKey_597067, base: "",
    url: url_TenantAccessGitRegenerateSecondaryKey_597068, schemes: {Scheme.Https})
type
  Call_TenantAccessRegeneratePrimaryKey_597078 = ref object of OpenApiRestCall_596457
proc url_TenantAccessRegeneratePrimaryKey_597080(protocol: Scheme; host: string;
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

proc validate_TenantAccessRegeneratePrimaryKey_597079(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key
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
  var valid_597081 = path.getOrDefault("resourceGroupName")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "resourceGroupName", valid_597081
  var valid_597082 = path.getOrDefault("accessName")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = newJString("access"))
  if valid_597082 != nil:
    section.add "accessName", valid_597082
  var valid_597083 = path.getOrDefault("subscriptionId")
  valid_597083 = validateParameter(valid_597083, JString, required = true,
                                 default = nil)
  if valid_597083 != nil:
    section.add "subscriptionId", valid_597083
  var valid_597084 = path.getOrDefault("serviceName")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "serviceName", valid_597084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597085 = query.getOrDefault("api-version")
  valid_597085 = validateParameter(valid_597085, JString, required = true,
                                 default = nil)
  if valid_597085 != nil:
    section.add "api-version", valid_597085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597086: Call_TenantAccessRegeneratePrimaryKey_597078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key
  ## 
  let valid = call_597086.validator(path, query, header, formData, body)
  let scheme = call_597086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597086.url(scheme.get, call_597086.host, call_597086.base,
                         call_597086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597086, url, valid)

proc call*(call_597087: Call_TenantAccessRegeneratePrimaryKey_597078;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; accessName: string = "access"): Recallable =
  ## tenantAccessRegeneratePrimaryKey
  ## Regenerate primary access key
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
  var path_597088 = newJObject()
  var query_597089 = newJObject()
  add(path_597088, "resourceGroupName", newJString(resourceGroupName))
  add(query_597089, "api-version", newJString(apiVersion))
  add(path_597088, "accessName", newJString(accessName))
  add(path_597088, "subscriptionId", newJString(subscriptionId))
  add(path_597088, "serviceName", newJString(serviceName))
  result = call_597087.call(path_597088, query_597089, nil, nil, nil)

var tenantAccessRegeneratePrimaryKey* = Call_TenantAccessRegeneratePrimaryKey_597078(
    name: "tenantAccessRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/regeneratePrimaryKey",
    validator: validate_TenantAccessRegeneratePrimaryKey_597079, base: "",
    url: url_TenantAccessRegeneratePrimaryKey_597080, schemes: {Scheme.Https})
type
  Call_TenantAccessRegenerateSecondaryKey_597090 = ref object of OpenApiRestCall_596457
proc url_TenantAccessRegenerateSecondaryKey_597092(protocol: Scheme; host: string;
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

proc validate_TenantAccessRegenerateSecondaryKey_597091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key
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
  var valid_597093 = path.getOrDefault("resourceGroupName")
  valid_597093 = validateParameter(valid_597093, JString, required = true,
                                 default = nil)
  if valid_597093 != nil:
    section.add "resourceGroupName", valid_597093
  var valid_597094 = path.getOrDefault("accessName")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = newJString("access"))
  if valid_597094 != nil:
    section.add "accessName", valid_597094
  var valid_597095 = path.getOrDefault("subscriptionId")
  valid_597095 = validateParameter(valid_597095, JString, required = true,
                                 default = nil)
  if valid_597095 != nil:
    section.add "subscriptionId", valid_597095
  var valid_597096 = path.getOrDefault("serviceName")
  valid_597096 = validateParameter(valid_597096, JString, required = true,
                                 default = nil)
  if valid_597096 != nil:
    section.add "serviceName", valid_597096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597097 = query.getOrDefault("api-version")
  valid_597097 = validateParameter(valid_597097, JString, required = true,
                                 default = nil)
  if valid_597097 != nil:
    section.add "api-version", valid_597097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597098: Call_TenantAccessRegenerateSecondaryKey_597090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key
  ## 
  let valid = call_597098.validator(path, query, header, formData, body)
  let scheme = call_597098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597098.url(scheme.get, call_597098.host, call_597098.base,
                         call_597098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597098, url, valid)

proc call*(call_597099: Call_TenantAccessRegenerateSecondaryKey_597090;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; accessName: string = "access"): Recallable =
  ## tenantAccessRegenerateSecondaryKey
  ## Regenerate secondary access key
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
  var path_597100 = newJObject()
  var query_597101 = newJObject()
  add(path_597100, "resourceGroupName", newJString(resourceGroupName))
  add(query_597101, "api-version", newJString(apiVersion))
  add(path_597100, "accessName", newJString(accessName))
  add(path_597100, "subscriptionId", newJString(subscriptionId))
  add(path_597100, "serviceName", newJString(serviceName))
  result = call_597099.call(path_597100, query_597101, nil, nil, nil)

var tenantAccessRegenerateSecondaryKey* = Call_TenantAccessRegenerateSecondaryKey_597090(
    name: "tenantAccessRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/regenerateSecondaryKey",
    validator: validate_TenantAccessRegenerateSecondaryKey_597091, base: "",
    url: url_TenantAccessRegenerateSecondaryKey_597092, schemes: {Scheme.Https})
type
  Call_TenantConfigurationDeploy_597102 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationDeploy_597104(protocol: Scheme; host: string;
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

proc validate_TenantConfigurationDeploy_597103(path: JsonNode; query: JsonNode;
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
  var valid_597105 = path.getOrDefault("resourceGroupName")
  valid_597105 = validateParameter(valid_597105, JString, required = true,
                                 default = nil)
  if valid_597105 != nil:
    section.add "resourceGroupName", valid_597105
  var valid_597106 = path.getOrDefault("subscriptionId")
  valid_597106 = validateParameter(valid_597106, JString, required = true,
                                 default = nil)
  if valid_597106 != nil:
    section.add "subscriptionId", valid_597106
  var valid_597107 = path.getOrDefault("configurationName")
  valid_597107 = validateParameter(valid_597107, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597107 != nil:
    section.add "configurationName", valid_597107
  var valid_597108 = path.getOrDefault("serviceName")
  valid_597108 = validateParameter(valid_597108, JString, required = true,
                                 default = nil)
  if valid_597108 != nil:
    section.add "serviceName", valid_597108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597109 = query.getOrDefault("api-version")
  valid_597109 = validateParameter(valid_597109, JString, required = true,
                                 default = nil)
  if valid_597109 != nil:
    section.add "api-version", valid_597109
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

proc call*(call_597111: Call_TenantConfigurationDeploy_597102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  let valid = call_597111.validator(path, query, header, formData, body)
  let scheme = call_597111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597111.url(scheme.get, call_597111.host, call_597111.base,
                         call_597111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597111, url, valid)

proc call*(call_597112: Call_TenantConfigurationDeploy_597102;
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
  var path_597113 = newJObject()
  var query_597114 = newJObject()
  var body_597115 = newJObject()
  add(path_597113, "resourceGroupName", newJString(resourceGroupName))
  add(query_597114, "api-version", newJString(apiVersion))
  add(path_597113, "subscriptionId", newJString(subscriptionId))
  add(path_597113, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597115 = parameters
  add(path_597113, "serviceName", newJString(serviceName))
  result = call_597112.call(path_597113, query_597114, nil, nil, body_597115)

var tenantConfigurationDeploy* = Call_TenantConfigurationDeploy_597102(
    name: "tenantConfigurationDeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/deploy",
    validator: validate_TenantConfigurationDeploy_597103, base: "",
    url: url_TenantConfigurationDeploy_597104, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSave_597116 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationSave_597118(protocol: Scheme; host: string; base: string;
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

proc validate_TenantConfigurationSave_597117(path: JsonNode; query: JsonNode;
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
  var valid_597119 = path.getOrDefault("resourceGroupName")
  valid_597119 = validateParameter(valid_597119, JString, required = true,
                                 default = nil)
  if valid_597119 != nil:
    section.add "resourceGroupName", valid_597119
  var valid_597120 = path.getOrDefault("subscriptionId")
  valid_597120 = validateParameter(valid_597120, JString, required = true,
                                 default = nil)
  if valid_597120 != nil:
    section.add "subscriptionId", valid_597120
  var valid_597121 = path.getOrDefault("configurationName")
  valid_597121 = validateParameter(valid_597121, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597121 != nil:
    section.add "configurationName", valid_597121
  var valid_597122 = path.getOrDefault("serviceName")
  valid_597122 = validateParameter(valid_597122, JString, required = true,
                                 default = nil)
  if valid_597122 != nil:
    section.add "serviceName", valid_597122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597123 = query.getOrDefault("api-version")
  valid_597123 = validateParameter(valid_597123, JString, required = true,
                                 default = nil)
  if valid_597123 != nil:
    section.add "api-version", valid_597123
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

proc call*(call_597125: Call_TenantConfigurationSave_597116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  let valid = call_597125.validator(path, query, header, formData, body)
  let scheme = call_597125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597125.url(scheme.get, call_597125.host, call_597125.base,
                         call_597125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597125, url, valid)

proc call*(call_597126: Call_TenantConfigurationSave_597116;
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
  var path_597127 = newJObject()
  var query_597128 = newJObject()
  var body_597129 = newJObject()
  add(path_597127, "resourceGroupName", newJString(resourceGroupName))
  add(query_597128, "api-version", newJString(apiVersion))
  add(path_597127, "subscriptionId", newJString(subscriptionId))
  add(path_597127, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597129 = parameters
  add(path_597127, "serviceName", newJString(serviceName))
  result = call_597126.call(path_597127, query_597128, nil, nil, body_597129)

var tenantConfigurationSave* = Call_TenantConfigurationSave_597116(
    name: "tenantConfigurationSave", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/save",
    validator: validate_TenantConfigurationSave_597117, base: "",
    url: url_TenantConfigurationSave_597118, schemes: {Scheme.Https})
type
  Call_TenantConfigurationGetSyncState_597130 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationGetSyncState_597132(protocol: Scheme; host: string;
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

proc validate_TenantConfigurationGetSyncState_597131(path: JsonNode;
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
  var valid_597133 = path.getOrDefault("resourceGroupName")
  valid_597133 = validateParameter(valid_597133, JString, required = true,
                                 default = nil)
  if valid_597133 != nil:
    section.add "resourceGroupName", valid_597133
  var valid_597134 = path.getOrDefault("subscriptionId")
  valid_597134 = validateParameter(valid_597134, JString, required = true,
                                 default = nil)
  if valid_597134 != nil:
    section.add "subscriptionId", valid_597134
  var valid_597135 = path.getOrDefault("configurationName")
  valid_597135 = validateParameter(valid_597135, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597135 != nil:
    section.add "configurationName", valid_597135
  var valid_597136 = path.getOrDefault("serviceName")
  valid_597136 = validateParameter(valid_597136, JString, required = true,
                                 default = nil)
  if valid_597136 != nil:
    section.add "serviceName", valid_597136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597137 = query.getOrDefault("api-version")
  valid_597137 = validateParameter(valid_597137, JString, required = true,
                                 default = nil)
  if valid_597137 != nil:
    section.add "api-version", valid_597137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597138: Call_TenantConfigurationGetSyncState_597130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  let valid = call_597138.validator(path, query, header, formData, body)
  let scheme = call_597138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597138.url(scheme.get, call_597138.host, call_597138.base,
                         call_597138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597138, url, valid)

proc call*(call_597139: Call_TenantConfigurationGetSyncState_597130;
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
  var path_597140 = newJObject()
  var query_597141 = newJObject()
  add(path_597140, "resourceGroupName", newJString(resourceGroupName))
  add(query_597141, "api-version", newJString(apiVersion))
  add(path_597140, "subscriptionId", newJString(subscriptionId))
  add(path_597140, "configurationName", newJString(configurationName))
  add(path_597140, "serviceName", newJString(serviceName))
  result = call_597139.call(path_597140, query_597141, nil, nil, nil)

var tenantConfigurationGetSyncState* = Call_TenantConfigurationGetSyncState_597130(
    name: "tenantConfigurationGetSyncState", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/syncState",
    validator: validate_TenantConfigurationGetSyncState_597131, base: "",
    url: url_TenantConfigurationGetSyncState_597132, schemes: {Scheme.Https})
type
  Call_TenantConfigurationValidate_597142 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationValidate_597144(protocol: Scheme; host: string;
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

proc validate_TenantConfigurationValidate_597143(path: JsonNode; query: JsonNode;
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
  var valid_597145 = path.getOrDefault("resourceGroupName")
  valid_597145 = validateParameter(valid_597145, JString, required = true,
                                 default = nil)
  if valid_597145 != nil:
    section.add "resourceGroupName", valid_597145
  var valid_597146 = path.getOrDefault("subscriptionId")
  valid_597146 = validateParameter(valid_597146, JString, required = true,
                                 default = nil)
  if valid_597146 != nil:
    section.add "subscriptionId", valid_597146
  var valid_597147 = path.getOrDefault("configurationName")
  valid_597147 = validateParameter(valid_597147, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597147 != nil:
    section.add "configurationName", valid_597147
  var valid_597148 = path.getOrDefault("serviceName")
  valid_597148 = validateParameter(valid_597148, JString, required = true,
                                 default = nil)
  if valid_597148 != nil:
    section.add "serviceName", valid_597148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597149 = query.getOrDefault("api-version")
  valid_597149 = validateParameter(valid_597149, JString, required = true,
                                 default = nil)
  if valid_597149 != nil:
    section.add "api-version", valid_597149
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

proc call*(call_597151: Call_TenantConfigurationValidate_597142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  let valid = call_597151.validator(path, query, header, formData, body)
  let scheme = call_597151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597151.url(scheme.get, call_597151.host, call_597151.base,
                         call_597151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597151, url, valid)

proc call*(call_597152: Call_TenantConfigurationValidate_597142;
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
  var path_597153 = newJObject()
  var query_597154 = newJObject()
  var body_597155 = newJObject()
  add(path_597153, "resourceGroupName", newJString(resourceGroupName))
  add(query_597154, "api-version", newJString(apiVersion))
  add(path_597153, "subscriptionId", newJString(subscriptionId))
  add(path_597153, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597155 = parameters
  add(path_597153, "serviceName", newJString(serviceName))
  result = call_597152.call(path_597153, query_597154, nil, nil, body_597155)

var tenantConfigurationValidate* = Call_TenantConfigurationValidate_597142(
    name: "tenantConfigurationValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/validate",
    validator: validate_TenantConfigurationValidate_597143, base: "",
    url: url_TenantConfigurationValidate_597144, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
