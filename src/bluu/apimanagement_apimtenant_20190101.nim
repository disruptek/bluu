
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2019-01-01
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

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
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
  Call_TenantAccessGetEntityTag_596999 = ref object of OpenApiRestCall_596458
proc url_TenantAccessGetEntityTag_597001(protocol: Scheme; host: string;
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

proc validate_TenantAccessGetEntityTag_597000(path: JsonNode; query: JsonNode;
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
  var valid_597002 = path.getOrDefault("resourceGroupName")
  valid_597002 = validateParameter(valid_597002, JString, required = true,
                                 default = nil)
  if valid_597002 != nil:
    section.add "resourceGroupName", valid_597002
  var valid_597003 = path.getOrDefault("accessName")
  valid_597003 = validateParameter(valid_597003, JString, required = true,
                                 default = newJString("access"))
  if valid_597003 != nil:
    section.add "accessName", valid_597003
  var valid_597004 = path.getOrDefault("subscriptionId")
  valid_597004 = validateParameter(valid_597004, JString, required = true,
                                 default = nil)
  if valid_597004 != nil:
    section.add "subscriptionId", valid_597004
  var valid_597005 = path.getOrDefault("serviceName")
  valid_597005 = validateParameter(valid_597005, JString, required = true,
                                 default = nil)
  if valid_597005 != nil:
    section.add "serviceName", valid_597005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597006 = query.getOrDefault("api-version")
  valid_597006 = validateParameter(valid_597006, JString, required = true,
                                 default = nil)
  if valid_597006 != nil:
    section.add "api-version", valid_597006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597007: Call_TenantAccessGetEntityTag_596999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tenant access metadata
  ## 
  let valid = call_597007.validator(path, query, header, formData, body)
  let scheme = call_597007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597007.url(scheme.get, call_597007.host, call_597007.base,
                         call_597007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597007, url, valid)

proc call*(call_597008: Call_TenantAccessGetEntityTag_596999;
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
  var path_597009 = newJObject()
  var query_597010 = newJObject()
  add(path_597009, "resourceGroupName", newJString(resourceGroupName))
  add(query_597010, "api-version", newJString(apiVersion))
  add(path_597009, "accessName", newJString(accessName))
  add(path_597009, "subscriptionId", newJString(subscriptionId))
  add(path_597009, "serviceName", newJString(serviceName))
  result = call_597008.call(path_597009, query_597010, nil, nil, nil)

var tenantAccessGetEntityTag* = Call_TenantAccessGetEntityTag_596999(
    name: "tenantAccessGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessGetEntityTag_597000, base: "",
    url: url_TenantAccessGetEntityTag_597001, schemes: {Scheme.Https})
type
  Call_TenantAccessGet_596680 = ref object of OpenApiRestCall_596458
proc url_TenantAccessGet_596682(protocol: Scheme; host: string; base: string;
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

proc validate_TenantAccessGet_596681(path: JsonNode; query: JsonNode;
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
  var valid_596842 = path.getOrDefault("resourceGroupName")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "resourceGroupName", valid_596842
  var valid_596856 = path.getOrDefault("accessName")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = newJString("access"))
  if valid_596856 != nil:
    section.add "accessName", valid_596856
  var valid_596857 = path.getOrDefault("subscriptionId")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "subscriptionId", valid_596857
  var valid_596858 = path.getOrDefault("serviceName")
  valid_596858 = validateParameter(valid_596858, JString, required = true,
                                 default = nil)
  if valid_596858 != nil:
    section.add "serviceName", valid_596858
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596859 = query.getOrDefault("api-version")
  valid_596859 = validateParameter(valid_596859, JString, required = true,
                                 default = nil)
  if valid_596859 != nil:
    section.add "api-version", valid_596859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596886: Call_TenantAccessGet_596680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tenant access information details
  ## 
  let valid = call_596886.validator(path, query, header, formData, body)
  let scheme = call_596886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596886.url(scheme.get, call_596886.host, call_596886.base,
                         call_596886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596886, url, valid)

proc call*(call_596957: Call_TenantAccessGet_596680; resourceGroupName: string;
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
  var path_596958 = newJObject()
  var query_596960 = newJObject()
  add(path_596958, "resourceGroupName", newJString(resourceGroupName))
  add(query_596960, "api-version", newJString(apiVersion))
  add(path_596958, "accessName", newJString(accessName))
  add(path_596958, "subscriptionId", newJString(subscriptionId))
  add(path_596958, "serviceName", newJString(serviceName))
  result = call_596957.call(path_596958, query_596960, nil, nil, nil)

var tenantAccessGet* = Call_TenantAccessGet_596680(name: "tenantAccessGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessGet_596681, base: "", url: url_TenantAccessGet_596682,
    schemes: {Scheme.Https})
type
  Call_TenantAccessUpdate_597011 = ref object of OpenApiRestCall_596458
proc url_TenantAccessUpdate_597013(protocol: Scheme; host: string; base: string;
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

proc validate_TenantAccessUpdate_597012(path: JsonNode; query: JsonNode;
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
  var valid_597031 = path.getOrDefault("resourceGroupName")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "resourceGroupName", valid_597031
  var valid_597032 = path.getOrDefault("accessName")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = newJString("access"))
  if valid_597032 != nil:
    section.add "accessName", valid_597032
  var valid_597033 = path.getOrDefault("subscriptionId")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "subscriptionId", valid_597033
  var valid_597034 = path.getOrDefault("serviceName")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "serviceName", valid_597034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597035 = query.getOrDefault("api-version")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "api-version", valid_597035
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597036 = header.getOrDefault("If-Match")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "If-Match", valid_597036
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

proc call*(call_597038: Call_TenantAccessUpdate_597011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tenant access information details.
  ## 
  let valid = call_597038.validator(path, query, header, formData, body)
  let scheme = call_597038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597038.url(scheme.get, call_597038.host, call_597038.base,
                         call_597038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597038, url, valid)

proc call*(call_597039: Call_TenantAccessUpdate_597011; resourceGroupName: string;
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
  var path_597040 = newJObject()
  var query_597041 = newJObject()
  var body_597042 = newJObject()
  add(path_597040, "resourceGroupName", newJString(resourceGroupName))
  add(query_597041, "api-version", newJString(apiVersion))
  add(path_597040, "accessName", newJString(accessName))
  add(path_597040, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597042 = parameters
  add(path_597040, "serviceName", newJString(serviceName))
  result = call_597039.call(path_597040, query_597041, nil, nil, body_597042)

var tenantAccessUpdate* = Call_TenantAccessUpdate_597011(
    name: "tenantAccessUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}",
    validator: validate_TenantAccessUpdate_597012, base: "",
    url: url_TenantAccessUpdate_597013, schemes: {Scheme.Https})
type
  Call_TenantAccessGitGet_597043 = ref object of OpenApiRestCall_596458
proc url_TenantAccessGitGet_597045(protocol: Scheme; host: string; base: string;
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

proc validate_TenantAccessGitGet_597044(path: JsonNode; query: JsonNode;
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
  var valid_597046 = path.getOrDefault("resourceGroupName")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "resourceGroupName", valid_597046
  var valid_597047 = path.getOrDefault("accessName")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = newJString("access"))
  if valid_597047 != nil:
    section.add "accessName", valid_597047
  var valid_597048 = path.getOrDefault("subscriptionId")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "subscriptionId", valid_597048
  var valid_597049 = path.getOrDefault("serviceName")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "serviceName", valid_597049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597050 = query.getOrDefault("api-version")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "api-version", valid_597050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597051: Call_TenantAccessGitGet_597043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Git access configuration for the tenant.
  ## 
  let valid = call_597051.validator(path, query, header, formData, body)
  let scheme = call_597051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597051.url(scheme.get, call_597051.host, call_597051.base,
                         call_597051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597051, url, valid)

proc call*(call_597052: Call_TenantAccessGitGet_597043; resourceGroupName: string;
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
  var path_597053 = newJObject()
  var query_597054 = newJObject()
  add(path_597053, "resourceGroupName", newJString(resourceGroupName))
  add(query_597054, "api-version", newJString(apiVersion))
  add(path_597053, "accessName", newJString(accessName))
  add(path_597053, "subscriptionId", newJString(subscriptionId))
  add(path_597053, "serviceName", newJString(serviceName))
  result = call_597052.call(path_597053, query_597054, nil, nil, nil)

var tenantAccessGitGet* = Call_TenantAccessGitGet_597043(
    name: "tenantAccessGitGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git",
    validator: validate_TenantAccessGitGet_597044, base: "",
    url: url_TenantAccessGitGet_597045, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegeneratePrimaryKey_597055 = ref object of OpenApiRestCall_596458
proc url_TenantAccessGitRegeneratePrimaryKey_597057(protocol: Scheme; host: string;
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

proc validate_TenantAccessGitRegeneratePrimaryKey_597056(path: JsonNode;
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
  var valid_597058 = path.getOrDefault("resourceGroupName")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "resourceGroupName", valid_597058
  var valid_597059 = path.getOrDefault("accessName")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = newJString("access"))
  if valid_597059 != nil:
    section.add "accessName", valid_597059
  var valid_597060 = path.getOrDefault("subscriptionId")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "subscriptionId", valid_597060
  var valid_597061 = path.getOrDefault("serviceName")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "serviceName", valid_597061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597062 = query.getOrDefault("api-version")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "api-version", valid_597062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597063: Call_TenantAccessGitRegeneratePrimaryKey_597055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key for GIT.
  ## 
  let valid = call_597063.validator(path, query, header, formData, body)
  let scheme = call_597063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597063.url(scheme.get, call_597063.host, call_597063.base,
                         call_597063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597063, url, valid)

proc call*(call_597064: Call_TenantAccessGitRegeneratePrimaryKey_597055;
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
  var path_597065 = newJObject()
  var query_597066 = newJObject()
  add(path_597065, "resourceGroupName", newJString(resourceGroupName))
  add(query_597066, "api-version", newJString(apiVersion))
  add(path_597065, "accessName", newJString(accessName))
  add(path_597065, "subscriptionId", newJString(subscriptionId))
  add(path_597065, "serviceName", newJString(serviceName))
  result = call_597064.call(path_597065, query_597066, nil, nil, nil)

var tenantAccessGitRegeneratePrimaryKey* = Call_TenantAccessGitRegeneratePrimaryKey_597055(
    name: "tenantAccessGitRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git/regeneratePrimaryKey",
    validator: validate_TenantAccessGitRegeneratePrimaryKey_597056, base: "",
    url: url_TenantAccessGitRegeneratePrimaryKey_597057, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegenerateSecondaryKey_597067 = ref object of OpenApiRestCall_596458
proc url_TenantAccessGitRegenerateSecondaryKey_597069(protocol: Scheme;
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

proc validate_TenantAccessGitRegenerateSecondaryKey_597068(path: JsonNode;
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
  var valid_597070 = path.getOrDefault("resourceGroupName")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "resourceGroupName", valid_597070
  var valid_597071 = path.getOrDefault("accessName")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = newJString("access"))
  if valid_597071 != nil:
    section.add "accessName", valid_597071
  var valid_597072 = path.getOrDefault("subscriptionId")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "subscriptionId", valid_597072
  var valid_597073 = path.getOrDefault("serviceName")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "serviceName", valid_597073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597074 = query.getOrDefault("api-version")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "api-version", valid_597074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597075: Call_TenantAccessGitRegenerateSecondaryKey_597067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key for GIT.
  ## 
  let valid = call_597075.validator(path, query, header, formData, body)
  let scheme = call_597075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597075.url(scheme.get, call_597075.host, call_597075.base,
                         call_597075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597075, url, valid)

proc call*(call_597076: Call_TenantAccessGitRegenerateSecondaryKey_597067;
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
  var path_597077 = newJObject()
  var query_597078 = newJObject()
  add(path_597077, "resourceGroupName", newJString(resourceGroupName))
  add(query_597078, "api-version", newJString(apiVersion))
  add(path_597077, "accessName", newJString(accessName))
  add(path_597077, "subscriptionId", newJString(subscriptionId))
  add(path_597077, "serviceName", newJString(serviceName))
  result = call_597076.call(path_597077, query_597078, nil, nil, nil)

var tenantAccessGitRegenerateSecondaryKey* = Call_TenantAccessGitRegenerateSecondaryKey_597067(
    name: "tenantAccessGitRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/git/regenerateSecondaryKey",
    validator: validate_TenantAccessGitRegenerateSecondaryKey_597068, base: "",
    url: url_TenantAccessGitRegenerateSecondaryKey_597069, schemes: {Scheme.Https})
type
  Call_TenantAccessRegeneratePrimaryKey_597079 = ref object of OpenApiRestCall_596458
proc url_TenantAccessRegeneratePrimaryKey_597081(protocol: Scheme; host: string;
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

proc validate_TenantAccessRegeneratePrimaryKey_597080(path: JsonNode;
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
  var valid_597082 = path.getOrDefault("resourceGroupName")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "resourceGroupName", valid_597082
  var valid_597083 = path.getOrDefault("accessName")
  valid_597083 = validateParameter(valid_597083, JString, required = true,
                                 default = newJString("access"))
  if valid_597083 != nil:
    section.add "accessName", valid_597083
  var valid_597084 = path.getOrDefault("subscriptionId")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "subscriptionId", valid_597084
  var valid_597085 = path.getOrDefault("serviceName")
  valid_597085 = validateParameter(valid_597085, JString, required = true,
                                 default = nil)
  if valid_597085 != nil:
    section.add "serviceName", valid_597085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597086 = query.getOrDefault("api-version")
  valid_597086 = validateParameter(valid_597086, JString, required = true,
                                 default = nil)
  if valid_597086 != nil:
    section.add "api-version", valid_597086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597087: Call_TenantAccessRegeneratePrimaryKey_597079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key
  ## 
  let valid = call_597087.validator(path, query, header, formData, body)
  let scheme = call_597087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597087.url(scheme.get, call_597087.host, call_597087.base,
                         call_597087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597087, url, valid)

proc call*(call_597088: Call_TenantAccessRegeneratePrimaryKey_597079;
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
  var path_597089 = newJObject()
  var query_597090 = newJObject()
  add(path_597089, "resourceGroupName", newJString(resourceGroupName))
  add(query_597090, "api-version", newJString(apiVersion))
  add(path_597089, "accessName", newJString(accessName))
  add(path_597089, "subscriptionId", newJString(subscriptionId))
  add(path_597089, "serviceName", newJString(serviceName))
  result = call_597088.call(path_597089, query_597090, nil, nil, nil)

var tenantAccessRegeneratePrimaryKey* = Call_TenantAccessRegeneratePrimaryKey_597079(
    name: "tenantAccessRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/regeneratePrimaryKey",
    validator: validate_TenantAccessRegeneratePrimaryKey_597080, base: "",
    url: url_TenantAccessRegeneratePrimaryKey_597081, schemes: {Scheme.Https})
type
  Call_TenantAccessRegenerateSecondaryKey_597091 = ref object of OpenApiRestCall_596458
proc url_TenantAccessRegenerateSecondaryKey_597093(protocol: Scheme; host: string;
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

proc validate_TenantAccessRegenerateSecondaryKey_597092(path: JsonNode;
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
  var valid_597094 = path.getOrDefault("resourceGroupName")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = nil)
  if valid_597094 != nil:
    section.add "resourceGroupName", valid_597094
  var valid_597095 = path.getOrDefault("accessName")
  valid_597095 = validateParameter(valid_597095, JString, required = true,
                                 default = newJString("access"))
  if valid_597095 != nil:
    section.add "accessName", valid_597095
  var valid_597096 = path.getOrDefault("subscriptionId")
  valid_597096 = validateParameter(valid_597096, JString, required = true,
                                 default = nil)
  if valid_597096 != nil:
    section.add "subscriptionId", valid_597096
  var valid_597097 = path.getOrDefault("serviceName")
  valid_597097 = validateParameter(valid_597097, JString, required = true,
                                 default = nil)
  if valid_597097 != nil:
    section.add "serviceName", valid_597097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597098 = query.getOrDefault("api-version")
  valid_597098 = validateParameter(valid_597098, JString, required = true,
                                 default = nil)
  if valid_597098 != nil:
    section.add "api-version", valid_597098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597099: Call_TenantAccessRegenerateSecondaryKey_597091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key
  ## 
  let valid = call_597099.validator(path, query, header, formData, body)
  let scheme = call_597099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597099.url(scheme.get, call_597099.host, call_597099.base,
                         call_597099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597099, url, valid)

proc call*(call_597100: Call_TenantAccessRegenerateSecondaryKey_597091;
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
  var path_597101 = newJObject()
  var query_597102 = newJObject()
  add(path_597101, "resourceGroupName", newJString(resourceGroupName))
  add(query_597102, "api-version", newJString(apiVersion))
  add(path_597101, "accessName", newJString(accessName))
  add(path_597101, "subscriptionId", newJString(subscriptionId))
  add(path_597101, "serviceName", newJString(serviceName))
  result = call_597100.call(path_597101, query_597102, nil, nil, nil)

var tenantAccessRegenerateSecondaryKey* = Call_TenantAccessRegenerateSecondaryKey_597091(
    name: "tenantAccessRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{accessName}/regenerateSecondaryKey",
    validator: validate_TenantAccessRegenerateSecondaryKey_597092, base: "",
    url: url_TenantAccessRegenerateSecondaryKey_597093, schemes: {Scheme.Https})
type
  Call_TenantConfigurationDeploy_597103 = ref object of OpenApiRestCall_596458
proc url_TenantConfigurationDeploy_597105(protocol: Scheme; host: string;
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

proc validate_TenantConfigurationDeploy_597104(path: JsonNode; query: JsonNode;
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
  var valid_597106 = path.getOrDefault("resourceGroupName")
  valid_597106 = validateParameter(valid_597106, JString, required = true,
                                 default = nil)
  if valid_597106 != nil:
    section.add "resourceGroupName", valid_597106
  var valid_597107 = path.getOrDefault("subscriptionId")
  valid_597107 = validateParameter(valid_597107, JString, required = true,
                                 default = nil)
  if valid_597107 != nil:
    section.add "subscriptionId", valid_597107
  var valid_597108 = path.getOrDefault("configurationName")
  valid_597108 = validateParameter(valid_597108, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597108 != nil:
    section.add "configurationName", valid_597108
  var valid_597109 = path.getOrDefault("serviceName")
  valid_597109 = validateParameter(valid_597109, JString, required = true,
                                 default = nil)
  if valid_597109 != nil:
    section.add "serviceName", valid_597109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597110 = query.getOrDefault("api-version")
  valid_597110 = validateParameter(valid_597110, JString, required = true,
                                 default = nil)
  if valid_597110 != nil:
    section.add "api-version", valid_597110
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

proc call*(call_597112: Call_TenantConfigurationDeploy_597103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  let valid = call_597112.validator(path, query, header, formData, body)
  let scheme = call_597112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597112.url(scheme.get, call_597112.host, call_597112.base,
                         call_597112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597112, url, valid)

proc call*(call_597113: Call_TenantConfigurationDeploy_597103;
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
  var path_597114 = newJObject()
  var query_597115 = newJObject()
  var body_597116 = newJObject()
  add(path_597114, "resourceGroupName", newJString(resourceGroupName))
  add(query_597115, "api-version", newJString(apiVersion))
  add(path_597114, "subscriptionId", newJString(subscriptionId))
  add(path_597114, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597116 = parameters
  add(path_597114, "serviceName", newJString(serviceName))
  result = call_597113.call(path_597114, query_597115, nil, nil, body_597116)

var tenantConfigurationDeploy* = Call_TenantConfigurationDeploy_597103(
    name: "tenantConfigurationDeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/deploy",
    validator: validate_TenantConfigurationDeploy_597104, base: "",
    url: url_TenantConfigurationDeploy_597105, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSave_597117 = ref object of OpenApiRestCall_596458
proc url_TenantConfigurationSave_597119(protocol: Scheme; host: string; base: string;
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

proc validate_TenantConfigurationSave_597118(path: JsonNode; query: JsonNode;
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
  var valid_597120 = path.getOrDefault("resourceGroupName")
  valid_597120 = validateParameter(valid_597120, JString, required = true,
                                 default = nil)
  if valid_597120 != nil:
    section.add "resourceGroupName", valid_597120
  var valid_597121 = path.getOrDefault("subscriptionId")
  valid_597121 = validateParameter(valid_597121, JString, required = true,
                                 default = nil)
  if valid_597121 != nil:
    section.add "subscriptionId", valid_597121
  var valid_597122 = path.getOrDefault("configurationName")
  valid_597122 = validateParameter(valid_597122, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597122 != nil:
    section.add "configurationName", valid_597122
  var valid_597123 = path.getOrDefault("serviceName")
  valid_597123 = validateParameter(valid_597123, JString, required = true,
                                 default = nil)
  if valid_597123 != nil:
    section.add "serviceName", valid_597123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597124 = query.getOrDefault("api-version")
  valid_597124 = validateParameter(valid_597124, JString, required = true,
                                 default = nil)
  if valid_597124 != nil:
    section.add "api-version", valid_597124
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

proc call*(call_597126: Call_TenantConfigurationSave_597117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  let valid = call_597126.validator(path, query, header, formData, body)
  let scheme = call_597126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597126.url(scheme.get, call_597126.host, call_597126.base,
                         call_597126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597126, url, valid)

proc call*(call_597127: Call_TenantConfigurationSave_597117;
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
  var path_597128 = newJObject()
  var query_597129 = newJObject()
  var body_597130 = newJObject()
  add(path_597128, "resourceGroupName", newJString(resourceGroupName))
  add(query_597129, "api-version", newJString(apiVersion))
  add(path_597128, "subscriptionId", newJString(subscriptionId))
  add(path_597128, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597130 = parameters
  add(path_597128, "serviceName", newJString(serviceName))
  result = call_597127.call(path_597128, query_597129, nil, nil, body_597130)

var tenantConfigurationSave* = Call_TenantConfigurationSave_597117(
    name: "tenantConfigurationSave", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/save",
    validator: validate_TenantConfigurationSave_597118, base: "",
    url: url_TenantConfigurationSave_597119, schemes: {Scheme.Https})
type
  Call_TenantConfigurationGetSyncState_597131 = ref object of OpenApiRestCall_596458
proc url_TenantConfigurationGetSyncState_597133(protocol: Scheme; host: string;
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

proc validate_TenantConfigurationGetSyncState_597132(path: JsonNode;
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
  var valid_597134 = path.getOrDefault("resourceGroupName")
  valid_597134 = validateParameter(valid_597134, JString, required = true,
                                 default = nil)
  if valid_597134 != nil:
    section.add "resourceGroupName", valid_597134
  var valid_597135 = path.getOrDefault("subscriptionId")
  valid_597135 = validateParameter(valid_597135, JString, required = true,
                                 default = nil)
  if valid_597135 != nil:
    section.add "subscriptionId", valid_597135
  var valid_597136 = path.getOrDefault("configurationName")
  valid_597136 = validateParameter(valid_597136, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597136 != nil:
    section.add "configurationName", valid_597136
  var valid_597137 = path.getOrDefault("serviceName")
  valid_597137 = validateParameter(valid_597137, JString, required = true,
                                 default = nil)
  if valid_597137 != nil:
    section.add "serviceName", valid_597137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597138 = query.getOrDefault("api-version")
  valid_597138 = validateParameter(valid_597138, JString, required = true,
                                 default = nil)
  if valid_597138 != nil:
    section.add "api-version", valid_597138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597139: Call_TenantConfigurationGetSyncState_597131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  let valid = call_597139.validator(path, query, header, formData, body)
  let scheme = call_597139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597139.url(scheme.get, call_597139.host, call_597139.base,
                         call_597139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597139, url, valid)

proc call*(call_597140: Call_TenantConfigurationGetSyncState_597131;
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
  var path_597141 = newJObject()
  var query_597142 = newJObject()
  add(path_597141, "resourceGroupName", newJString(resourceGroupName))
  add(query_597142, "api-version", newJString(apiVersion))
  add(path_597141, "subscriptionId", newJString(subscriptionId))
  add(path_597141, "configurationName", newJString(configurationName))
  add(path_597141, "serviceName", newJString(serviceName))
  result = call_597140.call(path_597141, query_597142, nil, nil, nil)

var tenantConfigurationGetSyncState* = Call_TenantConfigurationGetSyncState_597131(
    name: "tenantConfigurationGetSyncState", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/syncState",
    validator: validate_TenantConfigurationGetSyncState_597132, base: "",
    url: url_TenantConfigurationGetSyncState_597133, schemes: {Scheme.Https})
type
  Call_TenantConfigurationValidate_597143 = ref object of OpenApiRestCall_596458
proc url_TenantConfigurationValidate_597145(protocol: Scheme; host: string;
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

proc validate_TenantConfigurationValidate_597144(path: JsonNode; query: JsonNode;
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
  var valid_597146 = path.getOrDefault("resourceGroupName")
  valid_597146 = validateParameter(valid_597146, JString, required = true,
                                 default = nil)
  if valid_597146 != nil:
    section.add "resourceGroupName", valid_597146
  var valid_597147 = path.getOrDefault("subscriptionId")
  valid_597147 = validateParameter(valid_597147, JString, required = true,
                                 default = nil)
  if valid_597147 != nil:
    section.add "subscriptionId", valid_597147
  var valid_597148 = path.getOrDefault("configurationName")
  valid_597148 = validateParameter(valid_597148, JString, required = true,
                                 default = newJString("configuration"))
  if valid_597148 != nil:
    section.add "configurationName", valid_597148
  var valid_597149 = path.getOrDefault("serviceName")
  valid_597149 = validateParameter(valid_597149, JString, required = true,
                                 default = nil)
  if valid_597149 != nil:
    section.add "serviceName", valid_597149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597150 = query.getOrDefault("api-version")
  valid_597150 = validateParameter(valid_597150, JString, required = true,
                                 default = nil)
  if valid_597150 != nil:
    section.add "api-version", valid_597150
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

proc call*(call_597152: Call_TenantConfigurationValidate_597143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  let valid = call_597152.validator(path, query, header, formData, body)
  let scheme = call_597152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597152.url(scheme.get, call_597152.host, call_597152.base,
                         call_597152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597152, url, valid)

proc call*(call_597153: Call_TenantConfigurationValidate_597143;
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
  var path_597154 = newJObject()
  var query_597155 = newJObject()
  var body_597156 = newJObject()
  add(path_597154, "resourceGroupName", newJString(resourceGroupName))
  add(query_597155, "api-version", newJString(apiVersion))
  add(path_597154, "subscriptionId", newJString(subscriptionId))
  add(path_597154, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_597156 = parameters
  add(path_597154, "serviceName", newJString(serviceName))
  result = call_597153.call(path_597154, query_597155, nil, nil, body_597156)

var tenantConfigurationValidate* = Call_TenantConfigurationValidate_597143(
    name: "tenantConfigurationValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/validate",
    validator: validate_TenantConfigurationValidate_597144, base: "",
    url: url_TenantConfigurationValidate_597145, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
