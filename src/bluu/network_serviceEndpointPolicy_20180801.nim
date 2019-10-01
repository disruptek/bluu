
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2018-08-01
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  Call_ServiceEndpointPoliciesList_567863 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPoliciesList_567865(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPoliciesList_567864(path: JsonNode; query: JsonNode;
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
  var valid_568025 = path.getOrDefault("subscriptionId")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "subscriptionId", valid_568025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568026 = query.getOrDefault("api-version")
  valid_568026 = validateParameter(valid_568026, JString, required = true,
                                 default = nil)
  if valid_568026 != nil:
    section.add "api-version", valid_568026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568053: Call_ServiceEndpointPoliciesList_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the service endpoint policies in a subscription.
  ## 
  let valid = call_568053.validator(path, query, header, formData, body)
  let scheme = call_568053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568053.url(scheme.get, call_568053.host, call_568053.base,
                         call_568053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568053, url, valid)

proc call*(call_568124: Call_ServiceEndpointPoliciesList_567863;
          apiVersion: string; subscriptionId: string): Recallable =
  ## serviceEndpointPoliciesList
  ## Gets all the service endpoint policies in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568125 = newJObject()
  var query_568127 = newJObject()
  add(query_568127, "api-version", newJString(apiVersion))
  add(path_568125, "subscriptionId", newJString(subscriptionId))
  result = call_568124.call(path_568125, query_568127, nil, nil, nil)

var serviceEndpointPoliciesList* = Call_ServiceEndpointPoliciesList_567863(
    name: "serviceEndpointPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ServiceEndpointPolicies",
    validator: validate_ServiceEndpointPoliciesList_567864, base: "",
    url: url_ServiceEndpointPoliciesList_567865, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesListByResourceGroup_568166 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPoliciesListByResourceGroup_568168(protocol: Scheme;
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

proc validate_ServiceEndpointPoliciesListByResourceGroup_568167(path: JsonNode;
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
  var valid_568169 = path.getOrDefault("resourceGroupName")
  valid_568169 = validateParameter(valid_568169, JString, required = true,
                                 default = nil)
  if valid_568169 != nil:
    section.add "resourceGroupName", valid_568169
  var valid_568170 = path.getOrDefault("subscriptionId")
  valid_568170 = validateParameter(valid_568170, JString, required = true,
                                 default = nil)
  if valid_568170 != nil:
    section.add "subscriptionId", valid_568170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568171 = query.getOrDefault("api-version")
  valid_568171 = validateParameter(valid_568171, JString, required = true,
                                 default = nil)
  if valid_568171 != nil:
    section.add "api-version", valid_568171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568172: Call_ServiceEndpointPoliciesListByResourceGroup_568166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all service endpoint Policies in a resource group.
  ## 
  let valid = call_568172.validator(path, query, header, formData, body)
  let scheme = call_568172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568172.url(scheme.get, call_568172.host, call_568172.base,
                         call_568172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568172, url, valid)

proc call*(call_568173: Call_ServiceEndpointPoliciesListByResourceGroup_568166;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## serviceEndpointPoliciesListByResourceGroup
  ## Gets all service endpoint Policies in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568174 = newJObject()
  var query_568175 = newJObject()
  add(path_568174, "resourceGroupName", newJString(resourceGroupName))
  add(query_568175, "api-version", newJString(apiVersion))
  add(path_568174, "subscriptionId", newJString(subscriptionId))
  result = call_568173.call(path_568174, query_568175, nil, nil, nil)

var serviceEndpointPoliciesListByResourceGroup* = Call_ServiceEndpointPoliciesListByResourceGroup_568166(
    name: "serviceEndpointPoliciesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies",
    validator: validate_ServiceEndpointPoliciesListByResourceGroup_568167,
    base: "", url: url_ServiceEndpointPoliciesListByResourceGroup_568168,
    schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesCreateOrUpdate_568189 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPoliciesCreateOrUpdate_568191(protocol: Scheme;
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

proc validate_ServiceEndpointPoliciesCreateOrUpdate_568190(path: JsonNode;
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
  var valid_568218 = path.getOrDefault("resourceGroupName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "resourceGroupName", valid_568218
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  var valid_568220 = path.getOrDefault("serviceEndpointPolicyName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "serviceEndpointPolicyName", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
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

proc call*(call_568223: Call_ServiceEndpointPoliciesCreateOrUpdate_568189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a service Endpoint Policies.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_ServiceEndpointPoliciesCreateOrUpdate_568189;
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
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  var body_568227 = newJObject()
  add(path_568225, "resourceGroupName", newJString(resourceGroupName))
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  add(path_568225, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  if parameters != nil:
    body_568227 = parameters
  result = call_568224.call(path_568225, query_568226, nil, nil, body_568227)

var serviceEndpointPoliciesCreateOrUpdate* = Call_ServiceEndpointPoliciesCreateOrUpdate_568189(
    name: "serviceEndpointPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesCreateOrUpdate_568190, base: "",
    url: url_ServiceEndpointPoliciesCreateOrUpdate_568191, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesGet_568176 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPoliciesGet_568178(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPoliciesGet_568177(path: JsonNode; query: JsonNode;
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
  var valid_568180 = path.getOrDefault("resourceGroupName")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "resourceGroupName", valid_568180
  var valid_568181 = path.getOrDefault("subscriptionId")
  valid_568181 = validateParameter(valid_568181, JString, required = true,
                                 default = nil)
  if valid_568181 != nil:
    section.add "subscriptionId", valid_568181
  var valid_568182 = path.getOrDefault("serviceEndpointPolicyName")
  valid_568182 = validateParameter(valid_568182, JString, required = true,
                                 default = nil)
  if valid_568182 != nil:
    section.add "serviceEndpointPolicyName", valid_568182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568183 = query.getOrDefault("api-version")
  valid_568183 = validateParameter(valid_568183, JString, required = true,
                                 default = nil)
  if valid_568183 != nil:
    section.add "api-version", valid_568183
  var valid_568184 = query.getOrDefault("$expand")
  valid_568184 = validateParameter(valid_568184, JString, required = false,
                                 default = nil)
  if valid_568184 != nil:
    section.add "$expand", valid_568184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568185: Call_ServiceEndpointPoliciesGet_568176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified service Endpoint Policies in a specified resource group.
  ## 
  let valid = call_568185.validator(path, query, header, formData, body)
  let scheme = call_568185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568185.url(scheme.get, call_568185.host, call_568185.base,
                         call_568185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568185, url, valid)

proc call*(call_568186: Call_ServiceEndpointPoliciesGet_568176;
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
  var path_568187 = newJObject()
  var query_568188 = newJObject()
  add(path_568187, "resourceGroupName", newJString(resourceGroupName))
  add(query_568188, "api-version", newJString(apiVersion))
  add(query_568188, "$expand", newJString(Expand))
  add(path_568187, "subscriptionId", newJString(subscriptionId))
  add(path_568187, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_568186.call(path_568187, query_568188, nil, nil, nil)

var serviceEndpointPoliciesGet* = Call_ServiceEndpointPoliciesGet_568176(
    name: "serviceEndpointPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesGet_568177, base: "",
    url: url_ServiceEndpointPoliciesGet_568178, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesUpdate_568239 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPoliciesUpdate_568241(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPoliciesUpdate_568240(path: JsonNode; query: JsonNode;
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
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  var valid_568244 = path.getOrDefault("serviceEndpointPolicyName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "serviceEndpointPolicyName", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
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

proc call*(call_568247: Call_ServiceEndpointPoliciesUpdate_568239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates service Endpoint Policies.
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_ServiceEndpointPoliciesUpdate_568239;
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
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  var body_568251 = newJObject()
  add(path_568249, "resourceGroupName", newJString(resourceGroupName))
  add(query_568250, "api-version", newJString(apiVersion))
  add(path_568249, "subscriptionId", newJString(subscriptionId))
  add(path_568249, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  if parameters != nil:
    body_568251 = parameters
  result = call_568248.call(path_568249, query_568250, nil, nil, body_568251)

var serviceEndpointPoliciesUpdate* = Call_ServiceEndpointPoliciesUpdate_568239(
    name: "serviceEndpointPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesUpdate_568240, base: "",
    url: url_ServiceEndpointPoliciesUpdate_568241, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesDelete_568228 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPoliciesDelete_568230(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPoliciesDelete_568229(path: JsonNode; query: JsonNode;
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
  var valid_568231 = path.getOrDefault("resourceGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "resourceGroupName", valid_568231
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  var valid_568233 = path.getOrDefault("serviceEndpointPolicyName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "serviceEndpointPolicyName", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568235: Call_ServiceEndpointPoliciesDelete_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified service endpoint policy.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_ServiceEndpointPoliciesDelete_568228;
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
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(path_568237, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_568236.call(path_568237, query_568238, nil, nil, nil)

var serviceEndpointPoliciesDelete* = Call_ServiceEndpointPoliciesDelete_568228(
    name: "serviceEndpointPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesDelete_568229, base: "",
    url: url_ServiceEndpointPoliciesDelete_568230, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_568252 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPolicyDefinitionsListByResourceGroup_568254(
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

proc validate_ServiceEndpointPolicyDefinitionsListByResourceGroup_568253(
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
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  var valid_568257 = path.getOrDefault("serviceEndpointPolicyName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "serviceEndpointPolicyName", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_568252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all service endpoint policy definitions in a service end point policy.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_568252;
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
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  add(path_568261, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var serviceEndpointPolicyDefinitionsListByResourceGroup* = Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_568252(
    name: "serviceEndpointPolicyDefinitionsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions",
    validator: validate_ServiceEndpointPolicyDefinitionsListByResourceGroup_568253,
    base: "", url: url_ServiceEndpointPolicyDefinitionsListByResourceGroup_568254,
    schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_568275 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPolicyDefinitionsCreateOrUpdate_568277(protocol: Scheme;
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

proc validate_ServiceEndpointPolicyDefinitionsCreateOrUpdate_568276(
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
  var valid_568278 = path.getOrDefault("resourceGroupName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "resourceGroupName", valid_568278
  var valid_568279 = path.getOrDefault("serviceEndpointPolicyDefinitionName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "serviceEndpointPolicyDefinitionName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  var valid_568281 = path.getOrDefault("serviceEndpointPolicyName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "serviceEndpointPolicyName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
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

proc call*(call_568284: Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_568275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a service endpoint policy definition in the specified service endpoint policy.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_568275;
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
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  var body_568288 = newJObject()
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "serviceEndpointPolicyDefinitionName",
      newJString(serviceEndpointPolicyDefinitionName))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  if ServiceEndpointPolicyDefinitions != nil:
    body_568288 = ServiceEndpointPolicyDefinitions
  add(path_568286, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_568285.call(path_568286, query_568287, nil, nil, body_568288)

var serviceEndpointPolicyDefinitionsCreateOrUpdate* = Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_568275(
    name: "serviceEndpointPolicyDefinitionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions/{serviceEndpointPolicyDefinitionName}",
    validator: validate_ServiceEndpointPolicyDefinitionsCreateOrUpdate_568276,
    base: "", url: url_ServiceEndpointPolicyDefinitionsCreateOrUpdate_568277,
    schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsGet_568263 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPolicyDefinitionsGet_568265(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPolicyDefinitionsGet_568264(path: JsonNode;
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
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("serviceEndpointPolicyDefinitionName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "serviceEndpointPolicyDefinitionName", valid_568267
  var valid_568268 = path.getOrDefault("subscriptionId")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "subscriptionId", valid_568268
  var valid_568269 = path.getOrDefault("serviceEndpointPolicyName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "serviceEndpointPolicyName", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_ServiceEndpointPolicyDefinitionsGet_568263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified service endpoint policy definitions from service endpoint policy.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_ServiceEndpointPolicyDefinitionsGet_568263;
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
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  add(path_568273, "resourceGroupName", newJString(resourceGroupName))
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "serviceEndpointPolicyDefinitionName",
      newJString(serviceEndpointPolicyDefinitionName))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  add(path_568273, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_568272.call(path_568273, query_568274, nil, nil, nil)

var serviceEndpointPolicyDefinitionsGet* = Call_ServiceEndpointPolicyDefinitionsGet_568263(
    name: "serviceEndpointPolicyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions/{serviceEndpointPolicyDefinitionName}",
    validator: validate_ServiceEndpointPolicyDefinitionsGet_568264, base: "",
    url: url_ServiceEndpointPolicyDefinitionsGet_568265, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsDelete_568289 = ref object of OpenApiRestCall_567641
proc url_ServiceEndpointPolicyDefinitionsDelete_568291(protocol: Scheme;
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

proc validate_ServiceEndpointPolicyDefinitionsDelete_568290(path: JsonNode;
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
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("serviceEndpointPolicyDefinitionName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "serviceEndpointPolicyDefinitionName", valid_568293
  var valid_568294 = path.getOrDefault("subscriptionId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "subscriptionId", valid_568294
  var valid_568295 = path.getOrDefault("serviceEndpointPolicyName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "serviceEndpointPolicyName", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568297: Call_ServiceEndpointPolicyDefinitionsDelete_568289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified ServiceEndpoint policy definitions.
  ## 
  let valid = call_568297.validator(path, query, header, formData, body)
  let scheme = call_568297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568297.url(scheme.get, call_568297.host, call_568297.base,
                         call_568297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568297, url, valid)

proc call*(call_568298: Call_ServiceEndpointPolicyDefinitionsDelete_568289;
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
  var path_568299 = newJObject()
  var query_568300 = newJObject()
  add(path_568299, "resourceGroupName", newJString(resourceGroupName))
  add(query_568300, "api-version", newJString(apiVersion))
  add(path_568299, "serviceEndpointPolicyDefinitionName",
      newJString(serviceEndpointPolicyDefinitionName))
  add(path_568299, "subscriptionId", newJString(subscriptionId))
  add(path_568299, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_568298.call(path_568299, query_568300, nil, nil, nil)

var serviceEndpointPolicyDefinitionsDelete* = Call_ServiceEndpointPolicyDefinitionsDelete_568289(
    name: "serviceEndpointPolicyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions/{serviceEndpointPolicyDefinitionName}",
    validator: validate_ServiceEndpointPolicyDefinitionsDelete_568290, base: "",
    url: url_ServiceEndpointPolicyDefinitionsDelete_568291,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
