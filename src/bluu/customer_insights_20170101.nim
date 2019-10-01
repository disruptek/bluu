
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CustomerInsightsManagementClient
## version: 2017-01-01
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "customer-insights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
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
  var valid_568050 = query.getOrDefault("api-version")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "api-version", valid_568050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Customer Insights REST API operations.
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_OperationsList_567889; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Customer Insights REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  result = call_568144.call(nil, query_568145, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CustomerInsights/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
    schemes: {Scheme.Https})
type
  Call_HubsList_568185 = ref object of OpenApiRestCall_567667
proc url_HubsList_568187(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_HubsList_568186(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_HubsList_568185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all hubs in the specified subscription.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_HubsList_568185; apiVersion: string;
          subscriptionId: string): Recallable =
  ## hubsList
  ## Gets all hubs in the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var hubsList* = Call_HubsList_568185(name: "hubsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CustomerInsights/hubs",
                                  validator: validate_HubsList_568186, base: "",
                                  url: url_HubsList_568187,
                                  schemes: {Scheme.Https})
type
  Call_HubsListByResourceGroup_568208 = ref object of OpenApiRestCall_567667
proc url_HubsListByResourceGroup_568210(protocol: Scheme; host: string; base: string;
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

proc validate_HubsListByResourceGroup_568209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the hubs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568211 = path.getOrDefault("resourceGroupName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceGroupName", valid_568211
  var valid_568212 = path.getOrDefault("subscriptionId")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "subscriptionId", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_HubsListByResourceGroup_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the hubs in a resource group.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_HubsListByResourceGroup_568208;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## hubsListByResourceGroup
  ## Gets all the hubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(path_568216, "resourceGroupName", newJString(resourceGroupName))
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "subscriptionId", newJString(subscriptionId))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var hubsListByResourceGroup* = Call_HubsListByResourceGroup_568208(
    name: "hubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs",
    validator: validate_HubsListByResourceGroup_568209, base: "",
    url: url_HubsListByResourceGroup_568210, schemes: {Scheme.Https})
type
  Call_HubsCreateOrUpdate_568229 = ref object of OpenApiRestCall_567667
proc url_HubsCreateOrUpdate_568231(protocol: Scheme; host: string; base: string;
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

proc validate_HubsCreateOrUpdate_568230(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a hub, or updates an existing hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the Hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568249 = path.getOrDefault("resourceGroupName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "resourceGroupName", valid_568249
  var valid_568250 = path.getOrDefault("hubName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "hubName", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
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

proc call*(call_568254: Call_HubsCreateOrUpdate_568229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a hub, or updates an existing hub.
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_HubsCreateOrUpdate_568229; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## hubsCreateOrUpdate
  ## Creates a hub, or updates an existing hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the Hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Hub operation.
  var path_568256 = newJObject()
  var query_568257 = newJObject()
  var body_568258 = newJObject()
  add(path_568256, "resourceGroupName", newJString(resourceGroupName))
  add(path_568256, "hubName", newJString(hubName))
  add(query_568257, "api-version", newJString(apiVersion))
  add(path_568256, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568258 = parameters
  result = call_568255.call(path_568256, query_568257, nil, nil, body_568258)

var hubsCreateOrUpdate* = Call_HubsCreateOrUpdate_568229(
    name: "hubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
    validator: validate_HubsCreateOrUpdate_568230, base: "",
    url: url_HubsCreateOrUpdate_568231, schemes: {Scheme.Https})
type
  Call_HubsGet_568218 = ref object of OpenApiRestCall_567667
proc url_HubsGet_568220(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_HubsGet_568219(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568221 = path.getOrDefault("resourceGroupName")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "resourceGroupName", valid_568221
  var valid_568222 = path.getOrDefault("hubName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "hubName", valid_568222
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568224 = query.getOrDefault("api-version")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "api-version", valid_568224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568225: Call_HubsGet_568218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified hub.
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_HubsGet_568218; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## hubsGet
  ## Gets information about the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  add(path_568227, "resourceGroupName", newJString(resourceGroupName))
  add(path_568227, "hubName", newJString(hubName))
  add(query_568228, "api-version", newJString(apiVersion))
  add(path_568227, "subscriptionId", newJString(subscriptionId))
  result = call_568226.call(path_568227, query_568228, nil, nil, nil)

var hubsGet* = Call_HubsGet_568218(name: "hubsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
                                validator: validate_HubsGet_568219, base: "",
                                url: url_HubsGet_568220, schemes: {Scheme.Https})
type
  Call_HubsUpdate_568270 = ref object of OpenApiRestCall_567667
proc url_HubsUpdate_568272(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_HubsUpdate_568271(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the Hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568273 = path.getOrDefault("resourceGroupName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "resourceGroupName", valid_568273
  var valid_568274 = path.getOrDefault("hubName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "hubName", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
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

proc call*(call_568278: Call_HubsUpdate_568270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Hub.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_HubsUpdate_568270; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## hubsUpdate
  ## Updates a Hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the Hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Hub operation.
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  var body_568282 = newJObject()
  add(path_568280, "resourceGroupName", newJString(resourceGroupName))
  add(path_568280, "hubName", newJString(hubName))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568282 = parameters
  result = call_568279.call(path_568280, query_568281, nil, nil, body_568282)

var hubsUpdate* = Call_HubsUpdate_568270(name: "hubsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
                                      validator: validate_HubsUpdate_568271,
                                      base: "", url: url_HubsUpdate_568272,
                                      schemes: {Scheme.Https})
type
  Call_HubsDelete_568259 = ref object of OpenApiRestCall_567667
proc url_HubsDelete_568261(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_HubsDelete_568260(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("hubName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "hubName", valid_568263
  var valid_568264 = path.getOrDefault("subscriptionId")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "subscriptionId", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_HubsDelete_568259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified hub.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_HubsDelete_568259; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## hubsDelete
  ## Deletes the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(path_568268, "resourceGroupName", newJString(resourceGroupName))
  add(path_568268, "hubName", newJString(hubName))
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var hubsDelete* = Call_HubsDelete_568259(name: "hubsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
                                      validator: validate_HubsDelete_568260,
                                      base: "", url: url_HubsDelete_568261,
                                      schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesListByHub_568283 = ref object of OpenApiRestCall_567667
proc url_AuthorizationPoliciesListByHub_568285(protocol: Scheme; host: string;
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

proc validate_AuthorizationPoliciesListByHub_568284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the authorization policies in a specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568286 = path.getOrDefault("resourceGroupName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "resourceGroupName", valid_568286
  var valid_568287 = path.getOrDefault("hubName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "hubName", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568290: Call_AuthorizationPoliciesListByHub_568283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the authorization policies in a specified hub.
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_AuthorizationPoliciesListByHub_568283;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## authorizationPoliciesListByHub
  ## Gets all the authorization policies in a specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  add(path_568292, "resourceGroupName", newJString(resourceGroupName))
  add(path_568292, "hubName", newJString(hubName))
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "subscriptionId", newJString(subscriptionId))
  result = call_568291.call(path_568292, query_568293, nil, nil, nil)

var authorizationPoliciesListByHub* = Call_AuthorizationPoliciesListByHub_568283(
    name: "authorizationPoliciesListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies",
    validator: validate_AuthorizationPoliciesListByHub_568284, base: "",
    url: url_AuthorizationPoliciesListByHub_568285, schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesCreateOrUpdate_568306 = ref object of OpenApiRestCall_567667
proc url_AuthorizationPoliciesCreateOrUpdate_568308(protocol: Scheme; host: string;
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

proc validate_AuthorizationPoliciesCreateOrUpdate_568307(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an authorization policy or updates an existing authorization policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationPolicyName: JString (required)
  ##                          : The name of the policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568309 = path.getOrDefault("resourceGroupName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "resourceGroupName", valid_568309
  var valid_568310 = path.getOrDefault("hubName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "hubName", valid_568310
  var valid_568311 = path.getOrDefault("subscriptionId")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "subscriptionId", valid_568311
  var valid_568312 = path.getOrDefault("authorizationPolicyName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "authorizationPolicyName", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
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

proc call*(call_568315: Call_AuthorizationPoliciesCreateOrUpdate_568306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization policy or updates an existing authorization policy.
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_AuthorizationPoliciesCreateOrUpdate_568306;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode;
          authorizationPolicyName: string): Recallable =
  ## authorizationPoliciesCreateOrUpdate
  ## Creates an authorization policy or updates an existing authorization policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate authorization policy operation.
  ##   authorizationPolicyName: string (required)
  ##                          : The name of the policy.
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  var body_568319 = newJObject()
  add(path_568317, "resourceGroupName", newJString(resourceGroupName))
  add(path_568317, "hubName", newJString(hubName))
  add(query_568318, "api-version", newJString(apiVersion))
  add(path_568317, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568319 = parameters
  add(path_568317, "authorizationPolicyName", newJString(authorizationPolicyName))
  result = call_568316.call(path_568317, query_568318, nil, nil, body_568319)

var authorizationPoliciesCreateOrUpdate* = Call_AuthorizationPoliciesCreateOrUpdate_568306(
    name: "authorizationPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}",
    validator: validate_AuthorizationPoliciesCreateOrUpdate_568307, base: "",
    url: url_AuthorizationPoliciesCreateOrUpdate_568308, schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesGet_568294 = ref object of OpenApiRestCall_567667
proc url_AuthorizationPoliciesGet_568296(protocol: Scheme; host: string;
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

proc validate_AuthorizationPoliciesGet_568295(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization policy in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationPolicyName: JString (required)
  ##                          : The name of the policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568297 = path.getOrDefault("resourceGroupName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "resourceGroupName", valid_568297
  var valid_568298 = path.getOrDefault("hubName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "hubName", valid_568298
  var valid_568299 = path.getOrDefault("subscriptionId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "subscriptionId", valid_568299
  var valid_568300 = path.getOrDefault("authorizationPolicyName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "authorizationPolicyName", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_AuthorizationPoliciesGet_568294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization policy in the hub.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_AuthorizationPoliciesGet_568294;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; authorizationPolicyName: string): Recallable =
  ## authorizationPoliciesGet
  ## Gets an authorization policy in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationPolicyName: string (required)
  ##                          : The name of the policy.
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(path_568304, "hubName", newJString(hubName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  add(path_568304, "authorizationPolicyName", newJString(authorizationPolicyName))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var authorizationPoliciesGet* = Call_AuthorizationPoliciesGet_568294(
    name: "authorizationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}",
    validator: validate_AuthorizationPoliciesGet_568295, base: "",
    url: url_AuthorizationPoliciesGet_568296, schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesRegeneratePrimaryKey_568320 = ref object of OpenApiRestCall_567667
proc url_AuthorizationPoliciesRegeneratePrimaryKey_568322(protocol: Scheme;
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

proc validate_AuthorizationPoliciesRegeneratePrimaryKey_568321(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary policy key of the specified authorization policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationPolicyName: JString (required)
  ##                          : The name of the policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568323 = path.getOrDefault("resourceGroupName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "resourceGroupName", valid_568323
  var valid_568324 = path.getOrDefault("hubName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "hubName", valid_568324
  var valid_568325 = path.getOrDefault("subscriptionId")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "subscriptionId", valid_568325
  var valid_568326 = path.getOrDefault("authorizationPolicyName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "authorizationPolicyName", valid_568326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568327 = query.getOrDefault("api-version")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "api-version", valid_568327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568328: Call_AuthorizationPoliciesRegeneratePrimaryKey_568320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the primary policy key of the specified authorization policy.
  ## 
  let valid = call_568328.validator(path, query, header, formData, body)
  let scheme = call_568328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568328.url(scheme.get, call_568328.host, call_568328.base,
                         call_568328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568328, url, valid)

proc call*(call_568329: Call_AuthorizationPoliciesRegeneratePrimaryKey_568320;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; authorizationPolicyName: string): Recallable =
  ## authorizationPoliciesRegeneratePrimaryKey
  ## Regenerates the primary policy key of the specified authorization policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationPolicyName: string (required)
  ##                          : The name of the policy.
  var path_568330 = newJObject()
  var query_568331 = newJObject()
  add(path_568330, "resourceGroupName", newJString(resourceGroupName))
  add(path_568330, "hubName", newJString(hubName))
  add(query_568331, "api-version", newJString(apiVersion))
  add(path_568330, "subscriptionId", newJString(subscriptionId))
  add(path_568330, "authorizationPolicyName", newJString(authorizationPolicyName))
  result = call_568329.call(path_568330, query_568331, nil, nil, nil)

var authorizationPoliciesRegeneratePrimaryKey* = Call_AuthorizationPoliciesRegeneratePrimaryKey_568320(
    name: "authorizationPoliciesRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}/regeneratePrimaryKey",
    validator: validate_AuthorizationPoliciesRegeneratePrimaryKey_568321,
    base: "", url: url_AuthorizationPoliciesRegeneratePrimaryKey_568322,
    schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesRegenerateSecondaryKey_568332 = ref object of OpenApiRestCall_567667
proc url_AuthorizationPoliciesRegenerateSecondaryKey_568334(protocol: Scheme;
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

proc validate_AuthorizationPoliciesRegenerateSecondaryKey_568333(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the secondary policy key of the specified authorization policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationPolicyName: JString (required)
  ##                          : The name of the policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568335 = path.getOrDefault("resourceGroupName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "resourceGroupName", valid_568335
  var valid_568336 = path.getOrDefault("hubName")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "hubName", valid_568336
  var valid_568337 = path.getOrDefault("subscriptionId")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "subscriptionId", valid_568337
  var valid_568338 = path.getOrDefault("authorizationPolicyName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "authorizationPolicyName", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "api-version", valid_568339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568340: Call_AuthorizationPoliciesRegenerateSecondaryKey_568332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the secondary policy key of the specified authorization policy.
  ## 
  let valid = call_568340.validator(path, query, header, formData, body)
  let scheme = call_568340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568340.url(scheme.get, call_568340.host, call_568340.base,
                         call_568340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568340, url, valid)

proc call*(call_568341: Call_AuthorizationPoliciesRegenerateSecondaryKey_568332;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; authorizationPolicyName: string): Recallable =
  ## authorizationPoliciesRegenerateSecondaryKey
  ## Regenerates the secondary policy key of the specified authorization policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   authorizationPolicyName: string (required)
  ##                          : The name of the policy.
  var path_568342 = newJObject()
  var query_568343 = newJObject()
  add(path_568342, "resourceGroupName", newJString(resourceGroupName))
  add(path_568342, "hubName", newJString(hubName))
  add(query_568343, "api-version", newJString(apiVersion))
  add(path_568342, "subscriptionId", newJString(subscriptionId))
  add(path_568342, "authorizationPolicyName", newJString(authorizationPolicyName))
  result = call_568341.call(path_568342, query_568343, nil, nil, nil)

var authorizationPoliciesRegenerateSecondaryKey* = Call_AuthorizationPoliciesRegenerateSecondaryKey_568332(
    name: "authorizationPoliciesRegenerateSecondaryKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}/regenerateSecondaryKey",
    validator: validate_AuthorizationPoliciesRegenerateSecondaryKey_568333,
    base: "", url: url_AuthorizationPoliciesRegenerateSecondaryKey_568334,
    schemes: {Scheme.Https})
type
  Call_ConnectorsListByHub_568344 = ref object of OpenApiRestCall_567667
proc url_ConnectorsListByHub_568346(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorsListByHub_568345(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all the connectors in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568347 = path.getOrDefault("resourceGroupName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "resourceGroupName", valid_568347
  var valid_568348 = path.getOrDefault("hubName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "hubName", valid_568348
  var valid_568349 = path.getOrDefault("subscriptionId")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "subscriptionId", valid_568349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568350 = query.getOrDefault("api-version")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "api-version", valid_568350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568351: Call_ConnectorsListByHub_568344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the connectors in the specified hub.
  ## 
  let valid = call_568351.validator(path, query, header, formData, body)
  let scheme = call_568351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568351.url(scheme.get, call_568351.host, call_568351.base,
                         call_568351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568351, url, valid)

proc call*(call_568352: Call_ConnectorsListByHub_568344; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## connectorsListByHub
  ## Gets all the connectors in the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568353 = newJObject()
  var query_568354 = newJObject()
  add(path_568353, "resourceGroupName", newJString(resourceGroupName))
  add(path_568353, "hubName", newJString(hubName))
  add(query_568354, "api-version", newJString(apiVersion))
  add(path_568353, "subscriptionId", newJString(subscriptionId))
  result = call_568352.call(path_568353, query_568354, nil, nil, nil)

var connectorsListByHub* = Call_ConnectorsListByHub_568344(
    name: "connectorsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors",
    validator: validate_ConnectorsListByHub_568345, base: "",
    url: url_ConnectorsListByHub_568346, schemes: {Scheme.Https})
type
  Call_ConnectorsCreateOrUpdate_568367 = ref object of OpenApiRestCall_567667
proc url_ConnectorsCreateOrUpdate_568369(protocol: Scheme; host: string;
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

proc validate_ConnectorsCreateOrUpdate_568368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a connector or updates an existing connector in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568370 = path.getOrDefault("resourceGroupName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "resourceGroupName", valid_568370
  var valid_568371 = path.getOrDefault("hubName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "hubName", valid_568371
  var valid_568372 = path.getOrDefault("subscriptionId")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "subscriptionId", valid_568372
  var valid_568373 = path.getOrDefault("connectorName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "connectorName", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "api-version", valid_568374
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

proc call*(call_568376: Call_ConnectorsCreateOrUpdate_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a connector or updates an existing connector in the hub.
  ## 
  let valid = call_568376.validator(path, query, header, formData, body)
  let scheme = call_568376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568376.url(scheme.get, call_568376.host, call_568376.base,
                         call_568376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568376, url, valid)

proc call*(call_568377: Call_ConnectorsCreateOrUpdate_568367;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; connectorName: string; parameters: JsonNode): Recallable =
  ## connectorsCreateOrUpdate
  ## Creates a connector or updates an existing connector in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Connector operation.
  var path_568378 = newJObject()
  var query_568379 = newJObject()
  var body_568380 = newJObject()
  add(path_568378, "resourceGroupName", newJString(resourceGroupName))
  add(path_568378, "hubName", newJString(hubName))
  add(query_568379, "api-version", newJString(apiVersion))
  add(path_568378, "subscriptionId", newJString(subscriptionId))
  add(path_568378, "connectorName", newJString(connectorName))
  if parameters != nil:
    body_568380 = parameters
  result = call_568377.call(path_568378, query_568379, nil, nil, body_568380)

var connectorsCreateOrUpdate* = Call_ConnectorsCreateOrUpdate_568367(
    name: "connectorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}",
    validator: validate_ConnectorsCreateOrUpdate_568368, base: "",
    url: url_ConnectorsCreateOrUpdate_568369, schemes: {Scheme.Https})
type
  Call_ConnectorsGet_568355 = ref object of OpenApiRestCall_567667
proc url_ConnectorsGet_568357(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorsGet_568356(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a connector in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568358 = path.getOrDefault("resourceGroupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceGroupName", valid_568358
  var valid_568359 = path.getOrDefault("hubName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "hubName", valid_568359
  var valid_568360 = path.getOrDefault("subscriptionId")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "subscriptionId", valid_568360
  var valid_568361 = path.getOrDefault("connectorName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "connectorName", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568363: Call_ConnectorsGet_568355; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connector in the hub.
  ## 
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_ConnectorsGet_568355; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          connectorName: string): Recallable =
  ## connectorsGet
  ## Gets a connector in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  add(path_568365, "resourceGroupName", newJString(resourceGroupName))
  add(path_568365, "hubName", newJString(hubName))
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "subscriptionId", newJString(subscriptionId))
  add(path_568365, "connectorName", newJString(connectorName))
  result = call_568364.call(path_568365, query_568366, nil, nil, nil)

var connectorsGet* = Call_ConnectorsGet_568355(name: "connectorsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}",
    validator: validate_ConnectorsGet_568356, base: "", url: url_ConnectorsGet_568357,
    schemes: {Scheme.Https})
type
  Call_ConnectorsDelete_568381 = ref object of OpenApiRestCall_567667
proc url_ConnectorsDelete_568383(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorsDelete_568382(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a connector in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568384 = path.getOrDefault("resourceGroupName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "resourceGroupName", valid_568384
  var valid_568385 = path.getOrDefault("hubName")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "hubName", valid_568385
  var valid_568386 = path.getOrDefault("subscriptionId")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "subscriptionId", valid_568386
  var valid_568387 = path.getOrDefault("connectorName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "connectorName", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "api-version", valid_568388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568389: Call_ConnectorsDelete_568381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a connector in the hub.
  ## 
  let valid = call_568389.validator(path, query, header, formData, body)
  let scheme = call_568389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568389.url(scheme.get, call_568389.host, call_568389.base,
                         call_568389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568389, url, valid)

proc call*(call_568390: Call_ConnectorsDelete_568381; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          connectorName: string): Recallable =
  ## connectorsDelete
  ## Deletes a connector in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  var path_568391 = newJObject()
  var query_568392 = newJObject()
  add(path_568391, "resourceGroupName", newJString(resourceGroupName))
  add(path_568391, "hubName", newJString(hubName))
  add(query_568392, "api-version", newJString(apiVersion))
  add(path_568391, "subscriptionId", newJString(subscriptionId))
  add(path_568391, "connectorName", newJString(connectorName))
  result = call_568390.call(path_568391, query_568392, nil, nil, nil)

var connectorsDelete* = Call_ConnectorsDelete_568381(name: "connectorsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}",
    validator: validate_ConnectorsDelete_568382, base: "",
    url: url_ConnectorsDelete_568383, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsListByConnector_568393 = ref object of OpenApiRestCall_567667
proc url_ConnectorMappingsListByConnector_568395(protocol: Scheme; host: string;
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

proc validate_ConnectorMappingsListByConnector_568394(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the connector mappings in the specified connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568396 = path.getOrDefault("resourceGroupName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "resourceGroupName", valid_568396
  var valid_568397 = path.getOrDefault("hubName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "hubName", valid_568397
  var valid_568398 = path.getOrDefault("subscriptionId")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "subscriptionId", valid_568398
  var valid_568399 = path.getOrDefault("connectorName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "connectorName", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568400 = query.getOrDefault("api-version")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "api-version", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_ConnectorMappingsListByConnector_568393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the connector mappings in the specified connector.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_ConnectorMappingsListByConnector_568393;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; connectorName: string): Recallable =
  ## connectorMappingsListByConnector
  ## Gets all the connector mappings in the specified connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(path_568403, "hubName", newJString(hubName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  add(path_568403, "connectorName", newJString(connectorName))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var connectorMappingsListByConnector* = Call_ConnectorMappingsListByConnector_568393(
    name: "connectorMappingsListByConnector", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings",
    validator: validate_ConnectorMappingsListByConnector_568394, base: "",
    url: url_ConnectorMappingsListByConnector_568395, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsCreateOrUpdate_568418 = ref object of OpenApiRestCall_567667
proc url_ConnectorMappingsCreateOrUpdate_568420(protocol: Scheme; host: string;
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

proc validate_ConnectorMappingsCreateOrUpdate_568419(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a connector mapping or updates an existing connector mapping in the connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   mappingName: JString (required)
  ##              : The name of the connector mapping.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568421 = path.getOrDefault("resourceGroupName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "resourceGroupName", valid_568421
  var valid_568422 = path.getOrDefault("hubName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "hubName", valid_568422
  var valid_568423 = path.getOrDefault("mappingName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "mappingName", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  var valid_568425 = path.getOrDefault("connectorName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "connectorName", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "api-version", valid_568426
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

proc call*(call_568428: Call_ConnectorMappingsCreateOrUpdate_568418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a connector mapping or updates an existing connector mapping in the connector.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_ConnectorMappingsCreateOrUpdate_568418;
          resourceGroupName: string; hubName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; connectorName: string;
          parameters: JsonNode): Recallable =
  ## connectorMappingsCreateOrUpdate
  ## Creates a connector mapping or updates an existing connector mapping in the connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : The name of the connector mapping.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Connector Mapping operation.
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  var body_568432 = newJObject()
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(path_568430, "hubName", newJString(hubName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "mappingName", newJString(mappingName))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  add(path_568430, "connectorName", newJString(connectorName))
  if parameters != nil:
    body_568432 = parameters
  result = call_568429.call(path_568430, query_568431, nil, nil, body_568432)

var connectorMappingsCreateOrUpdate* = Call_ConnectorMappingsCreateOrUpdate_568418(
    name: "connectorMappingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings/{mappingName}",
    validator: validate_ConnectorMappingsCreateOrUpdate_568419, base: "",
    url: url_ConnectorMappingsCreateOrUpdate_568420, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsGet_568405 = ref object of OpenApiRestCall_567667
proc url_ConnectorMappingsGet_568407(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorMappingsGet_568406(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a connector mapping in the connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   mappingName: JString (required)
  ##              : The name of the connector mapping.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("hubName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "hubName", valid_568409
  var valid_568410 = path.getOrDefault("mappingName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "mappingName", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  var valid_568412 = path.getOrDefault("connectorName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "connectorName", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568413 = query.getOrDefault("api-version")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "api-version", valid_568413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_ConnectorMappingsGet_568405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connector mapping in the connector.
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_ConnectorMappingsGet_568405;
          resourceGroupName: string; hubName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; connectorName: string): Recallable =
  ## connectorMappingsGet
  ## Gets a connector mapping in the connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : The name of the connector mapping.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  add(path_568416, "resourceGroupName", newJString(resourceGroupName))
  add(path_568416, "hubName", newJString(hubName))
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "mappingName", newJString(mappingName))
  add(path_568416, "subscriptionId", newJString(subscriptionId))
  add(path_568416, "connectorName", newJString(connectorName))
  result = call_568415.call(path_568416, query_568417, nil, nil, nil)

var connectorMappingsGet* = Call_ConnectorMappingsGet_568405(
    name: "connectorMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings/{mappingName}",
    validator: validate_ConnectorMappingsGet_568406, base: "",
    url: url_ConnectorMappingsGet_568407, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsDelete_568433 = ref object of OpenApiRestCall_567667
proc url_ConnectorMappingsDelete_568435(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorMappingsDelete_568434(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a connector mapping in the connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   mappingName: JString (required)
  ##              : The name of the connector mapping.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: JString (required)
  ##                : The name of the connector.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
  var valid_568437 = path.getOrDefault("hubName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "hubName", valid_568437
  var valid_568438 = path.getOrDefault("mappingName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "mappingName", valid_568438
  var valid_568439 = path.getOrDefault("subscriptionId")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "subscriptionId", valid_568439
  var valid_568440 = path.getOrDefault("connectorName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "connectorName", valid_568440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568441 = query.getOrDefault("api-version")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "api-version", valid_568441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568442: Call_ConnectorMappingsDelete_568433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a connector mapping in the connector.
  ## 
  let valid = call_568442.validator(path, query, header, formData, body)
  let scheme = call_568442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568442.url(scheme.get, call_568442.host, call_568442.base,
                         call_568442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568442, url, valid)

proc call*(call_568443: Call_ConnectorMappingsDelete_568433;
          resourceGroupName: string; hubName: string; apiVersion: string;
          mappingName: string; subscriptionId: string; connectorName: string): Recallable =
  ## connectorMappingsDelete
  ## Deletes a connector mapping in the connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   mappingName: string (required)
  ##              : The name of the connector mapping.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   connectorName: string (required)
  ##                : The name of the connector.
  var path_568444 = newJObject()
  var query_568445 = newJObject()
  add(path_568444, "resourceGroupName", newJString(resourceGroupName))
  add(path_568444, "hubName", newJString(hubName))
  add(query_568445, "api-version", newJString(apiVersion))
  add(path_568444, "mappingName", newJString(mappingName))
  add(path_568444, "subscriptionId", newJString(subscriptionId))
  add(path_568444, "connectorName", newJString(connectorName))
  result = call_568443.call(path_568444, query_568445, nil, nil, nil)

var connectorMappingsDelete* = Call_ConnectorMappingsDelete_568433(
    name: "connectorMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings/{mappingName}",
    validator: validate_ConnectorMappingsDelete_568434, base: "",
    url: url_ConnectorMappingsDelete_568435, schemes: {Scheme.Https})
type
  Call_ImagesGetUploadUrlForData_568446 = ref object of OpenApiRestCall_567667
proc url_ImagesGetUploadUrlForData_568448(protocol: Scheme; host: string;
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

proc validate_ImagesGetUploadUrlForData_568447(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets data image upload URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568449 = path.getOrDefault("resourceGroupName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "resourceGroupName", valid_568449
  var valid_568450 = path.getOrDefault("hubName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "hubName", valid_568450
  var valid_568451 = path.getOrDefault("subscriptionId")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "subscriptionId", valid_568451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568452 = query.getOrDefault("api-version")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "api-version", valid_568452
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

proc call*(call_568454: Call_ImagesGetUploadUrlForData_568446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets data image upload URL.
  ## 
  let valid = call_568454.validator(path, query, header, formData, body)
  let scheme = call_568454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568454.url(scheme.get, call_568454.host, call_568454.base,
                         call_568454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568454, url, valid)

proc call*(call_568455: Call_ImagesGetUploadUrlForData_568446;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## imagesGetUploadUrlForData
  ## Gets data image upload URL.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the GetUploadUrlForData operation.
  var path_568456 = newJObject()
  var query_568457 = newJObject()
  var body_568458 = newJObject()
  add(path_568456, "resourceGroupName", newJString(resourceGroupName))
  add(path_568456, "hubName", newJString(hubName))
  add(query_568457, "api-version", newJString(apiVersion))
  add(path_568456, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568458 = parameters
  result = call_568455.call(path_568456, query_568457, nil, nil, body_568458)

var imagesGetUploadUrlForData* = Call_ImagesGetUploadUrlForData_568446(
    name: "imagesGetUploadUrlForData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/images/getDataImageUploadUrl",
    validator: validate_ImagesGetUploadUrlForData_568447, base: "",
    url: url_ImagesGetUploadUrlForData_568448, schemes: {Scheme.Https})
type
  Call_ImagesGetUploadUrlForEntityType_568459 = ref object of OpenApiRestCall_567667
proc url_ImagesGetUploadUrlForEntityType_568461(protocol: Scheme; host: string;
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

proc validate_ImagesGetUploadUrlForEntityType_568460(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets entity type (profile or interaction) image upload URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568462 = path.getOrDefault("resourceGroupName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "resourceGroupName", valid_568462
  var valid_568463 = path.getOrDefault("hubName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "hubName", valid_568463
  var valid_568464 = path.getOrDefault("subscriptionId")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "subscriptionId", valid_568464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568465 = query.getOrDefault("api-version")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "api-version", valid_568465
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

proc call*(call_568467: Call_ImagesGetUploadUrlForEntityType_568459;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets entity type (profile or interaction) image upload URL.
  ## 
  let valid = call_568467.validator(path, query, header, formData, body)
  let scheme = call_568467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568467.url(scheme.get, call_568467.host, call_568467.base,
                         call_568467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568467, url, valid)

proc call*(call_568468: Call_ImagesGetUploadUrlForEntityType_568459;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## imagesGetUploadUrlForEntityType
  ## Gets entity type (profile or interaction) image upload URL.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the GetUploadUrlForEntityType operation.
  var path_568469 = newJObject()
  var query_568470 = newJObject()
  var body_568471 = newJObject()
  add(path_568469, "resourceGroupName", newJString(resourceGroupName))
  add(path_568469, "hubName", newJString(hubName))
  add(query_568470, "api-version", newJString(apiVersion))
  add(path_568469, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568471 = parameters
  result = call_568468.call(path_568469, query_568470, nil, nil, body_568471)

var imagesGetUploadUrlForEntityType* = Call_ImagesGetUploadUrlForEntityType_568459(
    name: "imagesGetUploadUrlForEntityType", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/images/getEntityTypeImageUploadUrl",
    validator: validate_ImagesGetUploadUrlForEntityType_568460, base: "",
    url: url_ImagesGetUploadUrlForEntityType_568461, schemes: {Scheme.Https})
type
  Call_InteractionsListByHub_568472 = ref object of OpenApiRestCall_567667
proc url_InteractionsListByHub_568474(protocol: Scheme; host: string; base: string;
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

proc validate_InteractionsListByHub_568473(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all interactions in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568475 = path.getOrDefault("resourceGroupName")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "resourceGroupName", valid_568475
  var valid_568476 = path.getOrDefault("hubName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "hubName", valid_568476
  var valid_568477 = path.getOrDefault("subscriptionId")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "subscriptionId", valid_568477
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of interaction to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568478 = query.getOrDefault("api-version")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "api-version", valid_568478
  var valid_568492 = query.getOrDefault("locale-code")
  valid_568492 = validateParameter(valid_568492, JString, required = false,
                                 default = newJString("en-us"))
  if valid_568492 != nil:
    section.add "locale-code", valid_568492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568493: Call_InteractionsListByHub_568472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all interactions in the hub.
  ## 
  let valid = call_568493.validator(path, query, header, formData, body)
  let scheme = call_568493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568493.url(scheme.get, call_568493.host, call_568493.base,
                         call_568493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568493, url, valid)

proc call*(call_568494: Call_InteractionsListByHub_568472;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; localeCode: string = "en-us"): Recallable =
  ## interactionsListByHub
  ## Gets all interactions in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   localeCode: string
  ##             : Locale of interaction to retrieve, default is en-us.
  var path_568495 = newJObject()
  var query_568496 = newJObject()
  add(path_568495, "resourceGroupName", newJString(resourceGroupName))
  add(path_568495, "hubName", newJString(hubName))
  add(query_568496, "api-version", newJString(apiVersion))
  add(path_568495, "subscriptionId", newJString(subscriptionId))
  add(query_568496, "locale-code", newJString(localeCode))
  result = call_568494.call(path_568495, query_568496, nil, nil, nil)

var interactionsListByHub* = Call_InteractionsListByHub_568472(
    name: "interactionsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions",
    validator: validate_InteractionsListByHub_568473, base: "",
    url: url_InteractionsListByHub_568474, schemes: {Scheme.Https})
type
  Call_InteractionsCreateOrUpdate_568510 = ref object of OpenApiRestCall_567667
proc url_InteractionsCreateOrUpdate_568512(protocol: Scheme; host: string;
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

proc validate_InteractionsCreateOrUpdate_568511(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an interaction or updates an existing interaction within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   interactionName: JString (required)
  ##                  : The name of the interaction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568513 = path.getOrDefault("resourceGroupName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "resourceGroupName", valid_568513
  var valid_568514 = path.getOrDefault("hubName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "hubName", valid_568514
  var valid_568515 = path.getOrDefault("interactionName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "interactionName", valid_568515
  var valid_568516 = path.getOrDefault("subscriptionId")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "subscriptionId", valid_568516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568517 = query.getOrDefault("api-version")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "api-version", valid_568517
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

proc call*(call_568519: Call_InteractionsCreateOrUpdate_568510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an interaction or updates an existing interaction within a hub.
  ## 
  let valid = call_568519.validator(path, query, header, formData, body)
  let scheme = call_568519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568519.url(scheme.get, call_568519.host, call_568519.base,
                         call_568519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568519, url, valid)

proc call*(call_568520: Call_InteractionsCreateOrUpdate_568510;
          resourceGroupName: string; hubName: string; apiVersion: string;
          interactionName: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## interactionsCreateOrUpdate
  ## Creates an interaction or updates an existing interaction within a hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   interactionName: string (required)
  ##                  : The name of the interaction.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Interaction operation.
  var path_568521 = newJObject()
  var query_568522 = newJObject()
  var body_568523 = newJObject()
  add(path_568521, "resourceGroupName", newJString(resourceGroupName))
  add(path_568521, "hubName", newJString(hubName))
  add(query_568522, "api-version", newJString(apiVersion))
  add(path_568521, "interactionName", newJString(interactionName))
  add(path_568521, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568523 = parameters
  result = call_568520.call(path_568521, query_568522, nil, nil, body_568523)

var interactionsCreateOrUpdate* = Call_InteractionsCreateOrUpdate_568510(
    name: "interactionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions/{interactionName}",
    validator: validate_InteractionsCreateOrUpdate_568511, base: "",
    url: url_InteractionsCreateOrUpdate_568512, schemes: {Scheme.Https})
type
  Call_InteractionsGet_568497 = ref object of OpenApiRestCall_567667
proc url_InteractionsGet_568499(protocol: Scheme; host: string; base: string;
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

proc validate_InteractionsGet_568498(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets information about the specified interaction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   interactionName: JString (required)
  ##                  : The name of the interaction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568500 = path.getOrDefault("resourceGroupName")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "resourceGroupName", valid_568500
  var valid_568501 = path.getOrDefault("hubName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "hubName", valid_568501
  var valid_568502 = path.getOrDefault("interactionName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "interactionName", valid_568502
  var valid_568503 = path.getOrDefault("subscriptionId")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "subscriptionId", valid_568503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of interaction to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568504 = query.getOrDefault("api-version")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "api-version", valid_568504
  var valid_568505 = query.getOrDefault("locale-code")
  valid_568505 = validateParameter(valid_568505, JString, required = false,
                                 default = newJString("en-us"))
  if valid_568505 != nil:
    section.add "locale-code", valid_568505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568506: Call_InteractionsGet_568497; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified interaction.
  ## 
  let valid = call_568506.validator(path, query, header, formData, body)
  let scheme = call_568506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568506.url(scheme.get, call_568506.host, call_568506.base,
                         call_568506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568506, url, valid)

proc call*(call_568507: Call_InteractionsGet_568497; resourceGroupName: string;
          hubName: string; apiVersion: string; interactionName: string;
          subscriptionId: string; localeCode: string = "en-us"): Recallable =
  ## interactionsGet
  ## Gets information about the specified interaction.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   interactionName: string (required)
  ##                  : The name of the interaction.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   localeCode: string
  ##             : Locale of interaction to retrieve, default is en-us.
  var path_568508 = newJObject()
  var query_568509 = newJObject()
  add(path_568508, "resourceGroupName", newJString(resourceGroupName))
  add(path_568508, "hubName", newJString(hubName))
  add(query_568509, "api-version", newJString(apiVersion))
  add(path_568508, "interactionName", newJString(interactionName))
  add(path_568508, "subscriptionId", newJString(subscriptionId))
  add(query_568509, "locale-code", newJString(localeCode))
  result = call_568507.call(path_568508, query_568509, nil, nil, nil)

var interactionsGet* = Call_InteractionsGet_568497(name: "interactionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions/{interactionName}",
    validator: validate_InteractionsGet_568498, base: "", url: url_InteractionsGet_568499,
    schemes: {Scheme.Https})
type
  Call_InteractionsSuggestRelationshipLinks_568524 = ref object of OpenApiRestCall_567667
proc url_InteractionsSuggestRelationshipLinks_568526(protocol: Scheme;
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

proc validate_InteractionsSuggestRelationshipLinks_568525(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Suggests relationships to create relationship links.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   interactionName: JString (required)
  ##                  : The name of the interaction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568527 = path.getOrDefault("resourceGroupName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "resourceGroupName", valid_568527
  var valid_568528 = path.getOrDefault("hubName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "hubName", valid_568528
  var valid_568529 = path.getOrDefault("interactionName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "interactionName", valid_568529
  var valid_568530 = path.getOrDefault("subscriptionId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "subscriptionId", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568531 = query.getOrDefault("api-version")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "api-version", valid_568531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568532: Call_InteractionsSuggestRelationshipLinks_568524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Suggests relationships to create relationship links.
  ## 
  let valid = call_568532.validator(path, query, header, formData, body)
  let scheme = call_568532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568532.url(scheme.get, call_568532.host, call_568532.base,
                         call_568532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568532, url, valid)

proc call*(call_568533: Call_InteractionsSuggestRelationshipLinks_568524;
          resourceGroupName: string; hubName: string; apiVersion: string;
          interactionName: string; subscriptionId: string): Recallable =
  ## interactionsSuggestRelationshipLinks
  ## Suggests relationships to create relationship links.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   interactionName: string (required)
  ##                  : The name of the interaction.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568534 = newJObject()
  var query_568535 = newJObject()
  add(path_568534, "resourceGroupName", newJString(resourceGroupName))
  add(path_568534, "hubName", newJString(hubName))
  add(query_568535, "api-version", newJString(apiVersion))
  add(path_568534, "interactionName", newJString(interactionName))
  add(path_568534, "subscriptionId", newJString(subscriptionId))
  result = call_568533.call(path_568534, query_568535, nil, nil, nil)

var interactionsSuggestRelationshipLinks* = Call_InteractionsSuggestRelationshipLinks_568524(
    name: "interactionsSuggestRelationshipLinks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions/{interactionName}/suggestRelationshipLinks",
    validator: validate_InteractionsSuggestRelationshipLinks_568525, base: "",
    url: url_InteractionsSuggestRelationshipLinks_568526, schemes: {Scheme.Https})
type
  Call_KpiListByHub_568536 = ref object of OpenApiRestCall_567667
proc url_KpiListByHub_568538(protocol: Scheme; host: string; base: string;
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

proc validate_KpiListByHub_568537(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the KPIs in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568539 = path.getOrDefault("resourceGroupName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "resourceGroupName", valid_568539
  var valid_568540 = path.getOrDefault("hubName")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "hubName", valid_568540
  var valid_568541 = path.getOrDefault("subscriptionId")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "subscriptionId", valid_568541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568542 = query.getOrDefault("api-version")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "api-version", valid_568542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568543: Call_KpiListByHub_568536; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the KPIs in the specified hub.
  ## 
  let valid = call_568543.validator(path, query, header, formData, body)
  let scheme = call_568543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568543.url(scheme.get, call_568543.host, call_568543.base,
                         call_568543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568543, url, valid)

proc call*(call_568544: Call_KpiListByHub_568536; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## kpiListByHub
  ## Gets all the KPIs in the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568545 = newJObject()
  var query_568546 = newJObject()
  add(path_568545, "resourceGroupName", newJString(resourceGroupName))
  add(path_568545, "hubName", newJString(hubName))
  add(query_568546, "api-version", newJString(apiVersion))
  add(path_568545, "subscriptionId", newJString(subscriptionId))
  result = call_568544.call(path_568545, query_568546, nil, nil, nil)

var kpiListByHub* = Call_KpiListByHub_568536(name: "kpiListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi",
    validator: validate_KpiListByHub_568537, base: "", url: url_KpiListByHub_568538,
    schemes: {Scheme.Https})
type
  Call_KpiCreateOrUpdate_568559 = ref object of OpenApiRestCall_567667
proc url_KpiCreateOrUpdate_568561(protocol: Scheme; host: string; base: string;
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

proc validate_KpiCreateOrUpdate_568560(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a KPI or updates an existing KPI in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: JString (required)
  ##          : The name of the KPI.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568562 = path.getOrDefault("resourceGroupName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceGroupName", valid_568562
  var valid_568563 = path.getOrDefault("hubName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "hubName", valid_568563
  var valid_568564 = path.getOrDefault("subscriptionId")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "subscriptionId", valid_568564
  var valid_568565 = path.getOrDefault("kpiName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "kpiName", valid_568565
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568566 = query.getOrDefault("api-version")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "api-version", valid_568566
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

proc call*(call_568568: Call_KpiCreateOrUpdate_568559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a KPI or updates an existing KPI in the hub.
  ## 
  let valid = call_568568.validator(path, query, header, formData, body)
  let scheme = call_568568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568568.url(scheme.get, call_568568.host, call_568568.base,
                         call_568568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568568, url, valid)

proc call*(call_568569: Call_KpiCreateOrUpdate_568559; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          kpiName: string; parameters: JsonNode): Recallable =
  ## kpiCreateOrUpdate
  ## Creates a KPI or updates an existing KPI in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: string (required)
  ##          : The name of the KPI.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update KPI operation.
  var path_568570 = newJObject()
  var query_568571 = newJObject()
  var body_568572 = newJObject()
  add(path_568570, "resourceGroupName", newJString(resourceGroupName))
  add(path_568570, "hubName", newJString(hubName))
  add(query_568571, "api-version", newJString(apiVersion))
  add(path_568570, "subscriptionId", newJString(subscriptionId))
  add(path_568570, "kpiName", newJString(kpiName))
  if parameters != nil:
    body_568572 = parameters
  result = call_568569.call(path_568570, query_568571, nil, nil, body_568572)

var kpiCreateOrUpdate* = Call_KpiCreateOrUpdate_568559(name: "kpiCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}",
    validator: validate_KpiCreateOrUpdate_568560, base: "",
    url: url_KpiCreateOrUpdate_568561, schemes: {Scheme.Https})
type
  Call_KpiGet_568547 = ref object of OpenApiRestCall_567667
proc url_KpiGet_568549(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_KpiGet_568548(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a KPI in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: JString (required)
  ##          : The name of the KPI.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568550 = path.getOrDefault("resourceGroupName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "resourceGroupName", valid_568550
  var valid_568551 = path.getOrDefault("hubName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "hubName", valid_568551
  var valid_568552 = path.getOrDefault("subscriptionId")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "subscriptionId", valid_568552
  var valid_568553 = path.getOrDefault("kpiName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "kpiName", valid_568553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568554 = query.getOrDefault("api-version")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "api-version", valid_568554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568555: Call_KpiGet_568547; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a KPI in the hub.
  ## 
  let valid = call_568555.validator(path, query, header, formData, body)
  let scheme = call_568555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568555.url(scheme.get, call_568555.host, call_568555.base,
                         call_568555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568555, url, valid)

proc call*(call_568556: Call_KpiGet_568547; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string; kpiName: string): Recallable =
  ## kpiGet
  ## Gets a KPI in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: string (required)
  ##          : The name of the KPI.
  var path_568557 = newJObject()
  var query_568558 = newJObject()
  add(path_568557, "resourceGroupName", newJString(resourceGroupName))
  add(path_568557, "hubName", newJString(hubName))
  add(query_568558, "api-version", newJString(apiVersion))
  add(path_568557, "subscriptionId", newJString(subscriptionId))
  add(path_568557, "kpiName", newJString(kpiName))
  result = call_568556.call(path_568557, query_568558, nil, nil, nil)

var kpiGet* = Call_KpiGet_568547(name: "kpiGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}",
                              validator: validate_KpiGet_568548, base: "",
                              url: url_KpiGet_568549, schemes: {Scheme.Https})
type
  Call_KpiDelete_568573 = ref object of OpenApiRestCall_567667
proc url_KpiDelete_568575(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_KpiDelete_568574(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a KPI in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: JString (required)
  ##          : The name of the KPI.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568576 = path.getOrDefault("resourceGroupName")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "resourceGroupName", valid_568576
  var valid_568577 = path.getOrDefault("hubName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "hubName", valid_568577
  var valid_568578 = path.getOrDefault("subscriptionId")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "subscriptionId", valid_568578
  var valid_568579 = path.getOrDefault("kpiName")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "kpiName", valid_568579
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568580 = query.getOrDefault("api-version")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "api-version", valid_568580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568581: Call_KpiDelete_568573; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a KPI in the hub.
  ## 
  let valid = call_568581.validator(path, query, header, formData, body)
  let scheme = call_568581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568581.url(scheme.get, call_568581.host, call_568581.base,
                         call_568581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568581, url, valid)

proc call*(call_568582: Call_KpiDelete_568573; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string; kpiName: string): Recallable =
  ## kpiDelete
  ## Deletes a KPI in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: string (required)
  ##          : The name of the KPI.
  var path_568583 = newJObject()
  var query_568584 = newJObject()
  add(path_568583, "resourceGroupName", newJString(resourceGroupName))
  add(path_568583, "hubName", newJString(hubName))
  add(query_568584, "api-version", newJString(apiVersion))
  add(path_568583, "subscriptionId", newJString(subscriptionId))
  add(path_568583, "kpiName", newJString(kpiName))
  result = call_568582.call(path_568583, query_568584, nil, nil, nil)

var kpiDelete* = Call_KpiDelete_568573(name: "kpiDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}",
                                    validator: validate_KpiDelete_568574,
                                    base: "", url: url_KpiDelete_568575,
                                    schemes: {Scheme.Https})
type
  Call_KpiReprocess_568585 = ref object of OpenApiRestCall_567667
proc url_KpiReprocess_568587(protocol: Scheme; host: string; base: string;
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

proc validate_KpiReprocess_568586(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Reprocesses the Kpi values of the specified KPI.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: JString (required)
  ##          : The name of the KPI.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568588 = path.getOrDefault("resourceGroupName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "resourceGroupName", valid_568588
  var valid_568589 = path.getOrDefault("hubName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "hubName", valid_568589
  var valid_568590 = path.getOrDefault("subscriptionId")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "subscriptionId", valid_568590
  var valid_568591 = path.getOrDefault("kpiName")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "kpiName", valid_568591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568592 = query.getOrDefault("api-version")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "api-version", valid_568592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568593: Call_KpiReprocess_568585; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reprocesses the Kpi values of the specified KPI.
  ## 
  let valid = call_568593.validator(path, query, header, formData, body)
  let scheme = call_568593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568593.url(scheme.get, call_568593.host, call_568593.base,
                         call_568593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568593, url, valid)

proc call*(call_568594: Call_KpiReprocess_568585; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string; kpiName: string): Recallable =
  ## kpiReprocess
  ## Reprocesses the Kpi values of the specified KPI.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kpiName: string (required)
  ##          : The name of the KPI.
  var path_568595 = newJObject()
  var query_568596 = newJObject()
  add(path_568595, "resourceGroupName", newJString(resourceGroupName))
  add(path_568595, "hubName", newJString(hubName))
  add(query_568596, "api-version", newJString(apiVersion))
  add(path_568595, "subscriptionId", newJString(subscriptionId))
  add(path_568595, "kpiName", newJString(kpiName))
  result = call_568594.call(path_568595, query_568596, nil, nil, nil)

var kpiReprocess* = Call_KpiReprocess_568585(name: "kpiReprocess",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}/reprocess",
    validator: validate_KpiReprocess_568586, base: "", url: url_KpiReprocess_568587,
    schemes: {Scheme.Https})
type
  Call_LinksListByHub_568597 = ref object of OpenApiRestCall_567667
proc url_LinksListByHub_568599(protocol: Scheme; host: string; base: string;
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

proc validate_LinksListByHub_568598(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all the links in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568600 = path.getOrDefault("resourceGroupName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "resourceGroupName", valid_568600
  var valid_568601 = path.getOrDefault("hubName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "hubName", valid_568601
  var valid_568602 = path.getOrDefault("subscriptionId")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "subscriptionId", valid_568602
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568603 = query.getOrDefault("api-version")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "api-version", valid_568603
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568604: Call_LinksListByHub_568597; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the links in the specified hub.
  ## 
  let valid = call_568604.validator(path, query, header, formData, body)
  let scheme = call_568604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568604.url(scheme.get, call_568604.host, call_568604.base,
                         call_568604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568604, url, valid)

proc call*(call_568605: Call_LinksListByHub_568597; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## linksListByHub
  ## Gets all the links in the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568606 = newJObject()
  var query_568607 = newJObject()
  add(path_568606, "resourceGroupName", newJString(resourceGroupName))
  add(path_568606, "hubName", newJString(hubName))
  add(query_568607, "api-version", newJString(apiVersion))
  add(path_568606, "subscriptionId", newJString(subscriptionId))
  result = call_568605.call(path_568606, query_568607, nil, nil, nil)

var linksListByHub* = Call_LinksListByHub_568597(name: "linksListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links",
    validator: validate_LinksListByHub_568598, base: "", url: url_LinksListByHub_568599,
    schemes: {Scheme.Https})
type
  Call_LinksCreateOrUpdate_568620 = ref object of OpenApiRestCall_567667
proc url_LinksCreateOrUpdate_568622(protocol: Scheme; host: string; base: string;
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

proc validate_LinksCreateOrUpdate_568621(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a link or updates an existing link in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   linkName: JString (required)
  ##           : The name of the link.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568623 = path.getOrDefault("resourceGroupName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "resourceGroupName", valid_568623
  var valid_568624 = path.getOrDefault("hubName")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "hubName", valid_568624
  var valid_568625 = path.getOrDefault("subscriptionId")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "subscriptionId", valid_568625
  var valid_568626 = path.getOrDefault("linkName")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "linkName", valid_568626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568627 = query.getOrDefault("api-version")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "api-version", valid_568627
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

proc call*(call_568629: Call_LinksCreateOrUpdate_568620; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a link or updates an existing link in the hub.
  ## 
  let valid = call_568629.validator(path, query, header, formData, body)
  let scheme = call_568629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568629.url(scheme.get, call_568629.host, call_568629.base,
                         call_568629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568629, url, valid)

proc call*(call_568630: Call_LinksCreateOrUpdate_568620; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; linkName: string): Recallable =
  ## linksCreateOrUpdate
  ## Creates a link or updates an existing link in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Link operation.
  ##   linkName: string (required)
  ##           : The name of the link.
  var path_568631 = newJObject()
  var query_568632 = newJObject()
  var body_568633 = newJObject()
  add(path_568631, "resourceGroupName", newJString(resourceGroupName))
  add(path_568631, "hubName", newJString(hubName))
  add(query_568632, "api-version", newJString(apiVersion))
  add(path_568631, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568633 = parameters
  add(path_568631, "linkName", newJString(linkName))
  result = call_568630.call(path_568631, query_568632, nil, nil, body_568633)

var linksCreateOrUpdate* = Call_LinksCreateOrUpdate_568620(
    name: "linksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links/{linkName}",
    validator: validate_LinksCreateOrUpdate_568621, base: "",
    url: url_LinksCreateOrUpdate_568622, schemes: {Scheme.Https})
type
  Call_LinksGet_568608 = ref object of OpenApiRestCall_567667
proc url_LinksGet_568610(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LinksGet_568609(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a link in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   linkName: JString (required)
  ##           : The name of the link.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568611 = path.getOrDefault("resourceGroupName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "resourceGroupName", valid_568611
  var valid_568612 = path.getOrDefault("hubName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "hubName", valid_568612
  var valid_568613 = path.getOrDefault("subscriptionId")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "subscriptionId", valid_568613
  var valid_568614 = path.getOrDefault("linkName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "linkName", valid_568614
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568615 = query.getOrDefault("api-version")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "api-version", valid_568615
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568616: Call_LinksGet_568608; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a link in the hub.
  ## 
  let valid = call_568616.validator(path, query, header, formData, body)
  let scheme = call_568616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568616.url(scheme.get, call_568616.host, call_568616.base,
                         call_568616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568616, url, valid)

proc call*(call_568617: Call_LinksGet_568608; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          linkName: string): Recallable =
  ## linksGet
  ## Gets a link in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   linkName: string (required)
  ##           : The name of the link.
  var path_568618 = newJObject()
  var query_568619 = newJObject()
  add(path_568618, "resourceGroupName", newJString(resourceGroupName))
  add(path_568618, "hubName", newJString(hubName))
  add(query_568619, "api-version", newJString(apiVersion))
  add(path_568618, "subscriptionId", newJString(subscriptionId))
  add(path_568618, "linkName", newJString(linkName))
  result = call_568617.call(path_568618, query_568619, nil, nil, nil)

var linksGet* = Call_LinksGet_568608(name: "linksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links/{linkName}",
                                  validator: validate_LinksGet_568609, base: "",
                                  url: url_LinksGet_568610,
                                  schemes: {Scheme.Https})
type
  Call_LinksDelete_568634 = ref object of OpenApiRestCall_567667
proc url_LinksDelete_568636(protocol: Scheme; host: string; base: string;
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

proc validate_LinksDelete_568635(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a link in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   linkName: JString (required)
  ##           : The name of the link.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568637 = path.getOrDefault("resourceGroupName")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "resourceGroupName", valid_568637
  var valid_568638 = path.getOrDefault("hubName")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "hubName", valid_568638
  var valid_568639 = path.getOrDefault("subscriptionId")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "subscriptionId", valid_568639
  var valid_568640 = path.getOrDefault("linkName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "linkName", valid_568640
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568641 = query.getOrDefault("api-version")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "api-version", valid_568641
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568642: Call_LinksDelete_568634; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a link in the hub.
  ## 
  let valid = call_568642.validator(path, query, header, formData, body)
  let scheme = call_568642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568642.url(scheme.get, call_568642.host, call_568642.base,
                         call_568642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568642, url, valid)

proc call*(call_568643: Call_LinksDelete_568634; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          linkName: string): Recallable =
  ## linksDelete
  ## Deletes a link in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   linkName: string (required)
  ##           : The name of the link.
  var path_568644 = newJObject()
  var query_568645 = newJObject()
  add(path_568644, "resourceGroupName", newJString(resourceGroupName))
  add(path_568644, "hubName", newJString(hubName))
  add(query_568645, "api-version", newJString(apiVersion))
  add(path_568644, "subscriptionId", newJString(subscriptionId))
  add(path_568644, "linkName", newJString(linkName))
  result = call_568643.call(path_568644, query_568645, nil, nil, nil)

var linksDelete* = Call_LinksDelete_568634(name: "linksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links/{linkName}",
                                        validator: validate_LinksDelete_568635,
                                        base: "", url: url_LinksDelete_568636,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesListByHub_568646 = ref object of OpenApiRestCall_567667
proc url_ProfilesListByHub_568648(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesListByHub_568647(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all profile in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568649 = path.getOrDefault("resourceGroupName")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "resourceGroupName", valid_568649
  var valid_568650 = path.getOrDefault("hubName")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "hubName", valid_568650
  var valid_568651 = path.getOrDefault("subscriptionId")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "subscriptionId", valid_568651
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of profile to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568652 = query.getOrDefault("api-version")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "api-version", valid_568652
  var valid_568653 = query.getOrDefault("locale-code")
  valid_568653 = validateParameter(valid_568653, JString, required = false,
                                 default = newJString("en-us"))
  if valid_568653 != nil:
    section.add "locale-code", valid_568653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568654: Call_ProfilesListByHub_568646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all profile in the hub.
  ## 
  let valid = call_568654.validator(path, query, header, formData, body)
  let scheme = call_568654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568654.url(scheme.get, call_568654.host, call_568654.base,
                         call_568654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568654, url, valid)

proc call*(call_568655: Call_ProfilesListByHub_568646; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          localeCode: string = "en-us"): Recallable =
  ## profilesListByHub
  ## Gets all profile in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   localeCode: string
  ##             : Locale of profile to retrieve, default is en-us.
  var path_568656 = newJObject()
  var query_568657 = newJObject()
  add(path_568656, "resourceGroupName", newJString(resourceGroupName))
  add(path_568656, "hubName", newJString(hubName))
  add(query_568657, "api-version", newJString(apiVersion))
  add(path_568656, "subscriptionId", newJString(subscriptionId))
  add(query_568657, "locale-code", newJString(localeCode))
  result = call_568655.call(path_568656, query_568657, nil, nil, nil)

var profilesListByHub* = Call_ProfilesListByHub_568646(name: "profilesListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles",
    validator: validate_ProfilesListByHub_568647, base: "",
    url: url_ProfilesListByHub_568648, schemes: {Scheme.Https})
type
  Call_ProfilesCreateOrUpdate_568671 = ref object of OpenApiRestCall_567667
proc url_ProfilesCreateOrUpdate_568673(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesCreateOrUpdate_568672(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a profile within a Hub, or updates an existing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568674 = path.getOrDefault("resourceGroupName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "resourceGroupName", valid_568674
  var valid_568675 = path.getOrDefault("hubName")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "hubName", valid_568675
  var valid_568676 = path.getOrDefault("subscriptionId")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "subscriptionId", valid_568676
  var valid_568677 = path.getOrDefault("profileName")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "profileName", valid_568677
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568678 = query.getOrDefault("api-version")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "api-version", valid_568678
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

proc call*(call_568680: Call_ProfilesCreateOrUpdate_568671; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a profile within a Hub, or updates an existing profile.
  ## 
  let valid = call_568680.validator(path, query, header, formData, body)
  let scheme = call_568680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568680.url(scheme.get, call_568680.host, call_568680.base,
                         call_568680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568680, url, valid)

proc call*(call_568681: Call_ProfilesCreateOrUpdate_568671;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; profileName: string; parameters: JsonNode): Recallable =
  ## profilesCreateOrUpdate
  ## Creates a profile within a Hub, or updates an existing profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the profile.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/delete Profile type operation
  var path_568682 = newJObject()
  var query_568683 = newJObject()
  var body_568684 = newJObject()
  add(path_568682, "resourceGroupName", newJString(resourceGroupName))
  add(path_568682, "hubName", newJString(hubName))
  add(query_568683, "api-version", newJString(apiVersion))
  add(path_568682, "subscriptionId", newJString(subscriptionId))
  add(path_568682, "profileName", newJString(profileName))
  if parameters != nil:
    body_568684 = parameters
  result = call_568681.call(path_568682, query_568683, nil, nil, body_568684)

var profilesCreateOrUpdate* = Call_ProfilesCreateOrUpdate_568671(
    name: "profilesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}",
    validator: validate_ProfilesCreateOrUpdate_568672, base: "",
    url: url_ProfilesCreateOrUpdate_568673, schemes: {Scheme.Https})
type
  Call_ProfilesGet_568658 = ref object of OpenApiRestCall_567667
proc url_ProfilesGet_568660(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGet_568659(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568661 = path.getOrDefault("resourceGroupName")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "resourceGroupName", valid_568661
  var valid_568662 = path.getOrDefault("hubName")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "hubName", valid_568662
  var valid_568663 = path.getOrDefault("subscriptionId")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "subscriptionId", valid_568663
  var valid_568664 = path.getOrDefault("profileName")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "profileName", valid_568664
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of profile to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568665 = query.getOrDefault("api-version")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "api-version", valid_568665
  var valid_568666 = query.getOrDefault("locale-code")
  valid_568666 = validateParameter(valid_568666, JString, required = false,
                                 default = newJString("en-us"))
  if valid_568666 != nil:
    section.add "locale-code", valid_568666
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568667: Call_ProfilesGet_568658; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified profile.
  ## 
  let valid = call_568667.validator(path, query, header, formData, body)
  let scheme = call_568667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568667.url(scheme.get, call_568667.host, call_568667.base,
                         call_568667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568667, url, valid)

proc call*(call_568668: Call_ProfilesGet_568658; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          profileName: string; localeCode: string = "en-us"): Recallable =
  ## profilesGet
  ## Gets information about the specified profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   localeCode: string
  ##             : Locale of profile to retrieve, default is en-us.
  ##   profileName: string (required)
  ##              : The name of the profile.
  var path_568669 = newJObject()
  var query_568670 = newJObject()
  add(path_568669, "resourceGroupName", newJString(resourceGroupName))
  add(path_568669, "hubName", newJString(hubName))
  add(query_568670, "api-version", newJString(apiVersion))
  add(path_568669, "subscriptionId", newJString(subscriptionId))
  add(query_568670, "locale-code", newJString(localeCode))
  add(path_568669, "profileName", newJString(profileName))
  result = call_568668.call(path_568669, query_568670, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_568658(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}",
                                        validator: validate_ProfilesGet_568659,
                                        base: "", url: url_ProfilesGet_568660,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesDelete_568685 = ref object of OpenApiRestCall_567667
proc url_ProfilesDelete_568687(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesDelete_568686(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a profile within a hub
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568688 = path.getOrDefault("resourceGroupName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "resourceGroupName", valid_568688
  var valid_568689 = path.getOrDefault("hubName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "hubName", valid_568689
  var valid_568690 = path.getOrDefault("subscriptionId")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "subscriptionId", valid_568690
  var valid_568691 = path.getOrDefault("profileName")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "profileName", valid_568691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of profile to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568692 = query.getOrDefault("api-version")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "api-version", valid_568692
  var valid_568693 = query.getOrDefault("locale-code")
  valid_568693 = validateParameter(valid_568693, JString, required = false,
                                 default = newJString("en-us"))
  if valid_568693 != nil:
    section.add "locale-code", valid_568693
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568694: Call_ProfilesDelete_568685; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a profile within a hub
  ## 
  let valid = call_568694.validator(path, query, header, formData, body)
  let scheme = call_568694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568694.url(scheme.get, call_568694.host, call_568694.base,
                         call_568694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568694, url, valid)

proc call*(call_568695: Call_ProfilesDelete_568685; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          profileName: string; localeCode: string = "en-us"): Recallable =
  ## profilesDelete
  ## Deletes a profile within a hub
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   localeCode: string
  ##             : Locale of profile to retrieve, default is en-us.
  ##   profileName: string (required)
  ##              : The name of the profile.
  var path_568696 = newJObject()
  var query_568697 = newJObject()
  add(path_568696, "resourceGroupName", newJString(resourceGroupName))
  add(path_568696, "hubName", newJString(hubName))
  add(query_568697, "api-version", newJString(apiVersion))
  add(path_568696, "subscriptionId", newJString(subscriptionId))
  add(query_568697, "locale-code", newJString(localeCode))
  add(path_568696, "profileName", newJString(profileName))
  result = call_568695.call(path_568696, query_568697, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_568685(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}",
    validator: validate_ProfilesDelete_568686, base: "", url: url_ProfilesDelete_568687,
    schemes: {Scheme.Https})
type
  Call_ProfilesGetEnrichingKpis_568698 = ref object of OpenApiRestCall_567667
proc url_ProfilesGetEnrichingKpis_568700(protocol: Scheme; host: string;
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

proc validate_ProfilesGetEnrichingKpis_568699(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the KPIs that enrich the profile Type identified by the supplied name. Enrichment happens through participants of the Interaction on an Interaction KPI and through Relationships for Profile KPIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: JString (required)
  ##              : The name of the profile.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568701 = path.getOrDefault("resourceGroupName")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "resourceGroupName", valid_568701
  var valid_568702 = path.getOrDefault("hubName")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "hubName", valid_568702
  var valid_568703 = path.getOrDefault("subscriptionId")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "subscriptionId", valid_568703
  var valid_568704 = path.getOrDefault("profileName")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "profileName", valid_568704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568705 = query.getOrDefault("api-version")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "api-version", valid_568705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568706: Call_ProfilesGetEnrichingKpis_568698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the KPIs that enrich the profile Type identified by the supplied name. Enrichment happens through participants of the Interaction on an Interaction KPI and through Relationships for Profile KPIs.
  ## 
  let valid = call_568706.validator(path, query, header, formData, body)
  let scheme = call_568706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568706.url(scheme.get, call_568706.host, call_568706.base,
                         call_568706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568706, url, valid)

proc call*(call_568707: Call_ProfilesGetEnrichingKpis_568698;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; profileName: string): Recallable =
  ## profilesGetEnrichingKpis
  ## Gets the KPIs that enrich the profile Type identified by the supplied name. Enrichment happens through participants of the Interaction on an Interaction KPI and through Relationships for Profile KPIs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   profileName: string (required)
  ##              : The name of the profile.
  var path_568708 = newJObject()
  var query_568709 = newJObject()
  add(path_568708, "resourceGroupName", newJString(resourceGroupName))
  add(path_568708, "hubName", newJString(hubName))
  add(query_568709, "api-version", newJString(apiVersion))
  add(path_568708, "subscriptionId", newJString(subscriptionId))
  add(path_568708, "profileName", newJString(profileName))
  result = call_568707.call(path_568708, query_568709, nil, nil, nil)

var profilesGetEnrichingKpis* = Call_ProfilesGetEnrichingKpis_568698(
    name: "profilesGetEnrichingKpis", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}/getEnrichingKpis",
    validator: validate_ProfilesGetEnrichingKpis_568699, base: "",
    url: url_ProfilesGetEnrichingKpis_568700, schemes: {Scheme.Https})
type
  Call_RelationshipLinksListByHub_568710 = ref object of OpenApiRestCall_567667
proc url_RelationshipLinksListByHub_568712(protocol: Scheme; host: string;
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

proc validate_RelationshipLinksListByHub_568711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all relationship links in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568713 = path.getOrDefault("resourceGroupName")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "resourceGroupName", valid_568713
  var valid_568714 = path.getOrDefault("hubName")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "hubName", valid_568714
  var valid_568715 = path.getOrDefault("subscriptionId")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "subscriptionId", valid_568715
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568716 = query.getOrDefault("api-version")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "api-version", valid_568716
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568717: Call_RelationshipLinksListByHub_568710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all relationship links in the hub.
  ## 
  let valid = call_568717.validator(path, query, header, formData, body)
  let scheme = call_568717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568717.url(scheme.get, call_568717.host, call_568717.base,
                         call_568717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568717, url, valid)

proc call*(call_568718: Call_RelationshipLinksListByHub_568710;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## relationshipLinksListByHub
  ## Gets all relationship links in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568719 = newJObject()
  var query_568720 = newJObject()
  add(path_568719, "resourceGroupName", newJString(resourceGroupName))
  add(path_568719, "hubName", newJString(hubName))
  add(query_568720, "api-version", newJString(apiVersion))
  add(path_568719, "subscriptionId", newJString(subscriptionId))
  result = call_568718.call(path_568719, query_568720, nil, nil, nil)

var relationshipLinksListByHub* = Call_RelationshipLinksListByHub_568710(
    name: "relationshipLinksListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks",
    validator: validate_RelationshipLinksListByHub_568711, base: "",
    url: url_RelationshipLinksListByHub_568712, schemes: {Scheme.Https})
type
  Call_RelationshipLinksCreateOrUpdate_568733 = ref object of OpenApiRestCall_567667
proc url_RelationshipLinksCreateOrUpdate_568735(protocol: Scheme; host: string;
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

proc validate_RelationshipLinksCreateOrUpdate_568734(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a relationship link or updates an existing relationship link within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: JString (required)
  ##                       : The name of the relationship link.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568736 = path.getOrDefault("resourceGroupName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "resourceGroupName", valid_568736
  var valid_568737 = path.getOrDefault("hubName")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "hubName", valid_568737
  var valid_568738 = path.getOrDefault("subscriptionId")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "subscriptionId", valid_568738
  var valid_568739 = path.getOrDefault("relationshipLinkName")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "relationshipLinkName", valid_568739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568740 = query.getOrDefault("api-version")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "api-version", valid_568740
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

proc call*(call_568742: Call_RelationshipLinksCreateOrUpdate_568733;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a relationship link or updates an existing relationship link within a hub.
  ## 
  let valid = call_568742.validator(path, query, header, formData, body)
  let scheme = call_568742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568742.url(scheme.get, call_568742.host, call_568742.base,
                         call_568742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568742, url, valid)

proc call*(call_568743: Call_RelationshipLinksCreateOrUpdate_568733;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; relationshipLinkName: string): Recallable =
  ## relationshipLinksCreateOrUpdate
  ## Creates a relationship link or updates an existing relationship link within a hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate relationship link operation.
  ##   relationshipLinkName: string (required)
  ##                       : The name of the relationship link.
  var path_568744 = newJObject()
  var query_568745 = newJObject()
  var body_568746 = newJObject()
  add(path_568744, "resourceGroupName", newJString(resourceGroupName))
  add(path_568744, "hubName", newJString(hubName))
  add(query_568745, "api-version", newJString(apiVersion))
  add(path_568744, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568746 = parameters
  add(path_568744, "relationshipLinkName", newJString(relationshipLinkName))
  result = call_568743.call(path_568744, query_568745, nil, nil, body_568746)

var relationshipLinksCreateOrUpdate* = Call_RelationshipLinksCreateOrUpdate_568733(
    name: "relationshipLinksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks/{relationshipLinkName}",
    validator: validate_RelationshipLinksCreateOrUpdate_568734, base: "",
    url: url_RelationshipLinksCreateOrUpdate_568735, schemes: {Scheme.Https})
type
  Call_RelationshipLinksGet_568721 = ref object of OpenApiRestCall_567667
proc url_RelationshipLinksGet_568723(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipLinksGet_568722(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about the specified relationship Link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: JString (required)
  ##                       : The name of the relationship link.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568724 = path.getOrDefault("resourceGroupName")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "resourceGroupName", valid_568724
  var valid_568725 = path.getOrDefault("hubName")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "hubName", valid_568725
  var valid_568726 = path.getOrDefault("subscriptionId")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "subscriptionId", valid_568726
  var valid_568727 = path.getOrDefault("relationshipLinkName")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "relationshipLinkName", valid_568727
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568728 = query.getOrDefault("api-version")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "api-version", valid_568728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568729: Call_RelationshipLinksGet_568721; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified relationship Link.
  ## 
  let valid = call_568729.validator(path, query, header, formData, body)
  let scheme = call_568729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568729.url(scheme.get, call_568729.host, call_568729.base,
                         call_568729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568729, url, valid)

proc call*(call_568730: Call_RelationshipLinksGet_568721;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; relationshipLinkName: string): Recallable =
  ## relationshipLinksGet
  ## Gets information about the specified relationship Link.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: string (required)
  ##                       : The name of the relationship link.
  var path_568731 = newJObject()
  var query_568732 = newJObject()
  add(path_568731, "resourceGroupName", newJString(resourceGroupName))
  add(path_568731, "hubName", newJString(hubName))
  add(query_568732, "api-version", newJString(apiVersion))
  add(path_568731, "subscriptionId", newJString(subscriptionId))
  add(path_568731, "relationshipLinkName", newJString(relationshipLinkName))
  result = call_568730.call(path_568731, query_568732, nil, nil, nil)

var relationshipLinksGet* = Call_RelationshipLinksGet_568721(
    name: "relationshipLinksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks/{relationshipLinkName}",
    validator: validate_RelationshipLinksGet_568722, base: "",
    url: url_RelationshipLinksGet_568723, schemes: {Scheme.Https})
type
  Call_RelationshipLinksDelete_568747 = ref object of OpenApiRestCall_567667
proc url_RelationshipLinksDelete_568749(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipLinksDelete_568748(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a relationship link within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: JString (required)
  ##                       : The name of the relationship.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568750 = path.getOrDefault("resourceGroupName")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "resourceGroupName", valid_568750
  var valid_568751 = path.getOrDefault("hubName")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "hubName", valid_568751
  var valid_568752 = path.getOrDefault("subscriptionId")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "subscriptionId", valid_568752
  var valid_568753 = path.getOrDefault("relationshipLinkName")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "relationshipLinkName", valid_568753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568754 = query.getOrDefault("api-version")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "api-version", valid_568754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568755: Call_RelationshipLinksDelete_568747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a relationship link within a hub.
  ## 
  let valid = call_568755.validator(path, query, header, formData, body)
  let scheme = call_568755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568755.url(scheme.get, call_568755.host, call_568755.base,
                         call_568755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568755, url, valid)

proc call*(call_568756: Call_RelationshipLinksDelete_568747;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; relationshipLinkName: string): Recallable =
  ## relationshipLinksDelete
  ## Deletes a relationship link within a hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   relationshipLinkName: string (required)
  ##                       : The name of the relationship.
  var path_568757 = newJObject()
  var query_568758 = newJObject()
  add(path_568757, "resourceGroupName", newJString(resourceGroupName))
  add(path_568757, "hubName", newJString(hubName))
  add(query_568758, "api-version", newJString(apiVersion))
  add(path_568757, "subscriptionId", newJString(subscriptionId))
  add(path_568757, "relationshipLinkName", newJString(relationshipLinkName))
  result = call_568756.call(path_568757, query_568758, nil, nil, nil)

var relationshipLinksDelete* = Call_RelationshipLinksDelete_568747(
    name: "relationshipLinksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks/{relationshipLinkName}",
    validator: validate_RelationshipLinksDelete_568748, base: "",
    url: url_RelationshipLinksDelete_568749, schemes: {Scheme.Https})
type
  Call_RelationshipsListByHub_568759 = ref object of OpenApiRestCall_567667
proc url_RelationshipsListByHub_568761(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipsListByHub_568760(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all relationships in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568762 = path.getOrDefault("resourceGroupName")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "resourceGroupName", valid_568762
  var valid_568763 = path.getOrDefault("hubName")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "hubName", valid_568763
  var valid_568764 = path.getOrDefault("subscriptionId")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "subscriptionId", valid_568764
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568765 = query.getOrDefault("api-version")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "api-version", valid_568765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568766: Call_RelationshipsListByHub_568759; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all relationships in the hub.
  ## 
  let valid = call_568766.validator(path, query, header, formData, body)
  let scheme = call_568766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568766.url(scheme.get, call_568766.host, call_568766.base,
                         call_568766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568766, url, valid)

proc call*(call_568767: Call_RelationshipsListByHub_568759;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## relationshipsListByHub
  ## Gets all relationships in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568768 = newJObject()
  var query_568769 = newJObject()
  add(path_568768, "resourceGroupName", newJString(resourceGroupName))
  add(path_568768, "hubName", newJString(hubName))
  add(query_568769, "api-version", newJString(apiVersion))
  add(path_568768, "subscriptionId", newJString(subscriptionId))
  result = call_568767.call(path_568768, query_568769, nil, nil, nil)

var relationshipsListByHub* = Call_RelationshipsListByHub_568759(
    name: "relationshipsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships",
    validator: validate_RelationshipsListByHub_568760, base: "",
    url: url_RelationshipsListByHub_568761, schemes: {Scheme.Https})
type
  Call_RelationshipsCreateOrUpdate_568782 = ref object of OpenApiRestCall_567667
proc url_RelationshipsCreateOrUpdate_568784(protocol: Scheme; host: string;
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

proc validate_RelationshipsCreateOrUpdate_568783(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a relationship or updates an existing relationship within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   relationshipName: JString (required)
  ##                   : The name of the Relationship.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568785 = path.getOrDefault("resourceGroupName")
  valid_568785 = validateParameter(valid_568785, JString, required = true,
                                 default = nil)
  if valid_568785 != nil:
    section.add "resourceGroupName", valid_568785
  var valid_568786 = path.getOrDefault("hubName")
  valid_568786 = validateParameter(valid_568786, JString, required = true,
                                 default = nil)
  if valid_568786 != nil:
    section.add "hubName", valid_568786
  var valid_568787 = path.getOrDefault("relationshipName")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "relationshipName", valid_568787
  var valid_568788 = path.getOrDefault("subscriptionId")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "subscriptionId", valid_568788
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568789 = query.getOrDefault("api-version")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "api-version", valid_568789
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

proc call*(call_568791: Call_RelationshipsCreateOrUpdate_568782; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a relationship or updates an existing relationship within a hub.
  ## 
  let valid = call_568791.validator(path, query, header, formData, body)
  let scheme = call_568791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568791.url(scheme.get, call_568791.host, call_568791.base,
                         call_568791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568791, url, valid)

proc call*(call_568792: Call_RelationshipsCreateOrUpdate_568782;
          resourceGroupName: string; hubName: string; apiVersion: string;
          relationshipName: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## relationshipsCreateOrUpdate
  ## Creates a relationship or updates an existing relationship within a hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   relationshipName: string (required)
  ##                   : The name of the Relationship.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate Relationship operation.
  var path_568793 = newJObject()
  var query_568794 = newJObject()
  var body_568795 = newJObject()
  add(path_568793, "resourceGroupName", newJString(resourceGroupName))
  add(path_568793, "hubName", newJString(hubName))
  add(query_568794, "api-version", newJString(apiVersion))
  add(path_568793, "relationshipName", newJString(relationshipName))
  add(path_568793, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568795 = parameters
  result = call_568792.call(path_568793, query_568794, nil, nil, body_568795)

var relationshipsCreateOrUpdate* = Call_RelationshipsCreateOrUpdate_568782(
    name: "relationshipsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships/{relationshipName}",
    validator: validate_RelationshipsCreateOrUpdate_568783, base: "",
    url: url_RelationshipsCreateOrUpdate_568784, schemes: {Scheme.Https})
type
  Call_RelationshipsGet_568770 = ref object of OpenApiRestCall_567667
proc url_RelationshipsGet_568772(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipsGet_568771(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about the specified relationship.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   relationshipName: JString (required)
  ##                   : The name of the relationship.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568773 = path.getOrDefault("resourceGroupName")
  valid_568773 = validateParameter(valid_568773, JString, required = true,
                                 default = nil)
  if valid_568773 != nil:
    section.add "resourceGroupName", valid_568773
  var valid_568774 = path.getOrDefault("hubName")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "hubName", valid_568774
  var valid_568775 = path.getOrDefault("relationshipName")
  valid_568775 = validateParameter(valid_568775, JString, required = true,
                                 default = nil)
  if valid_568775 != nil:
    section.add "relationshipName", valid_568775
  var valid_568776 = path.getOrDefault("subscriptionId")
  valid_568776 = validateParameter(valid_568776, JString, required = true,
                                 default = nil)
  if valid_568776 != nil:
    section.add "subscriptionId", valid_568776
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568777 = query.getOrDefault("api-version")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "api-version", valid_568777
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568778: Call_RelationshipsGet_568770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified relationship.
  ## 
  let valid = call_568778.validator(path, query, header, formData, body)
  let scheme = call_568778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568778.url(scheme.get, call_568778.host, call_568778.base,
                         call_568778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568778, url, valid)

proc call*(call_568779: Call_RelationshipsGet_568770; resourceGroupName: string;
          hubName: string; apiVersion: string; relationshipName: string;
          subscriptionId: string): Recallable =
  ## relationshipsGet
  ## Gets information about the specified relationship.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   relationshipName: string (required)
  ##                   : The name of the relationship.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568780 = newJObject()
  var query_568781 = newJObject()
  add(path_568780, "resourceGroupName", newJString(resourceGroupName))
  add(path_568780, "hubName", newJString(hubName))
  add(query_568781, "api-version", newJString(apiVersion))
  add(path_568780, "relationshipName", newJString(relationshipName))
  add(path_568780, "subscriptionId", newJString(subscriptionId))
  result = call_568779.call(path_568780, query_568781, nil, nil, nil)

var relationshipsGet* = Call_RelationshipsGet_568770(name: "relationshipsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships/{relationshipName}",
    validator: validate_RelationshipsGet_568771, base: "",
    url: url_RelationshipsGet_568772, schemes: {Scheme.Https})
type
  Call_RelationshipsDelete_568796 = ref object of OpenApiRestCall_567667
proc url_RelationshipsDelete_568798(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipsDelete_568797(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a relationship within a hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   relationshipName: JString (required)
  ##                   : The name of the relationship.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568799 = path.getOrDefault("resourceGroupName")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "resourceGroupName", valid_568799
  var valid_568800 = path.getOrDefault("hubName")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "hubName", valid_568800
  var valid_568801 = path.getOrDefault("relationshipName")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "relationshipName", valid_568801
  var valid_568802 = path.getOrDefault("subscriptionId")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "subscriptionId", valid_568802
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568803 = query.getOrDefault("api-version")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "api-version", valid_568803
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568804: Call_RelationshipsDelete_568796; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a relationship within a hub.
  ## 
  let valid = call_568804.validator(path, query, header, formData, body)
  let scheme = call_568804.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568804.url(scheme.get, call_568804.host, call_568804.base,
                         call_568804.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568804, url, valid)

proc call*(call_568805: Call_RelationshipsDelete_568796; resourceGroupName: string;
          hubName: string; apiVersion: string; relationshipName: string;
          subscriptionId: string): Recallable =
  ## relationshipsDelete
  ## Deletes a relationship within a hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   relationshipName: string (required)
  ##                   : The name of the relationship.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568806 = newJObject()
  var query_568807 = newJObject()
  add(path_568806, "resourceGroupName", newJString(resourceGroupName))
  add(path_568806, "hubName", newJString(hubName))
  add(query_568807, "api-version", newJString(apiVersion))
  add(path_568806, "relationshipName", newJString(relationshipName))
  add(path_568806, "subscriptionId", newJString(subscriptionId))
  result = call_568805.call(path_568806, query_568807, nil, nil, nil)

var relationshipsDelete* = Call_RelationshipsDelete_568796(
    name: "relationshipsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships/{relationshipName}",
    validator: validate_RelationshipsDelete_568797, base: "",
    url: url_RelationshipsDelete_568798, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListByHub_568808 = ref object of OpenApiRestCall_567667
proc url_RoleAssignmentsListByHub_568810(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsListByHub_568809(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the role assignments for the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568811 = path.getOrDefault("resourceGroupName")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "resourceGroupName", valid_568811
  var valid_568812 = path.getOrDefault("hubName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "hubName", valid_568812
  var valid_568813 = path.getOrDefault("subscriptionId")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "subscriptionId", valid_568813
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568814 = query.getOrDefault("api-version")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "api-version", valid_568814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568815: Call_RoleAssignmentsListByHub_568808; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the role assignments for the specified hub.
  ## 
  let valid = call_568815.validator(path, query, header, formData, body)
  let scheme = call_568815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568815.url(scheme.get, call_568815.host, call_568815.base,
                         call_568815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568815, url, valid)

proc call*(call_568816: Call_RoleAssignmentsListByHub_568808;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## roleAssignmentsListByHub
  ## Gets all the role assignments for the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568817 = newJObject()
  var query_568818 = newJObject()
  add(path_568817, "resourceGroupName", newJString(resourceGroupName))
  add(path_568817, "hubName", newJString(hubName))
  add(query_568818, "api-version", newJString(apiVersion))
  add(path_568817, "subscriptionId", newJString(subscriptionId))
  result = call_568816.call(path_568817, query_568818, nil, nil, nil)

var roleAssignmentsListByHub* = Call_RoleAssignmentsListByHub_568808(
    name: "roleAssignmentsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments",
    validator: validate_RoleAssignmentsListByHub_568809, base: "",
    url: url_RoleAssignmentsListByHub_568810, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsCreateOrUpdate_568831 = ref object of OpenApiRestCall_567667
proc url_RoleAssignmentsCreateOrUpdate_568833(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsCreateOrUpdate_568832(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a role assignment in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   assignmentName: JString (required)
  ##                 : The assignment name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568834 = path.getOrDefault("resourceGroupName")
  valid_568834 = validateParameter(valid_568834, JString, required = true,
                                 default = nil)
  if valid_568834 != nil:
    section.add "resourceGroupName", valid_568834
  var valid_568835 = path.getOrDefault("hubName")
  valid_568835 = validateParameter(valid_568835, JString, required = true,
                                 default = nil)
  if valid_568835 != nil:
    section.add "hubName", valid_568835
  var valid_568836 = path.getOrDefault("subscriptionId")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "subscriptionId", valid_568836
  var valid_568837 = path.getOrDefault("assignmentName")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "assignmentName", valid_568837
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568838 = query.getOrDefault("api-version")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "api-version", valid_568838
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

proc call*(call_568840: Call_RoleAssignmentsCreateOrUpdate_568831; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a role assignment in the hub.
  ## 
  let valid = call_568840.validator(path, query, header, formData, body)
  let scheme = call_568840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568840.url(scheme.get, call_568840.host, call_568840.base,
                         call_568840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568840, url, valid)

proc call*(call_568841: Call_RoleAssignmentsCreateOrUpdate_568831;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; assignmentName: string): Recallable =
  ## roleAssignmentsCreateOrUpdate
  ## Creates or updates a role assignment in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate RoleAssignment operation.
  ##   assignmentName: string (required)
  ##                 : The assignment name
  var path_568842 = newJObject()
  var query_568843 = newJObject()
  var body_568844 = newJObject()
  add(path_568842, "resourceGroupName", newJString(resourceGroupName))
  add(path_568842, "hubName", newJString(hubName))
  add(query_568843, "api-version", newJString(apiVersion))
  add(path_568842, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568844 = parameters
  add(path_568842, "assignmentName", newJString(assignmentName))
  result = call_568841.call(path_568842, query_568843, nil, nil, body_568844)

var roleAssignmentsCreateOrUpdate* = Call_RoleAssignmentsCreateOrUpdate_568831(
    name: "roleAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments/{assignmentName}",
    validator: validate_RoleAssignmentsCreateOrUpdate_568832, base: "",
    url: url_RoleAssignmentsCreateOrUpdate_568833, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsGet_568819 = ref object of OpenApiRestCall_567667
proc url_RoleAssignmentsGet_568821(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsGet_568820(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the role assignment in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   assignmentName: JString (required)
  ##                 : The name of the role assignment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568822 = path.getOrDefault("resourceGroupName")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = nil)
  if valid_568822 != nil:
    section.add "resourceGroupName", valid_568822
  var valid_568823 = path.getOrDefault("hubName")
  valid_568823 = validateParameter(valid_568823, JString, required = true,
                                 default = nil)
  if valid_568823 != nil:
    section.add "hubName", valid_568823
  var valid_568824 = path.getOrDefault("subscriptionId")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "subscriptionId", valid_568824
  var valid_568825 = path.getOrDefault("assignmentName")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "assignmentName", valid_568825
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568826 = query.getOrDefault("api-version")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "api-version", valid_568826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568827: Call_RoleAssignmentsGet_568819; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the role assignment in the hub.
  ## 
  let valid = call_568827.validator(path, query, header, formData, body)
  let scheme = call_568827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568827.url(scheme.get, call_568827.host, call_568827.base,
                         call_568827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568827, url, valid)

proc call*(call_568828: Call_RoleAssignmentsGet_568819; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          assignmentName: string): Recallable =
  ## roleAssignmentsGet
  ## Gets the role assignment in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   assignmentName: string (required)
  ##                 : The name of the role assignment.
  var path_568829 = newJObject()
  var query_568830 = newJObject()
  add(path_568829, "resourceGroupName", newJString(resourceGroupName))
  add(path_568829, "hubName", newJString(hubName))
  add(query_568830, "api-version", newJString(apiVersion))
  add(path_568829, "subscriptionId", newJString(subscriptionId))
  add(path_568829, "assignmentName", newJString(assignmentName))
  result = call_568828.call(path_568829, query_568830, nil, nil, nil)

var roleAssignmentsGet* = Call_RoleAssignmentsGet_568819(
    name: "roleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments/{assignmentName}",
    validator: validate_RoleAssignmentsGet_568820, base: "",
    url: url_RoleAssignmentsGet_568821, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsDelete_568845 = ref object of OpenApiRestCall_567667
proc url_RoleAssignmentsDelete_568847(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsDelete_568846(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the role assignment in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   assignmentName: JString (required)
  ##                 : The name of the role assignment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568848 = path.getOrDefault("resourceGroupName")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "resourceGroupName", valid_568848
  var valid_568849 = path.getOrDefault("hubName")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "hubName", valid_568849
  var valid_568850 = path.getOrDefault("subscriptionId")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "subscriptionId", valid_568850
  var valid_568851 = path.getOrDefault("assignmentName")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "assignmentName", valid_568851
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568852 = query.getOrDefault("api-version")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = nil)
  if valid_568852 != nil:
    section.add "api-version", valid_568852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568853: Call_RoleAssignmentsDelete_568845; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the role assignment in the hub.
  ## 
  let valid = call_568853.validator(path, query, header, formData, body)
  let scheme = call_568853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568853.url(scheme.get, call_568853.host, call_568853.base,
                         call_568853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568853, url, valid)

proc call*(call_568854: Call_RoleAssignmentsDelete_568845;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string; assignmentName: string): Recallable =
  ## roleAssignmentsDelete
  ## Deletes the role assignment in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   assignmentName: string (required)
  ##                 : The name of the role assignment.
  var path_568855 = newJObject()
  var query_568856 = newJObject()
  add(path_568855, "resourceGroupName", newJString(resourceGroupName))
  add(path_568855, "hubName", newJString(hubName))
  add(query_568856, "api-version", newJString(apiVersion))
  add(path_568855, "subscriptionId", newJString(subscriptionId))
  add(path_568855, "assignmentName", newJString(assignmentName))
  result = call_568854.call(path_568855, query_568856, nil, nil, nil)

var roleAssignmentsDelete* = Call_RoleAssignmentsDelete_568845(
    name: "roleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments/{assignmentName}",
    validator: validate_RoleAssignmentsDelete_568846, base: "",
    url: url_RoleAssignmentsDelete_568847, schemes: {Scheme.Https})
type
  Call_RolesListByHub_568857 = ref object of OpenApiRestCall_567667
proc url_RolesListByHub_568859(protocol: Scheme; host: string; base: string;
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

proc validate_RolesListByHub_568858(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all the roles for the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568860 = path.getOrDefault("resourceGroupName")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "resourceGroupName", valid_568860
  var valid_568861 = path.getOrDefault("hubName")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "hubName", valid_568861
  var valid_568862 = path.getOrDefault("subscriptionId")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "subscriptionId", valid_568862
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568863 = query.getOrDefault("api-version")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "api-version", valid_568863
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568864: Call_RolesListByHub_568857; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the roles for the hub.
  ## 
  let valid = call_568864.validator(path, query, header, formData, body)
  let scheme = call_568864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568864.url(scheme.get, call_568864.host, call_568864.base,
                         call_568864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568864, url, valid)

proc call*(call_568865: Call_RolesListByHub_568857; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## rolesListByHub
  ## Gets all the roles for the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568866 = newJObject()
  var query_568867 = newJObject()
  add(path_568866, "resourceGroupName", newJString(resourceGroupName))
  add(path_568866, "hubName", newJString(hubName))
  add(query_568867, "api-version", newJString(apiVersion))
  add(path_568866, "subscriptionId", newJString(subscriptionId))
  result = call_568865.call(path_568866, query_568867, nil, nil, nil)

var rolesListByHub* = Call_RolesListByHub_568857(name: "rolesListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roles",
    validator: validate_RolesListByHub_568858, base: "", url: url_RolesListByHub_568859,
    schemes: {Scheme.Https})
type
  Call_ViewsListByHub_568868 = ref object of OpenApiRestCall_567667
proc url_ViewsListByHub_568870(protocol: Scheme; host: string; base: string;
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

proc validate_ViewsListByHub_568869(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all available views for given user in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568871 = path.getOrDefault("resourceGroupName")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "resourceGroupName", valid_568871
  var valid_568872 = path.getOrDefault("hubName")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "hubName", valid_568872
  var valid_568873 = path.getOrDefault("subscriptionId")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "subscriptionId", valid_568873
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   userId: JString (required)
  ##         : The user ID. Use * to retrieve hub level views.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568874 = query.getOrDefault("api-version")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "api-version", valid_568874
  var valid_568875 = query.getOrDefault("userId")
  valid_568875 = validateParameter(valid_568875, JString, required = true,
                                 default = nil)
  if valid_568875 != nil:
    section.add "userId", valid_568875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568876: Call_ViewsListByHub_568868; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available views for given user in the specified hub.
  ## 
  let valid = call_568876.validator(path, query, header, formData, body)
  let scheme = call_568876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568876.url(scheme.get, call_568876.host, call_568876.base,
                         call_568876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568876, url, valid)

proc call*(call_568877: Call_ViewsListByHub_568868; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string; userId: string): Recallable =
  ## viewsListByHub
  ## Gets all available views for given user in the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   userId: string (required)
  ##         : The user ID. Use * to retrieve hub level views.
  var path_568878 = newJObject()
  var query_568879 = newJObject()
  add(path_568878, "resourceGroupName", newJString(resourceGroupName))
  add(path_568878, "hubName", newJString(hubName))
  add(query_568879, "api-version", newJString(apiVersion))
  add(path_568878, "subscriptionId", newJString(subscriptionId))
  add(query_568879, "userId", newJString(userId))
  result = call_568877.call(path_568878, query_568879, nil, nil, nil)

var viewsListByHub* = Call_ViewsListByHub_568868(name: "viewsListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views",
    validator: validate_ViewsListByHub_568869, base: "", url: url_ViewsListByHub_568870,
    schemes: {Scheme.Https})
type
  Call_ViewsCreateOrUpdate_568893 = ref object of OpenApiRestCall_567667
proc url_ViewsCreateOrUpdate_568895(protocol: Scheme; host: string; base: string;
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

proc validate_ViewsCreateOrUpdate_568894(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a view or updates an existing view in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   viewName: JString (required)
  ##           : The name of the view.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568896 = path.getOrDefault("resourceGroupName")
  valid_568896 = validateParameter(valid_568896, JString, required = true,
                                 default = nil)
  if valid_568896 != nil:
    section.add "resourceGroupName", valid_568896
  var valid_568897 = path.getOrDefault("hubName")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = nil)
  if valid_568897 != nil:
    section.add "hubName", valid_568897
  var valid_568898 = path.getOrDefault("viewName")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "viewName", valid_568898
  var valid_568899 = path.getOrDefault("subscriptionId")
  valid_568899 = validateParameter(valid_568899, JString, required = true,
                                 default = nil)
  if valid_568899 != nil:
    section.add "subscriptionId", valid_568899
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568900 = query.getOrDefault("api-version")
  valid_568900 = validateParameter(valid_568900, JString, required = true,
                                 default = nil)
  if valid_568900 != nil:
    section.add "api-version", valid_568900
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

proc call*(call_568902: Call_ViewsCreateOrUpdate_568893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a view or updates an existing view in the hub.
  ## 
  let valid = call_568902.validator(path, query, header, formData, body)
  let scheme = call_568902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568902.url(scheme.get, call_568902.host, call_568902.base,
                         call_568902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568902, url, valid)

proc call*(call_568903: Call_ViewsCreateOrUpdate_568893; resourceGroupName: string;
          hubName: string; apiVersion: string; viewName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## viewsCreateOrUpdate
  ## Creates a view or updates an existing view in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   viewName: string (required)
  ##           : The name of the view.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate View operation.
  var path_568904 = newJObject()
  var query_568905 = newJObject()
  var body_568906 = newJObject()
  add(path_568904, "resourceGroupName", newJString(resourceGroupName))
  add(path_568904, "hubName", newJString(hubName))
  add(query_568905, "api-version", newJString(apiVersion))
  add(path_568904, "viewName", newJString(viewName))
  add(path_568904, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568906 = parameters
  result = call_568903.call(path_568904, query_568905, nil, nil, body_568906)

var viewsCreateOrUpdate* = Call_ViewsCreateOrUpdate_568893(
    name: "viewsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views/{viewName}",
    validator: validate_ViewsCreateOrUpdate_568894, base: "",
    url: url_ViewsCreateOrUpdate_568895, schemes: {Scheme.Https})
type
  Call_ViewsGet_568880 = ref object of OpenApiRestCall_567667
proc url_ViewsGet_568882(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ViewsGet_568881(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a view in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   viewName: JString (required)
  ##           : The name of the view.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568883 = path.getOrDefault("resourceGroupName")
  valid_568883 = validateParameter(valid_568883, JString, required = true,
                                 default = nil)
  if valid_568883 != nil:
    section.add "resourceGroupName", valid_568883
  var valid_568884 = path.getOrDefault("hubName")
  valid_568884 = validateParameter(valid_568884, JString, required = true,
                                 default = nil)
  if valid_568884 != nil:
    section.add "hubName", valid_568884
  var valid_568885 = path.getOrDefault("viewName")
  valid_568885 = validateParameter(valid_568885, JString, required = true,
                                 default = nil)
  if valid_568885 != nil:
    section.add "viewName", valid_568885
  var valid_568886 = path.getOrDefault("subscriptionId")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "subscriptionId", valid_568886
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   userId: JString (required)
  ##         : The user ID. Use * to retrieve hub level view.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568887 = query.getOrDefault("api-version")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "api-version", valid_568887
  var valid_568888 = query.getOrDefault("userId")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "userId", valid_568888
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568889: Call_ViewsGet_568880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a view in the hub.
  ## 
  let valid = call_568889.validator(path, query, header, formData, body)
  let scheme = call_568889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568889.url(scheme.get, call_568889.host, call_568889.base,
                         call_568889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568889, url, valid)

proc call*(call_568890: Call_ViewsGet_568880; resourceGroupName: string;
          hubName: string; apiVersion: string; viewName: string;
          subscriptionId: string; userId: string): Recallable =
  ## viewsGet
  ## Gets a view in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   viewName: string (required)
  ##           : The name of the view.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   userId: string (required)
  ##         : The user ID. Use * to retrieve hub level view.
  var path_568891 = newJObject()
  var query_568892 = newJObject()
  add(path_568891, "resourceGroupName", newJString(resourceGroupName))
  add(path_568891, "hubName", newJString(hubName))
  add(query_568892, "api-version", newJString(apiVersion))
  add(path_568891, "viewName", newJString(viewName))
  add(path_568891, "subscriptionId", newJString(subscriptionId))
  add(query_568892, "userId", newJString(userId))
  result = call_568890.call(path_568891, query_568892, nil, nil, nil)

var viewsGet* = Call_ViewsGet_568880(name: "viewsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views/{viewName}",
                                  validator: validate_ViewsGet_568881, base: "",
                                  url: url_ViewsGet_568882,
                                  schemes: {Scheme.Https})
type
  Call_ViewsDelete_568907 = ref object of OpenApiRestCall_567667
proc url_ViewsDelete_568909(protocol: Scheme; host: string; base: string;
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

proc validate_ViewsDelete_568908(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a view in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   viewName: JString (required)
  ##           : The name of the view.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568910 = path.getOrDefault("resourceGroupName")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = nil)
  if valid_568910 != nil:
    section.add "resourceGroupName", valid_568910
  var valid_568911 = path.getOrDefault("hubName")
  valid_568911 = validateParameter(valid_568911, JString, required = true,
                                 default = nil)
  if valid_568911 != nil:
    section.add "hubName", valid_568911
  var valid_568912 = path.getOrDefault("viewName")
  valid_568912 = validateParameter(valid_568912, JString, required = true,
                                 default = nil)
  if valid_568912 != nil:
    section.add "viewName", valid_568912
  var valid_568913 = path.getOrDefault("subscriptionId")
  valid_568913 = validateParameter(valid_568913, JString, required = true,
                                 default = nil)
  if valid_568913 != nil:
    section.add "subscriptionId", valid_568913
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   userId: JString (required)
  ##         : The user ID. Use * to retrieve hub level view.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568914 = query.getOrDefault("api-version")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "api-version", valid_568914
  var valid_568915 = query.getOrDefault("userId")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "userId", valid_568915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568916: Call_ViewsDelete_568907; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a view in the specified hub.
  ## 
  let valid = call_568916.validator(path, query, header, formData, body)
  let scheme = call_568916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568916.url(scheme.get, call_568916.host, call_568916.base,
                         call_568916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568916, url, valid)

proc call*(call_568917: Call_ViewsDelete_568907; resourceGroupName: string;
          hubName: string; apiVersion: string; viewName: string;
          subscriptionId: string; userId: string): Recallable =
  ## viewsDelete
  ## Deletes a view in the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   viewName: string (required)
  ##           : The name of the view.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   userId: string (required)
  ##         : The user ID. Use * to retrieve hub level view.
  var path_568918 = newJObject()
  var query_568919 = newJObject()
  add(path_568918, "resourceGroupName", newJString(resourceGroupName))
  add(path_568918, "hubName", newJString(hubName))
  add(query_568919, "api-version", newJString(apiVersion))
  add(path_568918, "viewName", newJString(viewName))
  add(path_568918, "subscriptionId", newJString(subscriptionId))
  add(query_568919, "userId", newJString(userId))
  result = call_568917.call(path_568918, query_568919, nil, nil, nil)

var viewsDelete* = Call_ViewsDelete_568907(name: "viewsDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views/{viewName}",
                                        validator: validate_ViewsDelete_568908,
                                        base: "", url: url_ViewsDelete_568909,
                                        schemes: {Scheme.Https})
type
  Call_WidgetTypesListByHub_568920 = ref object of OpenApiRestCall_567667
proc url_WidgetTypesListByHub_568922(protocol: Scheme; host: string; base: string;
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

proc validate_WidgetTypesListByHub_568921(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all available widget types in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568923 = path.getOrDefault("resourceGroupName")
  valid_568923 = validateParameter(valid_568923, JString, required = true,
                                 default = nil)
  if valid_568923 != nil:
    section.add "resourceGroupName", valid_568923
  var valid_568924 = path.getOrDefault("hubName")
  valid_568924 = validateParameter(valid_568924, JString, required = true,
                                 default = nil)
  if valid_568924 != nil:
    section.add "hubName", valid_568924
  var valid_568925 = path.getOrDefault("subscriptionId")
  valid_568925 = validateParameter(valid_568925, JString, required = true,
                                 default = nil)
  if valid_568925 != nil:
    section.add "subscriptionId", valid_568925
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568926 = query.getOrDefault("api-version")
  valid_568926 = validateParameter(valid_568926, JString, required = true,
                                 default = nil)
  if valid_568926 != nil:
    section.add "api-version", valid_568926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568927: Call_WidgetTypesListByHub_568920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available widget types in the specified hub.
  ## 
  let valid = call_568927.validator(path, query, header, formData, body)
  let scheme = call_568927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568927.url(scheme.get, call_568927.host, call_568927.base,
                         call_568927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568927, url, valid)

proc call*(call_568928: Call_WidgetTypesListByHub_568920;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## widgetTypesListByHub
  ## Gets all available widget types in the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568929 = newJObject()
  var query_568930 = newJObject()
  add(path_568929, "resourceGroupName", newJString(resourceGroupName))
  add(path_568929, "hubName", newJString(hubName))
  add(query_568930, "api-version", newJString(apiVersion))
  add(path_568929, "subscriptionId", newJString(subscriptionId))
  result = call_568928.call(path_568929, query_568930, nil, nil, nil)

var widgetTypesListByHub* = Call_WidgetTypesListByHub_568920(
    name: "widgetTypesListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/widgetTypes",
    validator: validate_WidgetTypesListByHub_568921, base: "",
    url: url_WidgetTypesListByHub_568922, schemes: {Scheme.Https})
type
  Call_WidgetTypesGet_568931 = ref object of OpenApiRestCall_567667
proc url_WidgetTypesGet_568933(protocol: Scheme; host: string; base: string;
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

proc validate_WidgetTypesGet_568932(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a widget type in the specified hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   widgetTypeName: JString (required)
  ##                 : The name of the widget type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568934 = path.getOrDefault("resourceGroupName")
  valid_568934 = validateParameter(valid_568934, JString, required = true,
                                 default = nil)
  if valid_568934 != nil:
    section.add "resourceGroupName", valid_568934
  var valid_568935 = path.getOrDefault("hubName")
  valid_568935 = validateParameter(valid_568935, JString, required = true,
                                 default = nil)
  if valid_568935 != nil:
    section.add "hubName", valid_568935
  var valid_568936 = path.getOrDefault("subscriptionId")
  valid_568936 = validateParameter(valid_568936, JString, required = true,
                                 default = nil)
  if valid_568936 != nil:
    section.add "subscriptionId", valid_568936
  var valid_568937 = path.getOrDefault("widgetTypeName")
  valid_568937 = validateParameter(valid_568937, JString, required = true,
                                 default = nil)
  if valid_568937 != nil:
    section.add "widgetTypeName", valid_568937
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568938 = query.getOrDefault("api-version")
  valid_568938 = validateParameter(valid_568938, JString, required = true,
                                 default = nil)
  if valid_568938 != nil:
    section.add "api-version", valid_568938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568939: Call_WidgetTypesGet_568931; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a widget type in the specified hub.
  ## 
  let valid = call_568939.validator(path, query, header, formData, body)
  let scheme = call_568939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568939.url(scheme.get, call_568939.host, call_568939.base,
                         call_568939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568939, url, valid)

proc call*(call_568940: Call_WidgetTypesGet_568931; resourceGroupName: string;
          hubName: string; apiVersion: string; subscriptionId: string;
          widgetTypeName: string): Recallable =
  ## widgetTypesGet
  ## Gets a widget type in the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   widgetTypeName: string (required)
  ##                 : The name of the widget type.
  var path_568941 = newJObject()
  var query_568942 = newJObject()
  add(path_568941, "resourceGroupName", newJString(resourceGroupName))
  add(path_568941, "hubName", newJString(hubName))
  add(query_568942, "api-version", newJString(apiVersion))
  add(path_568941, "subscriptionId", newJString(subscriptionId))
  add(path_568941, "widgetTypeName", newJString(widgetTypeName))
  result = call_568940.call(path_568941, query_568942, nil, nil, nil)

var widgetTypesGet* = Call_WidgetTypesGet_568931(name: "widgetTypesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/widgetTypes/{widgetTypeName}",
    validator: validate_WidgetTypesGet_568932, base: "", url: url_WidgetTypesGet_568933,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
