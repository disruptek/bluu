
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
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

  OpenApiRestCall_573641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573641): Option[Scheme] {.used.} =
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
  macServiceName = "network-serviceEndpointPolicy"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceEndpointPoliciesList_573863 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPoliciesList_573865(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ServiceEndpointPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPoliciesList_573864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the service endpoint policies in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574025 = path.getOrDefault("subscriptionId")
  valid_574025 = validateParameter(valid_574025, JString, required = true,
                                 default = nil)
  if valid_574025 != nil:
    section.add "subscriptionId", valid_574025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574026 = query.getOrDefault("api-version")
  valid_574026 = validateParameter(valid_574026, JString, required = true,
                                 default = nil)
  if valid_574026 != nil:
    section.add "api-version", valid_574026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574053: Call_ServiceEndpointPoliciesList_573863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the service endpoint policies in a subscription.
  ## 
  let valid = call_574053.validator(path, query, header, formData, body)
  let scheme = call_574053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574053.url(scheme.get, call_574053.host, call_574053.base,
                         call_574053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574053, url, valid)

proc call*(call_574124: Call_ServiceEndpointPoliciesList_573863;
          apiVersion: string; subscriptionId: string): Recallable =
  ## serviceEndpointPoliciesList
  ## Gets all the service endpoint policies in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574125 = newJObject()
  var query_574127 = newJObject()
  add(query_574127, "api-version", newJString(apiVersion))
  add(path_574125, "subscriptionId", newJString(subscriptionId))
  result = call_574124.call(path_574125, query_574127, nil, nil, nil)

var serviceEndpointPoliciesList* = Call_ServiceEndpointPoliciesList_573863(
    name: "serviceEndpointPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ServiceEndpointPolicies",
    validator: validate_ServiceEndpointPoliciesList_573864, base: "",
    url: url_ServiceEndpointPoliciesList_573865, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesListByResourceGroup_574166 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPoliciesListByResourceGroup_574168(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/serviceEndpointPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPoliciesListByResourceGroup_574167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all service endpoint Policies in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574169 = path.getOrDefault("resourceGroupName")
  valid_574169 = validateParameter(valid_574169, JString, required = true,
                                 default = nil)
  if valid_574169 != nil:
    section.add "resourceGroupName", valid_574169
  var valid_574170 = path.getOrDefault("subscriptionId")
  valid_574170 = validateParameter(valid_574170, JString, required = true,
                                 default = nil)
  if valid_574170 != nil:
    section.add "subscriptionId", valid_574170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574171 = query.getOrDefault("api-version")
  valid_574171 = validateParameter(valid_574171, JString, required = true,
                                 default = nil)
  if valid_574171 != nil:
    section.add "api-version", valid_574171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574172: Call_ServiceEndpointPoliciesListByResourceGroup_574166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all service endpoint Policies in a resource group.
  ## 
  let valid = call_574172.validator(path, query, header, formData, body)
  let scheme = call_574172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574172.url(scheme.get, call_574172.host, call_574172.base,
                         call_574172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574172, url, valid)

proc call*(call_574173: Call_ServiceEndpointPoliciesListByResourceGroup_574166;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## serviceEndpointPoliciesListByResourceGroup
  ## Gets all service endpoint Policies in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574174 = newJObject()
  var query_574175 = newJObject()
  add(path_574174, "resourceGroupName", newJString(resourceGroupName))
  add(query_574175, "api-version", newJString(apiVersion))
  add(path_574174, "subscriptionId", newJString(subscriptionId))
  result = call_574173.call(path_574174, query_574175, nil, nil, nil)

var serviceEndpointPoliciesListByResourceGroup* = Call_ServiceEndpointPoliciesListByResourceGroup_574166(
    name: "serviceEndpointPoliciesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies",
    validator: validate_ServiceEndpointPoliciesListByResourceGroup_574167,
    base: "", url: url_ServiceEndpointPoliciesListByResourceGroup_574168,
    schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesCreateOrUpdate_574189 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPoliciesCreateOrUpdate_574191(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceEndpointPolicyName" in path,
        "`serviceEndpointPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/serviceEndpointPolicies/"),
               (kind: VariableSegment, value: "serviceEndpointPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPoliciesCreateOrUpdate_574190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a service Endpoint Policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: JString (required)
  ##                            : The name of the service endpoint policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574218 = path.getOrDefault("resourceGroupName")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "resourceGroupName", valid_574218
  var valid_574219 = path.getOrDefault("subscriptionId")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "subscriptionId", valid_574219
  var valid_574220 = path.getOrDefault("serviceEndpointPolicyName")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = nil)
  if valid_574220 != nil:
    section.add "serviceEndpointPolicyName", valid_574220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574221 = query.getOrDefault("api-version")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "api-version", valid_574221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update service endpoint policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574223: Call_ServiceEndpointPoliciesCreateOrUpdate_574189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a service Endpoint Policies.
  ## 
  let valid = call_574223.validator(path, query, header, formData, body)
  let scheme = call_574223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574223.url(scheme.get, call_574223.host, call_574223.base,
                         call_574223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574223, url, valid)

proc call*(call_574224: Call_ServiceEndpointPoliciesCreateOrUpdate_574189;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceEndpointPolicyName: string; parameters: JsonNode): Recallable =
  ## serviceEndpointPoliciesCreateOrUpdate
  ## Creates or updates a service Endpoint Policies.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: string (required)
  ##                            : The name of the service endpoint policy.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update service endpoint policy operation.
  var path_574225 = newJObject()
  var query_574226 = newJObject()
  var body_574227 = newJObject()
  add(path_574225, "resourceGroupName", newJString(resourceGroupName))
  add(query_574226, "api-version", newJString(apiVersion))
  add(path_574225, "subscriptionId", newJString(subscriptionId))
  add(path_574225, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  if parameters != nil:
    body_574227 = parameters
  result = call_574224.call(path_574225, query_574226, nil, nil, body_574227)

var serviceEndpointPoliciesCreateOrUpdate* = Call_ServiceEndpointPoliciesCreateOrUpdate_574189(
    name: "serviceEndpointPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesCreateOrUpdate_574190, base: "",
    url: url_ServiceEndpointPoliciesCreateOrUpdate_574191, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesGet_574176 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPoliciesGet_574178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceEndpointPolicyName" in path,
        "`serviceEndpointPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/serviceEndpointPolicies/"),
               (kind: VariableSegment, value: "serviceEndpointPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPoliciesGet_574177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified service Endpoint Policies in a specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: JString (required)
  ##                            : The name of the service endpoint policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574180 = path.getOrDefault("resourceGroupName")
  valid_574180 = validateParameter(valid_574180, JString, required = true,
                                 default = nil)
  if valid_574180 != nil:
    section.add "resourceGroupName", valid_574180
  var valid_574181 = path.getOrDefault("subscriptionId")
  valid_574181 = validateParameter(valid_574181, JString, required = true,
                                 default = nil)
  if valid_574181 != nil:
    section.add "subscriptionId", valid_574181
  var valid_574182 = path.getOrDefault("serviceEndpointPolicyName")
  valid_574182 = validateParameter(valid_574182, JString, required = true,
                                 default = nil)
  if valid_574182 != nil:
    section.add "serviceEndpointPolicyName", valid_574182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574183 = query.getOrDefault("api-version")
  valid_574183 = validateParameter(valid_574183, JString, required = true,
                                 default = nil)
  if valid_574183 != nil:
    section.add "api-version", valid_574183
  var valid_574184 = query.getOrDefault("$expand")
  valid_574184 = validateParameter(valid_574184, JString, required = false,
                                 default = nil)
  if valid_574184 != nil:
    section.add "$expand", valid_574184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574185: Call_ServiceEndpointPoliciesGet_574176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified service Endpoint Policies in a specified resource group.
  ## 
  let valid = call_574185.validator(path, query, header, formData, body)
  let scheme = call_574185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574185.url(scheme.get, call_574185.host, call_574185.base,
                         call_574185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574185, url, valid)

proc call*(call_574186: Call_ServiceEndpointPoliciesGet_574176;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceEndpointPolicyName: string; Expand: string = ""): Recallable =
  ## serviceEndpointPoliciesGet
  ## Gets the specified service Endpoint Policies in a specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: string (required)
  ##                            : The name of the service endpoint policy.
  var path_574187 = newJObject()
  var query_574188 = newJObject()
  add(path_574187, "resourceGroupName", newJString(resourceGroupName))
  add(query_574188, "api-version", newJString(apiVersion))
  add(query_574188, "$expand", newJString(Expand))
  add(path_574187, "subscriptionId", newJString(subscriptionId))
  add(path_574187, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_574186.call(path_574187, query_574188, nil, nil, nil)

var serviceEndpointPoliciesGet* = Call_ServiceEndpointPoliciesGet_574176(
    name: "serviceEndpointPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesGet_574177, base: "",
    url: url_ServiceEndpointPoliciesGet_574178, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesUpdate_574239 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPoliciesUpdate_574241(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceEndpointPolicyName" in path,
        "`serviceEndpointPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/serviceEndpointPolicies/"),
               (kind: VariableSegment, value: "serviceEndpointPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPoliciesUpdate_574240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates service Endpoint Policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: JString (required)
  ##                            : The name of the service endpoint policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574242 = path.getOrDefault("resourceGroupName")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "resourceGroupName", valid_574242
  var valid_574243 = path.getOrDefault("subscriptionId")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "subscriptionId", valid_574243
  var valid_574244 = path.getOrDefault("serviceEndpointPolicyName")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "serviceEndpointPolicyName", valid_574244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574245 = query.getOrDefault("api-version")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "api-version", valid_574245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update service endpoint policy tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574247: Call_ServiceEndpointPoliciesUpdate_574239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates service Endpoint Policies.
  ## 
  let valid = call_574247.validator(path, query, header, formData, body)
  let scheme = call_574247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574247.url(scheme.get, call_574247.host, call_574247.base,
                         call_574247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574247, url, valid)

proc call*(call_574248: Call_ServiceEndpointPoliciesUpdate_574239;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceEndpointPolicyName: string; parameters: JsonNode): Recallable =
  ## serviceEndpointPoliciesUpdate
  ## Updates service Endpoint Policies.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: string (required)
  ##                            : The name of the service endpoint policy.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update service endpoint policy tags.
  var path_574249 = newJObject()
  var query_574250 = newJObject()
  var body_574251 = newJObject()
  add(path_574249, "resourceGroupName", newJString(resourceGroupName))
  add(query_574250, "api-version", newJString(apiVersion))
  add(path_574249, "subscriptionId", newJString(subscriptionId))
  add(path_574249, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  if parameters != nil:
    body_574251 = parameters
  result = call_574248.call(path_574249, query_574250, nil, nil, body_574251)

var serviceEndpointPoliciesUpdate* = Call_ServiceEndpointPoliciesUpdate_574239(
    name: "serviceEndpointPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesUpdate_574240, base: "",
    url: url_ServiceEndpointPoliciesUpdate_574241, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesDelete_574228 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPoliciesDelete_574230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceEndpointPolicyName" in path,
        "`serviceEndpointPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/serviceEndpointPolicies/"),
               (kind: VariableSegment, value: "serviceEndpointPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPoliciesDelete_574229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified service endpoint policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: JString (required)
  ##                            : The name of the service endpoint policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574231 = path.getOrDefault("resourceGroupName")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "resourceGroupName", valid_574231
  var valid_574232 = path.getOrDefault("subscriptionId")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "subscriptionId", valid_574232
  var valid_574233 = path.getOrDefault("serviceEndpointPolicyName")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "serviceEndpointPolicyName", valid_574233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574234 = query.getOrDefault("api-version")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "api-version", valid_574234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574235: Call_ServiceEndpointPoliciesDelete_574228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified service endpoint policy.
  ## 
  let valid = call_574235.validator(path, query, header, formData, body)
  let scheme = call_574235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574235.url(scheme.get, call_574235.host, call_574235.base,
                         call_574235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574235, url, valid)

proc call*(call_574236: Call_ServiceEndpointPoliciesDelete_574228;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceEndpointPolicyName: string): Recallable =
  ## serviceEndpointPoliciesDelete
  ## Deletes the specified service endpoint policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: string (required)
  ##                            : The name of the service endpoint policy.
  var path_574237 = newJObject()
  var query_574238 = newJObject()
  add(path_574237, "resourceGroupName", newJString(resourceGroupName))
  add(query_574238, "api-version", newJString(apiVersion))
  add(path_574237, "subscriptionId", newJString(subscriptionId))
  add(path_574237, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_574236.call(path_574237, query_574238, nil, nil, nil)

var serviceEndpointPoliciesDelete* = Call_ServiceEndpointPoliciesDelete_574228(
    name: "serviceEndpointPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesDelete_574229, base: "",
    url: url_ServiceEndpointPoliciesDelete_574230, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_574252 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPolicyDefinitionsListByResourceGroup_574254(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceEndpointPolicyName" in path,
        "`serviceEndpointPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/serviceEndpointPolicies/"),
               (kind: VariableSegment, value: "serviceEndpointPolicyName"), (
        kind: ConstantSegment, value: "/serviceEndpointPolicyDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPolicyDefinitionsListByResourceGroup_574253(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all service endpoint policy definitions in a service end point policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: JString (required)
  ##                            : The name of the service endpoint policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574255 = path.getOrDefault("resourceGroupName")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "resourceGroupName", valid_574255
  var valid_574256 = path.getOrDefault("subscriptionId")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "subscriptionId", valid_574256
  var valid_574257 = path.getOrDefault("serviceEndpointPolicyName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "serviceEndpointPolicyName", valid_574257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_574259: Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_574252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all service endpoint policy definitions in a service end point policy.
  ## 
  let valid = call_574259.validator(path, query, header, formData, body)
  let scheme = call_574259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574259.url(scheme.get, call_574259.host, call_574259.base,
                         call_574259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574259, url, valid)

proc call*(call_574260: Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_574252;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceEndpointPolicyName: string): Recallable =
  ## serviceEndpointPolicyDefinitionsListByResourceGroup
  ## Gets all service endpoint policy definitions in a service end point policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: string (required)
  ##                            : The name of the service endpoint policy name.
  var path_574261 = newJObject()
  var query_574262 = newJObject()
  add(path_574261, "resourceGroupName", newJString(resourceGroupName))
  add(query_574262, "api-version", newJString(apiVersion))
  add(path_574261, "subscriptionId", newJString(subscriptionId))
  add(path_574261, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_574260.call(path_574261, query_574262, nil, nil, nil)

var serviceEndpointPolicyDefinitionsListByResourceGroup* = Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_574252(
    name: "serviceEndpointPolicyDefinitionsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions",
    validator: validate_ServiceEndpointPolicyDefinitionsListByResourceGroup_574253,
    base: "", url: url_ServiceEndpointPolicyDefinitionsListByResourceGroup_574254,
    schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_574275 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPolicyDefinitionsCreateOrUpdate_574277(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceEndpointPolicyName" in path,
        "`serviceEndpointPolicyName` is a required path parameter"
  assert "serviceEndpointPolicyDefinitionName" in path,
        "`serviceEndpointPolicyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/serviceEndpointPolicies/"),
               (kind: VariableSegment, value: "serviceEndpointPolicyName"), (
        kind: ConstantSegment, value: "/serviceEndpointPolicyDefinitions/"), (
        kind: VariableSegment, value: "serviceEndpointPolicyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPolicyDefinitionsCreateOrUpdate_574276(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates a service endpoint policy definition in the specified service endpoint policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   serviceEndpointPolicyDefinitionName: JString (required)
  ##                                      : The name of the service endpoint policy definition name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: JString (required)
  ##                            : The name of the service endpoint policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574278 = path.getOrDefault("resourceGroupName")
  valid_574278 = validateParameter(valid_574278, JString, required = true,
                                 default = nil)
  if valid_574278 != nil:
    section.add "resourceGroupName", valid_574278
  var valid_574279 = path.getOrDefault("serviceEndpointPolicyDefinitionName")
  valid_574279 = validateParameter(valid_574279, JString, required = true,
                                 default = nil)
  if valid_574279 != nil:
    section.add "serviceEndpointPolicyDefinitionName", valid_574279
  var valid_574280 = path.getOrDefault("subscriptionId")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "subscriptionId", valid_574280
  var valid_574281 = path.getOrDefault("serviceEndpointPolicyName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "serviceEndpointPolicyName", valid_574281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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
  ## parameters in `body` object:
  ##   ServiceEndpointPolicyDefinitions: JObject (required)
  ##                                   : Parameters supplied to the create or update service endpoint policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574284: Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_574275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a service endpoint policy definition in the specified service endpoint policy.
  ## 
  let valid = call_574284.validator(path, query, header, formData, body)
  let scheme = call_574284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574284.url(scheme.get, call_574284.host, call_574284.base,
                         call_574284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574284, url, valid)

proc call*(call_574285: Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_574275;
          resourceGroupName: string; apiVersion: string;
          serviceEndpointPolicyDefinitionName: string; subscriptionId: string;
          ServiceEndpointPolicyDefinitions: JsonNode;
          serviceEndpointPolicyName: string): Recallable =
  ## serviceEndpointPolicyDefinitionsCreateOrUpdate
  ## Creates or updates a service endpoint policy definition in the specified service endpoint policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   serviceEndpointPolicyDefinitionName: string (required)
  ##                                      : The name of the service endpoint policy definition name.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ServiceEndpointPolicyDefinitions: JObject (required)
  ##                                   : Parameters supplied to the create or update service endpoint policy operation.
  ##   serviceEndpointPolicyName: string (required)
  ##                            : The name of the service endpoint policy.
  var path_574286 = newJObject()
  var query_574287 = newJObject()
  var body_574288 = newJObject()
  add(path_574286, "resourceGroupName", newJString(resourceGroupName))
  add(query_574287, "api-version", newJString(apiVersion))
  add(path_574286, "serviceEndpointPolicyDefinitionName",
      newJString(serviceEndpointPolicyDefinitionName))
  add(path_574286, "subscriptionId", newJString(subscriptionId))
  if ServiceEndpointPolicyDefinitions != nil:
    body_574288 = ServiceEndpointPolicyDefinitions
  add(path_574286, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_574285.call(path_574286, query_574287, nil, nil, body_574288)

var serviceEndpointPolicyDefinitionsCreateOrUpdate* = Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_574275(
    name: "serviceEndpointPolicyDefinitionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions/{serviceEndpointPolicyDefinitionName}",
    validator: validate_ServiceEndpointPolicyDefinitionsCreateOrUpdate_574276,
    base: "", url: url_ServiceEndpointPolicyDefinitionsCreateOrUpdate_574277,
    schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsGet_574263 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPolicyDefinitionsGet_574265(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceEndpointPolicyName" in path,
        "`serviceEndpointPolicyName` is a required path parameter"
  assert "serviceEndpointPolicyDefinitionName" in path,
        "`serviceEndpointPolicyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/serviceEndpointPolicies/"),
               (kind: VariableSegment, value: "serviceEndpointPolicyName"), (
        kind: ConstantSegment, value: "/serviceEndpointPolicyDefinitions/"), (
        kind: VariableSegment, value: "serviceEndpointPolicyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPolicyDefinitionsGet_574264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified service endpoint policy definitions from service endpoint policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   serviceEndpointPolicyDefinitionName: JString (required)
  ##                                      : The name of the service endpoint policy definition name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: JString (required)
  ##                            : The name of the service endpoint policy name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574266 = path.getOrDefault("resourceGroupName")
  valid_574266 = validateParameter(valid_574266, JString, required = true,
                                 default = nil)
  if valid_574266 != nil:
    section.add "resourceGroupName", valid_574266
  var valid_574267 = path.getOrDefault("serviceEndpointPolicyDefinitionName")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "serviceEndpointPolicyDefinitionName", valid_574267
  var valid_574268 = path.getOrDefault("subscriptionId")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "subscriptionId", valid_574268
  var valid_574269 = path.getOrDefault("serviceEndpointPolicyName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "serviceEndpointPolicyName", valid_574269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
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

proc call*(call_574271: Call_ServiceEndpointPolicyDefinitionsGet_574263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified service endpoint policy definitions from service endpoint policy.
  ## 
  let valid = call_574271.validator(path, query, header, formData, body)
  let scheme = call_574271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574271.url(scheme.get, call_574271.host, call_574271.base,
                         call_574271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574271, url, valid)

proc call*(call_574272: Call_ServiceEndpointPolicyDefinitionsGet_574263;
          resourceGroupName: string; apiVersion: string;
          serviceEndpointPolicyDefinitionName: string; subscriptionId: string;
          serviceEndpointPolicyName: string): Recallable =
  ## serviceEndpointPolicyDefinitionsGet
  ## Get the specified service endpoint policy definitions from service endpoint policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   serviceEndpointPolicyDefinitionName: string (required)
  ##                                      : The name of the service endpoint policy definition name.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: string (required)
  ##                            : The name of the service endpoint policy name.
  var path_574273 = newJObject()
  var query_574274 = newJObject()
  add(path_574273, "resourceGroupName", newJString(resourceGroupName))
  add(query_574274, "api-version", newJString(apiVersion))
  add(path_574273, "serviceEndpointPolicyDefinitionName",
      newJString(serviceEndpointPolicyDefinitionName))
  add(path_574273, "subscriptionId", newJString(subscriptionId))
  add(path_574273, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_574272.call(path_574273, query_574274, nil, nil, nil)

var serviceEndpointPolicyDefinitionsGet* = Call_ServiceEndpointPolicyDefinitionsGet_574263(
    name: "serviceEndpointPolicyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions/{serviceEndpointPolicyDefinitionName}",
    validator: validate_ServiceEndpointPolicyDefinitionsGet_574264, base: "",
    url: url_ServiceEndpointPolicyDefinitionsGet_574265, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsDelete_574289 = ref object of OpenApiRestCall_573641
proc url_ServiceEndpointPolicyDefinitionsDelete_574291(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceEndpointPolicyName" in path,
        "`serviceEndpointPolicyName` is a required path parameter"
  assert "serviceEndpointPolicyDefinitionName" in path,
        "`serviceEndpointPolicyDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/serviceEndpointPolicies/"),
               (kind: VariableSegment, value: "serviceEndpointPolicyName"), (
        kind: ConstantSegment, value: "/serviceEndpointPolicyDefinitions/"), (
        kind: VariableSegment, value: "serviceEndpointPolicyDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceEndpointPolicyDefinitionsDelete_574290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified ServiceEndpoint policy definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   serviceEndpointPolicyDefinitionName: JString (required)
  ##                                      : The name of the service endpoint policy definition.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: JString (required)
  ##                            : The name of the Service Endpoint Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574292 = path.getOrDefault("resourceGroupName")
  valid_574292 = validateParameter(valid_574292, JString, required = true,
                                 default = nil)
  if valid_574292 != nil:
    section.add "resourceGroupName", valid_574292
  var valid_574293 = path.getOrDefault("serviceEndpointPolicyDefinitionName")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "serviceEndpointPolicyDefinitionName", valid_574293
  var valid_574294 = path.getOrDefault("subscriptionId")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "subscriptionId", valid_574294
  var valid_574295 = path.getOrDefault("serviceEndpointPolicyName")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "serviceEndpointPolicyName", valid_574295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574296 = query.getOrDefault("api-version")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "api-version", valid_574296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574297: Call_ServiceEndpointPolicyDefinitionsDelete_574289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified ServiceEndpoint policy definitions.
  ## 
  let valid = call_574297.validator(path, query, header, formData, body)
  let scheme = call_574297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574297.url(scheme.get, call_574297.host, call_574297.base,
                         call_574297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574297, url, valid)

proc call*(call_574298: Call_ServiceEndpointPolicyDefinitionsDelete_574289;
          resourceGroupName: string; apiVersion: string;
          serviceEndpointPolicyDefinitionName: string; subscriptionId: string;
          serviceEndpointPolicyName: string): Recallable =
  ## serviceEndpointPolicyDefinitionsDelete
  ## Deletes the specified ServiceEndpoint policy definitions.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   serviceEndpointPolicyDefinitionName: string (required)
  ##                                      : The name of the service endpoint policy definition.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceEndpointPolicyName: string (required)
  ##                            : The name of the Service Endpoint Policy.
  var path_574299 = newJObject()
  var query_574300 = newJObject()
  add(path_574299, "resourceGroupName", newJString(resourceGroupName))
  add(query_574300, "api-version", newJString(apiVersion))
  add(path_574299, "serviceEndpointPolicyDefinitionName",
      newJString(serviceEndpointPolicyDefinitionName))
  add(path_574299, "subscriptionId", newJString(subscriptionId))
  add(path_574299, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_574298.call(path_574299, query_574300, nil, nil, nil)

var serviceEndpointPolicyDefinitionsDelete* = Call_ServiceEndpointPolicyDefinitionsDelete_574289(
    name: "serviceEndpointPolicyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions/{serviceEndpointPolicyDefinitionName}",
    validator: validate_ServiceEndpointPolicyDefinitionsDelete_574290, base: "",
    url: url_ServiceEndpointPolicyDefinitionsDelete_574291,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
