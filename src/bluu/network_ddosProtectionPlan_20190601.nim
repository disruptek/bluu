
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2019-06-01
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
  macServiceName = "network-ddosProtectionPlan"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DdosProtectionPlansList_593630 = ref object of OpenApiRestCall_593408
proc url_DdosProtectionPlansList_593632(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansList_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all DDoS protection plans in a subscription.
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

proc call*(call_593820: Call_DdosProtectionPlansList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all DDoS protection plans in a subscription.
  ## 
  let valid = call_593820.validator(path, query, header, formData, body)
  let scheme = call_593820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593820.url(scheme.get, call_593820.host, call_593820.base,
                         call_593820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593820, url, valid)

proc call*(call_593891: Call_DdosProtectionPlansList_593630; apiVersion: string;
          subscriptionId: string): Recallable =
  ## ddosProtectionPlansList
  ## Gets all DDoS protection plans in a subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593892 = newJObject()
  var query_593894 = newJObject()
  add(query_593894, "api-version", newJString(apiVersion))
  add(path_593892, "subscriptionId", newJString(subscriptionId))
  result = call_593891.call(path_593892, query_593894, nil, nil, nil)

var ddosProtectionPlansList* = Call_DdosProtectionPlansList_593630(
    name: "ddosProtectionPlansList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network/ddosProtectionPlans",
    validator: validate_DdosProtectionPlansList_593631, base: "",
    url: url_DdosProtectionPlansList_593632, schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansListByResourceGroup_593933 = ref object of OpenApiRestCall_593408
proc url_DdosProtectionPlansListByResourceGroup_593935(protocol: Scheme;
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
        value: "/providers/Microsoft.Network/ddosProtectionPlans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansListByResourceGroup_593934(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the DDoS protection plans in a resource group.
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

proc call*(call_593939: Call_DdosProtectionPlansListByResourceGroup_593933;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the DDoS protection plans in a resource group.
  ## 
  let valid = call_593939.validator(path, query, header, formData, body)
  let scheme = call_593939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593939.url(scheme.get, call_593939.host, call_593939.base,
                         call_593939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593939, url, valid)

proc call*(call_593940: Call_DdosProtectionPlansListByResourceGroup_593933;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## ddosProtectionPlansListByResourceGroup
  ## Gets all the DDoS protection plans in a resource group.
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

var ddosProtectionPlansListByResourceGroup* = Call_DdosProtectionPlansListByResourceGroup_593933(
    name: "ddosProtectionPlansListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans",
    validator: validate_DdosProtectionPlansListByResourceGroup_593934, base: "",
    url: url_DdosProtectionPlansListByResourceGroup_593935,
    schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansCreateOrUpdate_593954 = ref object of OpenApiRestCall_593408
proc url_DdosProtectionPlansCreateOrUpdate_593956(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosProtectionPlanName" in path,
        "`ddosProtectionPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans/"),
               (kind: VariableSegment, value: "ddosProtectionPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansCreateOrUpdate_593955(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a DDoS protection plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: JString (required)
  ##                         : The name of the DDoS protection plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593983 = path.getOrDefault("resourceGroupName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "resourceGroupName", valid_593983
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  var valid_593985 = path.getOrDefault("ddosProtectionPlanName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "ddosProtectionPlanName", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_DdosProtectionPlansCreateOrUpdate_593954;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a DDoS protection plan.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_DdosProtectionPlansCreateOrUpdate_593954;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosProtectionPlanName: string; parameters: JsonNode): Recallable =
  ## ddosProtectionPlansCreateOrUpdate
  ## Creates or updates a DDoS protection plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: string (required)
  ##                         : The name of the DDoS protection plan.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update operation.
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  var body_593992 = newJObject()
  add(path_593990, "resourceGroupName", newJString(resourceGroupName))
  add(query_593991, "api-version", newJString(apiVersion))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  add(path_593990, "ddosProtectionPlanName", newJString(ddosProtectionPlanName))
  if parameters != nil:
    body_593992 = parameters
  result = call_593989.call(path_593990, query_593991, nil, nil, body_593992)

var ddosProtectionPlansCreateOrUpdate* = Call_DdosProtectionPlansCreateOrUpdate_593954(
    name: "ddosProtectionPlansCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}",
    validator: validate_DdosProtectionPlansCreateOrUpdate_593955, base: "",
    url: url_DdosProtectionPlansCreateOrUpdate_593956, schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansGet_593943 = ref object of OpenApiRestCall_593408
proc url_DdosProtectionPlansGet_593945(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosProtectionPlanName" in path,
        "`ddosProtectionPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans/"),
               (kind: VariableSegment, value: "ddosProtectionPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansGet_593944(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified DDoS protection plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: JString (required)
  ##                         : The name of the DDoS protection plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593946 = path.getOrDefault("resourceGroupName")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "resourceGroupName", valid_593946
  var valid_593947 = path.getOrDefault("subscriptionId")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "subscriptionId", valid_593947
  var valid_593948 = path.getOrDefault("ddosProtectionPlanName")
  valid_593948 = validateParameter(valid_593948, JString, required = true,
                                 default = nil)
  if valid_593948 != nil:
    section.add "ddosProtectionPlanName", valid_593948
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593949 = query.getOrDefault("api-version")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "api-version", valid_593949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593950: Call_DdosProtectionPlansGet_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified DDoS protection plan.
  ## 
  let valid = call_593950.validator(path, query, header, formData, body)
  let scheme = call_593950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593950.url(scheme.get, call_593950.host, call_593950.base,
                         call_593950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593950, url, valid)

proc call*(call_593951: Call_DdosProtectionPlansGet_593943;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosProtectionPlanName: string): Recallable =
  ## ddosProtectionPlansGet
  ## Gets information about the specified DDoS protection plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: string (required)
  ##                         : The name of the DDoS protection plan.
  var path_593952 = newJObject()
  var query_593953 = newJObject()
  add(path_593952, "resourceGroupName", newJString(resourceGroupName))
  add(query_593953, "api-version", newJString(apiVersion))
  add(path_593952, "subscriptionId", newJString(subscriptionId))
  add(path_593952, "ddosProtectionPlanName", newJString(ddosProtectionPlanName))
  result = call_593951.call(path_593952, query_593953, nil, nil, nil)

var ddosProtectionPlansGet* = Call_DdosProtectionPlansGet_593943(
    name: "ddosProtectionPlansGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}",
    validator: validate_DdosProtectionPlansGet_593944, base: "",
    url: url_DdosProtectionPlansGet_593945, schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansUpdateTags_594004 = ref object of OpenApiRestCall_593408
proc url_DdosProtectionPlansUpdateTags_594006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosProtectionPlanName" in path,
        "`ddosProtectionPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans/"),
               (kind: VariableSegment, value: "ddosProtectionPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansUpdateTags_594005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a DDoS protection plan tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: JString (required)
  ##                         : The name of the DDoS protection plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594007 = path.getOrDefault("resourceGroupName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "resourceGroupName", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  var valid_594009 = path.getOrDefault("ddosProtectionPlanName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "ddosProtectionPlanName", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update DDoS protection plan resource tags.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_DdosProtectionPlansUpdateTags_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a DDoS protection plan tags.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_DdosProtectionPlansUpdateTags_594004;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosProtectionPlanName: string; parameters: JsonNode): Recallable =
  ## ddosProtectionPlansUpdateTags
  ## Update a DDoS protection plan tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: string (required)
  ##                         : The name of the DDoS protection plan.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update DDoS protection plan resource tags.
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  var body_594016 = newJObject()
  add(path_594014, "resourceGroupName", newJString(resourceGroupName))
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "subscriptionId", newJString(subscriptionId))
  add(path_594014, "ddosProtectionPlanName", newJString(ddosProtectionPlanName))
  if parameters != nil:
    body_594016 = parameters
  result = call_594013.call(path_594014, query_594015, nil, nil, body_594016)

var ddosProtectionPlansUpdateTags* = Call_DdosProtectionPlansUpdateTags_594004(
    name: "ddosProtectionPlansUpdateTags", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}",
    validator: validate_DdosProtectionPlansUpdateTags_594005, base: "",
    url: url_DdosProtectionPlansUpdateTags_594006, schemes: {Scheme.Https})
type
  Call_DdosProtectionPlansDelete_593993 = ref object of OpenApiRestCall_593408
proc url_DdosProtectionPlansDelete_593995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "ddosProtectionPlanName" in path,
        "`ddosProtectionPlanName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Network/ddosProtectionPlans/"),
               (kind: VariableSegment, value: "ddosProtectionPlanName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DdosProtectionPlansDelete_593994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified DDoS protection plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: JString (required)
  ##                         : The name of the DDoS protection plan.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593996 = path.getOrDefault("resourceGroupName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "resourceGroupName", valid_593996
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  var valid_593998 = path.getOrDefault("ddosProtectionPlanName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "ddosProtectionPlanName", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_DdosProtectionPlansDelete_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified DDoS protection plan.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_DdosProtectionPlansDelete_593993;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          ddosProtectionPlanName: string): Recallable =
  ## ddosProtectionPlansDelete
  ## Deletes the specified DDoS protection plan.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   ddosProtectionPlanName: string (required)
  ##                         : The name of the DDoS protection plan.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(path_594002, "resourceGroupName", newJString(resourceGroupName))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(path_594002, "ddosProtectionPlanName", newJString(ddosProtectionPlanName))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var ddosProtectionPlansDelete* = Call_DdosProtectionPlansDelete_593993(
    name: "ddosProtectionPlansDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/ddosProtectionPlans/{ddosProtectionPlanName}",
    validator: validate_DdosProtectionPlansDelete_593994, base: "",
    url: url_DdosProtectionPlansDelete_593995, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
