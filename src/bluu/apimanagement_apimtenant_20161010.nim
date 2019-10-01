
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2016-10-10
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/access")]
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
  var valid_596842 = path.getOrDefault("subscriptionId")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "subscriptionId", valid_596842
  var valid_596843 = path.getOrDefault("serviceName")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "serviceName", valid_596843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596844 = query.getOrDefault("api-version")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "api-version", valid_596844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596871: Call_TenantAccessGet_596679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tenant access information details.
  ## 
  let valid = call_596871.validator(path, query, header, formData, body)
  let scheme = call_596871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596871.url(scheme.get, call_596871.host, call_596871.base,
                         call_596871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596871, url, valid)

proc call*(call_596942: Call_TenantAccessGet_596679; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## tenantAccessGet
  ## Get tenant access information details.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_596943 = newJObject()
  var query_596945 = newJObject()
  add(path_596943, "resourceGroupName", newJString(resourceGroupName))
  add(query_596945, "api-version", newJString(apiVersion))
  add(path_596943, "subscriptionId", newJString(subscriptionId))
  add(path_596943, "serviceName", newJString(serviceName))
  result = call_596942.call(path_596943, query_596945, nil, nil, nil)

var tenantAccessGet* = Call_TenantAccessGet_596679(name: "tenantAccessGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access",
    validator: validate_TenantAccessGet_596680, base: "", url: url_TenantAccessGet_596681,
    schemes: {Scheme.Https})
type
  Call_TenantAccessUpdate_596984 = ref object of OpenApiRestCall_596457
proc url_TenantAccessUpdate_596986(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/access")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessUpdate_596985(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update tenant access information details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597013 = path.getOrDefault("resourceGroupName")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "resourceGroupName", valid_597013
  var valid_597014 = path.getOrDefault("subscriptionId")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "subscriptionId", valid_597014
  var valid_597015 = path.getOrDefault("serviceName")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "serviceName", valid_597015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597016 = query.getOrDefault("api-version")
  valid_597016 = validateParameter(valid_597016, JString, required = true,
                                 default = nil)
  if valid_597016 != nil:
    section.add "api-version", valid_597016
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the tenant access settings to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597017 = header.getOrDefault("If-Match")
  valid_597017 = validateParameter(valid_597017, JString, required = true,
                                 default = nil)
  if valid_597017 != nil:
    section.add "If-Match", valid_597017
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597019: Call_TenantAccessUpdate_596984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tenant access information details.
  ## 
  let valid = call_597019.validator(path, query, header, formData, body)
  let scheme = call_597019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597019.url(scheme.get, call_597019.host, call_597019.base,
                         call_597019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597019, url, valid)

proc call*(call_597020: Call_TenantAccessUpdate_596984; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## tenantAccessUpdate
  ## Update tenant access information details.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597021 = newJObject()
  var query_597022 = newJObject()
  var body_597023 = newJObject()
  add(path_597021, "resourceGroupName", newJString(resourceGroupName))
  add(query_597022, "api-version", newJString(apiVersion))
  add(path_597021, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597023 = parameters
  add(path_597021, "serviceName", newJString(serviceName))
  result = call_597020.call(path_597021, query_597022, nil, nil, body_597023)

var tenantAccessUpdate* = Call_TenantAccessUpdate_596984(
    name: "tenantAccessUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access",
    validator: validate_TenantAccessUpdate_596985, base: "",
    url: url_TenantAccessUpdate_596986, schemes: {Scheme.Https})
type
  Call_TenantAccessGitGet_597024 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGitGet_597026(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/access/git")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitGet_597025(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the Git access configuration for the tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
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
  var valid_597028 = path.getOrDefault("subscriptionId")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "subscriptionId", valid_597028
  var valid_597029 = path.getOrDefault("serviceName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "serviceName", valid_597029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597030 = query.getOrDefault("api-version")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "api-version", valid_597030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597031: Call_TenantAccessGitGet_597024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Git access configuration for the tenant.
  ## 
  let valid = call_597031.validator(path, query, header, formData, body)
  let scheme = call_597031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597031.url(scheme.get, call_597031.host, call_597031.base,
                         call_597031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597031, url, valid)

proc call*(call_597032: Call_TenantAccessGitGet_597024; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## tenantAccessGitGet
  ## Gets the Git access configuration for the tenant.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597033 = newJObject()
  var query_597034 = newJObject()
  add(path_597033, "resourceGroupName", newJString(resourceGroupName))
  add(query_597034, "api-version", newJString(apiVersion))
  add(path_597033, "subscriptionId", newJString(subscriptionId))
  add(path_597033, "serviceName", newJString(serviceName))
  result = call_597032.call(path_597033, query_597034, nil, nil, nil)

var tenantAccessGitGet* = Call_TenantAccessGitGet_597024(
    name: "tenantAccessGitGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/git",
    validator: validate_TenantAccessGitGet_597025, base: "",
    url: url_TenantAccessGitGet_597026, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegeneratePrimaryKey_597035 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGitRegeneratePrimaryKey_597037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/access/git/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegeneratePrimaryKey_597036(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597038 = path.getOrDefault("resourceGroupName")
  valid_597038 = validateParameter(valid_597038, JString, required = true,
                                 default = nil)
  if valid_597038 != nil:
    section.add "resourceGroupName", valid_597038
  var valid_597039 = path.getOrDefault("subscriptionId")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "subscriptionId", valid_597039
  var valid_597040 = path.getOrDefault("serviceName")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "serviceName", valid_597040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597041 = query.getOrDefault("api-version")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "api-version", valid_597041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597042: Call_TenantAccessGitRegeneratePrimaryKey_597035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key for GIT.
  ## 
  let valid = call_597042.validator(path, query, header, formData, body)
  let scheme = call_597042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597042.url(scheme.get, call_597042.host, call_597042.base,
                         call_597042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597042, url, valid)

proc call*(call_597043: Call_TenantAccessGitRegeneratePrimaryKey_597035;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantAccessGitRegeneratePrimaryKey
  ## Regenerate primary access key for GIT.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597044 = newJObject()
  var query_597045 = newJObject()
  add(path_597044, "resourceGroupName", newJString(resourceGroupName))
  add(query_597045, "api-version", newJString(apiVersion))
  add(path_597044, "subscriptionId", newJString(subscriptionId))
  add(path_597044, "serviceName", newJString(serviceName))
  result = call_597043.call(path_597044, query_597045, nil, nil, nil)

var tenantAccessGitRegeneratePrimaryKey* = Call_TenantAccessGitRegeneratePrimaryKey_597035(
    name: "tenantAccessGitRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/git/regeneratePrimaryKey",
    validator: validate_TenantAccessGitRegeneratePrimaryKey_597036, base: "",
    url: url_TenantAccessGitRegeneratePrimaryKey_597037, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegenerateSecondaryKey_597046 = ref object of OpenApiRestCall_596457
proc url_TenantAccessGitRegenerateSecondaryKey_597048(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/access/git/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegenerateSecondaryKey_597047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597049 = path.getOrDefault("resourceGroupName")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "resourceGroupName", valid_597049
  var valid_597050 = path.getOrDefault("subscriptionId")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "subscriptionId", valid_597050
  var valid_597051 = path.getOrDefault("serviceName")
  valid_597051 = validateParameter(valid_597051, JString, required = true,
                                 default = nil)
  if valid_597051 != nil:
    section.add "serviceName", valid_597051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597052 = query.getOrDefault("api-version")
  valid_597052 = validateParameter(valid_597052, JString, required = true,
                                 default = nil)
  if valid_597052 != nil:
    section.add "api-version", valid_597052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597053: Call_TenantAccessGitRegenerateSecondaryKey_597046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key for GIT.
  ## 
  let valid = call_597053.validator(path, query, header, formData, body)
  let scheme = call_597053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597053.url(scheme.get, call_597053.host, call_597053.base,
                         call_597053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597053, url, valid)

proc call*(call_597054: Call_TenantAccessGitRegenerateSecondaryKey_597046;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantAccessGitRegenerateSecondaryKey
  ## Regenerate secondary access key for GIT.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597055 = newJObject()
  var query_597056 = newJObject()
  add(path_597055, "resourceGroupName", newJString(resourceGroupName))
  add(query_597056, "api-version", newJString(apiVersion))
  add(path_597055, "subscriptionId", newJString(subscriptionId))
  add(path_597055, "serviceName", newJString(serviceName))
  result = call_597054.call(path_597055, query_597056, nil, nil, nil)

var tenantAccessGitRegenerateSecondaryKey* = Call_TenantAccessGitRegenerateSecondaryKey_597046(
    name: "tenantAccessGitRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/git/regenerateSecondaryKey",
    validator: validate_TenantAccessGitRegenerateSecondaryKey_597047, base: "",
    url: url_TenantAccessGitRegenerateSecondaryKey_597048, schemes: {Scheme.Https})
type
  Call_TenantAccessRegeneratePrimaryKey_597057 = ref object of OpenApiRestCall_596457
proc url_TenantAccessRegeneratePrimaryKey_597059(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/access/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegeneratePrimaryKey_597058(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597060 = path.getOrDefault("resourceGroupName")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "resourceGroupName", valid_597060
  var valid_597061 = path.getOrDefault("subscriptionId")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "subscriptionId", valid_597061
  var valid_597062 = path.getOrDefault("serviceName")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "serviceName", valid_597062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597063 = query.getOrDefault("api-version")
  valid_597063 = validateParameter(valid_597063, JString, required = true,
                                 default = nil)
  if valid_597063 != nil:
    section.add "api-version", valid_597063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597064: Call_TenantAccessRegeneratePrimaryKey_597057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key.
  ## 
  let valid = call_597064.validator(path, query, header, formData, body)
  let scheme = call_597064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597064.url(scheme.get, call_597064.host, call_597064.base,
                         call_597064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597064, url, valid)

proc call*(call_597065: Call_TenantAccessRegeneratePrimaryKey_597057;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantAccessRegeneratePrimaryKey
  ## Regenerate primary access key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597066 = newJObject()
  var query_597067 = newJObject()
  add(path_597066, "resourceGroupName", newJString(resourceGroupName))
  add(query_597067, "api-version", newJString(apiVersion))
  add(path_597066, "subscriptionId", newJString(subscriptionId))
  add(path_597066, "serviceName", newJString(serviceName))
  result = call_597065.call(path_597066, query_597067, nil, nil, nil)

var tenantAccessRegeneratePrimaryKey* = Call_TenantAccessRegeneratePrimaryKey_597057(
    name: "tenantAccessRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/regeneratePrimaryKey",
    validator: validate_TenantAccessRegeneratePrimaryKey_597058, base: "",
    url: url_TenantAccessRegeneratePrimaryKey_597059, schemes: {Scheme.Https})
type
  Call_TenantAccessRegenerateSecondaryKey_597068 = ref object of OpenApiRestCall_596457
proc url_TenantAccessRegenerateSecondaryKey_597070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/access/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegenerateSecondaryKey_597069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597071 = path.getOrDefault("resourceGroupName")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "resourceGroupName", valid_597071
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

proc call*(call_597075: Call_TenantAccessRegenerateSecondaryKey_597068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key.
  ## 
  let valid = call_597075.validator(path, query, header, formData, body)
  let scheme = call_597075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597075.url(scheme.get, call_597075.host, call_597075.base,
                         call_597075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597075, url, valid)

proc call*(call_597076: Call_TenantAccessRegenerateSecondaryKey_597068;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantAccessRegenerateSecondaryKey
  ## Regenerate secondary access key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597077 = newJObject()
  var query_597078 = newJObject()
  add(path_597077, "resourceGroupName", newJString(resourceGroupName))
  add(query_597078, "api-version", newJString(apiVersion))
  add(path_597077, "subscriptionId", newJString(subscriptionId))
  add(path_597077, "serviceName", newJString(serviceName))
  result = call_597076.call(path_597077, query_597078, nil, nil, nil)

var tenantAccessRegenerateSecondaryKey* = Call_TenantAccessRegenerateSecondaryKey_597068(
    name: "tenantAccessRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/access/regenerateSecondaryKey",
    validator: validate_TenantAccessRegenerateSecondaryKey_597069, base: "",
    url: url_TenantAccessRegenerateSecondaryKey_597070, schemes: {Scheme.Https})
type
  Call_TenantConfigurationDeploy_597079 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationDeploy_597081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/configuration/deploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationDeploy_597080(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597087: Call_TenantConfigurationDeploy_597079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  let valid = call_597087.validator(path, query, header, formData, body)
  let scheme = call_597087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597087.url(scheme.get, call_597087.host, call_597087.base,
                         call_597087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597087, url, valid)

proc call*(call_597088: Call_TenantConfigurationDeploy_597079;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
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
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597089 = newJObject()
  var query_597090 = newJObject()
  var body_597091 = newJObject()
  add(path_597089, "resourceGroupName", newJString(resourceGroupName))
  add(query_597090, "api-version", newJString(apiVersion))
  add(path_597089, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597091 = parameters
  add(path_597089, "serviceName", newJString(serviceName))
  result = call_597088.call(path_597089, query_597090, nil, nil, body_597091)

var tenantConfigurationDeploy* = Call_TenantConfigurationDeploy_597079(
    name: "tenantConfigurationDeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/configuration/deploy",
    validator: validate_TenantConfigurationDeploy_597080, base: "",
    url: url_TenantConfigurationDeploy_597081, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSave_597092 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationSave_597094(protocol: Scheme; host: string; base: string;
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
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/configuration/save")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationSave_597093(path: JsonNode; query: JsonNode;
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597095 = path.getOrDefault("resourceGroupName")
  valid_597095 = validateParameter(valid_597095, JString, required = true,
                                 default = nil)
  if valid_597095 != nil:
    section.add "resourceGroupName", valid_597095
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597100: Call_TenantConfigurationSave_597092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  let valid = call_597100.validator(path, query, header, formData, body)
  let scheme = call_597100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597100.url(scheme.get, call_597100.host, call_597100.base,
                         call_597100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597100, url, valid)

proc call*(call_597101: Call_TenantConfigurationSave_597092;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
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
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597102 = newJObject()
  var query_597103 = newJObject()
  var body_597104 = newJObject()
  add(path_597102, "resourceGroupName", newJString(resourceGroupName))
  add(query_597103, "api-version", newJString(apiVersion))
  add(path_597102, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597104 = parameters
  add(path_597102, "serviceName", newJString(serviceName))
  result = call_597101.call(path_597102, query_597103, nil, nil, body_597104)

var tenantConfigurationSave* = Call_TenantConfigurationSave_597092(
    name: "tenantConfigurationSave", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/configuration/save",
    validator: validate_TenantConfigurationSave_597093, base: "",
    url: url_TenantConfigurationSave_597094, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSyncStateGet_597105 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationSyncStateGet_597107(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/tenant/configuration/syncState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationSyncStateGet_597106(path: JsonNode;
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
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597108 = path.getOrDefault("resourceGroupName")
  valid_597108 = validateParameter(valid_597108, JString, required = true,
                                 default = nil)
  if valid_597108 != nil:
    section.add "resourceGroupName", valid_597108
  var valid_597109 = path.getOrDefault("subscriptionId")
  valid_597109 = validateParameter(valid_597109, JString, required = true,
                                 default = nil)
  if valid_597109 != nil:
    section.add "subscriptionId", valid_597109
  var valid_597110 = path.getOrDefault("serviceName")
  valid_597110 = validateParameter(valid_597110, JString, required = true,
                                 default = nil)
  if valid_597110 != nil:
    section.add "serviceName", valid_597110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597111 = query.getOrDefault("api-version")
  valid_597111 = validateParameter(valid_597111, JString, required = true,
                                 default = nil)
  if valid_597111 != nil:
    section.add "api-version", valid_597111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597112: Call_TenantConfigurationSyncStateGet_597105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  let valid = call_597112.validator(path, query, header, formData, body)
  let scheme = call_597112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597112.url(scheme.get, call_597112.host, call_597112.base,
                         call_597112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597112, url, valid)

proc call*(call_597113: Call_TenantConfigurationSyncStateGet_597105;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tenantConfigurationSyncStateGet
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597114 = newJObject()
  var query_597115 = newJObject()
  add(path_597114, "resourceGroupName", newJString(resourceGroupName))
  add(query_597115, "api-version", newJString(apiVersion))
  add(path_597114, "subscriptionId", newJString(subscriptionId))
  add(path_597114, "serviceName", newJString(serviceName))
  result = call_597113.call(path_597114, query_597115, nil, nil, nil)

var tenantConfigurationSyncStateGet* = Call_TenantConfigurationSyncStateGet_597105(
    name: "tenantConfigurationSyncStateGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/configuration/syncState",
    validator: validate_TenantConfigurationSyncStateGet_597106, base: "",
    url: url_TenantConfigurationSyncStateGet_597107, schemes: {Scheme.Https})
type
  Call_TenantConfigurationValidate_597116 = ref object of OpenApiRestCall_596457
proc url_TenantConfigurationValidate_597118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/configuration/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationValidate_597117(path: JsonNode; query: JsonNode;
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
  var valid_597121 = path.getOrDefault("serviceName")
  valid_597121 = validateParameter(valid_597121, JString, required = true,
                                 default = nil)
  if valid_597121 != nil:
    section.add "serviceName", valid_597121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597122 = query.getOrDefault("api-version")
  valid_597122 = validateParameter(valid_597122, JString, required = true,
                                 default = nil)
  if valid_597122 != nil:
    section.add "api-version", valid_597122
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

proc call*(call_597124: Call_TenantConfigurationValidate_597116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  let valid = call_597124.validator(path, query, header, formData, body)
  let scheme = call_597124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597124.url(scheme.get, call_597124.host, call_597124.base,
                         call_597124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597124, url, valid)

proc call*(call_597125: Call_TenantConfigurationValidate_597116;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tenantConfigurationValidate
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Validate Configuration parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597126 = newJObject()
  var query_597127 = newJObject()
  var body_597128 = newJObject()
  add(path_597126, "resourceGroupName", newJString(resourceGroupName))
  add(query_597127, "api-version", newJString(apiVersion))
  add(path_597126, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597128 = parameters
  add(path_597126, "serviceName", newJString(serviceName))
  result = call_597125.call(path_597126, query_597127, nil, nil, body_597128)

var tenantConfigurationValidate* = Call_TenantConfigurationValidate_597116(
    name: "tenantConfigurationValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/configuration/validate",
    validator: validate_TenantConfigurationValidate_597117, base: "",
    url: url_TenantConfigurationValidate_597118, schemes: {Scheme.Https})
type
  Call_TenantPolicyCreateOrUpdate_597140 = ref object of OpenApiRestCall_596457
proc url_TenantPolicyCreateOrUpdate_597142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/policy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantPolicyCreateOrUpdate_597141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates global policy configuration for the tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597143 = path.getOrDefault("resourceGroupName")
  valid_597143 = validateParameter(valid_597143, JString, required = true,
                                 default = nil)
  if valid_597143 != nil:
    section.add "resourceGroupName", valid_597143
  var valid_597144 = path.getOrDefault("subscriptionId")
  valid_597144 = validateParameter(valid_597144, JString, required = true,
                                 default = nil)
  if valid_597144 != nil:
    section.add "subscriptionId", valid_597144
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
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the tenant policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597147 = header.getOrDefault("If-Match")
  valid_597147 = validateParameter(valid_597147, JString, required = true,
                                 default = nil)
  if valid_597147 != nil:
    section.add "If-Match", valid_597147
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy content details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597149: Call_TenantPolicyCreateOrUpdate_597140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates global policy configuration for the tenant.
  ## 
  let valid = call_597149.validator(path, query, header, formData, body)
  let scheme = call_597149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597149.url(scheme.get, call_597149.host, call_597149.base,
                         call_597149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597149, url, valid)

proc call*(call_597150: Call_TenantPolicyCreateOrUpdate_597140;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tenantPolicyCreateOrUpdate
  ## Creates or updates global policy configuration for the tenant.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The policy content details.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597151 = newJObject()
  var query_597152 = newJObject()
  var body_597153 = newJObject()
  add(path_597151, "resourceGroupName", newJString(resourceGroupName))
  add(query_597152, "api-version", newJString(apiVersion))
  add(path_597151, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597153 = parameters
  add(path_597151, "serviceName", newJString(serviceName))
  result = call_597150.call(path_597151, query_597152, nil, nil, body_597153)

var tenantPolicyCreateOrUpdate* = Call_TenantPolicyCreateOrUpdate_597140(
    name: "tenantPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/policy",
    validator: validate_TenantPolicyCreateOrUpdate_597141, base: "",
    url: url_TenantPolicyCreateOrUpdate_597142, schemes: {Scheme.Https})
type
  Call_TenantPolicyGet_597129 = ref object of OpenApiRestCall_596457
proc url_TenantPolicyGet_597131(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/policy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantPolicyGet_597130(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the global policy configuration of the tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597132 = path.getOrDefault("resourceGroupName")
  valid_597132 = validateParameter(valid_597132, JString, required = true,
                                 default = nil)
  if valid_597132 != nil:
    section.add "resourceGroupName", valid_597132
  var valid_597133 = path.getOrDefault("subscriptionId")
  valid_597133 = validateParameter(valid_597133, JString, required = true,
                                 default = nil)
  if valid_597133 != nil:
    section.add "subscriptionId", valid_597133
  var valid_597134 = path.getOrDefault("serviceName")
  valid_597134 = validateParameter(valid_597134, JString, required = true,
                                 default = nil)
  if valid_597134 != nil:
    section.add "serviceName", valid_597134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597135 = query.getOrDefault("api-version")
  valid_597135 = validateParameter(valid_597135, JString, required = true,
                                 default = nil)
  if valid_597135 != nil:
    section.add "api-version", valid_597135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597136: Call_TenantPolicyGet_597129; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the global policy configuration of the tenant.
  ## 
  let valid = call_597136.validator(path, query, header, formData, body)
  let scheme = call_597136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597136.url(scheme.get, call_597136.host, call_597136.base,
                         call_597136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597136, url, valid)

proc call*(call_597137: Call_TenantPolicyGet_597129; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## tenantPolicyGet
  ## Get the global policy configuration of the tenant.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597138 = newJObject()
  var query_597139 = newJObject()
  add(path_597138, "resourceGroupName", newJString(resourceGroupName))
  add(query_597139, "api-version", newJString(apiVersion))
  add(path_597138, "subscriptionId", newJString(subscriptionId))
  add(path_597138, "serviceName", newJString(serviceName))
  result = call_597137.call(path_597138, query_597139, nil, nil, nil)

var tenantPolicyGet* = Call_TenantPolicyGet_597129(name: "tenantPolicyGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/policy",
    validator: validate_TenantPolicyGet_597130, base: "", url: url_TenantPolicyGet_597131,
    schemes: {Scheme.Https})
type
  Call_TenantPolicyDelete_597154 = ref object of OpenApiRestCall_596457
proc url_TenantPolicyDelete_597156(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tenant/policy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantPolicyDelete_597155(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the global tenant policy configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597157 = path.getOrDefault("resourceGroupName")
  valid_597157 = validateParameter(valid_597157, JString, required = true,
                                 default = nil)
  if valid_597157 != nil:
    section.add "resourceGroupName", valid_597157
  var valid_597158 = path.getOrDefault("subscriptionId")
  valid_597158 = validateParameter(valid_597158, JString, required = true,
                                 default = nil)
  if valid_597158 != nil:
    section.add "subscriptionId", valid_597158
  var valid_597159 = path.getOrDefault("serviceName")
  valid_597159 = validateParameter(valid_597159, JString, required = true,
                                 default = nil)
  if valid_597159 != nil:
    section.add "serviceName", valid_597159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597160 = query.getOrDefault("api-version")
  valid_597160 = validateParameter(valid_597160, JString, required = true,
                                 default = nil)
  if valid_597160 != nil:
    section.add "api-version", valid_597160
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the tenant policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597161 = header.getOrDefault("If-Match")
  valid_597161 = validateParameter(valid_597161, JString, required = true,
                                 default = nil)
  if valid_597161 != nil:
    section.add "If-Match", valid_597161
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597162: Call_TenantPolicyDelete_597154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the global tenant policy configuration.
  ## 
  let valid = call_597162.validator(path, query, header, formData, body)
  let scheme = call_597162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597162.url(scheme.get, call_597162.host, call_597162.base,
                         call_597162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597162, url, valid)

proc call*(call_597163: Call_TenantPolicyDelete_597154; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## tenantPolicyDelete
  ## Deletes the global tenant policy configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597164 = newJObject()
  var query_597165 = newJObject()
  add(path_597164, "resourceGroupName", newJString(resourceGroupName))
  add(query_597165, "api-version", newJString(apiVersion))
  add(path_597164, "subscriptionId", newJString(subscriptionId))
  add(path_597164, "serviceName", newJString(serviceName))
  result = call_597163.call(path_597164, query_597165, nil, nil, nil)

var tenantPolicyDelete* = Call_TenantPolicyDelete_597154(
    name: "tenantPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/policy",
    validator: validate_TenantPolicyDelete_597155, base: "",
    url: url_TenantPolicyDelete_597156, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
