
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2018-07-01
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_ServiceEndpointPoliciesList_593630 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPoliciesList_593632(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPoliciesList_593631(path: JsonNode; query: JsonNode;
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
  var valid_593792 = path.getOrDefault("subscriptionId")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "subscriptionId", valid_593792
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593793 = query.getOrDefault("api-version")
  valid_593793 = validateParameter(valid_593793, JString, required = true,
                                 default = nil)
  if valid_593793 != nil:
    section.add "api-version", valid_593793
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593820: Call_ServiceEndpointPoliciesList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the service endpoint policies in a subscription.
  ## 
  let valid = call_593820.validator(path, query, header, formData, body)
  let scheme = call_593820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593820.url(scheme.get, call_593820.host, call_593820.base,
                         call_593820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593820, url, valid)

proc call*(call_593891: Call_ServiceEndpointPoliciesList_593630;
          apiVersion: string; subscriptionId: string): Recallable =
  ## serviceEndpointPoliciesList
  ## Gets all the service endpoint policies in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593892 = newJObject()
  var query_593894 = newJObject()
  add(query_593894, "api-version", newJString(apiVersion))
  add(path_593892, "subscriptionId", newJString(subscriptionId))
  result = call_593891.call(path_593892, query_593894, nil, nil, nil)

var serviceEndpointPoliciesList* = Call_ServiceEndpointPoliciesList_593630(
    name: "serviceEndpointPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ServiceEndpointPolicies",
    validator: validate_ServiceEndpointPoliciesList_593631, base: "",
    url: url_ServiceEndpointPoliciesList_593632, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesListByResourceGroup_593933 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPoliciesListByResourceGroup_593935(protocol: Scheme;
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

proc validate_ServiceEndpointPoliciesListByResourceGroup_593934(path: JsonNode;
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
  var valid_593936 = path.getOrDefault("resourceGroupName")
  valid_593936 = validateParameter(valid_593936, JString, required = true,
                                 default = nil)
  if valid_593936 != nil:
    section.add "resourceGroupName", valid_593936
  var valid_593937 = path.getOrDefault("subscriptionId")
  valid_593937 = validateParameter(valid_593937, JString, required = true,
                                 default = nil)
  if valid_593937 != nil:
    section.add "subscriptionId", valid_593937
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593938 = query.getOrDefault("api-version")
  valid_593938 = validateParameter(valid_593938, JString, required = true,
                                 default = nil)
  if valid_593938 != nil:
    section.add "api-version", valid_593938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593939: Call_ServiceEndpointPoliciesListByResourceGroup_593933;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all service endpoint Policies in a resource group.
  ## 
  let valid = call_593939.validator(path, query, header, formData, body)
  let scheme = call_593939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593939.url(scheme.get, call_593939.host, call_593939.base,
                         call_593939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593939, url, valid)

proc call*(call_593940: Call_ServiceEndpointPoliciesListByResourceGroup_593933;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## serviceEndpointPoliciesListByResourceGroup
  ## Gets all service endpoint Policies in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593941 = newJObject()
  var query_593942 = newJObject()
  add(path_593941, "resourceGroupName", newJString(resourceGroupName))
  add(query_593942, "api-version", newJString(apiVersion))
  add(path_593941, "subscriptionId", newJString(subscriptionId))
  result = call_593940.call(path_593941, query_593942, nil, nil, nil)

var serviceEndpointPoliciesListByResourceGroup* = Call_ServiceEndpointPoliciesListByResourceGroup_593933(
    name: "serviceEndpointPoliciesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies",
    validator: validate_ServiceEndpointPoliciesListByResourceGroup_593934,
    base: "", url: url_ServiceEndpointPoliciesListByResourceGroup_593935,
    schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesCreateOrUpdate_593956 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPoliciesCreateOrUpdate_593958(protocol: Scheme;
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

proc validate_ServiceEndpointPoliciesCreateOrUpdate_593957(path: JsonNode;
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
  var valid_593985 = path.getOrDefault("resourceGroupName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "resourceGroupName", valid_593985
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  var valid_593987 = path.getOrDefault("serviceEndpointPolicyName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "serviceEndpointPolicyName", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
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

proc call*(call_593990: Call_ServiceEndpointPoliciesCreateOrUpdate_593956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a service Endpoint Policies.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_ServiceEndpointPoliciesCreateOrUpdate_593956;
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
  var path_593992 = newJObject()
  var query_593993 = newJObject()
  var body_593994 = newJObject()
  add(path_593992, "resourceGroupName", newJString(resourceGroupName))
  add(query_593993, "api-version", newJString(apiVersion))
  add(path_593992, "subscriptionId", newJString(subscriptionId))
  add(path_593992, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  if parameters != nil:
    body_593994 = parameters
  result = call_593991.call(path_593992, query_593993, nil, nil, body_593994)

var serviceEndpointPoliciesCreateOrUpdate* = Call_ServiceEndpointPoliciesCreateOrUpdate_593956(
    name: "serviceEndpointPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesCreateOrUpdate_593957, base: "",
    url: url_ServiceEndpointPoliciesCreateOrUpdate_593958, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesGet_593943 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPoliciesGet_593945(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPoliciesGet_593944(path: JsonNode; query: JsonNode;
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
  var valid_593947 = path.getOrDefault("resourceGroupName")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "resourceGroupName", valid_593947
  var valid_593948 = path.getOrDefault("subscriptionId")
  valid_593948 = validateParameter(valid_593948, JString, required = true,
                                 default = nil)
  if valid_593948 != nil:
    section.add "subscriptionId", valid_593948
  var valid_593949 = path.getOrDefault("serviceEndpointPolicyName")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "serviceEndpointPolicyName", valid_593949
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593950 = query.getOrDefault("api-version")
  valid_593950 = validateParameter(valid_593950, JString, required = true,
                                 default = nil)
  if valid_593950 != nil:
    section.add "api-version", valid_593950
  var valid_593951 = query.getOrDefault("$expand")
  valid_593951 = validateParameter(valid_593951, JString, required = false,
                                 default = nil)
  if valid_593951 != nil:
    section.add "$expand", valid_593951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593952: Call_ServiceEndpointPoliciesGet_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified service Endpoint Policies in a specified resource group.
  ## 
  let valid = call_593952.validator(path, query, header, formData, body)
  let scheme = call_593952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593952.url(scheme.get, call_593952.host, call_593952.base,
                         call_593952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593952, url, valid)

proc call*(call_593953: Call_ServiceEndpointPoliciesGet_593943;
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
  var path_593954 = newJObject()
  var query_593955 = newJObject()
  add(path_593954, "resourceGroupName", newJString(resourceGroupName))
  add(query_593955, "api-version", newJString(apiVersion))
  add(query_593955, "$expand", newJString(Expand))
  add(path_593954, "subscriptionId", newJString(subscriptionId))
  add(path_593954, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_593953.call(path_593954, query_593955, nil, nil, nil)

var serviceEndpointPoliciesGet* = Call_ServiceEndpointPoliciesGet_593943(
    name: "serviceEndpointPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesGet_593944, base: "",
    url: url_ServiceEndpointPoliciesGet_593945, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesUpdate_594006 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPoliciesUpdate_594008(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPoliciesUpdate_594007(path: JsonNode; query: JsonNode;
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
  var valid_594009 = path.getOrDefault("resourceGroupName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "resourceGroupName", valid_594009
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  var valid_594011 = path.getOrDefault("serviceEndpointPolicyName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "serviceEndpointPolicyName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
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

proc call*(call_594014: Call_ServiceEndpointPoliciesUpdate_594006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates service Endpoint Policies.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_ServiceEndpointPoliciesUpdate_594006;
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
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  add(path_594016, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  if parameters != nil:
    body_594018 = parameters
  result = call_594015.call(path_594016, query_594017, nil, nil, body_594018)

var serviceEndpointPoliciesUpdate* = Call_ServiceEndpointPoliciesUpdate_594006(
    name: "serviceEndpointPoliciesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesUpdate_594007, base: "",
    url: url_ServiceEndpointPoliciesUpdate_594008, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPoliciesDelete_593995 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPoliciesDelete_593997(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPoliciesDelete_593996(path: JsonNode; query: JsonNode;
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
  var valid_593998 = path.getOrDefault("resourceGroupName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "resourceGroupName", valid_593998
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  var valid_594000 = path.getOrDefault("serviceEndpointPolicyName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "serviceEndpointPolicyName", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_ServiceEndpointPoliciesDelete_593995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified service endpoint policy.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_ServiceEndpointPoliciesDelete_593995;
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
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(path_594004, "resourceGroupName", newJString(resourceGroupName))
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  add(path_594004, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var serviceEndpointPoliciesDelete* = Call_ServiceEndpointPoliciesDelete_593995(
    name: "serviceEndpointPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}",
    validator: validate_ServiceEndpointPoliciesDelete_593996, base: "",
    url: url_ServiceEndpointPoliciesDelete_593997, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_594019 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPolicyDefinitionsListByResourceGroup_594021(
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

proc validate_ServiceEndpointPolicyDefinitionsListByResourceGroup_594020(
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
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  var valid_594024 = path.getOrDefault("serviceEndpointPolicyName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "serviceEndpointPolicyName", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_594019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all service endpoint policy definitions in a service end point policy.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_594019;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(path_594028, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var serviceEndpointPolicyDefinitionsListByResourceGroup* = Call_ServiceEndpointPolicyDefinitionsListByResourceGroup_594019(
    name: "serviceEndpointPolicyDefinitionsListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions",
    validator: validate_ServiceEndpointPolicyDefinitionsListByResourceGroup_594020,
    base: "", url: url_ServiceEndpointPolicyDefinitionsListByResourceGroup_594021,
    schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_594042 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPolicyDefinitionsCreateOrUpdate_594044(protocol: Scheme;
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

proc validate_ServiceEndpointPolicyDefinitionsCreateOrUpdate_594043(
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
  var valid_594045 = path.getOrDefault("resourceGroupName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "resourceGroupName", valid_594045
  var valid_594046 = path.getOrDefault("serviceEndpointPolicyDefinitionName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "serviceEndpointPolicyDefinitionName", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("serviceEndpointPolicyName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "serviceEndpointPolicyName", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "api-version", valid_594049
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

proc call*(call_594051: Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_594042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a service endpoint policy definition in the specified service endpoint policy.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_594042;
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
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  var body_594055 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "serviceEndpointPolicyDefinitionName",
      newJString(serviceEndpointPolicyDefinitionName))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  if ServiceEndpointPolicyDefinitions != nil:
    body_594055 = ServiceEndpointPolicyDefinitions
  add(path_594053, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_594052.call(path_594053, query_594054, nil, nil, body_594055)

var serviceEndpointPolicyDefinitionsCreateOrUpdate* = Call_ServiceEndpointPolicyDefinitionsCreateOrUpdate_594042(
    name: "serviceEndpointPolicyDefinitionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions/{serviceEndpointPolicyDefinitionName}",
    validator: validate_ServiceEndpointPolicyDefinitionsCreateOrUpdate_594043,
    base: "", url: url_ServiceEndpointPolicyDefinitionsCreateOrUpdate_594044,
    schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsGet_594030 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPolicyDefinitionsGet_594032(protocol: Scheme; host: string;
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

proc validate_ServiceEndpointPolicyDefinitionsGet_594031(path: JsonNode;
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
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("serviceEndpointPolicyDefinitionName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "serviceEndpointPolicyDefinitionName", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  var valid_594036 = path.getOrDefault("serviceEndpointPolicyName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "serviceEndpointPolicyName", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_ServiceEndpointPolicyDefinitionsGet_594030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified service endpoint policy definitions from service endpoint policy.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_ServiceEndpointPolicyDefinitionsGet_594030;
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
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(path_594040, "resourceGroupName", newJString(resourceGroupName))
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "serviceEndpointPolicyDefinitionName",
      newJString(serviceEndpointPolicyDefinitionName))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  add(path_594040, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var serviceEndpointPolicyDefinitionsGet* = Call_ServiceEndpointPolicyDefinitionsGet_594030(
    name: "serviceEndpointPolicyDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions/{serviceEndpointPolicyDefinitionName}",
    validator: validate_ServiceEndpointPolicyDefinitionsGet_594031, base: "",
    url: url_ServiceEndpointPolicyDefinitionsGet_594032, schemes: {Scheme.Https})
type
  Call_ServiceEndpointPolicyDefinitionsDelete_594056 = ref object of OpenApiRestCall_593408
proc url_ServiceEndpointPolicyDefinitionsDelete_594058(protocol: Scheme;
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

proc validate_ServiceEndpointPolicyDefinitionsDelete_594057(path: JsonNode;
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
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("serviceEndpointPolicyDefinitionName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "serviceEndpointPolicyDefinitionName", valid_594060
  var valid_594061 = path.getOrDefault("subscriptionId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "subscriptionId", valid_594061
  var valid_594062 = path.getOrDefault("serviceEndpointPolicyName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "serviceEndpointPolicyName", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_ServiceEndpointPolicyDefinitionsDelete_594056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified ServiceEndpoint policy definitions.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_ServiceEndpointPolicyDefinitionsDelete_594056;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "serviceEndpointPolicyDefinitionName",
      newJString(serviceEndpointPolicyDefinitionName))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "serviceEndpointPolicyName",
      newJString(serviceEndpointPolicyName))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var serviceEndpointPolicyDefinitionsDelete* = Call_ServiceEndpointPolicyDefinitionsDelete_594056(
    name: "serviceEndpointPolicyDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/serviceEndpointPolicies/{serviceEndpointPolicyName}/serviceEndpointPolicyDefinitions/{serviceEndpointPolicyDefinitionName}",
    validator: validate_ServiceEndpointPolicyDefinitionsDelete_594057, base: "",
    url: url_ServiceEndpointPolicyDefinitionsDelete_594058,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
