
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "customer-insights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593660 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593662(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593661(path: JsonNode; query: JsonNode;
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_OperationsList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Customer Insights REST API operations.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_OperationsList_593660; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Customer Insights REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var operationsList* = Call_OperationsList_593660(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CustomerInsights/operations",
    validator: validate_OperationsList_593661, base: "", url: url_OperationsList_593662,
    schemes: {Scheme.Https})
type
  Call_HubsList_593956 = ref object of OpenApiRestCall_593438
proc url_HubsList_593958(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_HubsList_593957(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_HubsList_593956; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all hubs in the specified subscription.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_HubsList_593956; apiVersion: string;
          subscriptionId: string): Recallable =
  ## hubsList
  ## Gets all hubs in the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var hubsList* = Call_HubsList_593956(name: "hubsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CustomerInsights/hubs",
                                  validator: validate_HubsList_593957, base: "",
                                  url: url_HubsList_593958,
                                  schemes: {Scheme.Https})
type
  Call_HubsListByResourceGroup_593979 = ref object of OpenApiRestCall_593438
proc url_HubsListByResourceGroup_593981(protocol: Scheme; host: string; base: string;
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

proc validate_HubsListByResourceGroup_593980(path: JsonNode; query: JsonNode;
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
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_HubsListByResourceGroup_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the hubs in a resource group.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_HubsListByResourceGroup_593979;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## hubsListByResourceGroup
  ## Gets all the hubs in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(path_593987, "resourceGroupName", newJString(resourceGroupName))
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var hubsListByResourceGroup* = Call_HubsListByResourceGroup_593979(
    name: "hubsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs",
    validator: validate_HubsListByResourceGroup_593980, base: "",
    url: url_HubsListByResourceGroup_593981, schemes: {Scheme.Https})
type
  Call_HubsCreateOrUpdate_594000 = ref object of OpenApiRestCall_593438
proc url_HubsCreateOrUpdate_594002(protocol: Scheme; host: string; base: string;
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

proc validate_HubsCreateOrUpdate_594001(path: JsonNode; query: JsonNode;
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
  var valid_594020 = path.getOrDefault("resourceGroupName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "resourceGroupName", valid_594020
  var valid_594021 = path.getOrDefault("hubName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "hubName", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
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

proc call*(call_594025: Call_HubsCreateOrUpdate_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a hub, or updates an existing hub.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_HubsCreateOrUpdate_594000; resourceGroupName: string;
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
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(path_594027, "resourceGroupName", newJString(resourceGroupName))
  add(path_594027, "hubName", newJString(hubName))
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594029 = parameters
  result = call_594026.call(path_594027, query_594028, nil, nil, body_594029)

var hubsCreateOrUpdate* = Call_HubsCreateOrUpdate_594000(
    name: "hubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
    validator: validate_HubsCreateOrUpdate_594001, base: "",
    url: url_HubsCreateOrUpdate_594002, schemes: {Scheme.Https})
type
  Call_HubsGet_593989 = ref object of OpenApiRestCall_593438
proc url_HubsGet_593991(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_HubsGet_593990(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593992 = path.getOrDefault("resourceGroupName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "resourceGroupName", valid_593992
  var valid_593993 = path.getOrDefault("hubName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "hubName", valid_593993
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_HubsGet_593989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified hub.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_HubsGet_593989; resourceGroupName: string;
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
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(path_593998, "resourceGroupName", newJString(resourceGroupName))
  add(path_593998, "hubName", newJString(hubName))
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var hubsGet* = Call_HubsGet_593989(name: "hubsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
                                validator: validate_HubsGet_593990, base: "",
                                url: url_HubsGet_593991, schemes: {Scheme.Https})
type
  Call_HubsUpdate_594041 = ref object of OpenApiRestCall_593438
proc url_HubsUpdate_594043(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_HubsUpdate_594042(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594044 = path.getOrDefault("resourceGroupName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceGroupName", valid_594044
  var valid_594045 = path.getOrDefault("hubName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "hubName", valid_594045
  var valid_594046 = path.getOrDefault("subscriptionId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "subscriptionId", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
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

proc call*(call_594049: Call_HubsUpdate_594041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Hub.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_HubsUpdate_594041; resourceGroupName: string;
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
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  var body_594053 = newJObject()
  add(path_594051, "resourceGroupName", newJString(resourceGroupName))
  add(path_594051, "hubName", newJString(hubName))
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594053 = parameters
  result = call_594050.call(path_594051, query_594052, nil, nil, body_594053)

var hubsUpdate* = Call_HubsUpdate_594041(name: "hubsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
                                      validator: validate_HubsUpdate_594042,
                                      base: "", url: url_HubsUpdate_594043,
                                      schemes: {Scheme.Https})
type
  Call_HubsDelete_594030 = ref object of OpenApiRestCall_593438
proc url_HubsDelete_594032(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_HubsDelete_594031(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("hubName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "hubName", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_HubsDelete_594030; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified hub.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_HubsDelete_594030; resourceGroupName: string;
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
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(path_594039, "hubName", newJString(hubName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var hubsDelete* = Call_HubsDelete_594030(name: "hubsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}",
                                      validator: validate_HubsDelete_594031,
                                      base: "", url: url_HubsDelete_594032,
                                      schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesListByHub_594054 = ref object of OpenApiRestCall_593438
proc url_AuthorizationPoliciesListByHub_594056(protocol: Scheme; host: string;
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

proc validate_AuthorizationPoliciesListByHub_594055(path: JsonNode;
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
  var valid_594057 = path.getOrDefault("resourceGroupName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceGroupName", valid_594057
  var valid_594058 = path.getOrDefault("hubName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "hubName", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_AuthorizationPoliciesListByHub_594054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the authorization policies in a specified hub.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_AuthorizationPoliciesListByHub_594054;
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
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(path_594063, "resourceGroupName", newJString(resourceGroupName))
  add(path_594063, "hubName", newJString(hubName))
  add(query_594064, "api-version", newJString(apiVersion))
  add(path_594063, "subscriptionId", newJString(subscriptionId))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var authorizationPoliciesListByHub* = Call_AuthorizationPoliciesListByHub_594054(
    name: "authorizationPoliciesListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies",
    validator: validate_AuthorizationPoliciesListByHub_594055, base: "",
    url: url_AuthorizationPoliciesListByHub_594056, schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesCreateOrUpdate_594077 = ref object of OpenApiRestCall_593438
proc url_AuthorizationPoliciesCreateOrUpdate_594079(protocol: Scheme; host: string;
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

proc validate_AuthorizationPoliciesCreateOrUpdate_594078(path: JsonNode;
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
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("hubName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "hubName", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  var valid_594083 = path.getOrDefault("authorizationPolicyName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "authorizationPolicyName", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
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

proc call*(call_594086: Call_AuthorizationPoliciesCreateOrUpdate_594077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization policy or updates an existing authorization policy.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_AuthorizationPoliciesCreateOrUpdate_594077;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  var body_594090 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(path_594088, "hubName", newJString(hubName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594090 = parameters
  add(path_594088, "authorizationPolicyName", newJString(authorizationPolicyName))
  result = call_594087.call(path_594088, query_594089, nil, nil, body_594090)

var authorizationPoliciesCreateOrUpdate* = Call_AuthorizationPoliciesCreateOrUpdate_594077(
    name: "authorizationPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}",
    validator: validate_AuthorizationPoliciesCreateOrUpdate_594078, base: "",
    url: url_AuthorizationPoliciesCreateOrUpdate_594079, schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesGet_594065 = ref object of OpenApiRestCall_593438
proc url_AuthorizationPoliciesGet_594067(protocol: Scheme; host: string;
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

proc validate_AuthorizationPoliciesGet_594066(path: JsonNode; query: JsonNode;
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
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("hubName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "hubName", valid_594069
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("authorizationPolicyName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "authorizationPolicyName", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_AuthorizationPoliciesGet_594065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization policy in the hub.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_AuthorizationPoliciesGet_594065;
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
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(path_594075, "hubName", newJString(hubName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "authorizationPolicyName", newJString(authorizationPolicyName))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var authorizationPoliciesGet* = Call_AuthorizationPoliciesGet_594065(
    name: "authorizationPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}",
    validator: validate_AuthorizationPoliciesGet_594066, base: "",
    url: url_AuthorizationPoliciesGet_594067, schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesRegeneratePrimaryKey_594091 = ref object of OpenApiRestCall_593438
proc url_AuthorizationPoliciesRegeneratePrimaryKey_594093(protocol: Scheme;
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

proc validate_AuthorizationPoliciesRegeneratePrimaryKey_594092(path: JsonNode;
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
  var valid_594094 = path.getOrDefault("resourceGroupName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceGroupName", valid_594094
  var valid_594095 = path.getOrDefault("hubName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "hubName", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("authorizationPolicyName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "authorizationPolicyName", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594099: Call_AuthorizationPoliciesRegeneratePrimaryKey_594091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the primary policy key of the specified authorization policy.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_AuthorizationPoliciesRegeneratePrimaryKey_594091;
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
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  add(path_594101, "resourceGroupName", newJString(resourceGroupName))
  add(path_594101, "hubName", newJString(hubName))
  add(query_594102, "api-version", newJString(apiVersion))
  add(path_594101, "subscriptionId", newJString(subscriptionId))
  add(path_594101, "authorizationPolicyName", newJString(authorizationPolicyName))
  result = call_594100.call(path_594101, query_594102, nil, nil, nil)

var authorizationPoliciesRegeneratePrimaryKey* = Call_AuthorizationPoliciesRegeneratePrimaryKey_594091(
    name: "authorizationPoliciesRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}/regeneratePrimaryKey",
    validator: validate_AuthorizationPoliciesRegeneratePrimaryKey_594092,
    base: "", url: url_AuthorizationPoliciesRegeneratePrimaryKey_594093,
    schemes: {Scheme.Https})
type
  Call_AuthorizationPoliciesRegenerateSecondaryKey_594103 = ref object of OpenApiRestCall_593438
proc url_AuthorizationPoliciesRegenerateSecondaryKey_594105(protocol: Scheme;
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

proc validate_AuthorizationPoliciesRegenerateSecondaryKey_594104(path: JsonNode;
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
  var valid_594106 = path.getOrDefault("resourceGroupName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "resourceGroupName", valid_594106
  var valid_594107 = path.getOrDefault("hubName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "hubName", valid_594107
  var valid_594108 = path.getOrDefault("subscriptionId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "subscriptionId", valid_594108
  var valid_594109 = path.getOrDefault("authorizationPolicyName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "authorizationPolicyName", valid_594109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594110 = query.getOrDefault("api-version")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "api-version", valid_594110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594111: Call_AuthorizationPoliciesRegenerateSecondaryKey_594103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the secondary policy key of the specified authorization policy.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_AuthorizationPoliciesRegenerateSecondaryKey_594103;
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
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  add(path_594113, "resourceGroupName", newJString(resourceGroupName))
  add(path_594113, "hubName", newJString(hubName))
  add(query_594114, "api-version", newJString(apiVersion))
  add(path_594113, "subscriptionId", newJString(subscriptionId))
  add(path_594113, "authorizationPolicyName", newJString(authorizationPolicyName))
  result = call_594112.call(path_594113, query_594114, nil, nil, nil)

var authorizationPoliciesRegenerateSecondaryKey* = Call_AuthorizationPoliciesRegenerateSecondaryKey_594103(
    name: "authorizationPoliciesRegenerateSecondaryKey",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/authorizationPolicies/{authorizationPolicyName}/regenerateSecondaryKey",
    validator: validate_AuthorizationPoliciesRegenerateSecondaryKey_594104,
    base: "", url: url_AuthorizationPoliciesRegenerateSecondaryKey_594105,
    schemes: {Scheme.Https})
type
  Call_ConnectorsListByHub_594115 = ref object of OpenApiRestCall_593438
proc url_ConnectorsListByHub_594117(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorsListByHub_594116(path: JsonNode; query: JsonNode;
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
  var valid_594118 = path.getOrDefault("resourceGroupName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "resourceGroupName", valid_594118
  var valid_594119 = path.getOrDefault("hubName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "hubName", valid_594119
  var valid_594120 = path.getOrDefault("subscriptionId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "subscriptionId", valid_594120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594121 = query.getOrDefault("api-version")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "api-version", valid_594121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_ConnectorsListByHub_594115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the connectors in the specified hub.
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_ConnectorsListByHub_594115; resourceGroupName: string;
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
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  add(path_594124, "resourceGroupName", newJString(resourceGroupName))
  add(path_594124, "hubName", newJString(hubName))
  add(query_594125, "api-version", newJString(apiVersion))
  add(path_594124, "subscriptionId", newJString(subscriptionId))
  result = call_594123.call(path_594124, query_594125, nil, nil, nil)

var connectorsListByHub* = Call_ConnectorsListByHub_594115(
    name: "connectorsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors",
    validator: validate_ConnectorsListByHub_594116, base: "",
    url: url_ConnectorsListByHub_594117, schemes: {Scheme.Https})
type
  Call_ConnectorsCreateOrUpdate_594138 = ref object of OpenApiRestCall_593438
proc url_ConnectorsCreateOrUpdate_594140(protocol: Scheme; host: string;
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

proc validate_ConnectorsCreateOrUpdate_594139(path: JsonNode; query: JsonNode;
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
  var valid_594141 = path.getOrDefault("resourceGroupName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceGroupName", valid_594141
  var valid_594142 = path.getOrDefault("hubName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "hubName", valid_594142
  var valid_594143 = path.getOrDefault("subscriptionId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "subscriptionId", valid_594143
  var valid_594144 = path.getOrDefault("connectorName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "connectorName", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "api-version", valid_594145
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

proc call*(call_594147: Call_ConnectorsCreateOrUpdate_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a connector or updates an existing connector in the hub.
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_ConnectorsCreateOrUpdate_594138;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  var body_594151 = newJObject()
  add(path_594149, "resourceGroupName", newJString(resourceGroupName))
  add(path_594149, "hubName", newJString(hubName))
  add(query_594150, "api-version", newJString(apiVersion))
  add(path_594149, "subscriptionId", newJString(subscriptionId))
  add(path_594149, "connectorName", newJString(connectorName))
  if parameters != nil:
    body_594151 = parameters
  result = call_594148.call(path_594149, query_594150, nil, nil, body_594151)

var connectorsCreateOrUpdate* = Call_ConnectorsCreateOrUpdate_594138(
    name: "connectorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}",
    validator: validate_ConnectorsCreateOrUpdate_594139, base: "",
    url: url_ConnectorsCreateOrUpdate_594140, schemes: {Scheme.Https})
type
  Call_ConnectorsGet_594126 = ref object of OpenApiRestCall_593438
proc url_ConnectorsGet_594128(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorsGet_594127(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594129 = path.getOrDefault("resourceGroupName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceGroupName", valid_594129
  var valid_594130 = path.getOrDefault("hubName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "hubName", valid_594130
  var valid_594131 = path.getOrDefault("subscriptionId")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "subscriptionId", valid_594131
  var valid_594132 = path.getOrDefault("connectorName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "connectorName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_ConnectorsGet_594126; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connector in the hub.
  ## 
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_ConnectorsGet_594126; resourceGroupName: string;
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
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  add(path_594136, "resourceGroupName", newJString(resourceGroupName))
  add(path_594136, "hubName", newJString(hubName))
  add(query_594137, "api-version", newJString(apiVersion))
  add(path_594136, "subscriptionId", newJString(subscriptionId))
  add(path_594136, "connectorName", newJString(connectorName))
  result = call_594135.call(path_594136, query_594137, nil, nil, nil)

var connectorsGet* = Call_ConnectorsGet_594126(name: "connectorsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}",
    validator: validate_ConnectorsGet_594127, base: "", url: url_ConnectorsGet_594128,
    schemes: {Scheme.Https})
type
  Call_ConnectorsDelete_594152 = ref object of OpenApiRestCall_593438
proc url_ConnectorsDelete_594154(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorsDelete_594153(path: JsonNode; query: JsonNode;
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
  var valid_594155 = path.getOrDefault("resourceGroupName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "resourceGroupName", valid_594155
  var valid_594156 = path.getOrDefault("hubName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "hubName", valid_594156
  var valid_594157 = path.getOrDefault("subscriptionId")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "subscriptionId", valid_594157
  var valid_594158 = path.getOrDefault("connectorName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "connectorName", valid_594158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594159 = query.getOrDefault("api-version")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "api-version", valid_594159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594160: Call_ConnectorsDelete_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a connector in the hub.
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_ConnectorsDelete_594152; resourceGroupName: string;
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
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  add(path_594162, "resourceGroupName", newJString(resourceGroupName))
  add(path_594162, "hubName", newJString(hubName))
  add(query_594163, "api-version", newJString(apiVersion))
  add(path_594162, "subscriptionId", newJString(subscriptionId))
  add(path_594162, "connectorName", newJString(connectorName))
  result = call_594161.call(path_594162, query_594163, nil, nil, nil)

var connectorsDelete* = Call_ConnectorsDelete_594152(name: "connectorsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}",
    validator: validate_ConnectorsDelete_594153, base: "",
    url: url_ConnectorsDelete_594154, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsListByConnector_594164 = ref object of OpenApiRestCall_593438
proc url_ConnectorMappingsListByConnector_594166(protocol: Scheme; host: string;
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

proc validate_ConnectorMappingsListByConnector_594165(path: JsonNode;
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
  var valid_594167 = path.getOrDefault("resourceGroupName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "resourceGroupName", valid_594167
  var valid_594168 = path.getOrDefault("hubName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "hubName", valid_594168
  var valid_594169 = path.getOrDefault("subscriptionId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "subscriptionId", valid_594169
  var valid_594170 = path.getOrDefault("connectorName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "connectorName", valid_594170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594171 = query.getOrDefault("api-version")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "api-version", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_ConnectorMappingsListByConnector_594164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the connector mappings in the specified connector.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_ConnectorMappingsListByConnector_594164;
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
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(path_594174, "hubName", newJString(hubName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(path_594174, "connectorName", newJString(connectorName))
  result = call_594173.call(path_594174, query_594175, nil, nil, nil)

var connectorMappingsListByConnector* = Call_ConnectorMappingsListByConnector_594164(
    name: "connectorMappingsListByConnector", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings",
    validator: validate_ConnectorMappingsListByConnector_594165, base: "",
    url: url_ConnectorMappingsListByConnector_594166, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsCreateOrUpdate_594189 = ref object of OpenApiRestCall_593438
proc url_ConnectorMappingsCreateOrUpdate_594191(protocol: Scheme; host: string;
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

proc validate_ConnectorMappingsCreateOrUpdate_594190(path: JsonNode;
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
  var valid_594192 = path.getOrDefault("resourceGroupName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "resourceGroupName", valid_594192
  var valid_594193 = path.getOrDefault("hubName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "hubName", valid_594193
  var valid_594194 = path.getOrDefault("mappingName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "mappingName", valid_594194
  var valid_594195 = path.getOrDefault("subscriptionId")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "subscriptionId", valid_594195
  var valid_594196 = path.getOrDefault("connectorName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "connectorName", valid_594196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594197 = query.getOrDefault("api-version")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "api-version", valid_594197
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

proc call*(call_594199: Call_ConnectorMappingsCreateOrUpdate_594189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a connector mapping or updates an existing connector mapping in the connector.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_ConnectorMappingsCreateOrUpdate_594189;
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
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(path_594201, "resourceGroupName", newJString(resourceGroupName))
  add(path_594201, "hubName", newJString(hubName))
  add(query_594202, "api-version", newJString(apiVersion))
  add(path_594201, "mappingName", newJString(mappingName))
  add(path_594201, "subscriptionId", newJString(subscriptionId))
  add(path_594201, "connectorName", newJString(connectorName))
  if parameters != nil:
    body_594203 = parameters
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var connectorMappingsCreateOrUpdate* = Call_ConnectorMappingsCreateOrUpdate_594189(
    name: "connectorMappingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings/{mappingName}",
    validator: validate_ConnectorMappingsCreateOrUpdate_594190, base: "",
    url: url_ConnectorMappingsCreateOrUpdate_594191, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsGet_594176 = ref object of OpenApiRestCall_593438
proc url_ConnectorMappingsGet_594178(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorMappingsGet_594177(path: JsonNode; query: JsonNode;
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
  var valid_594179 = path.getOrDefault("resourceGroupName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "resourceGroupName", valid_594179
  var valid_594180 = path.getOrDefault("hubName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "hubName", valid_594180
  var valid_594181 = path.getOrDefault("mappingName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "mappingName", valid_594181
  var valid_594182 = path.getOrDefault("subscriptionId")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "subscriptionId", valid_594182
  var valid_594183 = path.getOrDefault("connectorName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "connectorName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_ConnectorMappingsGet_594176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a connector mapping in the connector.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_ConnectorMappingsGet_594176;
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
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "resourceGroupName", newJString(resourceGroupName))
  add(path_594187, "hubName", newJString(hubName))
  add(query_594188, "api-version", newJString(apiVersion))
  add(path_594187, "mappingName", newJString(mappingName))
  add(path_594187, "subscriptionId", newJString(subscriptionId))
  add(path_594187, "connectorName", newJString(connectorName))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var connectorMappingsGet* = Call_ConnectorMappingsGet_594176(
    name: "connectorMappingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings/{mappingName}",
    validator: validate_ConnectorMappingsGet_594177, base: "",
    url: url_ConnectorMappingsGet_594178, schemes: {Scheme.Https})
type
  Call_ConnectorMappingsDelete_594204 = ref object of OpenApiRestCall_593438
proc url_ConnectorMappingsDelete_594206(protocol: Scheme; host: string; base: string;
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

proc validate_ConnectorMappingsDelete_594205(path: JsonNode; query: JsonNode;
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
  var valid_594207 = path.getOrDefault("resourceGroupName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "resourceGroupName", valid_594207
  var valid_594208 = path.getOrDefault("hubName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "hubName", valid_594208
  var valid_594209 = path.getOrDefault("mappingName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "mappingName", valid_594209
  var valid_594210 = path.getOrDefault("subscriptionId")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "subscriptionId", valid_594210
  var valid_594211 = path.getOrDefault("connectorName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "connectorName", valid_594211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594212 = query.getOrDefault("api-version")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "api-version", valid_594212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594213: Call_ConnectorMappingsDelete_594204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a connector mapping in the connector.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_ConnectorMappingsDelete_594204;
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
  var path_594215 = newJObject()
  var query_594216 = newJObject()
  add(path_594215, "resourceGroupName", newJString(resourceGroupName))
  add(path_594215, "hubName", newJString(hubName))
  add(query_594216, "api-version", newJString(apiVersion))
  add(path_594215, "mappingName", newJString(mappingName))
  add(path_594215, "subscriptionId", newJString(subscriptionId))
  add(path_594215, "connectorName", newJString(connectorName))
  result = call_594214.call(path_594215, query_594216, nil, nil, nil)

var connectorMappingsDelete* = Call_ConnectorMappingsDelete_594204(
    name: "connectorMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/connectors/{connectorName}/mappings/{mappingName}",
    validator: validate_ConnectorMappingsDelete_594205, base: "",
    url: url_ConnectorMappingsDelete_594206, schemes: {Scheme.Https})
type
  Call_ImagesGetUploadUrlForData_594217 = ref object of OpenApiRestCall_593438
proc url_ImagesGetUploadUrlForData_594219(protocol: Scheme; host: string;
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

proc validate_ImagesGetUploadUrlForData_594218(path: JsonNode; query: JsonNode;
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
  var valid_594220 = path.getOrDefault("resourceGroupName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "resourceGroupName", valid_594220
  var valid_594221 = path.getOrDefault("hubName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "hubName", valid_594221
  var valid_594222 = path.getOrDefault("subscriptionId")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "subscriptionId", valid_594222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594223 = query.getOrDefault("api-version")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "api-version", valid_594223
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

proc call*(call_594225: Call_ImagesGetUploadUrlForData_594217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets data image upload URL.
  ## 
  let valid = call_594225.validator(path, query, header, formData, body)
  let scheme = call_594225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594225.url(scheme.get, call_594225.host, call_594225.base,
                         call_594225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594225, url, valid)

proc call*(call_594226: Call_ImagesGetUploadUrlForData_594217;
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
  var path_594227 = newJObject()
  var query_594228 = newJObject()
  var body_594229 = newJObject()
  add(path_594227, "resourceGroupName", newJString(resourceGroupName))
  add(path_594227, "hubName", newJString(hubName))
  add(query_594228, "api-version", newJString(apiVersion))
  add(path_594227, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594229 = parameters
  result = call_594226.call(path_594227, query_594228, nil, nil, body_594229)

var imagesGetUploadUrlForData* = Call_ImagesGetUploadUrlForData_594217(
    name: "imagesGetUploadUrlForData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/images/getDataImageUploadUrl",
    validator: validate_ImagesGetUploadUrlForData_594218, base: "",
    url: url_ImagesGetUploadUrlForData_594219, schemes: {Scheme.Https})
type
  Call_ImagesGetUploadUrlForEntityType_594230 = ref object of OpenApiRestCall_593438
proc url_ImagesGetUploadUrlForEntityType_594232(protocol: Scheme; host: string;
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

proc validate_ImagesGetUploadUrlForEntityType_594231(path: JsonNode;
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
  var valid_594233 = path.getOrDefault("resourceGroupName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "resourceGroupName", valid_594233
  var valid_594234 = path.getOrDefault("hubName")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "hubName", valid_594234
  var valid_594235 = path.getOrDefault("subscriptionId")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "subscriptionId", valid_594235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594236 = query.getOrDefault("api-version")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "api-version", valid_594236
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

proc call*(call_594238: Call_ImagesGetUploadUrlForEntityType_594230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets entity type (profile or interaction) image upload URL.
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_ImagesGetUploadUrlForEntityType_594230;
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
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  var body_594242 = newJObject()
  add(path_594240, "resourceGroupName", newJString(resourceGroupName))
  add(path_594240, "hubName", newJString(hubName))
  add(query_594241, "api-version", newJString(apiVersion))
  add(path_594240, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594242 = parameters
  result = call_594239.call(path_594240, query_594241, nil, nil, body_594242)

var imagesGetUploadUrlForEntityType* = Call_ImagesGetUploadUrlForEntityType_594230(
    name: "imagesGetUploadUrlForEntityType", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/images/getEntityTypeImageUploadUrl",
    validator: validate_ImagesGetUploadUrlForEntityType_594231, base: "",
    url: url_ImagesGetUploadUrlForEntityType_594232, schemes: {Scheme.Https})
type
  Call_InteractionsListByHub_594243 = ref object of OpenApiRestCall_593438
proc url_InteractionsListByHub_594245(protocol: Scheme; host: string; base: string;
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

proc validate_InteractionsListByHub_594244(path: JsonNode; query: JsonNode;
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
  var valid_594246 = path.getOrDefault("resourceGroupName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "resourceGroupName", valid_594246
  var valid_594247 = path.getOrDefault("hubName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "hubName", valid_594247
  var valid_594248 = path.getOrDefault("subscriptionId")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "subscriptionId", valid_594248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of interaction to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594249 = query.getOrDefault("api-version")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "api-version", valid_594249
  var valid_594263 = query.getOrDefault("locale-code")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = newJString("en-us"))
  if valid_594263 != nil:
    section.add "locale-code", valid_594263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594264: Call_InteractionsListByHub_594243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all interactions in the hub.
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_InteractionsListByHub_594243;
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
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  add(path_594266, "resourceGroupName", newJString(resourceGroupName))
  add(path_594266, "hubName", newJString(hubName))
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "subscriptionId", newJString(subscriptionId))
  add(query_594267, "locale-code", newJString(localeCode))
  result = call_594265.call(path_594266, query_594267, nil, nil, nil)

var interactionsListByHub* = Call_InteractionsListByHub_594243(
    name: "interactionsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions",
    validator: validate_InteractionsListByHub_594244, base: "",
    url: url_InteractionsListByHub_594245, schemes: {Scheme.Https})
type
  Call_InteractionsCreateOrUpdate_594281 = ref object of OpenApiRestCall_593438
proc url_InteractionsCreateOrUpdate_594283(protocol: Scheme; host: string;
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

proc validate_InteractionsCreateOrUpdate_594282(path: JsonNode; query: JsonNode;
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
  var valid_594284 = path.getOrDefault("resourceGroupName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "resourceGroupName", valid_594284
  var valid_594285 = path.getOrDefault("hubName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "hubName", valid_594285
  var valid_594286 = path.getOrDefault("interactionName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "interactionName", valid_594286
  var valid_594287 = path.getOrDefault("subscriptionId")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "subscriptionId", valid_594287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594288 = query.getOrDefault("api-version")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "api-version", valid_594288
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

proc call*(call_594290: Call_InteractionsCreateOrUpdate_594281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an interaction or updates an existing interaction within a hub.
  ## 
  let valid = call_594290.validator(path, query, header, formData, body)
  let scheme = call_594290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594290.url(scheme.get, call_594290.host, call_594290.base,
                         call_594290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594290, url, valid)

proc call*(call_594291: Call_InteractionsCreateOrUpdate_594281;
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
  var path_594292 = newJObject()
  var query_594293 = newJObject()
  var body_594294 = newJObject()
  add(path_594292, "resourceGroupName", newJString(resourceGroupName))
  add(path_594292, "hubName", newJString(hubName))
  add(query_594293, "api-version", newJString(apiVersion))
  add(path_594292, "interactionName", newJString(interactionName))
  add(path_594292, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594294 = parameters
  result = call_594291.call(path_594292, query_594293, nil, nil, body_594294)

var interactionsCreateOrUpdate* = Call_InteractionsCreateOrUpdate_594281(
    name: "interactionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions/{interactionName}",
    validator: validate_InteractionsCreateOrUpdate_594282, base: "",
    url: url_InteractionsCreateOrUpdate_594283, schemes: {Scheme.Https})
type
  Call_InteractionsGet_594268 = ref object of OpenApiRestCall_593438
proc url_InteractionsGet_594270(protocol: Scheme; host: string; base: string;
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

proc validate_InteractionsGet_594269(path: JsonNode; query: JsonNode;
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
  var valid_594271 = path.getOrDefault("resourceGroupName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "resourceGroupName", valid_594271
  var valid_594272 = path.getOrDefault("hubName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "hubName", valid_594272
  var valid_594273 = path.getOrDefault("interactionName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "interactionName", valid_594273
  var valid_594274 = path.getOrDefault("subscriptionId")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "subscriptionId", valid_594274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of interaction to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594275 = query.getOrDefault("api-version")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "api-version", valid_594275
  var valid_594276 = query.getOrDefault("locale-code")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = newJString("en-us"))
  if valid_594276 != nil:
    section.add "locale-code", valid_594276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594277: Call_InteractionsGet_594268; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified interaction.
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_InteractionsGet_594268; resourceGroupName: string;
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
  var path_594279 = newJObject()
  var query_594280 = newJObject()
  add(path_594279, "resourceGroupName", newJString(resourceGroupName))
  add(path_594279, "hubName", newJString(hubName))
  add(query_594280, "api-version", newJString(apiVersion))
  add(path_594279, "interactionName", newJString(interactionName))
  add(path_594279, "subscriptionId", newJString(subscriptionId))
  add(query_594280, "locale-code", newJString(localeCode))
  result = call_594278.call(path_594279, query_594280, nil, nil, nil)

var interactionsGet* = Call_InteractionsGet_594268(name: "interactionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions/{interactionName}",
    validator: validate_InteractionsGet_594269, base: "", url: url_InteractionsGet_594270,
    schemes: {Scheme.Https})
type
  Call_InteractionsSuggestRelationshipLinks_594295 = ref object of OpenApiRestCall_593438
proc url_InteractionsSuggestRelationshipLinks_594297(protocol: Scheme;
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

proc validate_InteractionsSuggestRelationshipLinks_594296(path: JsonNode;
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
  var valid_594298 = path.getOrDefault("resourceGroupName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "resourceGroupName", valid_594298
  var valid_594299 = path.getOrDefault("hubName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "hubName", valid_594299
  var valid_594300 = path.getOrDefault("interactionName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "interactionName", valid_594300
  var valid_594301 = path.getOrDefault("subscriptionId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "subscriptionId", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_InteractionsSuggestRelationshipLinks_594295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Suggests relationships to create relationship links.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_InteractionsSuggestRelationshipLinks_594295;
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
  var path_594305 = newJObject()
  var query_594306 = newJObject()
  add(path_594305, "resourceGroupName", newJString(resourceGroupName))
  add(path_594305, "hubName", newJString(hubName))
  add(query_594306, "api-version", newJString(apiVersion))
  add(path_594305, "interactionName", newJString(interactionName))
  add(path_594305, "subscriptionId", newJString(subscriptionId))
  result = call_594304.call(path_594305, query_594306, nil, nil, nil)

var interactionsSuggestRelationshipLinks* = Call_InteractionsSuggestRelationshipLinks_594295(
    name: "interactionsSuggestRelationshipLinks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/interactions/{interactionName}/suggestRelationshipLinks",
    validator: validate_InteractionsSuggestRelationshipLinks_594296, base: "",
    url: url_InteractionsSuggestRelationshipLinks_594297, schemes: {Scheme.Https})
type
  Call_KpiListByHub_594307 = ref object of OpenApiRestCall_593438
proc url_KpiListByHub_594309(protocol: Scheme; host: string; base: string;
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

proc validate_KpiListByHub_594308(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594310 = path.getOrDefault("resourceGroupName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "resourceGroupName", valid_594310
  var valid_594311 = path.getOrDefault("hubName")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "hubName", valid_594311
  var valid_594312 = path.getOrDefault("subscriptionId")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "subscriptionId", valid_594312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594313 = query.getOrDefault("api-version")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "api-version", valid_594313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594314: Call_KpiListByHub_594307; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the KPIs in the specified hub.
  ## 
  let valid = call_594314.validator(path, query, header, formData, body)
  let scheme = call_594314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594314.url(scheme.get, call_594314.host, call_594314.base,
                         call_594314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594314, url, valid)

proc call*(call_594315: Call_KpiListByHub_594307; resourceGroupName: string;
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
  var path_594316 = newJObject()
  var query_594317 = newJObject()
  add(path_594316, "resourceGroupName", newJString(resourceGroupName))
  add(path_594316, "hubName", newJString(hubName))
  add(query_594317, "api-version", newJString(apiVersion))
  add(path_594316, "subscriptionId", newJString(subscriptionId))
  result = call_594315.call(path_594316, query_594317, nil, nil, nil)

var kpiListByHub* = Call_KpiListByHub_594307(name: "kpiListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi",
    validator: validate_KpiListByHub_594308, base: "", url: url_KpiListByHub_594309,
    schemes: {Scheme.Https})
type
  Call_KpiCreateOrUpdate_594330 = ref object of OpenApiRestCall_593438
proc url_KpiCreateOrUpdate_594332(protocol: Scheme; host: string; base: string;
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

proc validate_KpiCreateOrUpdate_594331(path: JsonNode; query: JsonNode;
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
  var valid_594333 = path.getOrDefault("resourceGroupName")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "resourceGroupName", valid_594333
  var valid_594334 = path.getOrDefault("hubName")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "hubName", valid_594334
  var valid_594335 = path.getOrDefault("subscriptionId")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "subscriptionId", valid_594335
  var valid_594336 = path.getOrDefault("kpiName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "kpiName", valid_594336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594337 = query.getOrDefault("api-version")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "api-version", valid_594337
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

proc call*(call_594339: Call_KpiCreateOrUpdate_594330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a KPI or updates an existing KPI in the hub.
  ## 
  let valid = call_594339.validator(path, query, header, formData, body)
  let scheme = call_594339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594339.url(scheme.get, call_594339.host, call_594339.base,
                         call_594339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594339, url, valid)

proc call*(call_594340: Call_KpiCreateOrUpdate_594330; resourceGroupName: string;
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
  var path_594341 = newJObject()
  var query_594342 = newJObject()
  var body_594343 = newJObject()
  add(path_594341, "resourceGroupName", newJString(resourceGroupName))
  add(path_594341, "hubName", newJString(hubName))
  add(query_594342, "api-version", newJString(apiVersion))
  add(path_594341, "subscriptionId", newJString(subscriptionId))
  add(path_594341, "kpiName", newJString(kpiName))
  if parameters != nil:
    body_594343 = parameters
  result = call_594340.call(path_594341, query_594342, nil, nil, body_594343)

var kpiCreateOrUpdate* = Call_KpiCreateOrUpdate_594330(name: "kpiCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}",
    validator: validate_KpiCreateOrUpdate_594331, base: "",
    url: url_KpiCreateOrUpdate_594332, schemes: {Scheme.Https})
type
  Call_KpiGet_594318 = ref object of OpenApiRestCall_593438
proc url_KpiGet_594320(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_KpiGet_594319(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594321 = path.getOrDefault("resourceGroupName")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "resourceGroupName", valid_594321
  var valid_594322 = path.getOrDefault("hubName")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "hubName", valid_594322
  var valid_594323 = path.getOrDefault("subscriptionId")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "subscriptionId", valid_594323
  var valid_594324 = path.getOrDefault("kpiName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "kpiName", valid_594324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594325 = query.getOrDefault("api-version")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "api-version", valid_594325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594326: Call_KpiGet_594318; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a KPI in the hub.
  ## 
  let valid = call_594326.validator(path, query, header, formData, body)
  let scheme = call_594326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594326.url(scheme.get, call_594326.host, call_594326.base,
                         call_594326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594326, url, valid)

proc call*(call_594327: Call_KpiGet_594318; resourceGroupName: string;
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
  var path_594328 = newJObject()
  var query_594329 = newJObject()
  add(path_594328, "resourceGroupName", newJString(resourceGroupName))
  add(path_594328, "hubName", newJString(hubName))
  add(query_594329, "api-version", newJString(apiVersion))
  add(path_594328, "subscriptionId", newJString(subscriptionId))
  add(path_594328, "kpiName", newJString(kpiName))
  result = call_594327.call(path_594328, query_594329, nil, nil, nil)

var kpiGet* = Call_KpiGet_594318(name: "kpiGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}",
                              validator: validate_KpiGet_594319, base: "",
                              url: url_KpiGet_594320, schemes: {Scheme.Https})
type
  Call_KpiDelete_594344 = ref object of OpenApiRestCall_593438
proc url_KpiDelete_594346(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_KpiDelete_594345(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594347 = path.getOrDefault("resourceGroupName")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "resourceGroupName", valid_594347
  var valid_594348 = path.getOrDefault("hubName")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "hubName", valid_594348
  var valid_594349 = path.getOrDefault("subscriptionId")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "subscriptionId", valid_594349
  var valid_594350 = path.getOrDefault("kpiName")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "kpiName", valid_594350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594351 = query.getOrDefault("api-version")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "api-version", valid_594351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594352: Call_KpiDelete_594344; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a KPI in the hub.
  ## 
  let valid = call_594352.validator(path, query, header, formData, body)
  let scheme = call_594352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594352.url(scheme.get, call_594352.host, call_594352.base,
                         call_594352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594352, url, valid)

proc call*(call_594353: Call_KpiDelete_594344; resourceGroupName: string;
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
  var path_594354 = newJObject()
  var query_594355 = newJObject()
  add(path_594354, "resourceGroupName", newJString(resourceGroupName))
  add(path_594354, "hubName", newJString(hubName))
  add(query_594355, "api-version", newJString(apiVersion))
  add(path_594354, "subscriptionId", newJString(subscriptionId))
  add(path_594354, "kpiName", newJString(kpiName))
  result = call_594353.call(path_594354, query_594355, nil, nil, nil)

var kpiDelete* = Call_KpiDelete_594344(name: "kpiDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}",
                                    validator: validate_KpiDelete_594345,
                                    base: "", url: url_KpiDelete_594346,
                                    schemes: {Scheme.Https})
type
  Call_KpiReprocess_594356 = ref object of OpenApiRestCall_593438
proc url_KpiReprocess_594358(protocol: Scheme; host: string; base: string;
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

proc validate_KpiReprocess_594357(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594359 = path.getOrDefault("resourceGroupName")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "resourceGroupName", valid_594359
  var valid_594360 = path.getOrDefault("hubName")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "hubName", valid_594360
  var valid_594361 = path.getOrDefault("subscriptionId")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "subscriptionId", valid_594361
  var valid_594362 = path.getOrDefault("kpiName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "kpiName", valid_594362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594363 = query.getOrDefault("api-version")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "api-version", valid_594363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594364: Call_KpiReprocess_594356; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reprocesses the Kpi values of the specified KPI.
  ## 
  let valid = call_594364.validator(path, query, header, formData, body)
  let scheme = call_594364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594364.url(scheme.get, call_594364.host, call_594364.base,
                         call_594364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594364, url, valid)

proc call*(call_594365: Call_KpiReprocess_594356; resourceGroupName: string;
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
  var path_594366 = newJObject()
  var query_594367 = newJObject()
  add(path_594366, "resourceGroupName", newJString(resourceGroupName))
  add(path_594366, "hubName", newJString(hubName))
  add(query_594367, "api-version", newJString(apiVersion))
  add(path_594366, "subscriptionId", newJString(subscriptionId))
  add(path_594366, "kpiName", newJString(kpiName))
  result = call_594365.call(path_594366, query_594367, nil, nil, nil)

var kpiReprocess* = Call_KpiReprocess_594356(name: "kpiReprocess",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/kpi/{kpiName}/reprocess",
    validator: validate_KpiReprocess_594357, base: "", url: url_KpiReprocess_594358,
    schemes: {Scheme.Https})
type
  Call_LinksListByHub_594368 = ref object of OpenApiRestCall_593438
proc url_LinksListByHub_594370(protocol: Scheme; host: string; base: string;
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

proc validate_LinksListByHub_594369(path: JsonNode; query: JsonNode;
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
  var valid_594371 = path.getOrDefault("resourceGroupName")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "resourceGroupName", valid_594371
  var valid_594372 = path.getOrDefault("hubName")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "hubName", valid_594372
  var valid_594373 = path.getOrDefault("subscriptionId")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "subscriptionId", valid_594373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594374 = query.getOrDefault("api-version")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "api-version", valid_594374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594375: Call_LinksListByHub_594368; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the links in the specified hub.
  ## 
  let valid = call_594375.validator(path, query, header, formData, body)
  let scheme = call_594375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594375.url(scheme.get, call_594375.host, call_594375.base,
                         call_594375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594375, url, valid)

proc call*(call_594376: Call_LinksListByHub_594368; resourceGroupName: string;
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
  var path_594377 = newJObject()
  var query_594378 = newJObject()
  add(path_594377, "resourceGroupName", newJString(resourceGroupName))
  add(path_594377, "hubName", newJString(hubName))
  add(query_594378, "api-version", newJString(apiVersion))
  add(path_594377, "subscriptionId", newJString(subscriptionId))
  result = call_594376.call(path_594377, query_594378, nil, nil, nil)

var linksListByHub* = Call_LinksListByHub_594368(name: "linksListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links",
    validator: validate_LinksListByHub_594369, base: "", url: url_LinksListByHub_594370,
    schemes: {Scheme.Https})
type
  Call_LinksCreateOrUpdate_594391 = ref object of OpenApiRestCall_593438
proc url_LinksCreateOrUpdate_594393(protocol: Scheme; host: string; base: string;
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

proc validate_LinksCreateOrUpdate_594392(path: JsonNode; query: JsonNode;
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
  var valid_594394 = path.getOrDefault("resourceGroupName")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "resourceGroupName", valid_594394
  var valid_594395 = path.getOrDefault("hubName")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "hubName", valid_594395
  var valid_594396 = path.getOrDefault("subscriptionId")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "subscriptionId", valid_594396
  var valid_594397 = path.getOrDefault("linkName")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "linkName", valid_594397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594398 = query.getOrDefault("api-version")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "api-version", valid_594398
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

proc call*(call_594400: Call_LinksCreateOrUpdate_594391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a link or updates an existing link in the hub.
  ## 
  let valid = call_594400.validator(path, query, header, formData, body)
  let scheme = call_594400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594400.url(scheme.get, call_594400.host, call_594400.base,
                         call_594400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594400, url, valid)

proc call*(call_594401: Call_LinksCreateOrUpdate_594391; resourceGroupName: string;
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
  var path_594402 = newJObject()
  var query_594403 = newJObject()
  var body_594404 = newJObject()
  add(path_594402, "resourceGroupName", newJString(resourceGroupName))
  add(path_594402, "hubName", newJString(hubName))
  add(query_594403, "api-version", newJString(apiVersion))
  add(path_594402, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594404 = parameters
  add(path_594402, "linkName", newJString(linkName))
  result = call_594401.call(path_594402, query_594403, nil, nil, body_594404)

var linksCreateOrUpdate* = Call_LinksCreateOrUpdate_594391(
    name: "linksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links/{linkName}",
    validator: validate_LinksCreateOrUpdate_594392, base: "",
    url: url_LinksCreateOrUpdate_594393, schemes: {Scheme.Https})
type
  Call_LinksGet_594379 = ref object of OpenApiRestCall_593438
proc url_LinksGet_594381(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LinksGet_594380(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594382 = path.getOrDefault("resourceGroupName")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "resourceGroupName", valid_594382
  var valid_594383 = path.getOrDefault("hubName")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "hubName", valid_594383
  var valid_594384 = path.getOrDefault("subscriptionId")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "subscriptionId", valid_594384
  var valid_594385 = path.getOrDefault("linkName")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "linkName", valid_594385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594386 = query.getOrDefault("api-version")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "api-version", valid_594386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594387: Call_LinksGet_594379; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a link in the hub.
  ## 
  let valid = call_594387.validator(path, query, header, formData, body)
  let scheme = call_594387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594387.url(scheme.get, call_594387.host, call_594387.base,
                         call_594387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594387, url, valid)

proc call*(call_594388: Call_LinksGet_594379; resourceGroupName: string;
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
  var path_594389 = newJObject()
  var query_594390 = newJObject()
  add(path_594389, "resourceGroupName", newJString(resourceGroupName))
  add(path_594389, "hubName", newJString(hubName))
  add(query_594390, "api-version", newJString(apiVersion))
  add(path_594389, "subscriptionId", newJString(subscriptionId))
  add(path_594389, "linkName", newJString(linkName))
  result = call_594388.call(path_594389, query_594390, nil, nil, nil)

var linksGet* = Call_LinksGet_594379(name: "linksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links/{linkName}",
                                  validator: validate_LinksGet_594380, base: "",
                                  url: url_LinksGet_594381,
                                  schemes: {Scheme.Https})
type
  Call_LinksDelete_594405 = ref object of OpenApiRestCall_593438
proc url_LinksDelete_594407(protocol: Scheme; host: string; base: string;
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

proc validate_LinksDelete_594406(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594408 = path.getOrDefault("resourceGroupName")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "resourceGroupName", valid_594408
  var valid_594409 = path.getOrDefault("hubName")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "hubName", valid_594409
  var valid_594410 = path.getOrDefault("subscriptionId")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "subscriptionId", valid_594410
  var valid_594411 = path.getOrDefault("linkName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "linkName", valid_594411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594412 = query.getOrDefault("api-version")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "api-version", valid_594412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594413: Call_LinksDelete_594405; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a link in the hub.
  ## 
  let valid = call_594413.validator(path, query, header, formData, body)
  let scheme = call_594413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594413.url(scheme.get, call_594413.host, call_594413.base,
                         call_594413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594413, url, valid)

proc call*(call_594414: Call_LinksDelete_594405; resourceGroupName: string;
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
  var path_594415 = newJObject()
  var query_594416 = newJObject()
  add(path_594415, "resourceGroupName", newJString(resourceGroupName))
  add(path_594415, "hubName", newJString(hubName))
  add(query_594416, "api-version", newJString(apiVersion))
  add(path_594415, "subscriptionId", newJString(subscriptionId))
  add(path_594415, "linkName", newJString(linkName))
  result = call_594414.call(path_594415, query_594416, nil, nil, nil)

var linksDelete* = Call_LinksDelete_594405(name: "linksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/links/{linkName}",
                                        validator: validate_LinksDelete_594406,
                                        base: "", url: url_LinksDelete_594407,
                                        schemes: {Scheme.Https})
type
  Call_PredictionsListByHub_594417 = ref object of OpenApiRestCall_593438
proc url_PredictionsListByHub_594419(protocol: Scheme; host: string; base: string;
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

proc validate_PredictionsListByHub_594418(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the predictions in the specified hub.
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
  var valid_594420 = path.getOrDefault("resourceGroupName")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "resourceGroupName", valid_594420
  var valid_594421 = path.getOrDefault("hubName")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "hubName", valid_594421
  var valid_594422 = path.getOrDefault("subscriptionId")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "subscriptionId", valid_594422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594423 = query.getOrDefault("api-version")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "api-version", valid_594423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594424: Call_PredictionsListByHub_594417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the predictions in the specified hub.
  ## 
  let valid = call_594424.validator(path, query, header, formData, body)
  let scheme = call_594424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594424.url(scheme.get, call_594424.host, call_594424.base,
                         call_594424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594424, url, valid)

proc call*(call_594425: Call_PredictionsListByHub_594417;
          resourceGroupName: string; hubName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## predictionsListByHub
  ## Gets all the predictions in the specified hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594426 = newJObject()
  var query_594427 = newJObject()
  add(path_594426, "resourceGroupName", newJString(resourceGroupName))
  add(path_594426, "hubName", newJString(hubName))
  add(query_594427, "api-version", newJString(apiVersion))
  add(path_594426, "subscriptionId", newJString(subscriptionId))
  result = call_594425.call(path_594426, query_594427, nil, nil, nil)

var predictionsListByHub* = Call_PredictionsListByHub_594417(
    name: "predictionsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions",
    validator: validate_PredictionsListByHub_594418, base: "",
    url: url_PredictionsListByHub_594419, schemes: {Scheme.Https})
type
  Call_PredictionsCreateOrUpdate_594440 = ref object of OpenApiRestCall_593438
proc url_PredictionsCreateOrUpdate_594442(protocol: Scheme; host: string;
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

proc validate_PredictionsCreateOrUpdate_594441(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Prediction or updates an existing Prediction in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594443 = path.getOrDefault("resourceGroupName")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "resourceGroupName", valid_594443
  var valid_594444 = path.getOrDefault("hubName")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "hubName", valid_594444
  var valid_594445 = path.getOrDefault("predictionName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "predictionName", valid_594445
  var valid_594446 = path.getOrDefault("subscriptionId")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "subscriptionId", valid_594446
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594447 = query.getOrDefault("api-version")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "api-version", valid_594447
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

proc call*(call_594449: Call_PredictionsCreateOrUpdate_594440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Prediction or updates an existing Prediction in the hub.
  ## 
  let valid = call_594449.validator(path, query, header, formData, body)
  let scheme = call_594449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594449.url(scheme.get, call_594449.host, call_594449.base,
                         call_594449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594449, url, valid)

proc call*(call_594450: Call_PredictionsCreateOrUpdate_594440;
          resourceGroupName: string; hubName: string; predictionName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## predictionsCreateOrUpdate
  ## Creates a Prediction or updates an existing Prediction in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update Prediction operation.
  var path_594451 = newJObject()
  var query_594452 = newJObject()
  var body_594453 = newJObject()
  add(path_594451, "resourceGroupName", newJString(resourceGroupName))
  add(path_594451, "hubName", newJString(hubName))
  add(path_594451, "predictionName", newJString(predictionName))
  add(query_594452, "api-version", newJString(apiVersion))
  add(path_594451, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594453 = parameters
  result = call_594450.call(path_594451, query_594452, nil, nil, body_594453)

var predictionsCreateOrUpdate* = Call_PredictionsCreateOrUpdate_594440(
    name: "predictionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}",
    validator: validate_PredictionsCreateOrUpdate_594441, base: "",
    url: url_PredictionsCreateOrUpdate_594442, schemes: {Scheme.Https})
type
  Call_PredictionsGet_594428 = ref object of OpenApiRestCall_593438
proc url_PredictionsGet_594430(protocol: Scheme; host: string; base: string;
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

proc validate_PredictionsGet_594429(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a Prediction in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594431 = path.getOrDefault("resourceGroupName")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "resourceGroupName", valid_594431
  var valid_594432 = path.getOrDefault("hubName")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "hubName", valid_594432
  var valid_594433 = path.getOrDefault("predictionName")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "predictionName", valid_594433
  var valid_594434 = path.getOrDefault("subscriptionId")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "subscriptionId", valid_594434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594435 = query.getOrDefault("api-version")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "api-version", valid_594435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594436: Call_PredictionsGet_594428; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Prediction in the hub.
  ## 
  let valid = call_594436.validator(path, query, header, formData, body)
  let scheme = call_594436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594436.url(scheme.get, call_594436.host, call_594436.base,
                         call_594436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594436, url, valid)

proc call*(call_594437: Call_PredictionsGet_594428; resourceGroupName: string;
          hubName: string; predictionName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## predictionsGet
  ## Gets a Prediction in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594438 = newJObject()
  var query_594439 = newJObject()
  add(path_594438, "resourceGroupName", newJString(resourceGroupName))
  add(path_594438, "hubName", newJString(hubName))
  add(path_594438, "predictionName", newJString(predictionName))
  add(query_594439, "api-version", newJString(apiVersion))
  add(path_594438, "subscriptionId", newJString(subscriptionId))
  result = call_594437.call(path_594438, query_594439, nil, nil, nil)

var predictionsGet* = Call_PredictionsGet_594428(name: "predictionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}",
    validator: validate_PredictionsGet_594429, base: "", url: url_PredictionsGet_594430,
    schemes: {Scheme.Https})
type
  Call_PredictionsDelete_594454 = ref object of OpenApiRestCall_593438
proc url_PredictionsDelete_594456(protocol: Scheme; host: string; base: string;
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

proc validate_PredictionsDelete_594455(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a Prediction in the hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594457 = path.getOrDefault("resourceGroupName")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "resourceGroupName", valid_594457
  var valid_594458 = path.getOrDefault("hubName")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "hubName", valid_594458
  var valid_594459 = path.getOrDefault("predictionName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "predictionName", valid_594459
  var valid_594460 = path.getOrDefault("subscriptionId")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "subscriptionId", valid_594460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594461 = query.getOrDefault("api-version")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "api-version", valid_594461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594462: Call_PredictionsDelete_594454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Prediction in the hub.
  ## 
  let valid = call_594462.validator(path, query, header, formData, body)
  let scheme = call_594462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594462.url(scheme.get, call_594462.host, call_594462.base,
                         call_594462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594462, url, valid)

proc call*(call_594463: Call_PredictionsDelete_594454; resourceGroupName: string;
          hubName: string; predictionName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## predictionsDelete
  ## Deletes a Prediction in the hub.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594464 = newJObject()
  var query_594465 = newJObject()
  add(path_594464, "resourceGroupName", newJString(resourceGroupName))
  add(path_594464, "hubName", newJString(hubName))
  add(path_594464, "predictionName", newJString(predictionName))
  add(query_594465, "api-version", newJString(apiVersion))
  add(path_594464, "subscriptionId", newJString(subscriptionId))
  result = call_594463.call(path_594464, query_594465, nil, nil, nil)

var predictionsDelete* = Call_PredictionsDelete_594454(name: "predictionsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}",
    validator: validate_PredictionsDelete_594455, base: "",
    url: url_PredictionsDelete_594456, schemes: {Scheme.Https})
type
  Call_PredictionsGetModelStatus_594466 = ref object of OpenApiRestCall_593438
proc url_PredictionsGetModelStatus_594468(protocol: Scheme; host: string;
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

proc validate_PredictionsGetModelStatus_594467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets model status of the prediction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594469 = path.getOrDefault("resourceGroupName")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "resourceGroupName", valid_594469
  var valid_594470 = path.getOrDefault("hubName")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "hubName", valid_594470
  var valid_594471 = path.getOrDefault("predictionName")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "predictionName", valid_594471
  var valid_594472 = path.getOrDefault("subscriptionId")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "subscriptionId", valid_594472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594473 = query.getOrDefault("api-version")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "api-version", valid_594473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594474: Call_PredictionsGetModelStatus_594466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets model status of the prediction.
  ## 
  let valid = call_594474.validator(path, query, header, formData, body)
  let scheme = call_594474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594474.url(scheme.get, call_594474.host, call_594474.base,
                         call_594474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594474, url, valid)

proc call*(call_594475: Call_PredictionsGetModelStatus_594466;
          resourceGroupName: string; hubName: string; predictionName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## predictionsGetModelStatus
  ## Gets model status of the prediction.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594476 = newJObject()
  var query_594477 = newJObject()
  add(path_594476, "resourceGroupName", newJString(resourceGroupName))
  add(path_594476, "hubName", newJString(hubName))
  add(path_594476, "predictionName", newJString(predictionName))
  add(query_594477, "api-version", newJString(apiVersion))
  add(path_594476, "subscriptionId", newJString(subscriptionId))
  result = call_594475.call(path_594476, query_594477, nil, nil, nil)

var predictionsGetModelStatus* = Call_PredictionsGetModelStatus_594466(
    name: "predictionsGetModelStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}/getModelStatus",
    validator: validate_PredictionsGetModelStatus_594467, base: "",
    url: url_PredictionsGetModelStatus_594468, schemes: {Scheme.Https})
type
  Call_PredictionsGetTrainingResults_594478 = ref object of OpenApiRestCall_593438
proc url_PredictionsGetTrainingResults_594480(protocol: Scheme; host: string;
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

proc validate_PredictionsGetTrainingResults_594479(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets training results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594481 = path.getOrDefault("resourceGroupName")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "resourceGroupName", valid_594481
  var valid_594482 = path.getOrDefault("hubName")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "hubName", valid_594482
  var valid_594483 = path.getOrDefault("predictionName")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "predictionName", valid_594483
  var valid_594484 = path.getOrDefault("subscriptionId")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "subscriptionId", valid_594484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594485 = query.getOrDefault("api-version")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "api-version", valid_594485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594486: Call_PredictionsGetTrainingResults_594478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets training results.
  ## 
  let valid = call_594486.validator(path, query, header, formData, body)
  let scheme = call_594486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594486.url(scheme.get, call_594486.host, call_594486.base,
                         call_594486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594486, url, valid)

proc call*(call_594487: Call_PredictionsGetTrainingResults_594478;
          resourceGroupName: string; hubName: string; predictionName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## predictionsGetTrainingResults
  ## Gets training results.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594488 = newJObject()
  var query_594489 = newJObject()
  add(path_594488, "resourceGroupName", newJString(resourceGroupName))
  add(path_594488, "hubName", newJString(hubName))
  add(path_594488, "predictionName", newJString(predictionName))
  add(query_594489, "api-version", newJString(apiVersion))
  add(path_594488, "subscriptionId", newJString(subscriptionId))
  result = call_594487.call(path_594488, query_594489, nil, nil, nil)

var predictionsGetTrainingResults* = Call_PredictionsGetTrainingResults_594478(
    name: "predictionsGetTrainingResults", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}/getTrainingResults",
    validator: validate_PredictionsGetTrainingResults_594479, base: "",
    url: url_PredictionsGetTrainingResults_594480, schemes: {Scheme.Https})
type
  Call_PredictionsModelStatus_594490 = ref object of OpenApiRestCall_593438
proc url_PredictionsModelStatus_594492(protocol: Scheme; host: string; base: string;
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

proc validate_PredictionsModelStatus_594491(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the model status of prediction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hubName: JString (required)
  ##          : The name of the hub.
  ##   predictionName: JString (required)
  ##                 : The name of the Prediction.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594493 = path.getOrDefault("resourceGroupName")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "resourceGroupName", valid_594493
  var valid_594494 = path.getOrDefault("hubName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "hubName", valid_594494
  var valid_594495 = path.getOrDefault("predictionName")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "predictionName", valid_594495
  var valid_594496 = path.getOrDefault("subscriptionId")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "subscriptionId", valid_594496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594497 = query.getOrDefault("api-version")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "api-version", valid_594497
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

proc call*(call_594499: Call_PredictionsModelStatus_594490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the model status of prediction.
  ## 
  let valid = call_594499.validator(path, query, header, formData, body)
  let scheme = call_594499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594499.url(scheme.get, call_594499.host, call_594499.base,
                         call_594499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594499, url, valid)

proc call*(call_594500: Call_PredictionsModelStatus_594490;
          resourceGroupName: string; hubName: string; predictionName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## predictionsModelStatus
  ## Creates or updates the model status of prediction.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hubName: string (required)
  ##          : The name of the hub.
  ##   predictionName: string (required)
  ##                 : The name of the Prediction.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update prediction model status operation.
  var path_594501 = newJObject()
  var query_594502 = newJObject()
  var body_594503 = newJObject()
  add(path_594501, "resourceGroupName", newJString(resourceGroupName))
  add(path_594501, "hubName", newJString(hubName))
  add(path_594501, "predictionName", newJString(predictionName))
  add(query_594502, "api-version", newJString(apiVersion))
  add(path_594501, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594503 = parameters
  result = call_594500.call(path_594501, query_594502, nil, nil, body_594503)

var predictionsModelStatus* = Call_PredictionsModelStatus_594490(
    name: "predictionsModelStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/predictions/{predictionName}/modelStatus",
    validator: validate_PredictionsModelStatus_594491, base: "",
    url: url_PredictionsModelStatus_594492, schemes: {Scheme.Https})
type
  Call_ProfilesListByHub_594504 = ref object of OpenApiRestCall_593438
proc url_ProfilesListByHub_594506(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesListByHub_594505(path: JsonNode; query: JsonNode;
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
  var valid_594507 = path.getOrDefault("resourceGroupName")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "resourceGroupName", valid_594507
  var valid_594508 = path.getOrDefault("hubName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "hubName", valid_594508
  var valid_594509 = path.getOrDefault("subscriptionId")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "subscriptionId", valid_594509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of profile to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594510 = query.getOrDefault("api-version")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "api-version", valid_594510
  var valid_594511 = query.getOrDefault("locale-code")
  valid_594511 = validateParameter(valid_594511, JString, required = false,
                                 default = newJString("en-us"))
  if valid_594511 != nil:
    section.add "locale-code", valid_594511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594512: Call_ProfilesListByHub_594504; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all profile in the hub.
  ## 
  let valid = call_594512.validator(path, query, header, formData, body)
  let scheme = call_594512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594512.url(scheme.get, call_594512.host, call_594512.base,
                         call_594512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594512, url, valid)

proc call*(call_594513: Call_ProfilesListByHub_594504; resourceGroupName: string;
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
  var path_594514 = newJObject()
  var query_594515 = newJObject()
  add(path_594514, "resourceGroupName", newJString(resourceGroupName))
  add(path_594514, "hubName", newJString(hubName))
  add(query_594515, "api-version", newJString(apiVersion))
  add(path_594514, "subscriptionId", newJString(subscriptionId))
  add(query_594515, "locale-code", newJString(localeCode))
  result = call_594513.call(path_594514, query_594515, nil, nil, nil)

var profilesListByHub* = Call_ProfilesListByHub_594504(name: "profilesListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles",
    validator: validate_ProfilesListByHub_594505, base: "",
    url: url_ProfilesListByHub_594506, schemes: {Scheme.Https})
type
  Call_ProfilesCreateOrUpdate_594529 = ref object of OpenApiRestCall_593438
proc url_ProfilesCreateOrUpdate_594531(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesCreateOrUpdate_594530(path: JsonNode; query: JsonNode;
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
  var valid_594532 = path.getOrDefault("resourceGroupName")
  valid_594532 = validateParameter(valid_594532, JString, required = true,
                                 default = nil)
  if valid_594532 != nil:
    section.add "resourceGroupName", valid_594532
  var valid_594533 = path.getOrDefault("hubName")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "hubName", valid_594533
  var valid_594534 = path.getOrDefault("subscriptionId")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "subscriptionId", valid_594534
  var valid_594535 = path.getOrDefault("profileName")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "profileName", valid_594535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594536 = query.getOrDefault("api-version")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "api-version", valid_594536
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

proc call*(call_594538: Call_ProfilesCreateOrUpdate_594529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a profile within a Hub, or updates an existing profile.
  ## 
  let valid = call_594538.validator(path, query, header, formData, body)
  let scheme = call_594538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594538.url(scheme.get, call_594538.host, call_594538.base,
                         call_594538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594538, url, valid)

proc call*(call_594539: Call_ProfilesCreateOrUpdate_594529;
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
  var path_594540 = newJObject()
  var query_594541 = newJObject()
  var body_594542 = newJObject()
  add(path_594540, "resourceGroupName", newJString(resourceGroupName))
  add(path_594540, "hubName", newJString(hubName))
  add(query_594541, "api-version", newJString(apiVersion))
  add(path_594540, "subscriptionId", newJString(subscriptionId))
  add(path_594540, "profileName", newJString(profileName))
  if parameters != nil:
    body_594542 = parameters
  result = call_594539.call(path_594540, query_594541, nil, nil, body_594542)

var profilesCreateOrUpdate* = Call_ProfilesCreateOrUpdate_594529(
    name: "profilesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}",
    validator: validate_ProfilesCreateOrUpdate_594530, base: "",
    url: url_ProfilesCreateOrUpdate_594531, schemes: {Scheme.Https})
type
  Call_ProfilesGet_594516 = ref object of OpenApiRestCall_593438
proc url_ProfilesGet_594518(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGet_594517(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594519 = path.getOrDefault("resourceGroupName")
  valid_594519 = validateParameter(valid_594519, JString, required = true,
                                 default = nil)
  if valid_594519 != nil:
    section.add "resourceGroupName", valid_594519
  var valid_594520 = path.getOrDefault("hubName")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "hubName", valid_594520
  var valid_594521 = path.getOrDefault("subscriptionId")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "subscriptionId", valid_594521
  var valid_594522 = path.getOrDefault("profileName")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "profileName", valid_594522
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of profile to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594523 = query.getOrDefault("api-version")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "api-version", valid_594523
  var valid_594524 = query.getOrDefault("locale-code")
  valid_594524 = validateParameter(valid_594524, JString, required = false,
                                 default = newJString("en-us"))
  if valid_594524 != nil:
    section.add "locale-code", valid_594524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594525: Call_ProfilesGet_594516; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified profile.
  ## 
  let valid = call_594525.validator(path, query, header, formData, body)
  let scheme = call_594525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594525.url(scheme.get, call_594525.host, call_594525.base,
                         call_594525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594525, url, valid)

proc call*(call_594526: Call_ProfilesGet_594516; resourceGroupName: string;
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
  var path_594527 = newJObject()
  var query_594528 = newJObject()
  add(path_594527, "resourceGroupName", newJString(resourceGroupName))
  add(path_594527, "hubName", newJString(hubName))
  add(query_594528, "api-version", newJString(apiVersion))
  add(path_594527, "subscriptionId", newJString(subscriptionId))
  add(query_594528, "locale-code", newJString(localeCode))
  add(path_594527, "profileName", newJString(profileName))
  result = call_594526.call(path_594527, query_594528, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_594516(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}",
                                        validator: validate_ProfilesGet_594517,
                                        base: "", url: url_ProfilesGet_594518,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesDelete_594543 = ref object of OpenApiRestCall_593438
proc url_ProfilesDelete_594545(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesDelete_594544(path: JsonNode; query: JsonNode;
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
  var valid_594546 = path.getOrDefault("resourceGroupName")
  valid_594546 = validateParameter(valid_594546, JString, required = true,
                                 default = nil)
  if valid_594546 != nil:
    section.add "resourceGroupName", valid_594546
  var valid_594547 = path.getOrDefault("hubName")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = nil)
  if valid_594547 != nil:
    section.add "hubName", valid_594547
  var valid_594548 = path.getOrDefault("subscriptionId")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "subscriptionId", valid_594548
  var valid_594549 = path.getOrDefault("profileName")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "profileName", valid_594549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   locale-code: JString
  ##              : Locale of profile to retrieve, default is en-us.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594550 = query.getOrDefault("api-version")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "api-version", valid_594550
  var valid_594551 = query.getOrDefault("locale-code")
  valid_594551 = validateParameter(valid_594551, JString, required = false,
                                 default = newJString("en-us"))
  if valid_594551 != nil:
    section.add "locale-code", valid_594551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594552: Call_ProfilesDelete_594543; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a profile within a hub
  ## 
  let valid = call_594552.validator(path, query, header, formData, body)
  let scheme = call_594552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594552.url(scheme.get, call_594552.host, call_594552.base,
                         call_594552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594552, url, valid)

proc call*(call_594553: Call_ProfilesDelete_594543; resourceGroupName: string;
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
  var path_594554 = newJObject()
  var query_594555 = newJObject()
  add(path_594554, "resourceGroupName", newJString(resourceGroupName))
  add(path_594554, "hubName", newJString(hubName))
  add(query_594555, "api-version", newJString(apiVersion))
  add(path_594554, "subscriptionId", newJString(subscriptionId))
  add(query_594555, "locale-code", newJString(localeCode))
  add(path_594554, "profileName", newJString(profileName))
  result = call_594553.call(path_594554, query_594555, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_594543(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}",
    validator: validate_ProfilesDelete_594544, base: "", url: url_ProfilesDelete_594545,
    schemes: {Scheme.Https})
type
  Call_ProfilesGetEnrichingKpis_594556 = ref object of OpenApiRestCall_593438
proc url_ProfilesGetEnrichingKpis_594558(protocol: Scheme; host: string;
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

proc validate_ProfilesGetEnrichingKpis_594557(path: JsonNode; query: JsonNode;
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
  var valid_594559 = path.getOrDefault("resourceGroupName")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "resourceGroupName", valid_594559
  var valid_594560 = path.getOrDefault("hubName")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "hubName", valid_594560
  var valid_594561 = path.getOrDefault("subscriptionId")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "subscriptionId", valid_594561
  var valid_594562 = path.getOrDefault("profileName")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "profileName", valid_594562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594563 = query.getOrDefault("api-version")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "api-version", valid_594563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594564: Call_ProfilesGetEnrichingKpis_594556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the KPIs that enrich the profile Type identified by the supplied name. Enrichment happens through participants of the Interaction on an Interaction KPI and through Relationships for Profile KPIs.
  ## 
  let valid = call_594564.validator(path, query, header, formData, body)
  let scheme = call_594564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594564.url(scheme.get, call_594564.host, call_594564.base,
                         call_594564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594564, url, valid)

proc call*(call_594565: Call_ProfilesGetEnrichingKpis_594556;
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
  var path_594566 = newJObject()
  var query_594567 = newJObject()
  add(path_594566, "resourceGroupName", newJString(resourceGroupName))
  add(path_594566, "hubName", newJString(hubName))
  add(query_594567, "api-version", newJString(apiVersion))
  add(path_594566, "subscriptionId", newJString(subscriptionId))
  add(path_594566, "profileName", newJString(profileName))
  result = call_594565.call(path_594566, query_594567, nil, nil, nil)

var profilesGetEnrichingKpis* = Call_ProfilesGetEnrichingKpis_594556(
    name: "profilesGetEnrichingKpis", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/profiles/{profileName}/getEnrichingKpis",
    validator: validate_ProfilesGetEnrichingKpis_594557, base: "",
    url: url_ProfilesGetEnrichingKpis_594558, schemes: {Scheme.Https})
type
  Call_RelationshipLinksListByHub_594568 = ref object of OpenApiRestCall_593438
proc url_RelationshipLinksListByHub_594570(protocol: Scheme; host: string;
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

proc validate_RelationshipLinksListByHub_594569(path: JsonNode; query: JsonNode;
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
  var valid_594571 = path.getOrDefault("resourceGroupName")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "resourceGroupName", valid_594571
  var valid_594572 = path.getOrDefault("hubName")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "hubName", valid_594572
  var valid_594573 = path.getOrDefault("subscriptionId")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = nil)
  if valid_594573 != nil:
    section.add "subscriptionId", valid_594573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594574 = query.getOrDefault("api-version")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "api-version", valid_594574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594575: Call_RelationshipLinksListByHub_594568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all relationship links in the hub.
  ## 
  let valid = call_594575.validator(path, query, header, formData, body)
  let scheme = call_594575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594575.url(scheme.get, call_594575.host, call_594575.base,
                         call_594575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594575, url, valid)

proc call*(call_594576: Call_RelationshipLinksListByHub_594568;
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
  var path_594577 = newJObject()
  var query_594578 = newJObject()
  add(path_594577, "resourceGroupName", newJString(resourceGroupName))
  add(path_594577, "hubName", newJString(hubName))
  add(query_594578, "api-version", newJString(apiVersion))
  add(path_594577, "subscriptionId", newJString(subscriptionId))
  result = call_594576.call(path_594577, query_594578, nil, nil, nil)

var relationshipLinksListByHub* = Call_RelationshipLinksListByHub_594568(
    name: "relationshipLinksListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks",
    validator: validate_RelationshipLinksListByHub_594569, base: "",
    url: url_RelationshipLinksListByHub_594570, schemes: {Scheme.Https})
type
  Call_RelationshipLinksCreateOrUpdate_594591 = ref object of OpenApiRestCall_593438
proc url_RelationshipLinksCreateOrUpdate_594593(protocol: Scheme; host: string;
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

proc validate_RelationshipLinksCreateOrUpdate_594592(path: JsonNode;
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
  var valid_594594 = path.getOrDefault("resourceGroupName")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "resourceGroupName", valid_594594
  var valid_594595 = path.getOrDefault("hubName")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "hubName", valid_594595
  var valid_594596 = path.getOrDefault("subscriptionId")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "subscriptionId", valid_594596
  var valid_594597 = path.getOrDefault("relationshipLinkName")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "relationshipLinkName", valid_594597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594598 = query.getOrDefault("api-version")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "api-version", valid_594598
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

proc call*(call_594600: Call_RelationshipLinksCreateOrUpdate_594591;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a relationship link or updates an existing relationship link within a hub.
  ## 
  let valid = call_594600.validator(path, query, header, formData, body)
  let scheme = call_594600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594600.url(scheme.get, call_594600.host, call_594600.base,
                         call_594600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594600, url, valid)

proc call*(call_594601: Call_RelationshipLinksCreateOrUpdate_594591;
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
  var path_594602 = newJObject()
  var query_594603 = newJObject()
  var body_594604 = newJObject()
  add(path_594602, "resourceGroupName", newJString(resourceGroupName))
  add(path_594602, "hubName", newJString(hubName))
  add(query_594603, "api-version", newJString(apiVersion))
  add(path_594602, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594604 = parameters
  add(path_594602, "relationshipLinkName", newJString(relationshipLinkName))
  result = call_594601.call(path_594602, query_594603, nil, nil, body_594604)

var relationshipLinksCreateOrUpdate* = Call_RelationshipLinksCreateOrUpdate_594591(
    name: "relationshipLinksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks/{relationshipLinkName}",
    validator: validate_RelationshipLinksCreateOrUpdate_594592, base: "",
    url: url_RelationshipLinksCreateOrUpdate_594593, schemes: {Scheme.Https})
type
  Call_RelationshipLinksGet_594579 = ref object of OpenApiRestCall_593438
proc url_RelationshipLinksGet_594581(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipLinksGet_594580(path: JsonNode; query: JsonNode;
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
  var valid_594582 = path.getOrDefault("resourceGroupName")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "resourceGroupName", valid_594582
  var valid_594583 = path.getOrDefault("hubName")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "hubName", valid_594583
  var valid_594584 = path.getOrDefault("subscriptionId")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "subscriptionId", valid_594584
  var valid_594585 = path.getOrDefault("relationshipLinkName")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "relationshipLinkName", valid_594585
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594586 = query.getOrDefault("api-version")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "api-version", valid_594586
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594587: Call_RelationshipLinksGet_594579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified relationship Link.
  ## 
  let valid = call_594587.validator(path, query, header, formData, body)
  let scheme = call_594587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594587.url(scheme.get, call_594587.host, call_594587.base,
                         call_594587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594587, url, valid)

proc call*(call_594588: Call_RelationshipLinksGet_594579;
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
  var path_594589 = newJObject()
  var query_594590 = newJObject()
  add(path_594589, "resourceGroupName", newJString(resourceGroupName))
  add(path_594589, "hubName", newJString(hubName))
  add(query_594590, "api-version", newJString(apiVersion))
  add(path_594589, "subscriptionId", newJString(subscriptionId))
  add(path_594589, "relationshipLinkName", newJString(relationshipLinkName))
  result = call_594588.call(path_594589, query_594590, nil, nil, nil)

var relationshipLinksGet* = Call_RelationshipLinksGet_594579(
    name: "relationshipLinksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks/{relationshipLinkName}",
    validator: validate_RelationshipLinksGet_594580, base: "",
    url: url_RelationshipLinksGet_594581, schemes: {Scheme.Https})
type
  Call_RelationshipLinksDelete_594605 = ref object of OpenApiRestCall_593438
proc url_RelationshipLinksDelete_594607(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipLinksDelete_594606(path: JsonNode; query: JsonNode;
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
  var valid_594608 = path.getOrDefault("resourceGroupName")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "resourceGroupName", valid_594608
  var valid_594609 = path.getOrDefault("hubName")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "hubName", valid_594609
  var valid_594610 = path.getOrDefault("subscriptionId")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "subscriptionId", valid_594610
  var valid_594611 = path.getOrDefault("relationshipLinkName")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "relationshipLinkName", valid_594611
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594612 = query.getOrDefault("api-version")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "api-version", valid_594612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594613: Call_RelationshipLinksDelete_594605; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a relationship link within a hub.
  ## 
  let valid = call_594613.validator(path, query, header, formData, body)
  let scheme = call_594613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594613.url(scheme.get, call_594613.host, call_594613.base,
                         call_594613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594613, url, valid)

proc call*(call_594614: Call_RelationshipLinksDelete_594605;
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
  var path_594615 = newJObject()
  var query_594616 = newJObject()
  add(path_594615, "resourceGroupName", newJString(resourceGroupName))
  add(path_594615, "hubName", newJString(hubName))
  add(query_594616, "api-version", newJString(apiVersion))
  add(path_594615, "subscriptionId", newJString(subscriptionId))
  add(path_594615, "relationshipLinkName", newJString(relationshipLinkName))
  result = call_594614.call(path_594615, query_594616, nil, nil, nil)

var relationshipLinksDelete* = Call_RelationshipLinksDelete_594605(
    name: "relationshipLinksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationshipLinks/{relationshipLinkName}",
    validator: validate_RelationshipLinksDelete_594606, base: "",
    url: url_RelationshipLinksDelete_594607, schemes: {Scheme.Https})
type
  Call_RelationshipsListByHub_594617 = ref object of OpenApiRestCall_593438
proc url_RelationshipsListByHub_594619(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipsListByHub_594618(path: JsonNode; query: JsonNode;
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
  var valid_594620 = path.getOrDefault("resourceGroupName")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "resourceGroupName", valid_594620
  var valid_594621 = path.getOrDefault("hubName")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = nil)
  if valid_594621 != nil:
    section.add "hubName", valid_594621
  var valid_594622 = path.getOrDefault("subscriptionId")
  valid_594622 = validateParameter(valid_594622, JString, required = true,
                                 default = nil)
  if valid_594622 != nil:
    section.add "subscriptionId", valid_594622
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594623 = query.getOrDefault("api-version")
  valid_594623 = validateParameter(valid_594623, JString, required = true,
                                 default = nil)
  if valid_594623 != nil:
    section.add "api-version", valid_594623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594624: Call_RelationshipsListByHub_594617; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all relationships in the hub.
  ## 
  let valid = call_594624.validator(path, query, header, formData, body)
  let scheme = call_594624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594624.url(scheme.get, call_594624.host, call_594624.base,
                         call_594624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594624, url, valid)

proc call*(call_594625: Call_RelationshipsListByHub_594617;
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
  var path_594626 = newJObject()
  var query_594627 = newJObject()
  add(path_594626, "resourceGroupName", newJString(resourceGroupName))
  add(path_594626, "hubName", newJString(hubName))
  add(query_594627, "api-version", newJString(apiVersion))
  add(path_594626, "subscriptionId", newJString(subscriptionId))
  result = call_594625.call(path_594626, query_594627, nil, nil, nil)

var relationshipsListByHub* = Call_RelationshipsListByHub_594617(
    name: "relationshipsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships",
    validator: validate_RelationshipsListByHub_594618, base: "",
    url: url_RelationshipsListByHub_594619, schemes: {Scheme.Https})
type
  Call_RelationshipsCreateOrUpdate_594640 = ref object of OpenApiRestCall_593438
proc url_RelationshipsCreateOrUpdate_594642(protocol: Scheme; host: string;
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

proc validate_RelationshipsCreateOrUpdate_594641(path: JsonNode; query: JsonNode;
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
  var valid_594643 = path.getOrDefault("resourceGroupName")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "resourceGroupName", valid_594643
  var valid_594644 = path.getOrDefault("hubName")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "hubName", valid_594644
  var valid_594645 = path.getOrDefault("relationshipName")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = nil)
  if valid_594645 != nil:
    section.add "relationshipName", valid_594645
  var valid_594646 = path.getOrDefault("subscriptionId")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "subscriptionId", valid_594646
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594647 = query.getOrDefault("api-version")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "api-version", valid_594647
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

proc call*(call_594649: Call_RelationshipsCreateOrUpdate_594640; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a relationship or updates an existing relationship within a hub.
  ## 
  let valid = call_594649.validator(path, query, header, formData, body)
  let scheme = call_594649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594649.url(scheme.get, call_594649.host, call_594649.base,
                         call_594649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594649, url, valid)

proc call*(call_594650: Call_RelationshipsCreateOrUpdate_594640;
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
  var path_594651 = newJObject()
  var query_594652 = newJObject()
  var body_594653 = newJObject()
  add(path_594651, "resourceGroupName", newJString(resourceGroupName))
  add(path_594651, "hubName", newJString(hubName))
  add(query_594652, "api-version", newJString(apiVersion))
  add(path_594651, "relationshipName", newJString(relationshipName))
  add(path_594651, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594653 = parameters
  result = call_594650.call(path_594651, query_594652, nil, nil, body_594653)

var relationshipsCreateOrUpdate* = Call_RelationshipsCreateOrUpdate_594640(
    name: "relationshipsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships/{relationshipName}",
    validator: validate_RelationshipsCreateOrUpdate_594641, base: "",
    url: url_RelationshipsCreateOrUpdate_594642, schemes: {Scheme.Https})
type
  Call_RelationshipsGet_594628 = ref object of OpenApiRestCall_593438
proc url_RelationshipsGet_594630(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipsGet_594629(path: JsonNode; query: JsonNode;
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
  var valid_594631 = path.getOrDefault("resourceGroupName")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "resourceGroupName", valid_594631
  var valid_594632 = path.getOrDefault("hubName")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "hubName", valid_594632
  var valid_594633 = path.getOrDefault("relationshipName")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "relationshipName", valid_594633
  var valid_594634 = path.getOrDefault("subscriptionId")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "subscriptionId", valid_594634
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594635 = query.getOrDefault("api-version")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = nil)
  if valid_594635 != nil:
    section.add "api-version", valid_594635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594636: Call_RelationshipsGet_594628; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about the specified relationship.
  ## 
  let valid = call_594636.validator(path, query, header, formData, body)
  let scheme = call_594636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594636.url(scheme.get, call_594636.host, call_594636.base,
                         call_594636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594636, url, valid)

proc call*(call_594637: Call_RelationshipsGet_594628; resourceGroupName: string;
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
  var path_594638 = newJObject()
  var query_594639 = newJObject()
  add(path_594638, "resourceGroupName", newJString(resourceGroupName))
  add(path_594638, "hubName", newJString(hubName))
  add(query_594639, "api-version", newJString(apiVersion))
  add(path_594638, "relationshipName", newJString(relationshipName))
  add(path_594638, "subscriptionId", newJString(subscriptionId))
  result = call_594637.call(path_594638, query_594639, nil, nil, nil)

var relationshipsGet* = Call_RelationshipsGet_594628(name: "relationshipsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships/{relationshipName}",
    validator: validate_RelationshipsGet_594629, base: "",
    url: url_RelationshipsGet_594630, schemes: {Scheme.Https})
type
  Call_RelationshipsDelete_594654 = ref object of OpenApiRestCall_593438
proc url_RelationshipsDelete_594656(protocol: Scheme; host: string; base: string;
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

proc validate_RelationshipsDelete_594655(path: JsonNode; query: JsonNode;
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
  var valid_594657 = path.getOrDefault("resourceGroupName")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "resourceGroupName", valid_594657
  var valid_594658 = path.getOrDefault("hubName")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "hubName", valid_594658
  var valid_594659 = path.getOrDefault("relationshipName")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = nil)
  if valid_594659 != nil:
    section.add "relationshipName", valid_594659
  var valid_594660 = path.getOrDefault("subscriptionId")
  valid_594660 = validateParameter(valid_594660, JString, required = true,
                                 default = nil)
  if valid_594660 != nil:
    section.add "subscriptionId", valid_594660
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594661 = query.getOrDefault("api-version")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "api-version", valid_594661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594662: Call_RelationshipsDelete_594654; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a relationship within a hub.
  ## 
  let valid = call_594662.validator(path, query, header, formData, body)
  let scheme = call_594662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594662.url(scheme.get, call_594662.host, call_594662.base,
                         call_594662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594662, url, valid)

proc call*(call_594663: Call_RelationshipsDelete_594654; resourceGroupName: string;
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
  var path_594664 = newJObject()
  var query_594665 = newJObject()
  add(path_594664, "resourceGroupName", newJString(resourceGroupName))
  add(path_594664, "hubName", newJString(hubName))
  add(query_594665, "api-version", newJString(apiVersion))
  add(path_594664, "relationshipName", newJString(relationshipName))
  add(path_594664, "subscriptionId", newJString(subscriptionId))
  result = call_594663.call(path_594664, query_594665, nil, nil, nil)

var relationshipsDelete* = Call_RelationshipsDelete_594654(
    name: "relationshipsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/relationships/{relationshipName}",
    validator: validate_RelationshipsDelete_594655, base: "",
    url: url_RelationshipsDelete_594656, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListByHub_594666 = ref object of OpenApiRestCall_593438
proc url_RoleAssignmentsListByHub_594668(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsListByHub_594667(path: JsonNode; query: JsonNode;
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
  var valid_594669 = path.getOrDefault("resourceGroupName")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "resourceGroupName", valid_594669
  var valid_594670 = path.getOrDefault("hubName")
  valid_594670 = validateParameter(valid_594670, JString, required = true,
                                 default = nil)
  if valid_594670 != nil:
    section.add "hubName", valid_594670
  var valid_594671 = path.getOrDefault("subscriptionId")
  valid_594671 = validateParameter(valid_594671, JString, required = true,
                                 default = nil)
  if valid_594671 != nil:
    section.add "subscriptionId", valid_594671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594672 = query.getOrDefault("api-version")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = nil)
  if valid_594672 != nil:
    section.add "api-version", valid_594672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594673: Call_RoleAssignmentsListByHub_594666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the role assignments for the specified hub.
  ## 
  let valid = call_594673.validator(path, query, header, formData, body)
  let scheme = call_594673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594673.url(scheme.get, call_594673.host, call_594673.base,
                         call_594673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594673, url, valid)

proc call*(call_594674: Call_RoleAssignmentsListByHub_594666;
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
  var path_594675 = newJObject()
  var query_594676 = newJObject()
  add(path_594675, "resourceGroupName", newJString(resourceGroupName))
  add(path_594675, "hubName", newJString(hubName))
  add(query_594676, "api-version", newJString(apiVersion))
  add(path_594675, "subscriptionId", newJString(subscriptionId))
  result = call_594674.call(path_594675, query_594676, nil, nil, nil)

var roleAssignmentsListByHub* = Call_RoleAssignmentsListByHub_594666(
    name: "roleAssignmentsListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments",
    validator: validate_RoleAssignmentsListByHub_594667, base: "",
    url: url_RoleAssignmentsListByHub_594668, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsCreateOrUpdate_594689 = ref object of OpenApiRestCall_593438
proc url_RoleAssignmentsCreateOrUpdate_594691(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsCreateOrUpdate_594690(path: JsonNode; query: JsonNode;
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
  var valid_594692 = path.getOrDefault("resourceGroupName")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "resourceGroupName", valid_594692
  var valid_594693 = path.getOrDefault("hubName")
  valid_594693 = validateParameter(valid_594693, JString, required = true,
                                 default = nil)
  if valid_594693 != nil:
    section.add "hubName", valid_594693
  var valid_594694 = path.getOrDefault("subscriptionId")
  valid_594694 = validateParameter(valid_594694, JString, required = true,
                                 default = nil)
  if valid_594694 != nil:
    section.add "subscriptionId", valid_594694
  var valid_594695 = path.getOrDefault("assignmentName")
  valid_594695 = validateParameter(valid_594695, JString, required = true,
                                 default = nil)
  if valid_594695 != nil:
    section.add "assignmentName", valid_594695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594696 = query.getOrDefault("api-version")
  valid_594696 = validateParameter(valid_594696, JString, required = true,
                                 default = nil)
  if valid_594696 != nil:
    section.add "api-version", valid_594696
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

proc call*(call_594698: Call_RoleAssignmentsCreateOrUpdate_594689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a role assignment in the hub.
  ## 
  let valid = call_594698.validator(path, query, header, formData, body)
  let scheme = call_594698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594698.url(scheme.get, call_594698.host, call_594698.base,
                         call_594698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594698, url, valid)

proc call*(call_594699: Call_RoleAssignmentsCreateOrUpdate_594689;
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
  var path_594700 = newJObject()
  var query_594701 = newJObject()
  var body_594702 = newJObject()
  add(path_594700, "resourceGroupName", newJString(resourceGroupName))
  add(path_594700, "hubName", newJString(hubName))
  add(query_594701, "api-version", newJString(apiVersion))
  add(path_594700, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594702 = parameters
  add(path_594700, "assignmentName", newJString(assignmentName))
  result = call_594699.call(path_594700, query_594701, nil, nil, body_594702)

var roleAssignmentsCreateOrUpdate* = Call_RoleAssignmentsCreateOrUpdate_594689(
    name: "roleAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments/{assignmentName}",
    validator: validate_RoleAssignmentsCreateOrUpdate_594690, base: "",
    url: url_RoleAssignmentsCreateOrUpdate_594691, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsGet_594677 = ref object of OpenApiRestCall_593438
proc url_RoleAssignmentsGet_594679(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsGet_594678(path: JsonNode; query: JsonNode;
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
  var valid_594680 = path.getOrDefault("resourceGroupName")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "resourceGroupName", valid_594680
  var valid_594681 = path.getOrDefault("hubName")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "hubName", valid_594681
  var valid_594682 = path.getOrDefault("subscriptionId")
  valid_594682 = validateParameter(valid_594682, JString, required = true,
                                 default = nil)
  if valid_594682 != nil:
    section.add "subscriptionId", valid_594682
  var valid_594683 = path.getOrDefault("assignmentName")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "assignmentName", valid_594683
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594684 = query.getOrDefault("api-version")
  valid_594684 = validateParameter(valid_594684, JString, required = true,
                                 default = nil)
  if valid_594684 != nil:
    section.add "api-version", valid_594684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594685: Call_RoleAssignmentsGet_594677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the role assignment in the hub.
  ## 
  let valid = call_594685.validator(path, query, header, formData, body)
  let scheme = call_594685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594685.url(scheme.get, call_594685.host, call_594685.base,
                         call_594685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594685, url, valid)

proc call*(call_594686: Call_RoleAssignmentsGet_594677; resourceGroupName: string;
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
  var path_594687 = newJObject()
  var query_594688 = newJObject()
  add(path_594687, "resourceGroupName", newJString(resourceGroupName))
  add(path_594687, "hubName", newJString(hubName))
  add(query_594688, "api-version", newJString(apiVersion))
  add(path_594687, "subscriptionId", newJString(subscriptionId))
  add(path_594687, "assignmentName", newJString(assignmentName))
  result = call_594686.call(path_594687, query_594688, nil, nil, nil)

var roleAssignmentsGet* = Call_RoleAssignmentsGet_594677(
    name: "roleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments/{assignmentName}",
    validator: validate_RoleAssignmentsGet_594678, base: "",
    url: url_RoleAssignmentsGet_594679, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsDelete_594703 = ref object of OpenApiRestCall_593438
proc url_RoleAssignmentsDelete_594705(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsDelete_594704(path: JsonNode; query: JsonNode;
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
  var valid_594706 = path.getOrDefault("resourceGroupName")
  valid_594706 = validateParameter(valid_594706, JString, required = true,
                                 default = nil)
  if valid_594706 != nil:
    section.add "resourceGroupName", valid_594706
  var valid_594707 = path.getOrDefault("hubName")
  valid_594707 = validateParameter(valid_594707, JString, required = true,
                                 default = nil)
  if valid_594707 != nil:
    section.add "hubName", valid_594707
  var valid_594708 = path.getOrDefault("subscriptionId")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "subscriptionId", valid_594708
  var valid_594709 = path.getOrDefault("assignmentName")
  valid_594709 = validateParameter(valid_594709, JString, required = true,
                                 default = nil)
  if valid_594709 != nil:
    section.add "assignmentName", valid_594709
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594710 = query.getOrDefault("api-version")
  valid_594710 = validateParameter(valid_594710, JString, required = true,
                                 default = nil)
  if valid_594710 != nil:
    section.add "api-version", valid_594710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594711: Call_RoleAssignmentsDelete_594703; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the role assignment in the hub.
  ## 
  let valid = call_594711.validator(path, query, header, formData, body)
  let scheme = call_594711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594711.url(scheme.get, call_594711.host, call_594711.base,
                         call_594711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594711, url, valid)

proc call*(call_594712: Call_RoleAssignmentsDelete_594703;
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
  var path_594713 = newJObject()
  var query_594714 = newJObject()
  add(path_594713, "resourceGroupName", newJString(resourceGroupName))
  add(path_594713, "hubName", newJString(hubName))
  add(query_594714, "api-version", newJString(apiVersion))
  add(path_594713, "subscriptionId", newJString(subscriptionId))
  add(path_594713, "assignmentName", newJString(assignmentName))
  result = call_594712.call(path_594713, query_594714, nil, nil, nil)

var roleAssignmentsDelete* = Call_RoleAssignmentsDelete_594703(
    name: "roleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roleAssignments/{assignmentName}",
    validator: validate_RoleAssignmentsDelete_594704, base: "",
    url: url_RoleAssignmentsDelete_594705, schemes: {Scheme.Https})
type
  Call_RolesListByHub_594715 = ref object of OpenApiRestCall_593438
proc url_RolesListByHub_594717(protocol: Scheme; host: string; base: string;
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

proc validate_RolesListByHub_594716(path: JsonNode; query: JsonNode;
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
  var valid_594718 = path.getOrDefault("resourceGroupName")
  valid_594718 = validateParameter(valid_594718, JString, required = true,
                                 default = nil)
  if valid_594718 != nil:
    section.add "resourceGroupName", valid_594718
  var valid_594719 = path.getOrDefault("hubName")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "hubName", valid_594719
  var valid_594720 = path.getOrDefault("subscriptionId")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "subscriptionId", valid_594720
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594721 = query.getOrDefault("api-version")
  valid_594721 = validateParameter(valid_594721, JString, required = true,
                                 default = nil)
  if valid_594721 != nil:
    section.add "api-version", valid_594721
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594722: Call_RolesListByHub_594715; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the roles for the hub.
  ## 
  let valid = call_594722.validator(path, query, header, formData, body)
  let scheme = call_594722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594722.url(scheme.get, call_594722.host, call_594722.base,
                         call_594722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594722, url, valid)

proc call*(call_594723: Call_RolesListByHub_594715; resourceGroupName: string;
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
  var path_594724 = newJObject()
  var query_594725 = newJObject()
  add(path_594724, "resourceGroupName", newJString(resourceGroupName))
  add(path_594724, "hubName", newJString(hubName))
  add(query_594725, "api-version", newJString(apiVersion))
  add(path_594724, "subscriptionId", newJString(subscriptionId))
  result = call_594723.call(path_594724, query_594725, nil, nil, nil)

var rolesListByHub* = Call_RolesListByHub_594715(name: "rolesListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/roles",
    validator: validate_RolesListByHub_594716, base: "", url: url_RolesListByHub_594717,
    schemes: {Scheme.Https})
type
  Call_ViewsListByHub_594726 = ref object of OpenApiRestCall_593438
proc url_ViewsListByHub_594728(protocol: Scheme; host: string; base: string;
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

proc validate_ViewsListByHub_594727(path: JsonNode; query: JsonNode;
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
  var valid_594729 = path.getOrDefault("resourceGroupName")
  valid_594729 = validateParameter(valid_594729, JString, required = true,
                                 default = nil)
  if valid_594729 != nil:
    section.add "resourceGroupName", valid_594729
  var valid_594730 = path.getOrDefault("hubName")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = nil)
  if valid_594730 != nil:
    section.add "hubName", valid_594730
  var valid_594731 = path.getOrDefault("subscriptionId")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = nil)
  if valid_594731 != nil:
    section.add "subscriptionId", valid_594731
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   userId: JString (required)
  ##         : The user ID. Use * to retrieve hub level views.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594732 = query.getOrDefault("api-version")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "api-version", valid_594732
  var valid_594733 = query.getOrDefault("userId")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "userId", valid_594733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594734: Call_ViewsListByHub_594726; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available views for given user in the specified hub.
  ## 
  let valid = call_594734.validator(path, query, header, formData, body)
  let scheme = call_594734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594734.url(scheme.get, call_594734.host, call_594734.base,
                         call_594734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594734, url, valid)

proc call*(call_594735: Call_ViewsListByHub_594726; resourceGroupName: string;
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
  var path_594736 = newJObject()
  var query_594737 = newJObject()
  add(path_594736, "resourceGroupName", newJString(resourceGroupName))
  add(path_594736, "hubName", newJString(hubName))
  add(query_594737, "api-version", newJString(apiVersion))
  add(path_594736, "subscriptionId", newJString(subscriptionId))
  add(query_594737, "userId", newJString(userId))
  result = call_594735.call(path_594736, query_594737, nil, nil, nil)

var viewsListByHub* = Call_ViewsListByHub_594726(name: "viewsListByHub",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views",
    validator: validate_ViewsListByHub_594727, base: "", url: url_ViewsListByHub_594728,
    schemes: {Scheme.Https})
type
  Call_ViewsCreateOrUpdate_594751 = ref object of OpenApiRestCall_593438
proc url_ViewsCreateOrUpdate_594753(protocol: Scheme; host: string; base: string;
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

proc validate_ViewsCreateOrUpdate_594752(path: JsonNode; query: JsonNode;
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
  var valid_594754 = path.getOrDefault("resourceGroupName")
  valid_594754 = validateParameter(valid_594754, JString, required = true,
                                 default = nil)
  if valid_594754 != nil:
    section.add "resourceGroupName", valid_594754
  var valid_594755 = path.getOrDefault("hubName")
  valid_594755 = validateParameter(valid_594755, JString, required = true,
                                 default = nil)
  if valid_594755 != nil:
    section.add "hubName", valid_594755
  var valid_594756 = path.getOrDefault("viewName")
  valid_594756 = validateParameter(valid_594756, JString, required = true,
                                 default = nil)
  if valid_594756 != nil:
    section.add "viewName", valid_594756
  var valid_594757 = path.getOrDefault("subscriptionId")
  valid_594757 = validateParameter(valid_594757, JString, required = true,
                                 default = nil)
  if valid_594757 != nil:
    section.add "subscriptionId", valid_594757
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594758 = query.getOrDefault("api-version")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = nil)
  if valid_594758 != nil:
    section.add "api-version", valid_594758
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

proc call*(call_594760: Call_ViewsCreateOrUpdate_594751; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a view or updates an existing view in the hub.
  ## 
  let valid = call_594760.validator(path, query, header, formData, body)
  let scheme = call_594760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594760.url(scheme.get, call_594760.host, call_594760.base,
                         call_594760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594760, url, valid)

proc call*(call_594761: Call_ViewsCreateOrUpdate_594751; resourceGroupName: string;
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
  var path_594762 = newJObject()
  var query_594763 = newJObject()
  var body_594764 = newJObject()
  add(path_594762, "resourceGroupName", newJString(resourceGroupName))
  add(path_594762, "hubName", newJString(hubName))
  add(query_594763, "api-version", newJString(apiVersion))
  add(path_594762, "viewName", newJString(viewName))
  add(path_594762, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594764 = parameters
  result = call_594761.call(path_594762, query_594763, nil, nil, body_594764)

var viewsCreateOrUpdate* = Call_ViewsCreateOrUpdate_594751(
    name: "viewsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views/{viewName}",
    validator: validate_ViewsCreateOrUpdate_594752, base: "",
    url: url_ViewsCreateOrUpdate_594753, schemes: {Scheme.Https})
type
  Call_ViewsGet_594738 = ref object of OpenApiRestCall_593438
proc url_ViewsGet_594740(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ViewsGet_594739(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594741 = path.getOrDefault("resourceGroupName")
  valid_594741 = validateParameter(valid_594741, JString, required = true,
                                 default = nil)
  if valid_594741 != nil:
    section.add "resourceGroupName", valid_594741
  var valid_594742 = path.getOrDefault("hubName")
  valid_594742 = validateParameter(valid_594742, JString, required = true,
                                 default = nil)
  if valid_594742 != nil:
    section.add "hubName", valid_594742
  var valid_594743 = path.getOrDefault("viewName")
  valid_594743 = validateParameter(valid_594743, JString, required = true,
                                 default = nil)
  if valid_594743 != nil:
    section.add "viewName", valid_594743
  var valid_594744 = path.getOrDefault("subscriptionId")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "subscriptionId", valid_594744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   userId: JString (required)
  ##         : The user ID. Use * to retrieve hub level view.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594745 = query.getOrDefault("api-version")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = nil)
  if valid_594745 != nil:
    section.add "api-version", valid_594745
  var valid_594746 = query.getOrDefault("userId")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "userId", valid_594746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594747: Call_ViewsGet_594738; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a view in the hub.
  ## 
  let valid = call_594747.validator(path, query, header, formData, body)
  let scheme = call_594747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594747.url(scheme.get, call_594747.host, call_594747.base,
                         call_594747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594747, url, valid)

proc call*(call_594748: Call_ViewsGet_594738; resourceGroupName: string;
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
  var path_594749 = newJObject()
  var query_594750 = newJObject()
  add(path_594749, "resourceGroupName", newJString(resourceGroupName))
  add(path_594749, "hubName", newJString(hubName))
  add(query_594750, "api-version", newJString(apiVersion))
  add(path_594749, "viewName", newJString(viewName))
  add(path_594749, "subscriptionId", newJString(subscriptionId))
  add(query_594750, "userId", newJString(userId))
  result = call_594748.call(path_594749, query_594750, nil, nil, nil)

var viewsGet* = Call_ViewsGet_594738(name: "viewsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views/{viewName}",
                                  validator: validate_ViewsGet_594739, base: "",
                                  url: url_ViewsGet_594740,
                                  schemes: {Scheme.Https})
type
  Call_ViewsDelete_594765 = ref object of OpenApiRestCall_593438
proc url_ViewsDelete_594767(protocol: Scheme; host: string; base: string;
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

proc validate_ViewsDelete_594766(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594768 = path.getOrDefault("resourceGroupName")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "resourceGroupName", valid_594768
  var valid_594769 = path.getOrDefault("hubName")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "hubName", valid_594769
  var valid_594770 = path.getOrDefault("viewName")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "viewName", valid_594770
  var valid_594771 = path.getOrDefault("subscriptionId")
  valid_594771 = validateParameter(valid_594771, JString, required = true,
                                 default = nil)
  if valid_594771 != nil:
    section.add "subscriptionId", valid_594771
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   userId: JString (required)
  ##         : The user ID. Use * to retrieve hub level view.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594772 = query.getOrDefault("api-version")
  valid_594772 = validateParameter(valid_594772, JString, required = true,
                                 default = nil)
  if valid_594772 != nil:
    section.add "api-version", valid_594772
  var valid_594773 = query.getOrDefault("userId")
  valid_594773 = validateParameter(valid_594773, JString, required = true,
                                 default = nil)
  if valid_594773 != nil:
    section.add "userId", valid_594773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594774: Call_ViewsDelete_594765; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a view in the specified hub.
  ## 
  let valid = call_594774.validator(path, query, header, formData, body)
  let scheme = call_594774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594774.url(scheme.get, call_594774.host, call_594774.base,
                         call_594774.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594774, url, valid)

proc call*(call_594775: Call_ViewsDelete_594765; resourceGroupName: string;
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
  var path_594776 = newJObject()
  var query_594777 = newJObject()
  add(path_594776, "resourceGroupName", newJString(resourceGroupName))
  add(path_594776, "hubName", newJString(hubName))
  add(query_594777, "api-version", newJString(apiVersion))
  add(path_594776, "viewName", newJString(viewName))
  add(path_594776, "subscriptionId", newJString(subscriptionId))
  add(query_594777, "userId", newJString(userId))
  result = call_594775.call(path_594776, query_594777, nil, nil, nil)

var viewsDelete* = Call_ViewsDelete_594765(name: "viewsDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/views/{viewName}",
                                        validator: validate_ViewsDelete_594766,
                                        base: "", url: url_ViewsDelete_594767,
                                        schemes: {Scheme.Https})
type
  Call_WidgetTypesListByHub_594778 = ref object of OpenApiRestCall_593438
proc url_WidgetTypesListByHub_594780(protocol: Scheme; host: string; base: string;
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

proc validate_WidgetTypesListByHub_594779(path: JsonNode; query: JsonNode;
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
  var valid_594781 = path.getOrDefault("resourceGroupName")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "resourceGroupName", valid_594781
  var valid_594782 = path.getOrDefault("hubName")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "hubName", valid_594782
  var valid_594783 = path.getOrDefault("subscriptionId")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "subscriptionId", valid_594783
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594784 = query.getOrDefault("api-version")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "api-version", valid_594784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594785: Call_WidgetTypesListByHub_594778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available widget types in the specified hub.
  ## 
  let valid = call_594785.validator(path, query, header, formData, body)
  let scheme = call_594785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594785.url(scheme.get, call_594785.host, call_594785.base,
                         call_594785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594785, url, valid)

proc call*(call_594786: Call_WidgetTypesListByHub_594778;
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
  var path_594787 = newJObject()
  var query_594788 = newJObject()
  add(path_594787, "resourceGroupName", newJString(resourceGroupName))
  add(path_594787, "hubName", newJString(hubName))
  add(query_594788, "api-version", newJString(apiVersion))
  add(path_594787, "subscriptionId", newJString(subscriptionId))
  result = call_594786.call(path_594787, query_594788, nil, nil, nil)

var widgetTypesListByHub* = Call_WidgetTypesListByHub_594778(
    name: "widgetTypesListByHub", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/widgetTypes",
    validator: validate_WidgetTypesListByHub_594779, base: "",
    url: url_WidgetTypesListByHub_594780, schemes: {Scheme.Https})
type
  Call_WidgetTypesGet_594789 = ref object of OpenApiRestCall_593438
proc url_WidgetTypesGet_594791(protocol: Scheme; host: string; base: string;
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

proc validate_WidgetTypesGet_594790(path: JsonNode; query: JsonNode;
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
  var valid_594792 = path.getOrDefault("resourceGroupName")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "resourceGroupName", valid_594792
  var valid_594793 = path.getOrDefault("hubName")
  valid_594793 = validateParameter(valid_594793, JString, required = true,
                                 default = nil)
  if valid_594793 != nil:
    section.add "hubName", valid_594793
  var valid_594794 = path.getOrDefault("subscriptionId")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "subscriptionId", valid_594794
  var valid_594795 = path.getOrDefault("widgetTypeName")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "widgetTypeName", valid_594795
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594796 = query.getOrDefault("api-version")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "api-version", valid_594796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594797: Call_WidgetTypesGet_594789; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a widget type in the specified hub.
  ## 
  let valid = call_594797.validator(path, query, header, formData, body)
  let scheme = call_594797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594797.url(scheme.get, call_594797.host, call_594797.base,
                         call_594797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594797, url, valid)

proc call*(call_594798: Call_WidgetTypesGet_594789; resourceGroupName: string;
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
  var path_594799 = newJObject()
  var query_594800 = newJObject()
  add(path_594799, "resourceGroupName", newJString(resourceGroupName))
  add(path_594799, "hubName", newJString(hubName))
  add(query_594800, "api-version", newJString(apiVersion))
  add(path_594799, "subscriptionId", newJString(subscriptionId))
  add(path_594799, "widgetTypeName", newJString(widgetTypeName))
  result = call_594798.call(path_594799, query_594800, nil, nil, nil)

var widgetTypesGet* = Call_WidgetTypesGet_594789(name: "widgetTypesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomerInsights/hubs/{hubName}/widgetTypes/{widgetTypeName}",
    validator: validate_WidgetTypesGet_594790, base: "", url: url_WidgetTypesGet_594791,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
