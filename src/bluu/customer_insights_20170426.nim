
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: CustomerInsightsManagementClient
## version: 2017-04-26
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Customer Insights management API provides a RESTful set of web services that interact with Azure Customer Insights service to manage your resources. The API has entities that capture the relationship between an end user and the Azure Customer Insights service.
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "customer-insights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_OperationsList_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563788(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Customer Insights REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563950 = query.getOrDefault("api-version")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "api-version", valid_563950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563973: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Customer Insights REST API operations.
  ## 
  let valid = call_563973.validator(path, query, header, formData, body)
  let scheme = call_563973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563973.url(scheme.get, call_563973.host, call_563973.base,
                         call_563973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563973, url, valid)

proc call*(call_564044: Call_OperationsList_563787; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Customer Insights REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  result = call_564044.call(nil, query_564045, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CustomerInsights/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_HubsList_564085 = ref object of OpenApiRestCall_563565
proc url_HubsList_564087(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CustomerInsights/hubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HubsList_564086(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all hubs in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564103 = query.getOrDefault("api-version")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "api-version", valid_564103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564104: Call_HubsList_564085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all hubs in the specified subscription.
  ## 
  let valid = call_564104.validator(path, query, header, formData, body)
  let scheme = call_564104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564104.url(scheme.get, call_564104.host, call_564104.base,
                         call_564104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564104, url, valid)

proc call*(call_564105: Call_HubsList_564085; apiVersion: string;
          subscriptionId: string): Recallable =
  ## hubsList
  ## Gets all hubs in the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564106 = newJObject()
  var query_564107 = newJObject()
  add(query_564107, "api-version", newJString(apiVersion))
  add(path_564106, "subscriptionId", newJString(subscriptionId))
  result = call_564105.call(path_564106, query_564107, nil, nil, nil)

var hubsList* = Call_HubsList_564085(name: "hubsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CustomerInsights/hubs",
                                  validator: validate_HubsList_564086, base: "",
                                  url: url_HubsList_564087,
                                  schemes: {Scheme.Https})
type
  Call_HubsListByResourceGroup_564108 = ref object of OpenApiRestCall_563565
proc url_HubsListByResourceGroup_564110(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.CustomerInsights/hubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HubsListByResourceGroup_564109(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the hubs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564111 = path.getOrDefault("subscriptionId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "subscriptionId", valid_564111
  var valid_564112 = path.getOrDefault("resourceGroupName")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "resourceGroupName", valid_564112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_HubsListByResourceGroup_564108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the hubs in a resource group.
  ## 
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_HubsListByResourceGroup_564108; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## hubsListByResourceGroup
  ## Gets all the hubs in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564116 = newJObject()
  var query_564117 = newJObject()
  add(query_564117, "api-version", newJString(apiVersion))
  add(path_564116, "subscriptionId", newJString(subscriptionId))
  add(path_564116, "resourceGroupName", newJString(resourceGroupName))
  result = call_564115.call(path_564116, query_564117, nil, nil, nil)

var hubsListByResourceGroup* = Call_HubsListByResourceGroup_564108(
    name: "hubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs",
    validator: validate_HubsListByResourceGroup_564109, base: "",
    url: url_HubsListByResourceGroup_564110, schemes: {Scheme.Https})
type
  Call_HubsCreateOrUpdate_564129 = ref object of OpenApiRestCall_563565
proc url_HubsCreateOrUpdate_564131(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HubsCreateOrUpdate_564130(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a hub, or updates an existing hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the Hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  var valid_564150 = path.getOrDefault("resourceGroupName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "resourceGroupName", valid_564150
  var valid_564151 = path.getOrDefault("hubName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "hubName", valid_564151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564152 = query.getOrDefault("api-version")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "api-version", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Hub operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_HubsCreateOrUpdate_564129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a hub, or updates an existing hub.
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_HubsCreateOrUpdate_564129; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          parameters: JsonNode): Recallable =
  ## hubsCreateOrUpdate
  ## Creates a hub, or updates an existing hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the Hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Hub operation.
  var path_564156 = newJObject()
  var query_564157 = newJObject()
  var body_564158 = newJObject()
  add(query_564157, "api-version", newJString(apiVersion))
  add(path_564156, "subscriptionId", newJString(subscriptionId))
  add(path_564156, "resourceGroupName", newJString(resourceGroupName))
  add(path_564156, "hubName", newJString(hubName))
  if parameters != nil:
    body_564158 = parameters
  result = call_564155.call(path_564156, query_564157, nil, nil, body_564158)

var hubsCreateOrUpdate* = Call_HubsCreateOrUpdate_564129(
    name: "hubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
    validator: validate_HubsCreateOrUpdate_564130, base: "",
    url: url_HubsCreateOrUpdate_564131, schemes: {Scheme.Https})
type
  Call_HubsGet_564118 = ref object of OpenApiRestCall_563565
proc url_HubsGet_564120(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HubsGet_564119(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564121 = path.getOrDefault("subscriptionId")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "subscriptionId", valid_564121
  var valid_564122 = path.getOrDefault("resourceGroupName")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "resourceGroupName", valid_564122
  var valid_564123 = path.getOrDefault("hubName")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "hubName", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "api-version", valid_564124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564125: Call_HubsGet_564118; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified hub.
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_HubsGet_564118; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## hubsGet
  ## Gets information about the specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  add(query_564128, "api-version", newJString(apiVersion))
  add(path_564127, "subscriptionId", newJString(subscriptionId))
  add(path_564127, "resourceGroupName", newJString(resourceGroupName))
  add(path_564127, "hubName", newJString(hubName))
  result = call_564126.call(path_564127, query_564128, nil, nil, nil)

var hubsGet* = Call_HubsGet_564118(name: "hubsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
                                validator: validate_HubsGet_564119, base: "",
                                url: url_HubsGet_564120, schemes: {Scheme.Https})
type
  Call_HubsUpdate_564170 = ref object of OpenApiRestCall_563565
proc url_HubsUpdate_564172(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HubsUpdate_564171(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the Hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  var valid_564174 = path.getOrDefault("resourceGroupName")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "resourceGroupName", valid_564174
  var valid_564175 = path.getOrDefault("hubName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "hubName", valid_564175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564176 = query.getOrDefault("api-version")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "api-version", valid_564176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Hub operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564178: Call_HubsUpdate_564170; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Hub.
  ## 
  let valid = call_564178.validator(path, query, header, formData, body)
  let scheme = call_564178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564178.url(scheme.get, call_564178.host, call_564178.base,
                         call_564178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564178, url, valid)

proc call*(call_564179: Call_HubsUpdate_564170; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          parameters: JsonNode): Recallable =
  ## hubsUpdate
  ## Updates a Hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the Hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Hub operation.
  var path_564180 = newJObject()
  var query_564181 = newJObject()
  var body_564182 = newJObject()
  add(query_564181, "api-version", newJString(apiVersion))
  add(path_564180, "subscriptionId", newJString(subscriptionId))
  add(path_564180, "resourceGroupName", newJString(resourceGroupName))
  add(path_564180, "hubName", newJString(hubName))
  if parameters != nil:
    body_564182 = parameters
  result = call_564179.call(path_564180, query_564181, nil, nil, body_564182)

var hubsUpdate* = Call_HubsUpdate_564170(name: "hubsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
                                      validator: validate_HubsUpdate_564171,
                                      base: "", url: url_HubsUpdate_564172,
                                      schemes: {Scheme.Https})
type
  Call_HubsDelete_564159 = ref object of OpenApiRestCall_563565
proc url_HubsDelete_564161(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HubsDelete_564160(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("resourceGroupName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "resourceGroupName", valid_564163
  var valid_564164 = path.getOrDefault("hubName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "hubName", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564165 = query.getOrDefault("api-version")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "api-version", valid_564165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564166: Call_HubsDelete_564159; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified hub.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_HubsDelete_564159; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## hubsDelete
  ## Deletes the specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  add(query_564169, "api-version", newJString(apiVersion))
  add(path_564168, "subscriptionId", newJString(subscriptionId))
  add(path_564168, "resourceGroupName", newJString(resourceGroupName))
  add(path_564168, "hubName", newJString(hubName))
  result = call_564167.call(path_564168, query_564169, nil, nil, nil)

var hubsDelete* = Call_HubsDelete_564159(name: "hubsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
                                      validator: validate_HubsDelete_564160,
                                      base: "", url: url_HubsDelete_564161,
                                      schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesListByHub_564183 = ref object of OpenApiRestCall_563565
proc url_AuthorizationPoliciesListByHub_564185(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/authorizationPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationPoliciesListByHub_564184(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the authorization policies in a specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564186 = path.getOrDefault("subscriptionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "subscriptionId", valid_564186
  var valid_564187 = path.getOrDefault("resourceGroupName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "resourceGroupName", valid_564187
  var valid_564188 = path.getOrDefault("hubName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "hubName", valid_564188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564189 = query.getOrDefault("api-version")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "api-version", valid_564189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564190: Call_AuthorizationPoliciesListByHub_564183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the authorization policies in a specified hub.
  ## 
  let valid = call_564190.validator(path, query, header, formData, body)
  let scheme = call_564190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564190.url(scheme.get, call_564190.host, call_564190.base,
                         call_564190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564190, url, valid)

proc call*(call_564191: Call_AuthorizationPoliciesListByHub_564183;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## authorizationPoliciesListByHub
  ## Gets all the authorization policies in a specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564192 = newJObject()
  var query_564193 = newJObject()
  add(query_564193, "api-version", newJString(apiVersion))
  add(path_564192, "subscriptionId", newJString(subscriptionId))
  add(path_564192, "resourceGroupName", newJString(resourceGroupName))
  add(path_564192, "hubName", newJString(hubName))
  result = call_564191.call(path_564192, query_564193, nil, nil, nil)

var authorizationPoliciesListByHub* = Call_AuthorizationPoliciesListByHub_564183(
    name: "authorizationPoliciesListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies",
    validator: validate_AuthorizationPoliciesListByHub_564184, base: "",
    url: url_AuthorizationPoliciesListByHub_564185, schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesCreateOrUpdate_564206 = ref object of OpenApiRestCall_563565
proc url_AuthorizationPoliciesCreateOrUpdate_564208(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "authorizationPolicyName" in path,
        "`authorizationPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/authorizationPolicies/"),
               (kind: VariableSegment, value: "authorizationPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationPoliciesCreateOrUpdate_564207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an authorization policy or updates an existing authorization policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationPolicyName: JString (required)
  ##                          : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationPolicyName` field"
  var valid_564209 = path.getOrDefault("authorizationPolicyName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "authorizationPolicyName", valid_564209
  var valid_564210 = path.getOrDefault("subscriptionId")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "subscriptionId", valid_564210
  var valid_564211 = path.getOrDefault("resourceGroupName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "resourceGroupName", valid_564211
  var valid_564212 = path.getOrDefault("hubName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "hubName", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate authorization policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564215: Call_AuthorizationPoliciesCreateOrUpdate_564206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization policy or updates an existing authorization policy.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_AuthorizationPoliciesCreateOrUpdate_564206;
          apiVersion: string; authorizationPolicyName: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          parameters: JsonNode): Recallable =
  ## authorizationPoliciesCreateOrUpdate
  ## Creates an authorization policy or updates an existing authorization policy.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationPolicyName: string (required)
  ##                          : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate authorization policy operation.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  var body_564219 = newJObject()
  add(query_564218, "api-version", newJString(apiVersion))
  add(path_564217, "authorizationPolicyName", newJString(authorizationPolicyName))
  add(path_564217, "subscriptionId", newJString(subscriptionId))
  add(path_564217, "resourceGroupName", newJString(resourceGroupName))
  add(path_564217, "hubName", newJString(hubName))
  if parameters != nil:
    body_564219 = parameters
  result = call_564216.call(path_564217, query_564218, nil, nil, body_564219)

var authorizationPoliciesCreateOrUpdate* = Call_AuthorizationPoliciesCreateOrUpdate_564206(
    name: "authorizationPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}",
    validator: validate_AuthorizationPoliciesCreateOrUpdate_564207, base: "",
    url: url_AuthorizationPoliciesCreateOrUpdate_564208, schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesGet_564194 = ref object of OpenApiRestCall_563565
proc url_AuthorizationPoliciesGet_564196(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "authorizationPolicyName" in path,
        "`authorizationPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/authorizationPolicies/"),
               (kind: VariableSegment, value: "authorizationPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationPoliciesGet_564195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization policy in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationPolicyName: JString (required)
  ##                          : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationPolicyName` field"
  var valid_564197 = path.getOrDefault("authorizationPolicyName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "authorizationPolicyName", valid_564197
  var valid_564198 = path.getOrDefault("subscriptionId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "subscriptionId", valid_564198
  var valid_564199 = path.getOrDefault("resourceGroupName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourceGroupName", valid_564199
  var valid_564200 = path.getOrDefault("hubName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "hubName", valid_564200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564201 = query.getOrDefault("api-version")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "api-version", valid_564201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564202: Call_AuthorizationPoliciesGet_564194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization policy in the hub.
  ## 
  let valid = call_564202.validator(path, query, header, formData, body)
  let scheme = call_564202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564202.url(scheme.get, call_564202.host, call_564202.base,
                         call_564202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564202, url, valid)

proc call*(call_564203: Call_AuthorizationPoliciesGet_564194; apiVersion: string;
          authorizationPolicyName: string; subscriptionId: string;
          resourceGroupName: string; hubName: string): Recallable =
  ## authorizationPoliciesGet
  ## Gets an authorization policy in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationPolicyName: string (required)
  ##                          : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564204 = newJObject()
  var query_564205 = newJObject()
  add(query_564205, "api-version", newJString(apiVersion))
  add(path_564204, "authorizationPolicyName", newJString(authorizationPolicyName))
  add(path_564204, "subscriptionId", newJString(subscriptionId))
  add(path_564204, "resourceGroupName", newJString(resourceGroupName))
  add(path_564204, "hubName", newJString(hubName))
  result = call_564203.call(path_564204, query_564205, nil, nil, nil)

var authorizationPoliciesGet* = Call_AuthorizationPoliciesGet_564194(
    name: "authorizationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}",
    validator: validate_AuthorizationPoliciesGet_564195, base: "",
    url: url_AuthorizationPoliciesGet_564196, schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesRegeneratePrimaryKey_564220 = ref object of OpenApiRestCall_563565
proc url_AuthorizationPoliciesRegeneratePrimaryKey_564222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "authorizationPolicyName" in path,
        "`authorizationPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/authorizationPolicies/"),
               (kind: VariableSegment, value: "authorizationPolicyName"),
               (kind: ConstantSegment, value: "/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationPoliciesRegeneratePrimaryKey_564221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary policy key of the specified authorization policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationPolicyName: JString (required)
  ##                          : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationPolicyName` field"
  var valid_564223 = path.getOrDefault("authorizationPolicyName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "authorizationPolicyName", valid_564223
  var valid_564224 = path.getOrDefault("subscriptionId")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "subscriptionId", valid_564224
  var valid_564225 = path.getOrDefault("resourceGroupName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "resourceGroupName", valid_564225
  var valid_564226 = path.getOrDefault("hubName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "hubName", valid_564226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564227 = query.getOrDefault("api-version")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "api-version", valid_564227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564228: Call_AuthorizationPoliciesRegeneratePrimaryKey_564220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the primary policy key of the specified authorization policy.
  ## 
  let valid = call_564228.validator(path, query, header, formData, body)
  let scheme = call_564228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564228.url(scheme.get, call_564228.host, call_564228.base,
                         call_564228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564228, url, valid)

proc call*(call_564229: Call_AuthorizationPoliciesRegeneratePrimaryKey_564220;
          apiVersion: string; authorizationPolicyName: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## authorizationPoliciesRegeneratePrimaryKey
  ## Regenerates the primary policy key of the specified authorization policy.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationPolicyName: string (required)
  ##                          : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564230 = newJObject()
  var query_564231 = newJObject()
  add(query_564231, "api-version", newJString(apiVersion))
  add(path_564230, "authorizationPolicyName", newJString(authorizationPolicyName))
  add(path_564230, "subscriptionId", newJString(subscriptionId))
  add(path_564230, "resourceGroupName", newJString(resourceGroupName))
  add(path_564230, "hubName", newJString(hubName))
  result = call_564229.call(path_564230, query_564231, nil, nil, nil)

var authorizationPoliciesRegeneratePrimaryKey* = Call_AuthorizationPoliciesRegeneratePrimaryKey_564220(
    name: "authorizationPoliciesRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}/regeneratePrimaryKey",
    validator: validate_AuthorizationPoliciesRegeneratePrimaryKey_564221,
    base: "", url: url_AuthorizationPoliciesRegeneratePrimaryKey_564222,
    schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesRegenerateSecondaryKey_564232 = ref object of OpenApiRestCall_563565
proc url_AuthorizationPoliciesRegenerateSecondaryKey_564234(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "authorizationPolicyName" in path,
        "`authorizationPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/authorizationPolicies/"),
               (kind: VariableSegment, value: "authorizationPolicyName"),
               (kind: ConstantSegment, value: "/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AuthorizationPoliciesRegenerateSecondaryKey_564233(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the secondary policy key of the specified authorization policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationPolicyName: JString (required)
  ##                          : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationPolicyName` field"
  var valid_564235 = path.getOrDefault("authorizationPolicyName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "authorizationPolicyName", valid_564235
  var valid_564236 = path.getOrDefault("subscriptionId")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "subscriptionId", valid_564236
  var valid_564237 = path.getOrDefault("resourceGroupName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "resourceGroupName", valid_564237
  var valid_564238 = path.getOrDefault("hubName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "hubName", valid_564238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564239 = query.getOrDefault("api-version")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "api-version", valid_564239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564240: Call_AuthorizationPoliciesRegenerateSecondaryKey_564232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the secondary policy key of the specified authorization policy.
  ## 
  let valid = call_564240.validator(path, query, header, formData, body)
  let scheme = call_564240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564240.url(scheme.get, call_564240.host, call_564240.base,
                         call_564240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564240, url, valid)

proc call*(call_564241: Call_AuthorizationPoliciesRegenerateSecondaryKey_564232;
          apiVersion: string; authorizationPolicyName: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## authorizationPoliciesRegenerateSecondaryKey
  ## Regenerates the secondary policy key of the specified authorization policy.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationPolicyName: string (required)
  ##                          : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564242 = newJObject()
  var query_564243 = newJObject()
  add(query_564243, "api-version", newJString(apiVersion))
  add(path_564242, "authorizationPolicyName", newJString(authorizationPolicyName))
  add(path_564242, "subscriptionId", newJString(subscriptionId))
  add(path_564242, "resourceGroupName", newJString(resourceGroupName))
  add(path_564242, "hubName", newJString(hubName))
  result = call_564241.call(path_564242, query_564243, nil, nil, nil)

var authorizationPoliciesRegenerateSecondaryKey* = Call_AuthorizationPoliciesRegenerateSecondaryKey_564232(
    name: "authorizationPoliciesRegenerateSecondaryKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}/regenerateSecondaryKey",
    validator: validate_AuthorizationPoliciesRegenerateSecondaryKey_564233,
    base: "", url: url_AuthorizationPoliciesRegenerateSecondaryKey_564234,
    schemes: {Scheme.Https})
type
  Call_ConnectorsListByHub_564244 = ref object of OpenApiRestCall_563565
proc url_ConnectorsListByHub_564246(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/connectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorsListByHub_564245(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all the connectors in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564247 = path.getOrDefault("subscriptionId")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "subscriptionId", valid_564247
  var valid_564248 = path.getOrDefault("resourceGroupName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "resourceGroupName", valid_564248
  var valid_564249 = path.getOrDefault("hubName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "hubName", valid_564249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564250 = query.getOrDefault("api-version")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "api-version", valid_564250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564251: Call_ConnectorsListByHub_564244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the connectors in the specified hub.
  ## 
  let valid = call_564251.validator(path, query, header, formData, body)
  let scheme = call_564251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564251.url(scheme.get, call_564251.host, call_564251.base,
                         call_564251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564251, url, valid)

proc call*(call_564252: Call_ConnectorsListByHub_564244; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## connectorsListByHub
  ## Gets all the connectors in the specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564253 = newJObject()
  var query_564254 = newJObject()
  add(query_564254, "api-version", newJString(apiVersion))
  add(path_564253, "subscriptionId", newJString(subscriptionId))
  add(path_564253, "resourceGroupName", newJString(resourceGroupName))
  add(path_564253, "hubName", newJString(hubName))
  result = call_564252.call(path_564253, query_564254, nil, nil, nil)

var connectorsListByHub* = Call_ConnectorsListByHub_564244(
    name: "connectorsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors",
    validator: validate_ConnectorsListByHub_564245, base: "",
    url: url_ConnectorsListByHub_564246, schemes: {Scheme.Https})
type
  Call_ConnectorsCreateOrUpdate_564267 = ref object of OpenApiRestCall_563565
proc url_ConnectorsCreateOrUpdate_564269(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/connectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorsCreateOrUpdate_564268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a connector or updates an existing connector in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564270 = path.getOrDefault("subscriptionId")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "subscriptionId", valid_564270
  var valid_564271 = path.getOrDefault("connectorName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "connectorName", valid_564271
  var valid_564272 = path.getOrDefault("resourceGroupName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "resourceGroupName", valid_564272
  var valid_564273 = path.getOrDefault("hubName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "hubName", valid_564273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564274 = query.getOrDefault("api-version")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "api-version", valid_564274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Connector operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564276: Call_ConnectorsCreateOrUpdate_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a connector or updates an existing connector in the hub.
  ## 
  let valid = call_564276.validator(path, query, header, formData, body)
  let scheme = call_564276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564276.url(scheme.get, call_564276.host, call_564276.base,
                         call_564276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564276, url, valid)

proc call*(call_564277: Call_ConnectorsCreateOrUpdate_564267; apiVersion: string;
          subscriptionId: string; connectorName: string; resourceGroupName: string;
          hubName: string; parameters: JsonNode): Recallable =
  ## connectorsCreateOrUpdate
  ## Creates a connector or updates an existing connector in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Connector operation.
  var path_564278 = newJObject()
  var query_564279 = newJObject()
  var body_564280 = newJObject()
  add(query_564279, "api-version", newJString(apiVersion))
  add(path_564278, "subscriptionId", newJString(subscriptionId))
  add(path_564278, "connectorName", newJString(connectorName))
  add(path_564278, "resourceGroupName", newJString(resourceGroupName))
  add(path_564278, "hubName", newJString(hubName))
  if parameters != nil:
    body_564280 = parameters
  result = call_564277.call(path_564278, query_564279, nil, nil, body_564280)

var connectorsCreateOrUpdate* = Call_ConnectorsCreateOrUpdate_564267(
    name: "connectorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}",
    validator: validate_ConnectorsCreateOrUpdate_564268, base: "",
    url: url_ConnectorsCreateOrUpdate_564269, schemes: {Scheme.Https})
type
  Call_ConnectorsGet_564255 = ref object of OpenApiRestCall_563565
proc url_ConnectorsGet_564257(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/connectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorsGet_564256(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a connector in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("connectorName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "connectorName", valid_564259
  var valid_564260 = path.getOrDefault("resourceGroupName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "resourceGroupName", valid_564260
  var valid_564261 = path.getOrDefault("hubName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "hubName", valid_564261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564262 = query.getOrDefault("api-version")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "api-version", valid_564262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_ConnectorsGet_564255; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connector in the hub.
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_ConnectorsGet_564255; apiVersion: string;
          subscriptionId: string; connectorName: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## connectorsGet
  ## Gets a connector in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  add(query_564266, "api-version", newJString(apiVersion))
  add(path_564265, "subscriptionId", newJString(subscriptionId))
  add(path_564265, "connectorName", newJString(connectorName))
  add(path_564265, "resourceGroupName", newJString(resourceGroupName))
  add(path_564265, "hubName", newJString(hubName))
  result = call_564264.call(path_564265, query_564266, nil, nil, nil)

var connectorsGet* = Call_ConnectorsGet_564255(name: "connectorsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}",
    validator: validate_ConnectorsGet_564256, base: "", url: url_ConnectorsGet_564257,
    schemes: {Scheme.Https})
type
  Call_ConnectorsDelete_564281 = ref object of OpenApiRestCall_563565
proc url_ConnectorsDelete_564283(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/connectors/"),
               (kind: VariableSegment, value: "connectorName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorsDelete_564282(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a connector in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564284 = path.getOrDefault("subscriptionId")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "subscriptionId", valid_564284
  var valid_564285 = path.getOrDefault("connectorName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "connectorName", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  var valid_564287 = path.getOrDefault("hubName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "hubName", valid_564287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564288 = query.getOrDefault("api-version")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "api-version", valid_564288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564289: Call_ConnectorsDelete_564281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a connector in the hub.
  ## 
  let valid = call_564289.validator(path, query, header, formData, body)
  let scheme = call_564289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564289.url(scheme.get, call_564289.host, call_564289.base,
                         call_564289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564289, url, valid)

proc call*(call_564290: Call_ConnectorsDelete_564281; apiVersion: string;
          subscriptionId: string; connectorName: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## connectorsDelete
  ## Deletes a connector in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564291 = newJObject()
  var query_564292 = newJObject()
  add(query_564292, "api-version", newJString(apiVersion))
  add(path_564291, "subscriptionId", newJString(subscriptionId))
  add(path_564291, "connectorName", newJString(connectorName))
  add(path_564291, "resourceGroupName", newJString(resourceGroupName))
  add(path_564291, "hubName", newJString(hubName))
  result = call_564290.call(path_564291, query_564292, nil, nil, nil)

var connectorsDelete* = Call_ConnectorsDelete_564281(name: "connectorsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}",
    validator: validate_ConnectorsDelete_564282, base: "",
    url: url_ConnectorsDelete_564283, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsListByConnector_564293 = ref object of OpenApiRestCall_563565
proc url_ConnectorMappingsListByConnector_564295(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/connectors/"),
               (kind: VariableSegment, value: "connectorName"),
               (kind: ConstantSegment, value: "/mappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorMappingsListByConnector_564294(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the connector mappings in the specified connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564296 = path.getOrDefault("subscriptionId")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "subscriptionId", valid_564296
  var valid_564297 = path.getOrDefault("connectorName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "connectorName", valid_564297
  var valid_564298 = path.getOrDefault("resourceGroupName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "resourceGroupName", valid_564298
  var valid_564299 = path.getOrDefault("hubName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "hubName", valid_564299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564300 = query.getOrDefault("api-version")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "api-version", valid_564300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_ConnectorMappingsListByConnector_564293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the connector mappings in the specified connector.
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_ConnectorMappingsListByConnector_564293;
          apiVersion: string; subscriptionId: string; connectorName: string;
          resourceGroupName: string; hubName: string): Recallable =
  ## connectorMappingsListByConnector
  ## Gets all the connector mappings in the specified connector.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "connectorName", newJString(connectorName))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  add(path_564303, "hubName", newJString(hubName))
  result = call_564302.call(path_564303, query_564304, nil, nil, nil)

var connectorMappingsListByConnector* = Call_ConnectorMappingsListByConnector_564293(
    name: "connectorMappingsListByConnector", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings",
    validator: validate_ConnectorMappingsListByConnector_564294, base: "",
    url: url_ConnectorMappingsListByConnector_564295, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsCreateOrUpdate_564318 = ref object of OpenApiRestCall_563565
proc url_ConnectorMappingsCreateOrUpdate_564320(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/connectors/"),
               (kind: VariableSegment, value: "connectorName"),
               (kind: ConstantSegment, value: "/mappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorMappingsCreateOrUpdate_564319(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a connector mapping or updates an existing connector mapping in the connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  ##   mappingName: JString (required)
  ##              : The name of the connector mapping.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564321 = path.getOrDefault("subscriptionId")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "subscriptionId", valid_564321
  var valid_564322 = path.getOrDefault("connectorName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "connectorName", valid_564322
  var valid_564323 = path.getOrDefault("mappingName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "mappingName", valid_564323
  var valid_564324 = path.getOrDefault("resourceGroupName")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "resourceGroupName", valid_564324
  var valid_564325 = path.getOrDefault("hubName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "hubName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "api-version", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Connector Mapping operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564328: Call_ConnectorMappingsCreateOrUpdate_564318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a connector mapping or updates an existing connector mapping in the connector.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_ConnectorMappingsCreateOrUpdate_564318;
          apiVersion: string; subscriptionId: string; connectorName: string;
          mappingName: string; resourceGroupName: string; hubName: string;
          parameters: JsonNode): Recallable =
  ## connectorMappingsCreateOrUpdate
  ## Creates a connector mapping or updates an existing connector mapping in the connector.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  ##   mappingName: string (required)
  ##              : The name of the connector mapping.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Connector Mapping operation.
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  var body_564332 = newJObject()
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(path_564330, "connectorName", newJString(connectorName))
  add(path_564330, "mappingName", newJString(mappingName))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  add(path_564330, "hubName", newJString(hubName))
  if parameters != nil:
    body_564332 = parameters
  result = call_564329.call(path_564330, query_564331, nil, nil, body_564332)

var connectorMappingsCreateOrUpdate* = Call_ConnectorMappingsCreateOrUpdate_564318(
    name: "connectorMappingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings/{mappingName}",
    validator: validate_ConnectorMappingsCreateOrUpdate_564319, base: "",
    url: url_ConnectorMappingsCreateOrUpdate_564320, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsGet_564305 = ref object of OpenApiRestCall_563565
proc url_ConnectorMappingsGet_564307(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/connectors/"),
               (kind: VariableSegment, value: "connectorName"),
               (kind: ConstantSegment, value: "/mappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorMappingsGet_564306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a connector mapping in the connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  ##   mappingName: JString (required)
  ##              : The name of the connector mapping.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("connectorName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "connectorName", valid_564309
  var valid_564310 = path.getOrDefault("mappingName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "mappingName", valid_564310
  var valid_564311 = path.getOrDefault("resourceGroupName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "resourceGroupName", valid_564311
  var valid_564312 = path.getOrDefault("hubName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "hubName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_ConnectorMappingsGet_564305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connector mapping in the connector.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_ConnectorMappingsGet_564305; apiVersion: string;
          subscriptionId: string; connectorName: string; mappingName: string;
          resourceGroupName: string; hubName: string): Recallable =
  ## connectorMappingsGet
  ## Gets a connector mapping in the connector.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  ##   mappingName: string (required)
  ##              : The name of the connector mapping.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "connectorName", newJString(connectorName))
  add(path_564316, "mappingName", newJString(mappingName))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  add(path_564316, "hubName", newJString(hubName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var connectorMappingsGet* = Call_ConnectorMappingsGet_564305(
    name: "connectorMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings/{mappingName}",
    validator: validate_ConnectorMappingsGet_564306, base: "",
    url: url_ConnectorMappingsGet_564307, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsDelete_564333 = ref object of OpenApiRestCall_563565
proc url_ConnectorMappingsDelete_564335(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "connectorName" in path, "`connectorName` is a required path parameter"
  assert "mappingName" in path, "`mappingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/connectors/"),
               (kind: VariableSegment, value: "connectorName"),
               (kind: ConstantSegment, value: "/mappings/"),
               (kind: VariableSegment, value: "mappingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConnectorMappingsDelete_564334(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a connector mapping in the connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  ##   mappingName: JString (required)
  ##              : The name of the connector mapping.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564336 = path.getOrDefault("subscriptionId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "subscriptionId", valid_564336
  var valid_564337 = path.getOrDefault("connectorName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "connectorName", valid_564337
  var valid_564338 = path.getOrDefault("mappingName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "mappingName", valid_564338
  var valid_564339 = path.getOrDefault("resourceGroupName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "resourceGroupName", valid_564339
  var valid_564340 = path.getOrDefault("hubName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "hubName", valid_564340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564341 = query.getOrDefault("api-version")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "api-version", valid_564341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564342: Call_ConnectorMappingsDelete_564333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a connector mapping in the connector.
  ## 
  let valid = call_564342.validator(path, query, header, formData, body)
  let scheme = call_564342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564342.url(scheme.get, call_564342.host, call_564342.base,
                         call_564342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564342, url, valid)

proc call*(call_564343: Call_ConnectorMappingsDelete_564333; apiVersion: string;
          subscriptionId: string; connectorName: string; mappingName: string;
          resourceGroupName: string; hubName: string): Recallable =
  ## connectorMappingsDelete
  ## Deletes a connector mapping in the connector.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  ##   mappingName: string (required)
  ##              : The name of the connector mapping.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564344 = newJObject()
  var query_564345 = newJObject()
  add(query_564345, "api-version", newJString(apiVersion))
  add(path_564344, "subscriptionId", newJString(subscriptionId))
  add(path_564344, "connectorName", newJString(connectorName))
  add(path_564344, "mappingName", newJString(mappingName))
  add(path_564344, "resourceGroupName", newJString(resourceGroupName))
  add(path_564344, "hubName", newJString(hubName))
  result = call_564343.call(path_564344, query_564345, nil, nil, nil)

var connectorMappingsDelete* = Call_ConnectorMappingsDelete_564333(
    name: "connectorMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings/{mappingName}",
    validator: validate_ConnectorMappingsDelete_564334, base: "",
    url: url_ConnectorMappingsDelete_564335, schemes: {Scheme.Https})
type
  Call_ImagesGetUploadUrlForData_564346 = ref object of OpenApiRestCall_563565
proc url_ImagesGetUploadUrlForData_564348(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/images/getDataImageUploadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesGetUploadUrlForData_564347(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets data image upload URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564349 = path.getOrDefault("subscriptionId")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "subscriptionId", valid_564349
  var valid_564350 = path.getOrDefault("resourceGroupName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "resourceGroupName", valid_564350
  var valid_564351 = path.getOrDefault("hubName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "hubName", valid_564351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564352 = query.getOrDefault("api-version")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "api-version", valid_564352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the GetUploadUrlForData operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564354: Call_ImagesGetUploadUrlForData_564346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets data image upload URL.
  ## 
  let valid = call_564354.validator(path, query, header, formData, body)
  let scheme = call_564354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564354.url(scheme.get, call_564354.host, call_564354.base,
                         call_564354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564354, url, valid)

proc call*(call_564355: Call_ImagesGetUploadUrlForData_564346; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          parameters: JsonNode): Recallable =
  ## imagesGetUploadUrlForData
  ## Gets data image upload URL.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the GetUploadUrlForData operation.
  var path_564356 = newJObject()
  var query_564357 = newJObject()
  var body_564358 = newJObject()
  add(query_564357, "api-version", newJString(apiVersion))
  add(path_564356, "subscriptionId", newJString(subscriptionId))
  add(path_564356, "resourceGroupName", newJString(resourceGroupName))
  add(path_564356, "hubName", newJString(hubName))
  if parameters != nil:
    body_564358 = parameters
  result = call_564355.call(path_564356, query_564357, nil, nil, body_564358)

var imagesGetUploadUrlForData* = Call_ImagesGetUploadUrlForData_564346(
    name: "imagesGetUploadUrlForData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/images/getDataImageUploadUrl",
    validator: validate_ImagesGetUploadUrlForData_564347, base: "",
    url: url_ImagesGetUploadUrlForData_564348, schemes: {Scheme.Https})
type
  Call_ImagesGetUploadUrlForEntityType_564359 = ref object of OpenApiRestCall_563565
proc url_ImagesGetUploadUrlForEntityType_564361(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"), (kind: ConstantSegment,
        value: "/images/getEntityTypeImageUploadUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesGetUploadUrlForEntityType_564360(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets entity type (profile or interaction) image upload URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564362 = path.getOrDefault("subscriptionId")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "subscriptionId", valid_564362
  var valid_564363 = path.getOrDefault("resourceGroupName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "resourceGroupName", valid_564363
  var valid_564364 = path.getOrDefault("hubName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "hubName", valid_564364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564365 = query.getOrDefault("api-version")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "api-version", valid_564365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the GetUploadUrlForEntityType operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564367: Call_ImagesGetUploadUrlForEntityType_564359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets entity type (profile or interaction) image upload URL.
  ## 
  let valid = call_564367.validator(path, query, header, formData, body)
  let scheme = call_564367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564367.url(scheme.get, call_564367.host, call_564367.base,
                         call_564367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564367, url, valid)

proc call*(call_564368: Call_ImagesGetUploadUrlForEntityType_564359;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string; parameters: JsonNode): Recallable =
  ## imagesGetUploadUrlForEntityType
  ## Gets entity type (profile or interaction) image upload URL.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the GetUploadUrlForEntityType operation.
  var path_564369 = newJObject()
  var query_564370 = newJObject()
  var body_564371 = newJObject()
  add(query_564370, "api-version", newJString(apiVersion))
  add(path_564369, "subscriptionId", newJString(subscriptionId))
  add(path_564369, "resourceGroupName", newJString(resourceGroupName))
  add(path_564369, "hubName", newJString(hubName))
  if parameters != nil:
    body_564371 = parameters
  result = call_564368.call(path_564369, query_564370, nil, nil, body_564371)

var imagesGetUploadUrlForEntityType* = Call_ImagesGetUploadUrlForEntityType_564359(
    name: "imagesGetUploadUrlForEntityType", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/images/getEntityTypeImageUploadUrl",
    validator: validate_ImagesGetUploadUrlForEntityType_564360, base: "",
    url: url_ImagesGetUploadUrlForEntityType_564361, schemes: {Scheme.Https})
type
  Call_InteractionsListByHub_564372 = ref object of OpenApiRestCall_563565
proc url_InteractionsListByHub_564374(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/interactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InteractionsListByHub_564373(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all interactions in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564375 = path.getOrDefault("subscriptionId")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "subscriptionId", valid_564375
  var valid_564376 = path.getOrDefault("resourceGroupName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "resourceGroupName", valid_564376
  var valid_564377 = path.getOrDefault("hubName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "hubName", valid_564377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of interaction to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564378 = query.getOrDefault("api-version")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "api-version", valid_564378
  var valid_564392 = query.getOrDefault("locale-code")
  valid_564392 = validateParameter(valid_564392, JString, required = false,
                                 default = newJString("en-us"))
  if valid_564392 != nil:
    section.add "locale-code", valid_564392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564393: Call_InteractionsListByHub_564372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all interactions in the hub.
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_InteractionsListByHub_564372; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          localeCode: string = "en-us"): Recallable =
  ## interactionsListByHub
  ## Gets all interactions in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   localeCode: string
  ##             : Locale of interaction to retrieve, default is en-us.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  add(query_564396, "api-version", newJString(apiVersion))
  add(query_564396, "locale-code", newJString(localeCode))
  add(path_564395, "subscriptionId", newJString(subscriptionId))
  add(path_564395, "resourceGroupName", newJString(resourceGroupName))
  add(path_564395, "hubName", newJString(hubName))
  result = call_564394.call(path_564395, query_564396, nil, nil, nil)

var interactionsListByHub* = Call_InteractionsListByHub_564372(
    name: "interactionsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions",
    validator: validate_InteractionsListByHub_564373, base: "",
    url: url_InteractionsListByHub_564374, schemes: {Scheme.Https})
type
  Call_InteractionsCreateOrUpdate_564410 = ref object of OpenApiRestCall_563565
proc url_InteractionsCreateOrUpdate_564412(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "interactionName" in path, "`interactionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/interactions/"),
               (kind: VariableSegment, value: "interactionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InteractionsCreateOrUpdate_564411(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an interaction or updates an existing interaction within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   interactionName: JString (required)
  ##                  : The name of the interaction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `interactionName` field"
  var valid_564413 = path.getOrDefault("interactionName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "interactionName", valid_564413
  var valid_564414 = path.getOrDefault("subscriptionId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "subscriptionId", valid_564414
  var valid_564415 = path.getOrDefault("resourceGroupName")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "resourceGroupName", valid_564415
  var valid_564416 = path.getOrDefault("hubName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "hubName", valid_564416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564417 = query.getOrDefault("api-version")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "api-version", valid_564417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Interaction operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564419: Call_InteractionsCreateOrUpdate_564410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an interaction or updates an existing interaction within a hub.
  ## 
  let valid = call_564419.validator(path, query, header, formData, body)
  let scheme = call_564419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564419.url(scheme.get, call_564419.host, call_564419.base,
                         call_564419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564419, url, valid)

proc call*(call_564420: Call_InteractionsCreateOrUpdate_564410;
          interactionName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; hubName: string; parameters: JsonNode): Recallable =
  ## interactionsCreateOrUpdate
  ## Creates an interaction or updates an existing interaction within a hub.
  ##   interactionName: string (required)
  ##                  : The name of the interaction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Interaction operation.
  var path_564421 = newJObject()
  var query_564422 = newJObject()
  var body_564423 = newJObject()
  add(path_564421, "interactionName", newJString(interactionName))
  add(query_564422, "api-version", newJString(apiVersion))
  add(path_564421, "subscriptionId", newJString(subscriptionId))
  add(path_564421, "resourceGroupName", newJString(resourceGroupName))
  add(path_564421, "hubName", newJString(hubName))
  if parameters != nil:
    body_564423 = parameters
  result = call_564420.call(path_564421, query_564422, nil, nil, body_564423)

var interactionsCreateOrUpdate* = Call_InteractionsCreateOrUpdate_564410(
    name: "interactionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions/{interactionName}",
    validator: validate_InteractionsCreateOrUpdate_564411, base: "",
    url: url_InteractionsCreateOrUpdate_564412, schemes: {Scheme.Https})
type
  Call_InteractionsGet_564397 = ref object of OpenApiRestCall_563565
proc url_InteractionsGet_564399(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "interactionName" in path, "`interactionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/interactions/"),
               (kind: VariableSegment, value: "interactionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InteractionsGet_564398(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about the specified interaction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   interactionName: JString (required)
  ##                  : The name of the interaction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `interactionName` field"
  var valid_564400 = path.getOrDefault("interactionName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "interactionName", valid_564400
  var valid_564401 = path.getOrDefault("subscriptionId")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "subscriptionId", valid_564401
  var valid_564402 = path.getOrDefault("resourceGroupName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "resourceGroupName", valid_564402
  var valid_564403 = path.getOrDefault("hubName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "hubName", valid_564403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of interaction to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564404 = query.getOrDefault("api-version")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "api-version", valid_564404
  var valid_564405 = query.getOrDefault("locale-code")
  valid_564405 = validateParameter(valid_564405, JString, required = false,
                                 default = newJString("en-us"))
  if valid_564405 != nil:
    section.add "locale-code", valid_564405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564406: Call_InteractionsGet_564397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified interaction.
  ## 
  let valid = call_564406.validator(path, query, header, formData, body)
  let scheme = call_564406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564406.url(scheme.get, call_564406.host, call_564406.base,
                         call_564406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564406, url, valid)

proc call*(call_564407: Call_InteractionsGet_564397; interactionName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string; localeCode: string = "en-us"): Recallable =
  ## interactionsGet
  ## Gets information about the specified interaction.
  ##   interactionName: string (required)
  ##                  : The name of the interaction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   localeCode: string
  ##             : Locale of interaction to retrieve, default is en-us.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564408 = newJObject()
  var query_564409 = newJObject()
  add(path_564408, "interactionName", newJString(interactionName))
  add(query_564409, "api-version", newJString(apiVersion))
  add(query_564409, "locale-code", newJString(localeCode))
  add(path_564408, "subscriptionId", newJString(subscriptionId))
  add(path_564408, "resourceGroupName", newJString(resourceGroupName))
  add(path_564408, "hubName", newJString(hubName))
  result = call_564407.call(path_564408, query_564409, nil, nil, nil)

var interactionsGet* = Call_InteractionsGet_564397(name: "interactionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions/{interactionName}",
    validator: validate_InteractionsGet_564398, base: "", url: url_InteractionsGet_564399,
    schemes: {Scheme.Https})
type
  Call_InteractionsSuggestRelationshipLinks_564424 = ref object of OpenApiRestCall_563565
proc url_InteractionsSuggestRelationshipLinks_564426(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "interactionName" in path, "`interactionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/interactions/"),
               (kind: VariableSegment, value: "interactionName"),
               (kind: ConstantSegment, value: "/suggestRelationshipLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InteractionsSuggestRelationshipLinks_564425(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suggests relationships to create relationship links.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   interactionName: JString (required)
  ##                  : The name of the interaction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `interactionName` field"
  var valid_564427 = path.getOrDefault("interactionName")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "interactionName", valid_564427
  var valid_564428 = path.getOrDefault("subscriptionId")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "subscriptionId", valid_564428
  var valid_564429 = path.getOrDefault("resourceGroupName")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "resourceGroupName", valid_564429
  var valid_564430 = path.getOrDefault("hubName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "hubName", valid_564430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564431 = query.getOrDefault("api-version")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "api-version", valid_564431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564432: Call_InteractionsSuggestRelationshipLinks_564424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Suggests relationships to create relationship links.
  ## 
  let valid = call_564432.validator(path, query, header, formData, body)
  let scheme = call_564432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564432.url(scheme.get, call_564432.host, call_564432.base,
                         call_564432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564432, url, valid)

proc call*(call_564433: Call_InteractionsSuggestRelationshipLinks_564424;
          interactionName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; hubName: string): Recallable =
  ## interactionsSuggestRelationshipLinks
  ## Suggests relationships to create relationship links.
  ##   interactionName: string (required)
  ##                  : The name of the interaction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564434 = newJObject()
  var query_564435 = newJObject()
  add(path_564434, "interactionName", newJString(interactionName))
  add(query_564435, "api-version", newJString(apiVersion))
  add(path_564434, "subscriptionId", newJString(subscriptionId))
  add(path_564434, "resourceGroupName", newJString(resourceGroupName))
  add(path_564434, "hubName", newJString(hubName))
  result = call_564433.call(path_564434, query_564435, nil, nil, nil)

var interactionsSuggestRelationshipLinks* = Call_InteractionsSuggestRelationshipLinks_564424(
    name: "interactionsSuggestRelationshipLinks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions/{interactionName}/suggestRelationshipLinks",
    validator: validate_InteractionsSuggestRelationshipLinks_564425, base: "",
    url: url_InteractionsSuggestRelationshipLinks_564426, schemes: {Scheme.Https})
type
  Call_KpiListByHub_564436 = ref object of OpenApiRestCall_563565
proc url_KpiListByHub_564438(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/kpi")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KpiListByHub_564437(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the KPIs in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564439 = path.getOrDefault("subscriptionId")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "subscriptionId", valid_564439
  var valid_564440 = path.getOrDefault("resourceGroupName")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "resourceGroupName", valid_564440
  var valid_564441 = path.getOrDefault("hubName")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "hubName", valid_564441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564442 = query.getOrDefault("api-version")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "api-version", valid_564442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564443: Call_KpiListByHub_564436; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the KPIs in the specified hub.
  ## 
  let valid = call_564443.validator(path, query, header, formData, body)
  let scheme = call_564443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564443.url(scheme.get, call_564443.host, call_564443.base,
                         call_564443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564443, url, valid)

proc call*(call_564444: Call_KpiListByHub_564436; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## kpiListByHub
  ## Gets all the KPIs in the specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564445 = newJObject()
  var query_564446 = newJObject()
  add(query_564446, "api-version", newJString(apiVersion))
  add(path_564445, "subscriptionId", newJString(subscriptionId))
  add(path_564445, "resourceGroupName", newJString(resourceGroupName))
  add(path_564445, "hubName", newJString(hubName))
  result = call_564444.call(path_564445, query_564446, nil, nil, nil)

var kpiListByHub* = Call_KpiListByHub_564436(name: "kpiListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi",
    validator: validate_KpiListByHub_564437, base: "", url: url_KpiListByHub_564438,
    schemes: {Scheme.Https})
type
  Call_KpiCreateOrUpdate_564459 = ref object of OpenApiRestCall_563565
proc url_KpiCreateOrUpdate_564461(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "kpiName" in path, "`kpiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/kpi/"),
               (kind: VariableSegment, value: "kpiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KpiCreateOrUpdate_564460(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a KPI or updates an existing KPI in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: JString (required)
  ##          : The name of the KPI.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564462 = path.getOrDefault("subscriptionId")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "subscriptionId", valid_564462
  var valid_564463 = path.getOrDefault("kpiName")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "kpiName", valid_564463
  var valid_564464 = path.getOrDefault("resourceGroupName")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = nil)
  if valid_564464 != nil:
    section.add "resourceGroupName", valid_564464
  var valid_564465 = path.getOrDefault("hubName")
  valid_564465 = validateParameter(valid_564465, JString, required = true,
                                 default = nil)
  if valid_564465 != nil:
    section.add "hubName", valid_564465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564466 = query.getOrDefault("api-version")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "api-version", valid_564466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update KPI operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564468: Call_KpiCreateOrUpdate_564459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a KPI or updates an existing KPI in the hub.
  ## 
  let valid = call_564468.validator(path, query, header, formData, body)
  let scheme = call_564468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564468.url(scheme.get, call_564468.host, call_564468.base,
                         call_564468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564468, url, valid)

proc call*(call_564469: Call_KpiCreateOrUpdate_564459; apiVersion: string;
          subscriptionId: string; kpiName: string; resourceGroupName: string;
          hubName: string; parameters: JsonNode): Recallable =
  ## kpiCreateOrUpdate
  ## Creates a KPI or updates an existing KPI in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: string (required)
  ##          : The name of the KPI.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update KPI operation.
  var path_564470 = newJObject()
  var query_564471 = newJObject()
  var body_564472 = newJObject()
  add(query_564471, "api-version", newJString(apiVersion))
  add(path_564470, "subscriptionId", newJString(subscriptionId))
  add(path_564470, "kpiName", newJString(kpiName))
  add(path_564470, "resourceGroupName", newJString(resourceGroupName))
  add(path_564470, "hubName", newJString(hubName))
  if parameters != nil:
    body_564472 = parameters
  result = call_564469.call(path_564470, query_564471, nil, nil, body_564472)

var kpiCreateOrUpdate* = Call_KpiCreateOrUpdate_564459(name: "kpiCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}",
    validator: validate_KpiCreateOrUpdate_564460, base: "",
    url: url_KpiCreateOrUpdate_564461, schemes: {Scheme.Https})
type
  Call_KpiGet_564447 = ref object of OpenApiRestCall_563565
proc url_KpiGet_564449(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "kpiName" in path, "`kpiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/kpi/"),
               (kind: VariableSegment, value: "kpiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KpiGet_564448(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a KPI in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: JString (required)
  ##          : The name of the KPI.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564450 = path.getOrDefault("subscriptionId")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "subscriptionId", valid_564450
  var valid_564451 = path.getOrDefault("kpiName")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "kpiName", valid_564451
  var valid_564452 = path.getOrDefault("resourceGroupName")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "resourceGroupName", valid_564452
  var valid_564453 = path.getOrDefault("hubName")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "hubName", valid_564453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564454 = query.getOrDefault("api-version")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "api-version", valid_564454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564455: Call_KpiGet_564447; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a KPI in the hub.
  ## 
  let valid = call_564455.validator(path, query, header, formData, body)
  let scheme = call_564455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564455.url(scheme.get, call_564455.host, call_564455.base,
                         call_564455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564455, url, valid)

proc call*(call_564456: Call_KpiGet_564447; apiVersion: string;
          subscriptionId: string; kpiName: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## kpiGet
  ## Gets a KPI in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: string (required)
  ##          : The name of the KPI.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564457 = newJObject()
  var query_564458 = newJObject()
  add(query_564458, "api-version", newJString(apiVersion))
  add(path_564457, "subscriptionId", newJString(subscriptionId))
  add(path_564457, "kpiName", newJString(kpiName))
  add(path_564457, "resourceGroupName", newJString(resourceGroupName))
  add(path_564457, "hubName", newJString(hubName))
  result = call_564456.call(path_564457, query_564458, nil, nil, nil)

var kpiGet* = Call_KpiGet_564447(name: "kpiGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}",
                              validator: validate_KpiGet_564448, base: "",
                              url: url_KpiGet_564449, schemes: {Scheme.Https})
type
  Call_KpiDelete_564473 = ref object of OpenApiRestCall_563565
proc url_KpiDelete_564475(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "kpiName" in path, "`kpiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/kpi/"),
               (kind: VariableSegment, value: "kpiName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KpiDelete_564474(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a KPI in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: JString (required)
  ##          : The name of the KPI.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564476 = path.getOrDefault("subscriptionId")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "subscriptionId", valid_564476
  var valid_564477 = path.getOrDefault("kpiName")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "kpiName", valid_564477
  var valid_564478 = path.getOrDefault("resourceGroupName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "resourceGroupName", valid_564478
  var valid_564479 = path.getOrDefault("hubName")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "hubName", valid_564479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564480 = query.getOrDefault("api-version")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "api-version", valid_564480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564481: Call_KpiDelete_564473; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a KPI in the hub.
  ## 
  let valid = call_564481.validator(path, query, header, formData, body)
  let scheme = call_564481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564481.url(scheme.get, call_564481.host, call_564481.base,
                         call_564481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564481, url, valid)

proc call*(call_564482: Call_KpiDelete_564473; apiVersion: string;
          subscriptionId: string; kpiName: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## kpiDelete
  ## Deletes a KPI in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: string (required)
  ##          : The name of the KPI.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564483 = newJObject()
  var query_564484 = newJObject()
  add(query_564484, "api-version", newJString(apiVersion))
  add(path_564483, "subscriptionId", newJString(subscriptionId))
  add(path_564483, "kpiName", newJString(kpiName))
  add(path_564483, "resourceGroupName", newJString(resourceGroupName))
  add(path_564483, "hubName", newJString(hubName))
  result = call_564482.call(path_564483, query_564484, nil, nil, nil)

var kpiDelete* = Call_KpiDelete_564473(name: "kpiDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}",
                                    validator: validate_KpiDelete_564474,
                                    base: "", url: url_KpiDelete_564475,
                                    schemes: {Scheme.Https})
type
  Call_KpiReprocess_564485 = ref object of OpenApiRestCall_563565
proc url_KpiReprocess_564487(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "kpiName" in path, "`kpiName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/kpi/"),
               (kind: VariableSegment, value: "kpiName"),
               (kind: ConstantSegment, value: "/reprocess")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_KpiReprocess_564486(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Reprocesses the Kpi values of the specified KPI.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: JString (required)
  ##          : The name of the KPI.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564488 = path.getOrDefault("subscriptionId")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "subscriptionId", valid_564488
  var valid_564489 = path.getOrDefault("kpiName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "kpiName", valid_564489
  var valid_564490 = path.getOrDefault("resourceGroupName")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "resourceGroupName", valid_564490
  var valid_564491 = path.getOrDefault("hubName")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "hubName", valid_564491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564492 = query.getOrDefault("api-version")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "api-version", valid_564492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564493: Call_KpiReprocess_564485; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reprocesses the Kpi values of the specified KPI.
  ## 
  let valid = call_564493.validator(path, query, header, formData, body)
  let scheme = call_564493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564493.url(scheme.get, call_564493.host, call_564493.base,
                         call_564493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564493, url, valid)

proc call*(call_564494: Call_KpiReprocess_564485; apiVersion: string;
          subscriptionId: string; kpiName: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## kpiReprocess
  ## Reprocesses the Kpi values of the specified KPI.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: string (required)
  ##          : The name of the KPI.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564495 = newJObject()
  var query_564496 = newJObject()
  add(query_564496, "api-version", newJString(apiVersion))
  add(path_564495, "subscriptionId", newJString(subscriptionId))
  add(path_564495, "kpiName", newJString(kpiName))
  add(path_564495, "resourceGroupName", newJString(resourceGroupName))
  add(path_564495, "hubName", newJString(hubName))
  result = call_564494.call(path_564495, query_564496, nil, nil, nil)

var kpiReprocess* = Call_KpiReprocess_564485(name: "kpiReprocess",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}/reprocess",
    validator: validate_KpiReprocess_564486, base: "", url: url_KpiReprocess_564487,
    schemes: {Scheme.Https})
type
  Call_LinksListByHub_564497 = ref object of OpenApiRestCall_563565
proc url_LinksListByHub_564499(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/links")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinksListByHub_564498(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all the links in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564500 = path.getOrDefault("subscriptionId")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "subscriptionId", valid_564500
  var valid_564501 = path.getOrDefault("resourceGroupName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "resourceGroupName", valid_564501
  var valid_564502 = path.getOrDefault("hubName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "hubName", valid_564502
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564503 = query.getOrDefault("api-version")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "api-version", valid_564503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564504: Call_LinksListByHub_564497; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the links in the specified hub.
  ## 
  let valid = call_564504.validator(path, query, header, formData, body)
  let scheme = call_564504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564504.url(scheme.get, call_564504.host, call_564504.base,
                         call_564504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564504, url, valid)

proc call*(call_564505: Call_LinksListByHub_564497; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## linksListByHub
  ## Gets all the links in the specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564506 = newJObject()
  var query_564507 = newJObject()
  add(query_564507, "api-version", newJString(apiVersion))
  add(path_564506, "subscriptionId", newJString(subscriptionId))
  add(path_564506, "resourceGroupName", newJString(resourceGroupName))
  add(path_564506, "hubName", newJString(hubName))
  result = call_564505.call(path_564506, query_564507, nil, nil, nil)

var linksListByHub* = Call_LinksListByHub_564497(name: "linksListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links",
    validator: validate_LinksListByHub_564498, base: "", url: url_LinksListByHub_564499,
    schemes: {Scheme.Https})
type
  Call_LinksCreateOrUpdate_564520 = ref object of OpenApiRestCall_563565
proc url_LinksCreateOrUpdate_564522(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "linkName" in path, "`linkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/links/"),
               (kind: VariableSegment, value: "linkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinksCreateOrUpdate_564521(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a link or updates an existing link in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkName: JString (required)
  ##           : The name of the link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkName` field"
  var valid_564523 = path.getOrDefault("linkName")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "linkName", valid_564523
  var valid_564524 = path.getOrDefault("subscriptionId")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "subscriptionId", valid_564524
  var valid_564525 = path.getOrDefault("resourceGroupName")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "resourceGroupName", valid_564525
  var valid_564526 = path.getOrDefault("hubName")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "hubName", valid_564526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564527 = query.getOrDefault("api-version")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "api-version", valid_564527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Link operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564529: Call_LinksCreateOrUpdate_564520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a link or updates an existing link in the hub.
  ## 
  let valid = call_564529.validator(path, query, header, formData, body)
  let scheme = call_564529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564529.url(scheme.get, call_564529.host, call_564529.base,
                         call_564529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564529, url, valid)

proc call*(call_564530: Call_LinksCreateOrUpdate_564520; linkName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string; parameters: JsonNode): Recallable =
  ## linksCreateOrUpdate
  ## Creates a link or updates an existing link in the hub.
  ##   linkName: string (required)
  ##           : The name of the link.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Link operation.
  var path_564531 = newJObject()
  var query_564532 = newJObject()
  var body_564533 = newJObject()
  add(path_564531, "linkName", newJString(linkName))
  add(query_564532, "api-version", newJString(apiVersion))
  add(path_564531, "subscriptionId", newJString(subscriptionId))
  add(path_564531, "resourceGroupName", newJString(resourceGroupName))
  add(path_564531, "hubName", newJString(hubName))
  if parameters != nil:
    body_564533 = parameters
  result = call_564530.call(path_564531, query_564532, nil, nil, body_564533)

var linksCreateOrUpdate* = Call_LinksCreateOrUpdate_564520(
    name: "linksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links/{linkName}",
    validator: validate_LinksCreateOrUpdate_564521, base: "",
    url: url_LinksCreateOrUpdate_564522, schemes: {Scheme.Https})
type
  Call_LinksGet_564508 = ref object of OpenApiRestCall_563565
proc url_LinksGet_564510(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "linkName" in path, "`linkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/links/"),
               (kind: VariableSegment, value: "linkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinksGet_564509(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a link in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkName: JString (required)
  ##           : The name of the link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkName` field"
  var valid_564511 = path.getOrDefault("linkName")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "linkName", valid_564511
  var valid_564512 = path.getOrDefault("subscriptionId")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "subscriptionId", valid_564512
  var valid_564513 = path.getOrDefault("resourceGroupName")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "resourceGroupName", valid_564513
  var valid_564514 = path.getOrDefault("hubName")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "hubName", valid_564514
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564515 = query.getOrDefault("api-version")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "api-version", valid_564515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564516: Call_LinksGet_564508; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a link in the hub.
  ## 
  let valid = call_564516.validator(path, query, header, formData, body)
  let scheme = call_564516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564516.url(scheme.get, call_564516.host, call_564516.base,
                         call_564516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564516, url, valid)

proc call*(call_564517: Call_LinksGet_564508; linkName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## linksGet
  ## Gets a link in the hub.
  ##   linkName: string (required)
  ##           : The name of the link.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564518 = newJObject()
  var query_564519 = newJObject()
  add(path_564518, "linkName", newJString(linkName))
  add(query_564519, "api-version", newJString(apiVersion))
  add(path_564518, "subscriptionId", newJString(subscriptionId))
  add(path_564518, "resourceGroupName", newJString(resourceGroupName))
  add(path_564518, "hubName", newJString(hubName))
  result = call_564517.call(path_564518, query_564519, nil, nil, nil)

var linksGet* = Call_LinksGet_564508(name: "linksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links/{linkName}",
                                  validator: validate_LinksGet_564509, base: "",
                                  url: url_LinksGet_564510,
                                  schemes: {Scheme.Https})
type
  Call_LinksDelete_564534 = ref object of OpenApiRestCall_563565
proc url_LinksDelete_564536(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "linkName" in path, "`linkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/links/"),
               (kind: VariableSegment, value: "linkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinksDelete_564535(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a link in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkName: JString (required)
  ##           : The name of the link.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkName` field"
  var valid_564537 = path.getOrDefault("linkName")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "linkName", valid_564537
  var valid_564538 = path.getOrDefault("subscriptionId")
  valid_564538 = validateParameter(valid_564538, JString, required = true,
                                 default = nil)
  if valid_564538 != nil:
    section.add "subscriptionId", valid_564538
  var valid_564539 = path.getOrDefault("resourceGroupName")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "resourceGroupName", valid_564539
  var valid_564540 = path.getOrDefault("hubName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "hubName", valid_564540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564541 = query.getOrDefault("api-version")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "api-version", valid_564541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564542: Call_LinksDelete_564534; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a link in the hub.
  ## 
  let valid = call_564542.validator(path, query, header, formData, body)
  let scheme = call_564542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564542.url(scheme.get, call_564542.host, call_564542.base,
                         call_564542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564542, url, valid)

proc call*(call_564543: Call_LinksDelete_564534; linkName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## linksDelete
  ## Deletes a link in the hub.
  ##   linkName: string (required)
  ##           : The name of the link.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564544 = newJObject()
  var query_564545 = newJObject()
  add(path_564544, "linkName", newJString(linkName))
  add(query_564545, "api-version", newJString(apiVersion))
  add(path_564544, "subscriptionId", newJString(subscriptionId))
  add(path_564544, "resourceGroupName", newJString(resourceGroupName))
  add(path_564544, "hubName", newJString(hubName))
  result = call_564543.call(path_564544, query_564545, nil, nil, nil)

var linksDelete* = Call_LinksDelete_564534(name: "linksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links/{linkName}",
                                        validator: validate_LinksDelete_564535,
                                        base: "", url: url_LinksDelete_564536,
                                        schemes: {Scheme.Https})
type
  Call_PredictionsListByHub_564546 = ref object of OpenApiRestCall_563565
proc url_PredictionsListByHub_564548(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/predictions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionsListByHub_564547(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the predictions in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564549 = path.getOrDefault("subscriptionId")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "subscriptionId", valid_564549
  var valid_564550 = path.getOrDefault("resourceGroupName")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "resourceGroupName", valid_564550
  var valid_564551 = path.getOrDefault("hubName")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "hubName", valid_564551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564552 = query.getOrDefault("api-version")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "api-version", valid_564552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564553: Call_PredictionsListByHub_564546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the predictions in the specified hub.
  ## 
  let valid = call_564553.validator(path, query, header, formData, body)
  let scheme = call_564553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564553.url(scheme.get, call_564553.host, call_564553.base,
                         call_564553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564553, url, valid)

proc call*(call_564554: Call_PredictionsListByHub_564546; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## predictionsListByHub
  ## Gets all the predictions in the specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564555 = newJObject()
  var query_564556 = newJObject()
  add(query_564556, "api-version", newJString(apiVersion))
  add(path_564555, "subscriptionId", newJString(subscriptionId))
  add(path_564555, "resourceGroupName", newJString(resourceGroupName))
  add(path_564555, "hubName", newJString(hubName))
  result = call_564554.call(path_564555, query_564556, nil, nil, nil)

var predictionsListByHub* = Call_PredictionsListByHub_564546(
    name: "predictionsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions",
    validator: validate_PredictionsListByHub_564547, base: "",
    url: url_PredictionsListByHub_564548, schemes: {Scheme.Https})
type
  Call_PredictionsCreateOrUpdate_564569 = ref object of OpenApiRestCall_563565
proc url_PredictionsCreateOrUpdate_564571(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "predictionName" in path, "`predictionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/predictions/"),
               (kind: VariableSegment, value: "predictionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionsCreateOrUpdate_564570(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Prediction or updates an existing Prediction in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564572 = path.getOrDefault("subscriptionId")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "subscriptionId", valid_564572
  var valid_564573 = path.getOrDefault("resourceGroupName")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "resourceGroupName", valid_564573
  var valid_564574 = path.getOrDefault("hubName")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "hubName", valid_564574
  var valid_564575 = path.getOrDefault("predictionName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "predictionName", valid_564575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564576 = query.getOrDefault("api-version")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "api-version", valid_564576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Prediction operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564578: Call_PredictionsCreateOrUpdate_564569; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Prediction or updates an existing Prediction in the hub.
  ## 
  let valid = call_564578.validator(path, query, header, formData, body)
  let scheme = call_564578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564578.url(scheme.get, call_564578.host, call_564578.base,
                         call_564578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564578, url, valid)

proc call*(call_564579: Call_PredictionsCreateOrUpdate_564569; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          predictionName: string; parameters: JsonNode): Recallable =
  ## predictionsCreateOrUpdate
  ## Creates a Prediction or updates an existing Prediction in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Prediction operation.
  var path_564580 = newJObject()
  var query_564581 = newJObject()
  var body_564582 = newJObject()
  add(query_564581, "api-version", newJString(apiVersion))
  add(path_564580, "subscriptionId", newJString(subscriptionId))
  add(path_564580, "resourceGroupName", newJString(resourceGroupName))
  add(path_564580, "hubName", newJString(hubName))
  add(path_564580, "predictionName", newJString(predictionName))
  if parameters != nil:
    body_564582 = parameters
  result = call_564579.call(path_564580, query_564581, nil, nil, body_564582)

var predictionsCreateOrUpdate* = Call_PredictionsCreateOrUpdate_564569(
    name: "predictionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}",
    validator: validate_PredictionsCreateOrUpdate_564570, base: "",
    url: url_PredictionsCreateOrUpdate_564571, schemes: {Scheme.Https})
type
  Call_PredictionsGet_564557 = ref object of OpenApiRestCall_563565
proc url_PredictionsGet_564559(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "predictionName" in path, "`predictionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/predictions/"),
               (kind: VariableSegment, value: "predictionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionsGet_564558(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a Prediction in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564560 = path.getOrDefault("subscriptionId")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "subscriptionId", valid_564560
  var valid_564561 = path.getOrDefault("resourceGroupName")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "resourceGroupName", valid_564561
  var valid_564562 = path.getOrDefault("hubName")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "hubName", valid_564562
  var valid_564563 = path.getOrDefault("predictionName")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "predictionName", valid_564563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564564 = query.getOrDefault("api-version")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "api-version", valid_564564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564565: Call_PredictionsGet_564557; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Prediction in the hub.
  ## 
  let valid = call_564565.validator(path, query, header, formData, body)
  let scheme = call_564565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564565.url(scheme.get, call_564565.host, call_564565.base,
                         call_564565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564565, url, valid)

proc call*(call_564566: Call_PredictionsGet_564557; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          predictionName: string): Recallable =
  ## predictionsGet
  ## Gets a Prediction in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  var path_564567 = newJObject()
  var query_564568 = newJObject()
  add(query_564568, "api-version", newJString(apiVersion))
  add(path_564567, "subscriptionId", newJString(subscriptionId))
  add(path_564567, "resourceGroupName", newJString(resourceGroupName))
  add(path_564567, "hubName", newJString(hubName))
  add(path_564567, "predictionName", newJString(predictionName))
  result = call_564566.call(path_564567, query_564568, nil, nil, nil)

var predictionsGet* = Call_PredictionsGet_564557(name: "predictionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}",
    validator: validate_PredictionsGet_564558, base: "", url: url_PredictionsGet_564559,
    schemes: {Scheme.Https})
type
  Call_PredictionsDelete_564583 = ref object of OpenApiRestCall_563565
proc url_PredictionsDelete_564585(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "predictionName" in path, "`predictionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/predictions/"),
               (kind: VariableSegment, value: "predictionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionsDelete_564584(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a Prediction in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564586 = path.getOrDefault("subscriptionId")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "subscriptionId", valid_564586
  var valid_564587 = path.getOrDefault("resourceGroupName")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "resourceGroupName", valid_564587
  var valid_564588 = path.getOrDefault("hubName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "hubName", valid_564588
  var valid_564589 = path.getOrDefault("predictionName")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "predictionName", valid_564589
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564590 = query.getOrDefault("api-version")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "api-version", valid_564590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564591: Call_PredictionsDelete_564583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Prediction in the hub.
  ## 
  let valid = call_564591.validator(path, query, header, formData, body)
  let scheme = call_564591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564591.url(scheme.get, call_564591.host, call_564591.base,
                         call_564591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564591, url, valid)

proc call*(call_564592: Call_PredictionsDelete_564583; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          predictionName: string): Recallable =
  ## predictionsDelete
  ## Deletes a Prediction in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  var path_564593 = newJObject()
  var query_564594 = newJObject()
  add(query_564594, "api-version", newJString(apiVersion))
  add(path_564593, "subscriptionId", newJString(subscriptionId))
  add(path_564593, "resourceGroupName", newJString(resourceGroupName))
  add(path_564593, "hubName", newJString(hubName))
  add(path_564593, "predictionName", newJString(predictionName))
  result = call_564592.call(path_564593, query_564594, nil, nil, nil)

var predictionsDelete* = Call_PredictionsDelete_564583(name: "predictionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}",
    validator: validate_PredictionsDelete_564584, base: "",
    url: url_PredictionsDelete_564585, schemes: {Scheme.Https})
type
  Call_PredictionsGetModelStatus_564595 = ref object of OpenApiRestCall_563565
proc url_PredictionsGetModelStatus_564597(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "predictionName" in path, "`predictionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/predictions/"),
               (kind: VariableSegment, value: "predictionName"),
               (kind: ConstantSegment, value: "/getModelStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionsGetModelStatus_564596(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets model status of the prediction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564598 = path.getOrDefault("subscriptionId")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "subscriptionId", valid_564598
  var valid_564599 = path.getOrDefault("resourceGroupName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "resourceGroupName", valid_564599
  var valid_564600 = path.getOrDefault("hubName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "hubName", valid_564600
  var valid_564601 = path.getOrDefault("predictionName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "predictionName", valid_564601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564602 = query.getOrDefault("api-version")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "api-version", valid_564602
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564603: Call_PredictionsGetModelStatus_564595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets model status of the prediction.
  ## 
  let valid = call_564603.validator(path, query, header, formData, body)
  let scheme = call_564603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564603.url(scheme.get, call_564603.host, call_564603.base,
                         call_564603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564603, url, valid)

proc call*(call_564604: Call_PredictionsGetModelStatus_564595; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          predictionName: string): Recallable =
  ## predictionsGetModelStatus
  ## Gets model status of the prediction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  var path_564605 = newJObject()
  var query_564606 = newJObject()
  add(query_564606, "api-version", newJString(apiVersion))
  add(path_564605, "subscriptionId", newJString(subscriptionId))
  add(path_564605, "resourceGroupName", newJString(resourceGroupName))
  add(path_564605, "hubName", newJString(hubName))
  add(path_564605, "predictionName", newJString(predictionName))
  result = call_564604.call(path_564605, query_564606, nil, nil, nil)

var predictionsGetModelStatus* = Call_PredictionsGetModelStatus_564595(
    name: "predictionsGetModelStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}/getModelStatus",
    validator: validate_PredictionsGetModelStatus_564596, base: "",
    url: url_PredictionsGetModelStatus_564597, schemes: {Scheme.Https})
type
  Call_PredictionsGetTrainingResults_564607 = ref object of OpenApiRestCall_563565
proc url_PredictionsGetTrainingResults_564609(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "predictionName" in path, "`predictionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/predictions/"),
               (kind: VariableSegment, value: "predictionName"),
               (kind: ConstantSegment, value: "/getTrainingResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionsGetTrainingResults_564608(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets training results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564610 = path.getOrDefault("subscriptionId")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "subscriptionId", valid_564610
  var valid_564611 = path.getOrDefault("resourceGroupName")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "resourceGroupName", valid_564611
  var valid_564612 = path.getOrDefault("hubName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "hubName", valid_564612
  var valid_564613 = path.getOrDefault("predictionName")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "predictionName", valid_564613
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564614 = query.getOrDefault("api-version")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "api-version", valid_564614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564615: Call_PredictionsGetTrainingResults_564607; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets training results.
  ## 
  let valid = call_564615.validator(path, query, header, formData, body)
  let scheme = call_564615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564615.url(scheme.get, call_564615.host, call_564615.base,
                         call_564615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564615, url, valid)

proc call*(call_564616: Call_PredictionsGetTrainingResults_564607;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string; predictionName: string): Recallable =
  ## predictionsGetTrainingResults
  ## Gets training results.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  var path_564617 = newJObject()
  var query_564618 = newJObject()
  add(query_564618, "api-version", newJString(apiVersion))
  add(path_564617, "subscriptionId", newJString(subscriptionId))
  add(path_564617, "resourceGroupName", newJString(resourceGroupName))
  add(path_564617, "hubName", newJString(hubName))
  add(path_564617, "predictionName", newJString(predictionName))
  result = call_564616.call(path_564617, query_564618, nil, nil, nil)

var predictionsGetTrainingResults* = Call_PredictionsGetTrainingResults_564607(
    name: "predictionsGetTrainingResults", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}/getTrainingResults",
    validator: validate_PredictionsGetTrainingResults_564608, base: "",
    url: url_PredictionsGetTrainingResults_564609, schemes: {Scheme.Https})
type
  Call_PredictionsModelStatus_564619 = ref object of OpenApiRestCall_563565
proc url_PredictionsModelStatus_564621(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "predictionName" in path, "`predictionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/predictions/"),
               (kind: VariableSegment, value: "predictionName"),
               (kind: ConstantSegment, value: "/modelStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionsModelStatus_564620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the model status of prediction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564622 = path.getOrDefault("subscriptionId")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "subscriptionId", valid_564622
  var valid_564623 = path.getOrDefault("resourceGroupName")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "resourceGroupName", valid_564623
  var valid_564624 = path.getOrDefault("hubName")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "hubName", valid_564624
  var valid_564625 = path.getOrDefault("predictionName")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "predictionName", valid_564625
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564626 = query.getOrDefault("api-version")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "api-version", valid_564626
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update prediction model status operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564628: Call_PredictionsModelStatus_564619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the model status of prediction.
  ## 
  let valid = call_564628.validator(path, query, header, formData, body)
  let scheme = call_564628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564628.url(scheme.get, call_564628.host, call_564628.base,
                         call_564628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564628, url, valid)

proc call*(call_564629: Call_PredictionsModelStatus_564619; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          predictionName: string; parameters: JsonNode): Recallable =
  ## predictionsModelStatus
  ## Creates or updates the model status of prediction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update prediction model status operation.
  var path_564630 = newJObject()
  var query_564631 = newJObject()
  var body_564632 = newJObject()
  add(query_564631, "api-version", newJString(apiVersion))
  add(path_564630, "subscriptionId", newJString(subscriptionId))
  add(path_564630, "resourceGroupName", newJString(resourceGroupName))
  add(path_564630, "hubName", newJString(hubName))
  add(path_564630, "predictionName", newJString(predictionName))
  if parameters != nil:
    body_564632 = parameters
  result = call_564629.call(path_564630, query_564631, nil, nil, body_564632)

var predictionsModelStatus* = Call_PredictionsModelStatus_564619(
    name: "predictionsModelStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}/modelStatus",
    validator: validate_PredictionsModelStatus_564620, base: "",
    url: url_PredictionsModelStatus_564621, schemes: {Scheme.Https})
type
  Call_ProfilesListByHub_564633 = ref object of OpenApiRestCall_563565
proc url_ProfilesListByHub_564635(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListByHub_564634(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all profile in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564636 = path.getOrDefault("subscriptionId")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "subscriptionId", valid_564636
  var valid_564637 = path.getOrDefault("resourceGroupName")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "resourceGroupName", valid_564637
  var valid_564638 = path.getOrDefault("hubName")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "hubName", valid_564638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of profile to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564639 = query.getOrDefault("api-version")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "api-version", valid_564639
  var valid_564640 = query.getOrDefault("locale-code")
  valid_564640 = validateParameter(valid_564640, JString, required = false,
                                 default = newJString("en-us"))
  if valid_564640 != nil:
    section.add "locale-code", valid_564640
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564641: Call_ProfilesListByHub_564633; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all profile in the hub.
  ## 
  let valid = call_564641.validator(path, query, header, formData, body)
  let scheme = call_564641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564641.url(scheme.get, call_564641.host, call_564641.base,
                         call_564641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564641, url, valid)

proc call*(call_564642: Call_ProfilesListByHub_564633; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          localeCode: string = "en-us"): Recallable =
  ## profilesListByHub
  ## Gets all profile in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   localeCode: string
  ##             : Locale of profile to retrieve, default is en-us.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564643 = newJObject()
  var query_564644 = newJObject()
  add(query_564644, "api-version", newJString(apiVersion))
  add(query_564644, "locale-code", newJString(localeCode))
  add(path_564643, "subscriptionId", newJString(subscriptionId))
  add(path_564643, "resourceGroupName", newJString(resourceGroupName))
  add(path_564643, "hubName", newJString(hubName))
  result = call_564642.call(path_564643, query_564644, nil, nil, nil)

var profilesListByHub* = Call_ProfilesListByHub_564633(name: "profilesListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles",
    validator: validate_ProfilesListByHub_564634, base: "",
    url: url_ProfilesListByHub_564635, schemes: {Scheme.Https})
type
  Call_ProfilesCreateOrUpdate_564658 = ref object of OpenApiRestCall_563565
proc url_ProfilesCreateOrUpdate_564660(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesCreateOrUpdate_564659(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a profile within a Hub, or updates an existing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : The name of the profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564661 = path.getOrDefault("profileName")
  valid_564661 = validateParameter(valid_564661, JString, required = true,
                                 default = nil)
  if valid_564661 != nil:
    section.add "profileName", valid_564661
  var valid_564662 = path.getOrDefault("subscriptionId")
  valid_564662 = validateParameter(valid_564662, JString, required = true,
                                 default = nil)
  if valid_564662 != nil:
    section.add "subscriptionId", valid_564662
  var valid_564663 = path.getOrDefault("resourceGroupName")
  valid_564663 = validateParameter(valid_564663, JString, required = true,
                                 default = nil)
  if valid_564663 != nil:
    section.add "resourceGroupName", valid_564663
  var valid_564664 = path.getOrDefault("hubName")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "hubName", valid_564664
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564665 = query.getOrDefault("api-version")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "api-version", valid_564665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete Profile type operation
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564667: Call_ProfilesCreateOrUpdate_564658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a profile within a Hub, or updates an existing profile.
  ## 
  let valid = call_564667.validator(path, query, header, formData, body)
  let scheme = call_564667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564667.url(scheme.get, call_564667.host, call_564667.base,
                         call_564667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564667, url, valid)

proc call*(call_564668: Call_ProfilesCreateOrUpdate_564658; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string; parameters: JsonNode): Recallable =
  ## profilesCreateOrUpdate
  ## Creates a profile within a Hub, or updates an existing profile.
  ##   profileName: string (required)
  ##              : The name of the profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete Profile type operation
  var path_564669 = newJObject()
  var query_564670 = newJObject()
  var body_564671 = newJObject()
  add(path_564669, "profileName", newJString(profileName))
  add(query_564670, "api-version", newJString(apiVersion))
  add(path_564669, "subscriptionId", newJString(subscriptionId))
  add(path_564669, "resourceGroupName", newJString(resourceGroupName))
  add(path_564669, "hubName", newJString(hubName))
  if parameters != nil:
    body_564671 = parameters
  result = call_564668.call(path_564669, query_564670, nil, nil, body_564671)

var profilesCreateOrUpdate* = Call_ProfilesCreateOrUpdate_564658(
    name: "profilesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}",
    validator: validate_ProfilesCreateOrUpdate_564659, base: "",
    url: url_ProfilesCreateOrUpdate_564660, schemes: {Scheme.Https})
type
  Call_ProfilesGet_564645 = ref object of OpenApiRestCall_563565
proc url_ProfilesGet_564647(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGet_564646(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : The name of the profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564648 = path.getOrDefault("profileName")
  valid_564648 = validateParameter(valid_564648, JString, required = true,
                                 default = nil)
  if valid_564648 != nil:
    section.add "profileName", valid_564648
  var valid_564649 = path.getOrDefault("subscriptionId")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "subscriptionId", valid_564649
  var valid_564650 = path.getOrDefault("resourceGroupName")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "resourceGroupName", valid_564650
  var valid_564651 = path.getOrDefault("hubName")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "hubName", valid_564651
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of profile to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564652 = query.getOrDefault("api-version")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "api-version", valid_564652
  var valid_564653 = query.getOrDefault("locale-code")
  valid_564653 = validateParameter(valid_564653, JString, required = false,
                                 default = newJString("en-us"))
  if valid_564653 != nil:
    section.add "locale-code", valid_564653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564654: Call_ProfilesGet_564645; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified profile.
  ## 
  let valid = call_564654.validator(path, query, header, formData, body)
  let scheme = call_564654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564654.url(scheme.get, call_564654.host, call_564654.base,
                         call_564654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564654, url, valid)

proc call*(call_564655: Call_ProfilesGet_564645; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string; localeCode: string = "en-us"): Recallable =
  ## profilesGet
  ## Gets information about the specified profile.
  ##   profileName: string (required)
  ##              : The name of the profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   localeCode: string
  ##             : Locale of profile to retrieve, default is en-us.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564656 = newJObject()
  var query_564657 = newJObject()
  add(path_564656, "profileName", newJString(profileName))
  add(query_564657, "api-version", newJString(apiVersion))
  add(query_564657, "locale-code", newJString(localeCode))
  add(path_564656, "subscriptionId", newJString(subscriptionId))
  add(path_564656, "resourceGroupName", newJString(resourceGroupName))
  add(path_564656, "hubName", newJString(hubName))
  result = call_564655.call(path_564656, query_564657, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_564645(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}",
                                        validator: validate_ProfilesGet_564646,
                                        base: "", url: url_ProfilesGet_564647,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesDelete_564672 = ref object of OpenApiRestCall_563565
proc url_ProfilesDelete_564674(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesDelete_564673(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a profile within a hub
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : The name of the profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564675 = path.getOrDefault("profileName")
  valid_564675 = validateParameter(valid_564675, JString, required = true,
                                 default = nil)
  if valid_564675 != nil:
    section.add "profileName", valid_564675
  var valid_564676 = path.getOrDefault("subscriptionId")
  valid_564676 = validateParameter(valid_564676, JString, required = true,
                                 default = nil)
  if valid_564676 != nil:
    section.add "subscriptionId", valid_564676
  var valid_564677 = path.getOrDefault("resourceGroupName")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "resourceGroupName", valid_564677
  var valid_564678 = path.getOrDefault("hubName")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "hubName", valid_564678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of profile to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564679 = query.getOrDefault("api-version")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "api-version", valid_564679
  var valid_564680 = query.getOrDefault("locale-code")
  valid_564680 = validateParameter(valid_564680, JString, required = false,
                                 default = newJString("en-us"))
  if valid_564680 != nil:
    section.add "locale-code", valid_564680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564681: Call_ProfilesDelete_564672; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a profile within a hub
  ## 
  let valid = call_564681.validator(path, query, header, formData, body)
  let scheme = call_564681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564681.url(scheme.get, call_564681.host, call_564681.base,
                         call_564681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564681, url, valid)

proc call*(call_564682: Call_ProfilesDelete_564672; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string; localeCode: string = "en-us"): Recallable =
  ## profilesDelete
  ## Deletes a profile within a hub
  ##   profileName: string (required)
  ##              : The name of the profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   localeCode: string
  ##             : Locale of profile to retrieve, default is en-us.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564683 = newJObject()
  var query_564684 = newJObject()
  add(path_564683, "profileName", newJString(profileName))
  add(query_564684, "api-version", newJString(apiVersion))
  add(query_564684, "locale-code", newJString(localeCode))
  add(path_564683, "subscriptionId", newJString(subscriptionId))
  add(path_564683, "resourceGroupName", newJString(resourceGroupName))
  add(path_564683, "hubName", newJString(hubName))
  result = call_564682.call(path_564683, query_564684, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_564672(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}",
    validator: validate_ProfilesDelete_564673, base: "", url: url_ProfilesDelete_564674,
    schemes: {Scheme.Https})
type
  Call_ProfilesGetEnrichingKpis_564685 = ref object of OpenApiRestCall_563565
proc url_ProfilesGetEnrichingKpis_564687(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/getEnrichingKpis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGetEnrichingKpis_564686(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the KPIs that enrich the profile Type identified by the supplied name. Enrichment happens through participants of the Interaction on an Interaction KPI and through Relationships for Profile KPIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileName: JString (required)
  ##              : The name of the profile.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `profileName` field"
  var valid_564688 = path.getOrDefault("profileName")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = nil)
  if valid_564688 != nil:
    section.add "profileName", valid_564688
  var valid_564689 = path.getOrDefault("subscriptionId")
  valid_564689 = validateParameter(valid_564689, JString, required = true,
                                 default = nil)
  if valid_564689 != nil:
    section.add "subscriptionId", valid_564689
  var valid_564690 = path.getOrDefault("resourceGroupName")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "resourceGroupName", valid_564690
  var valid_564691 = path.getOrDefault("hubName")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "hubName", valid_564691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564692 = query.getOrDefault("api-version")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "api-version", valid_564692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564693: Call_ProfilesGetEnrichingKpis_564685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the KPIs that enrich the profile Type identified by the supplied name. Enrichment happens through participants of the Interaction on an Interaction KPI and through Relationships for Profile KPIs.
  ## 
  let valid = call_564693.validator(path, query, header, formData, body)
  let scheme = call_564693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564693.url(scheme.get, call_564693.host, call_564693.base,
                         call_564693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564693, url, valid)

proc call*(call_564694: Call_ProfilesGetEnrichingKpis_564685; profileName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## profilesGetEnrichingKpis
  ## Gets the KPIs that enrich the profile Type identified by the supplied name. Enrichment happens through participants of the Interaction on an Interaction KPI and through Relationships for Profile KPIs.
  ##   profileName: string (required)
  ##              : The name of the profile.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564695 = newJObject()
  var query_564696 = newJObject()
  add(path_564695, "profileName", newJString(profileName))
  add(query_564696, "api-version", newJString(apiVersion))
  add(path_564695, "subscriptionId", newJString(subscriptionId))
  add(path_564695, "resourceGroupName", newJString(resourceGroupName))
  add(path_564695, "hubName", newJString(hubName))
  result = call_564694.call(path_564695, query_564696, nil, nil, nil)

var profilesGetEnrichingKpis* = Call_ProfilesGetEnrichingKpis_564685(
    name: "profilesGetEnrichingKpis", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}/getEnrichingKpis",
    validator: validate_ProfilesGetEnrichingKpis_564686, base: "",
    url: url_ProfilesGetEnrichingKpis_564687, schemes: {Scheme.Https})
type
  Call_RelationshipLinksListByHub_564697 = ref object of OpenApiRestCall_563565
proc url_RelationshipLinksListByHub_564699(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/relationshipLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RelationshipLinksListByHub_564698(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all relationship links in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564700 = path.getOrDefault("subscriptionId")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "subscriptionId", valid_564700
  var valid_564701 = path.getOrDefault("resourceGroupName")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "resourceGroupName", valid_564701
  var valid_564702 = path.getOrDefault("hubName")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = nil)
  if valid_564702 != nil:
    section.add "hubName", valid_564702
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564703 = query.getOrDefault("api-version")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "api-version", valid_564703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564704: Call_RelationshipLinksListByHub_564697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all relationship links in the hub.
  ## 
  let valid = call_564704.validator(path, query, header, formData, body)
  let scheme = call_564704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564704.url(scheme.get, call_564704.host, call_564704.base,
                         call_564704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564704, url, valid)

proc call*(call_564705: Call_RelationshipLinksListByHub_564697; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## relationshipLinksListByHub
  ## Gets all relationship links in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564706 = newJObject()
  var query_564707 = newJObject()
  add(query_564707, "api-version", newJString(apiVersion))
  add(path_564706, "subscriptionId", newJString(subscriptionId))
  add(path_564706, "resourceGroupName", newJString(resourceGroupName))
  add(path_564706, "hubName", newJString(hubName))
  result = call_564705.call(path_564706, query_564707, nil, nil, nil)

var relationshipLinksListByHub* = Call_RelationshipLinksListByHub_564697(
    name: "relationshipLinksListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks",
    validator: validate_RelationshipLinksListByHub_564698, base: "",
    url: url_RelationshipLinksListByHub_564699, schemes: {Scheme.Https})
type
  Call_RelationshipLinksCreateOrUpdate_564720 = ref object of OpenApiRestCall_563565
proc url_RelationshipLinksCreateOrUpdate_564722(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "relationshipLinkName" in path,
        "`relationshipLinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/relationshipLinks/"),
               (kind: VariableSegment, value: "relationshipLinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RelationshipLinksCreateOrUpdate_564721(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a relationship link or updates an existing relationship link within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: JString (required)
  ##                       : The name of the relationship link.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564723 = path.getOrDefault("subscriptionId")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "subscriptionId", valid_564723
  var valid_564724 = path.getOrDefault("relationshipLinkName")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "relationshipLinkName", valid_564724
  var valid_564725 = path.getOrDefault("resourceGroupName")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "resourceGroupName", valid_564725
  var valid_564726 = path.getOrDefault("hubName")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "hubName", valid_564726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564727 = query.getOrDefault("api-version")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "api-version", valid_564727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate relationship link operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564729: Call_RelationshipLinksCreateOrUpdate_564720;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a relationship link or updates an existing relationship link within a hub.
  ## 
  let valid = call_564729.validator(path, query, header, formData, body)
  let scheme = call_564729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564729.url(scheme.get, call_564729.host, call_564729.base,
                         call_564729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564729, url, valid)

proc call*(call_564730: Call_RelationshipLinksCreateOrUpdate_564720;
          apiVersion: string; subscriptionId: string; relationshipLinkName: string;
          resourceGroupName: string; hubName: string; parameters: JsonNode): Recallable =
  ## relationshipLinksCreateOrUpdate
  ## Creates a relationship link or updates an existing relationship link within a hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: string (required)
  ##                       : The name of the relationship link.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate relationship link operation.
  var path_564731 = newJObject()
  var query_564732 = newJObject()
  var body_564733 = newJObject()
  add(query_564732, "api-version", newJString(apiVersion))
  add(path_564731, "subscriptionId", newJString(subscriptionId))
  add(path_564731, "relationshipLinkName", newJString(relationshipLinkName))
  add(path_564731, "resourceGroupName", newJString(resourceGroupName))
  add(path_564731, "hubName", newJString(hubName))
  if parameters != nil:
    body_564733 = parameters
  result = call_564730.call(path_564731, query_564732, nil, nil, body_564733)

var relationshipLinksCreateOrUpdate* = Call_RelationshipLinksCreateOrUpdate_564720(
    name: "relationshipLinksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks/{relationshipLinkName}",
    validator: validate_RelationshipLinksCreateOrUpdate_564721, base: "",
    url: url_RelationshipLinksCreateOrUpdate_564722, schemes: {Scheme.Https})
type
  Call_RelationshipLinksGet_564708 = ref object of OpenApiRestCall_563565
proc url_RelationshipLinksGet_564710(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "relationshipLinkName" in path,
        "`relationshipLinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/relationshipLinks/"),
               (kind: VariableSegment, value: "relationshipLinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RelationshipLinksGet_564709(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified relationship Link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: JString (required)
  ##                       : The name of the relationship link.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564711 = path.getOrDefault("subscriptionId")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "subscriptionId", valid_564711
  var valid_564712 = path.getOrDefault("relationshipLinkName")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "relationshipLinkName", valid_564712
  var valid_564713 = path.getOrDefault("resourceGroupName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "resourceGroupName", valid_564713
  var valid_564714 = path.getOrDefault("hubName")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "hubName", valid_564714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564715 = query.getOrDefault("api-version")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "api-version", valid_564715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564716: Call_RelationshipLinksGet_564708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified relationship Link.
  ## 
  let valid = call_564716.validator(path, query, header, formData, body)
  let scheme = call_564716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564716.url(scheme.get, call_564716.host, call_564716.base,
                         call_564716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564716, url, valid)

proc call*(call_564717: Call_RelationshipLinksGet_564708; apiVersion: string;
          subscriptionId: string; relationshipLinkName: string;
          resourceGroupName: string; hubName: string): Recallable =
  ## relationshipLinksGet
  ## Gets information about the specified relationship Link.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: string (required)
  ##                       : The name of the relationship link.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564718 = newJObject()
  var query_564719 = newJObject()
  add(query_564719, "api-version", newJString(apiVersion))
  add(path_564718, "subscriptionId", newJString(subscriptionId))
  add(path_564718, "relationshipLinkName", newJString(relationshipLinkName))
  add(path_564718, "resourceGroupName", newJString(resourceGroupName))
  add(path_564718, "hubName", newJString(hubName))
  result = call_564717.call(path_564718, query_564719, nil, nil, nil)

var relationshipLinksGet* = Call_RelationshipLinksGet_564708(
    name: "relationshipLinksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks/{relationshipLinkName}",
    validator: validate_RelationshipLinksGet_564709, base: "",
    url: url_RelationshipLinksGet_564710, schemes: {Scheme.Https})
type
  Call_RelationshipLinksDelete_564734 = ref object of OpenApiRestCall_563565
proc url_RelationshipLinksDelete_564736(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "relationshipLinkName" in path,
        "`relationshipLinkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/relationshipLinks/"),
               (kind: VariableSegment, value: "relationshipLinkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RelationshipLinksDelete_564735(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a relationship link within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: JString (required)
  ##                       : The name of the relationship.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564737 = path.getOrDefault("subscriptionId")
  valid_564737 = validateParameter(valid_564737, JString, required = true,
                                 default = nil)
  if valid_564737 != nil:
    section.add "subscriptionId", valid_564737
  var valid_564738 = path.getOrDefault("relationshipLinkName")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "relationshipLinkName", valid_564738
  var valid_564739 = path.getOrDefault("resourceGroupName")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "resourceGroupName", valid_564739
  var valid_564740 = path.getOrDefault("hubName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "hubName", valid_564740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564741 = query.getOrDefault("api-version")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "api-version", valid_564741
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564742: Call_RelationshipLinksDelete_564734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a relationship link within a hub.
  ## 
  let valid = call_564742.validator(path, query, header, formData, body)
  let scheme = call_564742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564742.url(scheme.get, call_564742.host, call_564742.base,
                         call_564742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564742, url, valid)

proc call*(call_564743: Call_RelationshipLinksDelete_564734; apiVersion: string;
          subscriptionId: string; relationshipLinkName: string;
          resourceGroupName: string; hubName: string): Recallable =
  ## relationshipLinksDelete
  ## Deletes a relationship link within a hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: string (required)
  ##                       : The name of the relationship.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564744 = newJObject()
  var query_564745 = newJObject()
  add(query_564745, "api-version", newJString(apiVersion))
  add(path_564744, "subscriptionId", newJString(subscriptionId))
  add(path_564744, "relationshipLinkName", newJString(relationshipLinkName))
  add(path_564744, "resourceGroupName", newJString(resourceGroupName))
  add(path_564744, "hubName", newJString(hubName))
  result = call_564743.call(path_564744, query_564745, nil, nil, nil)

var relationshipLinksDelete* = Call_RelationshipLinksDelete_564734(
    name: "relationshipLinksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks/{relationshipLinkName}",
    validator: validate_RelationshipLinksDelete_564735, base: "",
    url: url_RelationshipLinksDelete_564736, schemes: {Scheme.Https})
type
  Call_RelationshipsListByHub_564746 = ref object of OpenApiRestCall_563565
proc url_RelationshipsListByHub_564748(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/relationships")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RelationshipsListByHub_564747(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all relationships in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564749 = path.getOrDefault("subscriptionId")
  valid_564749 = validateParameter(valid_564749, JString, required = true,
                                 default = nil)
  if valid_564749 != nil:
    section.add "subscriptionId", valid_564749
  var valid_564750 = path.getOrDefault("resourceGroupName")
  valid_564750 = validateParameter(valid_564750, JString, required = true,
                                 default = nil)
  if valid_564750 != nil:
    section.add "resourceGroupName", valid_564750
  var valid_564751 = path.getOrDefault("hubName")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = nil)
  if valid_564751 != nil:
    section.add "hubName", valid_564751
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564752 = query.getOrDefault("api-version")
  valid_564752 = validateParameter(valid_564752, JString, required = true,
                                 default = nil)
  if valid_564752 != nil:
    section.add "api-version", valid_564752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564753: Call_RelationshipsListByHub_564746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all relationships in the hub.
  ## 
  let valid = call_564753.validator(path, query, header, formData, body)
  let scheme = call_564753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564753.url(scheme.get, call_564753.host, call_564753.base,
                         call_564753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564753, url, valid)

proc call*(call_564754: Call_RelationshipsListByHub_564746; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## relationshipsListByHub
  ## Gets all relationships in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564755 = newJObject()
  var query_564756 = newJObject()
  add(query_564756, "api-version", newJString(apiVersion))
  add(path_564755, "subscriptionId", newJString(subscriptionId))
  add(path_564755, "resourceGroupName", newJString(resourceGroupName))
  add(path_564755, "hubName", newJString(hubName))
  result = call_564754.call(path_564755, query_564756, nil, nil, nil)

var relationshipsListByHub* = Call_RelationshipsListByHub_564746(
    name: "relationshipsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships",
    validator: validate_RelationshipsListByHub_564747, base: "",
    url: url_RelationshipsListByHub_564748, schemes: {Scheme.Https})
type
  Call_RelationshipsCreateOrUpdate_564769 = ref object of OpenApiRestCall_563565
proc url_RelationshipsCreateOrUpdate_564771(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "relationshipName" in path,
        "`relationshipName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/relationships/"),
               (kind: VariableSegment, value: "relationshipName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RelationshipsCreateOrUpdate_564770(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a relationship or updates an existing relationship within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipName: JString (required)
  ##                   : The name of the Relationship.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564772 = path.getOrDefault("subscriptionId")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "subscriptionId", valid_564772
  var valid_564773 = path.getOrDefault("relationshipName")
  valid_564773 = validateParameter(valid_564773, JString, required = true,
                                 default = nil)
  if valid_564773 != nil:
    section.add "relationshipName", valid_564773
  var valid_564774 = path.getOrDefault("resourceGroupName")
  valid_564774 = validateParameter(valid_564774, JString, required = true,
                                 default = nil)
  if valid_564774 != nil:
    section.add "resourceGroupName", valid_564774
  var valid_564775 = path.getOrDefault("hubName")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "hubName", valid_564775
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564776 = query.getOrDefault("api-version")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "api-version", valid_564776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Relationship operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564778: Call_RelationshipsCreateOrUpdate_564769; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a relationship or updates an existing relationship within a hub.
  ## 
  let valid = call_564778.validator(path, query, header, formData, body)
  let scheme = call_564778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564778.url(scheme.get, call_564778.host, call_564778.base,
                         call_564778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564778, url, valid)

proc call*(call_564779: Call_RelationshipsCreateOrUpdate_564769;
          apiVersion: string; subscriptionId: string; relationshipName: string;
          resourceGroupName: string; hubName: string; parameters: JsonNode): Recallable =
  ## relationshipsCreateOrUpdate
  ## Creates a relationship or updates an existing relationship within a hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipName: string (required)
  ##                   : The name of the Relationship.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Relationship operation.
  var path_564780 = newJObject()
  var query_564781 = newJObject()
  var body_564782 = newJObject()
  add(query_564781, "api-version", newJString(apiVersion))
  add(path_564780, "subscriptionId", newJString(subscriptionId))
  add(path_564780, "relationshipName", newJString(relationshipName))
  add(path_564780, "resourceGroupName", newJString(resourceGroupName))
  add(path_564780, "hubName", newJString(hubName))
  if parameters != nil:
    body_564782 = parameters
  result = call_564779.call(path_564780, query_564781, nil, nil, body_564782)

var relationshipsCreateOrUpdate* = Call_RelationshipsCreateOrUpdate_564769(
    name: "relationshipsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships/{relationshipName}",
    validator: validate_RelationshipsCreateOrUpdate_564770, base: "",
    url: url_RelationshipsCreateOrUpdate_564771, schemes: {Scheme.Https})
type
  Call_RelationshipsGet_564757 = ref object of OpenApiRestCall_563565
proc url_RelationshipsGet_564759(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "relationshipName" in path,
        "`relationshipName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/relationships/"),
               (kind: VariableSegment, value: "relationshipName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RelationshipsGet_564758(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the specified relationship.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipName: JString (required)
  ##                   : The name of the relationship.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564760 = path.getOrDefault("subscriptionId")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "subscriptionId", valid_564760
  var valid_564761 = path.getOrDefault("relationshipName")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "relationshipName", valid_564761
  var valid_564762 = path.getOrDefault("resourceGroupName")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "resourceGroupName", valid_564762
  var valid_564763 = path.getOrDefault("hubName")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "hubName", valid_564763
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564764 = query.getOrDefault("api-version")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = nil)
  if valid_564764 != nil:
    section.add "api-version", valid_564764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564765: Call_RelationshipsGet_564757; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified relationship.
  ## 
  let valid = call_564765.validator(path, query, header, formData, body)
  let scheme = call_564765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564765.url(scheme.get, call_564765.host, call_564765.base,
                         call_564765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564765, url, valid)

proc call*(call_564766: Call_RelationshipsGet_564757; apiVersion: string;
          subscriptionId: string; relationshipName: string;
          resourceGroupName: string; hubName: string): Recallable =
  ## relationshipsGet
  ## Gets information about the specified relationship.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipName: string (required)
  ##                   : The name of the relationship.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564767 = newJObject()
  var query_564768 = newJObject()
  add(query_564768, "api-version", newJString(apiVersion))
  add(path_564767, "subscriptionId", newJString(subscriptionId))
  add(path_564767, "relationshipName", newJString(relationshipName))
  add(path_564767, "resourceGroupName", newJString(resourceGroupName))
  add(path_564767, "hubName", newJString(hubName))
  result = call_564766.call(path_564767, query_564768, nil, nil, nil)

var relationshipsGet* = Call_RelationshipsGet_564757(name: "relationshipsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships/{relationshipName}",
    validator: validate_RelationshipsGet_564758, base: "",
    url: url_RelationshipsGet_564759, schemes: {Scheme.Https})
type
  Call_RelationshipsDelete_564783 = ref object of OpenApiRestCall_563565
proc url_RelationshipsDelete_564785(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "relationshipName" in path,
        "`relationshipName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/relationships/"),
               (kind: VariableSegment, value: "relationshipName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RelationshipsDelete_564784(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a relationship within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipName: JString (required)
  ##                   : The name of the relationship.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564786 = path.getOrDefault("subscriptionId")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "subscriptionId", valid_564786
  var valid_564787 = path.getOrDefault("relationshipName")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "relationshipName", valid_564787
  var valid_564788 = path.getOrDefault("resourceGroupName")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "resourceGroupName", valid_564788
  var valid_564789 = path.getOrDefault("hubName")
  valid_564789 = validateParameter(valid_564789, JString, required = true,
                                 default = nil)
  if valid_564789 != nil:
    section.add "hubName", valid_564789
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564790 = query.getOrDefault("api-version")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "api-version", valid_564790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564791: Call_RelationshipsDelete_564783; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a relationship within a hub.
  ## 
  let valid = call_564791.validator(path, query, header, formData, body)
  let scheme = call_564791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564791.url(scheme.get, call_564791.host, call_564791.base,
                         call_564791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564791, url, valid)

proc call*(call_564792: Call_RelationshipsDelete_564783; apiVersion: string;
          subscriptionId: string; relationshipName: string;
          resourceGroupName: string; hubName: string): Recallable =
  ## relationshipsDelete
  ## Deletes a relationship within a hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipName: string (required)
  ##                   : The name of the relationship.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564793 = newJObject()
  var query_564794 = newJObject()
  add(query_564794, "api-version", newJString(apiVersion))
  add(path_564793, "subscriptionId", newJString(subscriptionId))
  add(path_564793, "relationshipName", newJString(relationshipName))
  add(path_564793, "resourceGroupName", newJString(resourceGroupName))
  add(path_564793, "hubName", newJString(hubName))
  result = call_564792.call(path_564793, query_564794, nil, nil, nil)

var relationshipsDelete* = Call_RelationshipsDelete_564783(
    name: "relationshipsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships/{relationshipName}",
    validator: validate_RelationshipsDelete_564784, base: "",
    url: url_RelationshipsDelete_564785, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListByHub_564795 = ref object of OpenApiRestCall_563565
proc url_RoleAssignmentsListByHub_564797(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/roleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsListByHub_564796(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the role assignments for the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564798 = path.getOrDefault("subscriptionId")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "subscriptionId", valid_564798
  var valid_564799 = path.getOrDefault("resourceGroupName")
  valid_564799 = validateParameter(valid_564799, JString, required = true,
                                 default = nil)
  if valid_564799 != nil:
    section.add "resourceGroupName", valid_564799
  var valid_564800 = path.getOrDefault("hubName")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "hubName", valid_564800
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564801 = query.getOrDefault("api-version")
  valid_564801 = validateParameter(valid_564801, JString, required = true,
                                 default = nil)
  if valid_564801 != nil:
    section.add "api-version", valid_564801
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564802: Call_RoleAssignmentsListByHub_564795; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the role assignments for the specified hub.
  ## 
  let valid = call_564802.validator(path, query, header, formData, body)
  let scheme = call_564802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564802.url(scheme.get, call_564802.host, call_564802.base,
                         call_564802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564802, url, valid)

proc call*(call_564803: Call_RoleAssignmentsListByHub_564795; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## roleAssignmentsListByHub
  ## Gets all the role assignments for the specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564804 = newJObject()
  var query_564805 = newJObject()
  add(query_564805, "api-version", newJString(apiVersion))
  add(path_564804, "subscriptionId", newJString(subscriptionId))
  add(path_564804, "resourceGroupName", newJString(resourceGroupName))
  add(path_564804, "hubName", newJString(hubName))
  result = call_564803.call(path_564804, query_564805, nil, nil, nil)

var roleAssignmentsListByHub* = Call_RoleAssignmentsListByHub_564795(
    name: "roleAssignmentsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments",
    validator: validate_RoleAssignmentsListByHub_564796, base: "",
    url: url_RoleAssignmentsListByHub_564797, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsCreateOrUpdate_564818 = ref object of OpenApiRestCall_563565
proc url_RoleAssignmentsCreateOrUpdate_564820(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/roleAssignments/"),
               (kind: VariableSegment, value: "assignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsCreateOrUpdate_564819(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a role assignment in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   assignmentName: JString (required)
  ##                 : The assignment name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564821 = path.getOrDefault("subscriptionId")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "subscriptionId", valid_564821
  var valid_564822 = path.getOrDefault("resourceGroupName")
  valid_564822 = validateParameter(valid_564822, JString, required = true,
                                 default = nil)
  if valid_564822 != nil:
    section.add "resourceGroupName", valid_564822
  var valid_564823 = path.getOrDefault("hubName")
  valid_564823 = validateParameter(valid_564823, JString, required = true,
                                 default = nil)
  if valid_564823 != nil:
    section.add "hubName", valid_564823
  var valid_564824 = path.getOrDefault("assignmentName")
  valid_564824 = validateParameter(valid_564824, JString, required = true,
                                 default = nil)
  if valid_564824 != nil:
    section.add "assignmentName", valid_564824
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564825 = query.getOrDefault("api-version")
  valid_564825 = validateParameter(valid_564825, JString, required = true,
                                 default = nil)
  if valid_564825 != nil:
    section.add "api-version", valid_564825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate RoleAssignment operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564827: Call_RoleAssignmentsCreateOrUpdate_564818; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a role assignment in the hub.
  ## 
  let valid = call_564827.validator(path, query, header, formData, body)
  let scheme = call_564827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564827.url(scheme.get, call_564827.host, call_564827.base,
                         call_564827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564827, url, valid)

proc call*(call_564828: Call_RoleAssignmentsCreateOrUpdate_564818;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string; assignmentName: string; parameters: JsonNode): Recallable =
  ## roleAssignmentsCreateOrUpdate
  ## Creates or updates a role assignment in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   assignmentName: string (required)
  ##                 : The assignment name
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate RoleAssignment operation.
  var path_564829 = newJObject()
  var query_564830 = newJObject()
  var body_564831 = newJObject()
  add(query_564830, "api-version", newJString(apiVersion))
  add(path_564829, "subscriptionId", newJString(subscriptionId))
  add(path_564829, "resourceGroupName", newJString(resourceGroupName))
  add(path_564829, "hubName", newJString(hubName))
  add(path_564829, "assignmentName", newJString(assignmentName))
  if parameters != nil:
    body_564831 = parameters
  result = call_564828.call(path_564829, query_564830, nil, nil, body_564831)

var roleAssignmentsCreateOrUpdate* = Call_RoleAssignmentsCreateOrUpdate_564818(
    name: "roleAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments/{assignmentName}",
    validator: validate_RoleAssignmentsCreateOrUpdate_564819, base: "",
    url: url_RoleAssignmentsCreateOrUpdate_564820, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsGet_564806 = ref object of OpenApiRestCall_563565
proc url_RoleAssignmentsGet_564808(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/roleAssignments/"),
               (kind: VariableSegment, value: "assignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsGet_564807(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the role assignment in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   assignmentName: JString (required)
  ##                 : The name of the role assignment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564809 = path.getOrDefault("subscriptionId")
  valid_564809 = validateParameter(valid_564809, JString, required = true,
                                 default = nil)
  if valid_564809 != nil:
    section.add "subscriptionId", valid_564809
  var valid_564810 = path.getOrDefault("resourceGroupName")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "resourceGroupName", valid_564810
  var valid_564811 = path.getOrDefault("hubName")
  valid_564811 = validateParameter(valid_564811, JString, required = true,
                                 default = nil)
  if valid_564811 != nil:
    section.add "hubName", valid_564811
  var valid_564812 = path.getOrDefault("assignmentName")
  valid_564812 = validateParameter(valid_564812, JString, required = true,
                                 default = nil)
  if valid_564812 != nil:
    section.add "assignmentName", valid_564812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564813 = query.getOrDefault("api-version")
  valid_564813 = validateParameter(valid_564813, JString, required = true,
                                 default = nil)
  if valid_564813 != nil:
    section.add "api-version", valid_564813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564814: Call_RoleAssignmentsGet_564806; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the role assignment in the hub.
  ## 
  let valid = call_564814.validator(path, query, header, formData, body)
  let scheme = call_564814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564814.url(scheme.get, call_564814.host, call_564814.base,
                         call_564814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564814, url, valid)

proc call*(call_564815: Call_RoleAssignmentsGet_564806; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          assignmentName: string): Recallable =
  ## roleAssignmentsGet
  ## Gets the role assignment in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   assignmentName: string (required)
  ##                 : The name of the role assignment.
  var path_564816 = newJObject()
  var query_564817 = newJObject()
  add(query_564817, "api-version", newJString(apiVersion))
  add(path_564816, "subscriptionId", newJString(subscriptionId))
  add(path_564816, "resourceGroupName", newJString(resourceGroupName))
  add(path_564816, "hubName", newJString(hubName))
  add(path_564816, "assignmentName", newJString(assignmentName))
  result = call_564815.call(path_564816, query_564817, nil, nil, nil)

var roleAssignmentsGet* = Call_RoleAssignmentsGet_564806(
    name: "roleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments/{assignmentName}",
    validator: validate_RoleAssignmentsGet_564807, base: "",
    url: url_RoleAssignmentsGet_564808, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsDelete_564832 = ref object of OpenApiRestCall_563565
proc url_RoleAssignmentsDelete_564834(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/roleAssignments/"),
               (kind: VariableSegment, value: "assignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsDelete_564833(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the role assignment in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   assignmentName: JString (required)
  ##                 : The name of the role assignment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564835 = path.getOrDefault("subscriptionId")
  valid_564835 = validateParameter(valid_564835, JString, required = true,
                                 default = nil)
  if valid_564835 != nil:
    section.add "subscriptionId", valid_564835
  var valid_564836 = path.getOrDefault("resourceGroupName")
  valid_564836 = validateParameter(valid_564836, JString, required = true,
                                 default = nil)
  if valid_564836 != nil:
    section.add "resourceGroupName", valid_564836
  var valid_564837 = path.getOrDefault("hubName")
  valid_564837 = validateParameter(valid_564837, JString, required = true,
                                 default = nil)
  if valid_564837 != nil:
    section.add "hubName", valid_564837
  var valid_564838 = path.getOrDefault("assignmentName")
  valid_564838 = validateParameter(valid_564838, JString, required = true,
                                 default = nil)
  if valid_564838 != nil:
    section.add "assignmentName", valid_564838
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564839 = query.getOrDefault("api-version")
  valid_564839 = validateParameter(valid_564839, JString, required = true,
                                 default = nil)
  if valid_564839 != nil:
    section.add "api-version", valid_564839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564840: Call_RoleAssignmentsDelete_564832; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the role assignment in the hub.
  ## 
  let valid = call_564840.validator(path, query, header, formData, body)
  let scheme = call_564840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564840.url(scheme.get, call_564840.host, call_564840.base,
                         call_564840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564840, url, valid)

proc call*(call_564841: Call_RoleAssignmentsDelete_564832; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          assignmentName: string): Recallable =
  ## roleAssignmentsDelete
  ## Deletes the role assignment in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   assignmentName: string (required)
  ##                 : The name of the role assignment.
  var path_564842 = newJObject()
  var query_564843 = newJObject()
  add(query_564843, "api-version", newJString(apiVersion))
  add(path_564842, "subscriptionId", newJString(subscriptionId))
  add(path_564842, "resourceGroupName", newJString(resourceGroupName))
  add(path_564842, "hubName", newJString(hubName))
  add(path_564842, "assignmentName", newJString(assignmentName))
  result = call_564841.call(path_564842, query_564843, nil, nil, nil)

var roleAssignmentsDelete* = Call_RoleAssignmentsDelete_564832(
    name: "roleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments/{assignmentName}",
    validator: validate_RoleAssignmentsDelete_564833, base: "",
    url: url_RoleAssignmentsDelete_564834, schemes: {Scheme.Https})
type
  Call_RolesListByHub_564844 = ref object of OpenApiRestCall_563565
proc url_RolesListByHub_564846(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RolesListByHub_564845(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all the roles for the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564847 = path.getOrDefault("subscriptionId")
  valid_564847 = validateParameter(valid_564847, JString, required = true,
                                 default = nil)
  if valid_564847 != nil:
    section.add "subscriptionId", valid_564847
  var valid_564848 = path.getOrDefault("resourceGroupName")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "resourceGroupName", valid_564848
  var valid_564849 = path.getOrDefault("hubName")
  valid_564849 = validateParameter(valid_564849, JString, required = true,
                                 default = nil)
  if valid_564849 != nil:
    section.add "hubName", valid_564849
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564850 = query.getOrDefault("api-version")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "api-version", valid_564850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564851: Call_RolesListByHub_564844; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the roles for the hub.
  ## 
  let valid = call_564851.validator(path, query, header, formData, body)
  let scheme = call_564851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564851.url(scheme.get, call_564851.host, call_564851.base,
                         call_564851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564851, url, valid)

proc call*(call_564852: Call_RolesListByHub_564844; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## rolesListByHub
  ## Gets all the roles for the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564853 = newJObject()
  var query_564854 = newJObject()
  add(query_564854, "api-version", newJString(apiVersion))
  add(path_564853, "subscriptionId", newJString(subscriptionId))
  add(path_564853, "resourceGroupName", newJString(resourceGroupName))
  add(path_564853, "hubName", newJString(hubName))
  result = call_564852.call(path_564853, query_564854, nil, nil, nil)

var rolesListByHub* = Call_RolesListByHub_564844(name: "rolesListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roles",
    validator: validate_RolesListByHub_564845, base: "", url: url_RolesListByHub_564846,
    schemes: {Scheme.Https})
type
  Call_ViewsListByHub_564855 = ref object of OpenApiRestCall_563565
proc url_ViewsListByHub_564857(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/views")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsListByHub_564856(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all available views for given user in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564858 = path.getOrDefault("subscriptionId")
  valid_564858 = validateParameter(valid_564858, JString, required = true,
                                 default = nil)
  if valid_564858 != nil:
    section.add "subscriptionId", valid_564858
  var valid_564859 = path.getOrDefault("resourceGroupName")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "resourceGroupName", valid_564859
  var valid_564860 = path.getOrDefault("hubName")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "hubName", valid_564860
  result.add "path", section
  ## parameters in `query` object:
  ##   userId: JString (required)
  ##         : The user ID. Use * to retrieve hub level views.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `userId` field"
  var valid_564861 = query.getOrDefault("userId")
  valid_564861 = validateParameter(valid_564861, JString, required = true,
                                 default = nil)
  if valid_564861 != nil:
    section.add "userId", valid_564861
  var valid_564862 = query.getOrDefault("api-version")
  valid_564862 = validateParameter(valid_564862, JString, required = true,
                                 default = nil)
  if valid_564862 != nil:
    section.add "api-version", valid_564862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564863: Call_ViewsListByHub_564855; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available views for given user in the specified hub.
  ## 
  let valid = call_564863.validator(path, query, header, formData, body)
  let scheme = call_564863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564863.url(scheme.get, call_564863.host, call_564863.base,
                         call_564863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564863, url, valid)

proc call*(call_564864: Call_ViewsListByHub_564855; userId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## viewsListByHub
  ## Gets all available views for given user in the specified hub.
  ##   userId: string (required)
  ##         : The user ID. Use * to retrieve hub level views.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564865 = newJObject()
  var query_564866 = newJObject()
  add(query_564866, "userId", newJString(userId))
  add(query_564866, "api-version", newJString(apiVersion))
  add(path_564865, "subscriptionId", newJString(subscriptionId))
  add(path_564865, "resourceGroupName", newJString(resourceGroupName))
  add(path_564865, "hubName", newJString(hubName))
  result = call_564864.call(path_564865, query_564866, nil, nil, nil)

var viewsListByHub* = Call_ViewsListByHub_564855(name: "viewsListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views",
    validator: validate_ViewsListByHub_564856, base: "", url: url_ViewsListByHub_564857,
    schemes: {Scheme.Https})
type
  Call_ViewsCreateOrUpdate_564880 = ref object of OpenApiRestCall_563565
proc url_ViewsCreateOrUpdate_564882(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsCreateOrUpdate_564881(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a view or updates an existing view in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   viewName: JString (required)
  ##           : The name of the view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564883 = path.getOrDefault("subscriptionId")
  valid_564883 = validateParameter(valid_564883, JString, required = true,
                                 default = nil)
  if valid_564883 != nil:
    section.add "subscriptionId", valid_564883
  var valid_564884 = path.getOrDefault("resourceGroupName")
  valid_564884 = validateParameter(valid_564884, JString, required = true,
                                 default = nil)
  if valid_564884 != nil:
    section.add "resourceGroupName", valid_564884
  var valid_564885 = path.getOrDefault("hubName")
  valid_564885 = validateParameter(valid_564885, JString, required = true,
                                 default = nil)
  if valid_564885 != nil:
    section.add "hubName", valid_564885
  var valid_564886 = path.getOrDefault("viewName")
  valid_564886 = validateParameter(valid_564886, JString, required = true,
                                 default = nil)
  if valid_564886 != nil:
    section.add "viewName", valid_564886
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564887 = query.getOrDefault("api-version")
  valid_564887 = validateParameter(valid_564887, JString, required = true,
                                 default = nil)
  if valid_564887 != nil:
    section.add "api-version", valid_564887
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate View operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564889: Call_ViewsCreateOrUpdate_564880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a view or updates an existing view in the hub.
  ## 
  let valid = call_564889.validator(path, query, header, formData, body)
  let scheme = call_564889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564889.url(scheme.get, call_564889.host, call_564889.base,
                         call_564889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564889, url, valid)

proc call*(call_564890: Call_ViewsCreateOrUpdate_564880; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          viewName: string; parameters: JsonNode): Recallable =
  ## viewsCreateOrUpdate
  ## Creates a view or updates an existing view in the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   viewName: string (required)
  ##           : The name of the view.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate View operation.
  var path_564891 = newJObject()
  var query_564892 = newJObject()
  var body_564893 = newJObject()
  add(query_564892, "api-version", newJString(apiVersion))
  add(path_564891, "subscriptionId", newJString(subscriptionId))
  add(path_564891, "resourceGroupName", newJString(resourceGroupName))
  add(path_564891, "hubName", newJString(hubName))
  add(path_564891, "viewName", newJString(viewName))
  if parameters != nil:
    body_564893 = parameters
  result = call_564890.call(path_564891, query_564892, nil, nil, body_564893)

var viewsCreateOrUpdate* = Call_ViewsCreateOrUpdate_564880(
    name: "viewsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views/{viewName}",
    validator: validate_ViewsCreateOrUpdate_564881, base: "",
    url: url_ViewsCreateOrUpdate_564882, schemes: {Scheme.Https})
type
  Call_ViewsGet_564867 = ref object of OpenApiRestCall_563565
proc url_ViewsGet_564869(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsGet_564868(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a view in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   viewName: JString (required)
  ##           : The name of the view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564870 = path.getOrDefault("subscriptionId")
  valid_564870 = validateParameter(valid_564870, JString, required = true,
                                 default = nil)
  if valid_564870 != nil:
    section.add "subscriptionId", valid_564870
  var valid_564871 = path.getOrDefault("resourceGroupName")
  valid_564871 = validateParameter(valid_564871, JString, required = true,
                                 default = nil)
  if valid_564871 != nil:
    section.add "resourceGroupName", valid_564871
  var valid_564872 = path.getOrDefault("hubName")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "hubName", valid_564872
  var valid_564873 = path.getOrDefault("viewName")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "viewName", valid_564873
  result.add "path", section
  ## parameters in `query` object:
  ##   userId: JString (required)
  ##         : The user ID. Use * to retrieve hub level view.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `userId` field"
  var valid_564874 = query.getOrDefault("userId")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = nil)
  if valid_564874 != nil:
    section.add "userId", valid_564874
  var valid_564875 = query.getOrDefault("api-version")
  valid_564875 = validateParameter(valid_564875, JString, required = true,
                                 default = nil)
  if valid_564875 != nil:
    section.add "api-version", valid_564875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564876: Call_ViewsGet_564867; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a view in the hub.
  ## 
  let valid = call_564876.validator(path, query, header, formData, body)
  let scheme = call_564876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564876.url(scheme.get, call_564876.host, call_564876.base,
                         call_564876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564876, url, valid)

proc call*(call_564877: Call_ViewsGet_564867; userId: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          viewName: string): Recallable =
  ## viewsGet
  ## Gets a view in the hub.
  ##   userId: string (required)
  ##         : The user ID. Use * to retrieve hub level view.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   viewName: string (required)
  ##           : The name of the view.
  var path_564878 = newJObject()
  var query_564879 = newJObject()
  add(query_564879, "userId", newJString(userId))
  add(query_564879, "api-version", newJString(apiVersion))
  add(path_564878, "subscriptionId", newJString(subscriptionId))
  add(path_564878, "resourceGroupName", newJString(resourceGroupName))
  add(path_564878, "hubName", newJString(hubName))
  add(path_564878, "viewName", newJString(viewName))
  result = call_564877.call(path_564878, query_564879, nil, nil, nil)

var viewsGet* = Call_ViewsGet_564867(name: "viewsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views/{viewName}",
                                  validator: validate_ViewsGet_564868, base: "",
                                  url: url_ViewsGet_564869,
                                  schemes: {Scheme.Https})
type
  Call_ViewsDelete_564894 = ref object of OpenApiRestCall_563565
proc url_ViewsDelete_564896(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "viewName" in path, "`viewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/views/"),
               (kind: VariableSegment, value: "viewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ViewsDelete_564895(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a view in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   viewName: JString (required)
  ##           : The name of the view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564897 = path.getOrDefault("subscriptionId")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "subscriptionId", valid_564897
  var valid_564898 = path.getOrDefault("resourceGroupName")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = nil)
  if valid_564898 != nil:
    section.add "resourceGroupName", valid_564898
  var valid_564899 = path.getOrDefault("hubName")
  valid_564899 = validateParameter(valid_564899, JString, required = true,
                                 default = nil)
  if valid_564899 != nil:
    section.add "hubName", valid_564899
  var valid_564900 = path.getOrDefault("viewName")
  valid_564900 = validateParameter(valid_564900, JString, required = true,
                                 default = nil)
  if valid_564900 != nil:
    section.add "viewName", valid_564900
  result.add "path", section
  ## parameters in `query` object:
  ##   userId: JString (required)
  ##         : The user ID. Use * to retrieve hub level view.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `userId` field"
  var valid_564901 = query.getOrDefault("userId")
  valid_564901 = validateParameter(valid_564901, JString, required = true,
                                 default = nil)
  if valid_564901 != nil:
    section.add "userId", valid_564901
  var valid_564902 = query.getOrDefault("api-version")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = nil)
  if valid_564902 != nil:
    section.add "api-version", valid_564902
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564903: Call_ViewsDelete_564894; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a view in the specified hub.
  ## 
  let valid = call_564903.validator(path, query, header, formData, body)
  let scheme = call_564903.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564903.url(scheme.get, call_564903.host, call_564903.base,
                         call_564903.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564903, url, valid)

proc call*(call_564904: Call_ViewsDelete_564894; userId: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string;
          viewName: string): Recallable =
  ## viewsDelete
  ## Deletes a view in the specified hub.
  ##   userId: string (required)
  ##         : The user ID. Use * to retrieve hub level view.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   viewName: string (required)
  ##           : The name of the view.
  var path_564905 = newJObject()
  var query_564906 = newJObject()
  add(query_564906, "userId", newJString(userId))
  add(query_564906, "api-version", newJString(apiVersion))
  add(path_564905, "subscriptionId", newJString(subscriptionId))
  add(path_564905, "resourceGroupName", newJString(resourceGroupName))
  add(path_564905, "hubName", newJString(hubName))
  add(path_564905, "viewName", newJString(viewName))
  result = call_564904.call(path_564905, query_564906, nil, nil, nil)

var viewsDelete* = Call_ViewsDelete_564894(name: "viewsDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views/{viewName}",
                                        validator: validate_ViewsDelete_564895,
                                        base: "", url: url_ViewsDelete_564896,
                                        schemes: {Scheme.Https})
type
  Call_WidgetTypesListByHub_564907 = ref object of OpenApiRestCall_563565
proc url_WidgetTypesListByHub_564909(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/widgetTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WidgetTypesListByHub_564908(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all available widget types in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564910 = path.getOrDefault("subscriptionId")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "subscriptionId", valid_564910
  var valid_564911 = path.getOrDefault("resourceGroupName")
  valid_564911 = validateParameter(valid_564911, JString, required = true,
                                 default = nil)
  if valid_564911 != nil:
    section.add "resourceGroupName", valid_564911
  var valid_564912 = path.getOrDefault("hubName")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "hubName", valid_564912
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564913 = query.getOrDefault("api-version")
  valid_564913 = validateParameter(valid_564913, JString, required = true,
                                 default = nil)
  if valid_564913 != nil:
    section.add "api-version", valid_564913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564914: Call_WidgetTypesListByHub_564907; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available widget types in the specified hub.
  ## 
  let valid = call_564914.validator(path, query, header, formData, body)
  let scheme = call_564914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564914.url(scheme.get, call_564914.host, call_564914.base,
                         call_564914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564914, url, valid)

proc call*(call_564915: Call_WidgetTypesListByHub_564907; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; hubName: string): Recallable =
  ## widgetTypesListByHub
  ## Gets all available widget types in the specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564916 = newJObject()
  var query_564917 = newJObject()
  add(query_564917, "api-version", newJString(apiVersion))
  add(path_564916, "subscriptionId", newJString(subscriptionId))
  add(path_564916, "resourceGroupName", newJString(resourceGroupName))
  add(path_564916, "hubName", newJString(hubName))
  result = call_564915.call(path_564916, query_564917, nil, nil, nil)

var widgetTypesListByHub* = Call_WidgetTypesListByHub_564907(
    name: "widgetTypesListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/widgetTypes",
    validator: validate_WidgetTypesListByHub_564908, base: "",
    url: url_WidgetTypesListByHub_564909, schemes: {Scheme.Https})
type
  Call_WidgetTypesGet_564918 = ref object of OpenApiRestCall_563565
proc url_WidgetTypesGet_564920(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hubName" in path, "`hubName` is a required path parameter"
  assert "widgetTypeName" in path, "`widgetTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomerInsights/hubs/"),
               (kind: VariableSegment, value: "hubName"),
               (kind: ConstantSegment, value: "/widgetTypes/"),
               (kind: VariableSegment, value: "widgetTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WidgetTypesGet_564919(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a widget type in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   widgetTypeName: JString (required)
  ##                 : The name of the widget type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564921 = path.getOrDefault("subscriptionId")
  valid_564921 = validateParameter(valid_564921, JString, required = true,
                                 default = nil)
  if valid_564921 != nil:
    section.add "subscriptionId", valid_564921
  var valid_564922 = path.getOrDefault("widgetTypeName")
  valid_564922 = validateParameter(valid_564922, JString, required = true,
                                 default = nil)
  if valid_564922 != nil:
    section.add "widgetTypeName", valid_564922
  var valid_564923 = path.getOrDefault("resourceGroupName")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "resourceGroupName", valid_564923
  var valid_564924 = path.getOrDefault("hubName")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "hubName", valid_564924
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564925 = query.getOrDefault("api-version")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "api-version", valid_564925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564926: Call_WidgetTypesGet_564918; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a widget type in the specified hub.
  ## 
  let valid = call_564926.validator(path, query, header, formData, body)
  let scheme = call_564926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564926.url(scheme.get, call_564926.host, call_564926.base,
                         call_564926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564926, url, valid)

proc call*(call_564927: Call_WidgetTypesGet_564918; apiVersion: string;
          subscriptionId: string; widgetTypeName: string; resourceGroupName: string;
          hubName: string): Recallable =
  ## widgetTypesGet
  ## Gets a widget type in the specified hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   widgetTypeName: string (required)
  ##                 : The name of the widget type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  var path_564928 = newJObject()
  var query_564929 = newJObject()
  add(query_564929, "api-version", newJString(apiVersion))
  add(path_564928, "subscriptionId", newJString(subscriptionId))
  add(path_564928, "widgetTypeName", newJString(widgetTypeName))
  add(path_564928, "resourceGroupName", newJString(resourceGroupName))
  add(path_564928, "hubName", newJString(hubName))
  result = call_564927.call(path_564928, query_564929, nil, nil, nil)

var widgetTypesGet* = Call_WidgetTypesGet_564918(name: "widgetTypesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/widgetTypes/{widgetTypeName}",
    validator: validate_WidgetTypesGet_564919, base: "", url: url_WidgetTypesGet_564920,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
