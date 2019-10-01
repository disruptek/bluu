
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on entities like API, Product, and Subscription associated with your Azure API Management deployment.
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
  macServiceName = "apimanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyListByService_596679 = ref object of OpenApiRestCall_596457
proc url_PolicyListByService_596681(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyListByService_596680(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all the Global Policy definitions of the Api Management service.
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
  var valid_596854 = path.getOrDefault("resourceGroupName")
  valid_596854 = validateParameter(valid_596854, JString, required = true,
                                 default = nil)
  if valid_596854 != nil:
    section.add "resourceGroupName", valid_596854
  var valid_596855 = path.getOrDefault("subscriptionId")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = nil)
  if valid_596855 != nil:
    section.add "subscriptionId", valid_596855
  var valid_596856 = path.getOrDefault("serviceName")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "serviceName", valid_596856
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   scope: JString
  ##        : Policy scope.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596857 = query.getOrDefault("api-version")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "api-version", valid_596857
  var valid_596871 = query.getOrDefault("scope")
  valid_596871 = validateParameter(valid_596871, JString, required = false,
                                 default = newJString("Tenant"))
  if valid_596871 != nil:
    section.add "scope", valid_596871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596894: Call_PolicyListByService_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Global Policy definitions of the Api Management service.
  ## 
  let valid = call_596894.validator(path, query, header, formData, body)
  let scheme = call_596894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596894.url(scheme.get, call_596894.host, call_596894.base,
                         call_596894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596894, url, valid)

proc call*(call_596965: Call_PolicyListByService_596679; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          scope: string = "Tenant"): Recallable =
  ## policyListByService
  ## Lists all the Global Policy definitions of the Api Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   scope: string
  ##        : Policy scope.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_596966 = newJObject()
  var query_596968 = newJObject()
  add(path_596966, "resourceGroupName", newJString(resourceGroupName))
  add(query_596968, "api-version", newJString(apiVersion))
  add(query_596968, "scope", newJString(scope))
  add(path_596966, "subscriptionId", newJString(subscriptionId))
  add(path_596966, "serviceName", newJString(serviceName))
  result = call_596965.call(path_596966, query_596968, nil, nil, nil)

var policyListByService* = Call_PolicyListByService_596679(
    name: "policyListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies",
    validator: validate_PolicyListByService_596680, base: "",
    url: url_PolicyListByService_596681, schemes: {Scheme.Https})
type
  Call_PolicyCreateOrUpdate_597019 = ref object of OpenApiRestCall_596457
proc url_PolicyCreateOrUpdate_597021(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyCreateOrUpdate_597020(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the global policy configuration of the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597039 = path.getOrDefault("resourceGroupName")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "resourceGroupName", valid_597039
  var valid_597040 = path.getOrDefault("subscriptionId")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "subscriptionId", valid_597040
  var valid_597041 = path.getOrDefault("policyId")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = newJString("policy"))
  if valid_597041 != nil:
    section.add "policyId", valid_597041
  var valid_597042 = path.getOrDefault("serviceName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "serviceName", valid_597042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597043 = query.getOrDefault("api-version")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "api-version", valid_597043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597045: Call_PolicyCreateOrUpdate_597019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the global policy configuration of the Api Management service.
  ## 
  let valid = call_597045.validator(path, query, header, formData, body)
  let scheme = call_597045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597045.url(scheme.get, call_597045.host, call_597045.base,
                         call_597045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597045, url, valid)

proc call*(call_597046: Call_PolicyCreateOrUpdate_597019;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string; policyId: string = "policy"): Recallable =
  ## policyCreateOrUpdate
  ## Creates or updates the global policy configuration of the Api Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597047 = newJObject()
  var query_597048 = newJObject()
  var body_597049 = newJObject()
  add(path_597047, "resourceGroupName", newJString(resourceGroupName))
  add(query_597048, "api-version", newJString(apiVersion))
  add(path_597047, "subscriptionId", newJString(subscriptionId))
  add(path_597047, "policyId", newJString(policyId))
  if parameters != nil:
    body_597049 = parameters
  add(path_597047, "serviceName", newJString(serviceName))
  result = call_597046.call(path_597047, query_597048, nil, nil, body_597049)

var policyCreateOrUpdate* = Call_PolicyCreateOrUpdate_597019(
    name: "policyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}",
    validator: validate_PolicyCreateOrUpdate_597020, base: "",
    url: url_PolicyCreateOrUpdate_597021, schemes: {Scheme.Https})
type
  Call_PolicyGetEntityTag_597063 = ref object of OpenApiRestCall_596457
proc url_PolicyGetEntityTag_597065(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyGetEntityTag_597064(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
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
  var valid_597067 = path.getOrDefault("subscriptionId")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "subscriptionId", valid_597067
  var valid_597068 = path.getOrDefault("policyId")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = newJString("policy"))
  if valid_597068 != nil:
    section.add "policyId", valid_597068
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

proc call*(call_597071: Call_PolicyGetEntityTag_597063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
  ## 
  let valid = call_597071.validator(path, query, header, formData, body)
  let scheme = call_597071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597071.url(scheme.get, call_597071.host, call_597071.base,
                         call_597071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597071, url, valid)

proc call*(call_597072: Call_PolicyGetEntityTag_597063; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          policyId: string = "policy"): Recallable =
  ## policyGetEntityTag
  ## Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597073 = newJObject()
  var query_597074 = newJObject()
  add(path_597073, "resourceGroupName", newJString(resourceGroupName))
  add(query_597074, "api-version", newJString(apiVersion))
  add(path_597073, "subscriptionId", newJString(subscriptionId))
  add(path_597073, "policyId", newJString(policyId))
  add(path_597073, "serviceName", newJString(serviceName))
  result = call_597072.call(path_597073, query_597074, nil, nil, nil)

var policyGetEntityTag* = Call_PolicyGetEntityTag_597063(
    name: "policyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}",
    validator: validate_PolicyGetEntityTag_597064, base: "",
    url: url_PolicyGetEntityTag_597065, schemes: {Scheme.Https})
type
  Call_PolicyGet_597007 = ref object of OpenApiRestCall_596457
proc url_PolicyGet_597009(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyGet_597008(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the Global policy definition of the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597010 = path.getOrDefault("resourceGroupName")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "resourceGroupName", valid_597010
  var valid_597011 = path.getOrDefault("subscriptionId")
  valid_597011 = validateParameter(valid_597011, JString, required = true,
                                 default = nil)
  if valid_597011 != nil:
    section.add "subscriptionId", valid_597011
  var valid_597012 = path.getOrDefault("policyId")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = newJString("policy"))
  if valid_597012 != nil:
    section.add "policyId", valid_597012
  var valid_597013 = path.getOrDefault("serviceName")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "serviceName", valid_597013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597014 = query.getOrDefault("api-version")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "api-version", valid_597014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597015: Call_PolicyGet_597007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Global policy definition of the Api Management service.
  ## 
  let valid = call_597015.validator(path, query, header, formData, body)
  let scheme = call_597015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597015.url(scheme.get, call_597015.host, call_597015.base,
                         call_597015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597015, url, valid)

proc call*(call_597016: Call_PolicyGet_597007; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          policyId: string = "policy"): Recallable =
  ## policyGet
  ## Get the Global policy definition of the Api Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597017 = newJObject()
  var query_597018 = newJObject()
  add(path_597017, "resourceGroupName", newJString(resourceGroupName))
  add(query_597018, "api-version", newJString(apiVersion))
  add(path_597017, "subscriptionId", newJString(subscriptionId))
  add(path_597017, "policyId", newJString(policyId))
  add(path_597017, "serviceName", newJString(serviceName))
  result = call_597016.call(path_597017, query_597018, nil, nil, nil)

var policyGet* = Call_PolicyGet_597007(name: "policyGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}",
                                    validator: validate_PolicyGet_597008,
                                    base: "", url: url_PolicyGet_597009,
                                    schemes: {Scheme.Https})
type
  Call_PolicyDelete_597050 = ref object of OpenApiRestCall_596457
proc url_PolicyDelete_597052(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDelete_597051(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the global policy configuration of the Api Management Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597053 = path.getOrDefault("resourceGroupName")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "resourceGroupName", valid_597053
  var valid_597054 = path.getOrDefault("subscriptionId")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "subscriptionId", valid_597054
  var valid_597055 = path.getOrDefault("policyId")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = newJString("policy"))
  if valid_597055 != nil:
    section.add "policyId", valid_597055
  var valid_597056 = path.getOrDefault("serviceName")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "serviceName", valid_597056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597057 = query.getOrDefault("api-version")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "api-version", valid_597057
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597058 = header.getOrDefault("If-Match")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "If-Match", valid_597058
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597059: Call_PolicyDelete_597050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the global policy configuration of the Api Management Service.
  ## 
  let valid = call_597059.validator(path, query, header, formData, body)
  let scheme = call_597059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597059.url(scheme.get, call_597059.host, call_597059.base,
                         call_597059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597059, url, valid)

proc call*(call_597060: Call_PolicyDelete_597050; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          policyId: string = "policy"): Recallable =
  ## policyDelete
  ## Deletes the global policy configuration of the Api Management Service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597061 = newJObject()
  var query_597062 = newJObject()
  add(path_597061, "resourceGroupName", newJString(resourceGroupName))
  add(query_597062, "api-version", newJString(apiVersion))
  add(path_597061, "subscriptionId", newJString(subscriptionId))
  add(path_597061, "policyId", newJString(policyId))
  add(path_597061, "serviceName", newJString(serviceName))
  result = call_597060.call(path_597061, query_597062, nil, nil, nil)

var policyDelete* = Call_PolicyDelete_597050(name: "policyDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}",
    validator: validate_PolicyDelete_597051, base: "", url: url_PolicyDelete_597052,
    schemes: {Scheme.Https})
type
  Call_PolicySnippetsListByService_597075 = ref object of OpenApiRestCall_596457
proc url_PolicySnippetsListByService_597077(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/policySnippets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySnippetsListByService_597076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all policy snippets.
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
  var valid_597078 = path.getOrDefault("resourceGroupName")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "resourceGroupName", valid_597078
  var valid_597079 = path.getOrDefault("subscriptionId")
  valid_597079 = validateParameter(valid_597079, JString, required = true,
                                 default = nil)
  if valid_597079 != nil:
    section.add "subscriptionId", valid_597079
  var valid_597080 = path.getOrDefault("serviceName")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "serviceName", valid_597080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   scope: JString
  ##        : Policy scope.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597081 = query.getOrDefault("api-version")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "api-version", valid_597081
  var valid_597082 = query.getOrDefault("scope")
  valid_597082 = validateParameter(valid_597082, JString, required = false,
                                 default = newJString("Tenant"))
  if valid_597082 != nil:
    section.add "scope", valid_597082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597083: Call_PolicySnippetsListByService_597075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all policy snippets.
  ## 
  let valid = call_597083.validator(path, query, header, formData, body)
  let scheme = call_597083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597083.url(scheme.get, call_597083.host, call_597083.base,
                         call_597083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597083, url, valid)

proc call*(call_597084: Call_PolicySnippetsListByService_597075;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; scope: string = "Tenant"): Recallable =
  ## policySnippetsListByService
  ## Lists all policy snippets.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   scope: string
  ##        : Policy scope.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597085 = newJObject()
  var query_597086 = newJObject()
  add(path_597085, "resourceGroupName", newJString(resourceGroupName))
  add(query_597086, "api-version", newJString(apiVersion))
  add(query_597086, "scope", newJString(scope))
  add(path_597085, "subscriptionId", newJString(subscriptionId))
  add(path_597085, "serviceName", newJString(serviceName))
  result = call_597084.call(path_597085, query_597086, nil, nil, nil)

var policySnippetsListByService* = Call_PolicySnippetsListByService_597075(
    name: "policySnippetsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policySnippets",
    validator: validate_PolicySnippetsListByService_597076, base: "",
    url: url_PolicySnippetsListByService_597077, schemes: {Scheme.Https})
type
  Call_RegionsListByService_597087 = ref object of OpenApiRestCall_596457
proc url_RegionsListByService_597089(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/regions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegionsListByService_597088(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all azure regions in which the service exists.
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
  var valid_597090 = path.getOrDefault("resourceGroupName")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "resourceGroupName", valid_597090
  var valid_597091 = path.getOrDefault("subscriptionId")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "subscriptionId", valid_597091
  var valid_597092 = path.getOrDefault("serviceName")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "serviceName", valid_597092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597093 = query.getOrDefault("api-version")
  valid_597093 = validateParameter(valid_597093, JString, required = true,
                                 default = nil)
  if valid_597093 != nil:
    section.add "api-version", valid_597093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597094: Call_RegionsListByService_597087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all azure regions in which the service exists.
  ## 
  let valid = call_597094.validator(path, query, header, formData, body)
  let scheme = call_597094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597094.url(scheme.get, call_597094.host, call_597094.base,
                         call_597094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597094, url, valid)

proc call*(call_597095: Call_RegionsListByService_597087;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## regionsListByService
  ## Lists all azure regions in which the service exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597096 = newJObject()
  var query_597097 = newJObject()
  add(path_597096, "resourceGroupName", newJString(resourceGroupName))
  add(query_597097, "api-version", newJString(apiVersion))
  add(path_597096, "subscriptionId", newJString(subscriptionId))
  add(path_597096, "serviceName", newJString(serviceName))
  result = call_597095.call(path_597096, query_597097, nil, nil, nil)

var regionsListByService* = Call_RegionsListByService_597087(
    name: "regionsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/regions",
    validator: validate_RegionsListByService_597088, base: "",
    url: url_RegionsListByService_597089, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
