
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DevTestLabsClient
## version: 2016-05-15
## termsOfService: (not provided)
## license: (not provided)
## 
## The DevTest Labs Client.
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

  OpenApiRestCall_567650 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567650](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567650): Option[Scheme] {.used.} =
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
  macServiceName = "devtestlabs-DTL"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderOperationsList_567872 = ref object of OpenApiRestCall_567650
proc url_ProviderOperationsList_567874(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsList_567873(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Result of the request to list REST API operations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568046 = query.getOrDefault("api-version")
  valid_568046 = validateParameter(valid_568046, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568046 != nil:
    section.add "api-version", valid_568046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568069: Call_ProviderOperationsList_567872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Result of the request to list REST API operations
  ## 
  let valid = call_568069.validator(path, query, header, formData, body)
  let scheme = call_568069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568069.url(scheme.get, call_568069.host, call_568069.base,
                         call_568069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568069, url, valid)

proc call*(call_568140: Call_ProviderOperationsList_567872;
          apiVersion: string = "2016-05-15"): Recallable =
  ## providerOperationsList
  ## Result of the request to list REST API operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568141 = newJObject()
  add(query_568141, "api-version", newJString(apiVersion))
  result = call_568140.call(nil, query_568141, nil, nil, nil)

var providerOperationsList* = Call_ProviderOperationsList_567872(
    name: "providerOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DevTestLab/operations",
    validator: validate_ProviderOperationsList_567873, base: "",
    url: url_ProviderOperationsList_567874, schemes: {Scheme.Https})
type
  Call_LabsListBySubscription_568181 = ref object of OpenApiRestCall_567650
proc url_LabsListBySubscription_568183(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsListBySubscription_568182(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568199 = path.getOrDefault("subscriptionId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "subscriptionId", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568200 = query.getOrDefault("$orderby")
  valid_568200 = validateParameter(valid_568200, JString, required = false,
                                 default = nil)
  if valid_568200 != nil:
    section.add "$orderby", valid_568200
  var valid_568201 = query.getOrDefault("$expand")
  valid_568201 = validateParameter(valid_568201, JString, required = false,
                                 default = nil)
  if valid_568201 != nil:
    section.add "$expand", valid_568201
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  var valid_568203 = query.getOrDefault("$top")
  valid_568203 = validateParameter(valid_568203, JInt, required = false, default = nil)
  if valid_568203 != nil:
    section.add "$top", valid_568203
  var valid_568204 = query.getOrDefault("$filter")
  valid_568204 = validateParameter(valid_568204, JString, required = false,
                                 default = nil)
  if valid_568204 != nil:
    section.add "$filter", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_LabsListBySubscription_568181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a subscription.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_LabsListBySubscription_568181; subscriptionId: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## labsListBySubscription
  ## List labs in a subscription.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(query_568208, "$orderby", newJString(Orderby))
  add(query_568208, "$expand", newJString(Expand))
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  add(query_568208, "$top", newJInt(Top))
  add(query_568208, "$filter", newJString(Filter))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var labsListBySubscription* = Call_LabsListBySubscription_568181(
    name: "labsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListBySubscription_568182, base: "",
    url: url_LabsListBySubscription_568183, schemes: {Scheme.Https})
type
  Call_OperationsGet_568209 = ref object of OpenApiRestCall_567650
proc url_OperationsGet_568211(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsGet_568210(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   locationName: JString (required)
  ##               : The name of the location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_568212 = path.getOrDefault("name")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "name", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  var valid_568214 = path.getOrDefault("locationName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "locationName", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_OperationsGet_568209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get operation.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_OperationsGet_568209; name: string;
          subscriptionId: string; locationName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## operationsGet
  ## Get operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   locationName: string (required)
  ##               : The name of the location.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "name", newJString(name))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  add(path_568218, "locationName", newJString(locationName))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var operationsGet* = Call_OperationsGet_568209(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/locations/{locationName}/operations/{name}",
    validator: validate_OperationsGet_568210, base: "", url: url_OperationsGet_568211,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListBySubscription_568220 = ref object of OpenApiRestCall_567650
proc url_GlobalSchedulesListBySubscription_568222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesListBySubscription_568221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568223 = path.getOrDefault("subscriptionId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "subscriptionId", valid_568223
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568224 = query.getOrDefault("$orderby")
  valid_568224 = validateParameter(valid_568224, JString, required = false,
                                 default = nil)
  if valid_568224 != nil:
    section.add "$orderby", valid_568224
  var valid_568225 = query.getOrDefault("$expand")
  valid_568225 = validateParameter(valid_568225, JString, required = false,
                                 default = nil)
  if valid_568225 != nil:
    section.add "$expand", valid_568225
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  var valid_568227 = query.getOrDefault("$top")
  valid_568227 = validateParameter(valid_568227, JInt, required = false, default = nil)
  if valid_568227 != nil:
    section.add "$top", valid_568227
  var valid_568228 = query.getOrDefault("$filter")
  valid_568228 = validateParameter(valid_568228, JString, required = false,
                                 default = nil)
  if valid_568228 != nil:
    section.add "$filter", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_GlobalSchedulesListBySubscription_568220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a subscription.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_GlobalSchedulesListBySubscription_568220;
          subscriptionId: string; Orderby: string = ""; Expand: string = "";
          apiVersion: string = "2016-05-15"; Top: int = 0; Filter: string = ""): Recallable =
  ## globalSchedulesListBySubscription
  ## List schedules in a subscription.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  add(query_568232, "$orderby", newJString(Orderby))
  add(query_568232, "$expand", newJString(Expand))
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "subscriptionId", newJString(subscriptionId))
  add(query_568232, "$top", newJInt(Top))
  add(query_568232, "$filter", newJString(Filter))
  result = call_568230.call(path_568231, query_568232, nil, nil, nil)

var globalSchedulesListBySubscription* = Call_GlobalSchedulesListBySubscription_568220(
    name: "globalSchedulesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListBySubscription_568221, base: "",
    url: url_GlobalSchedulesListBySubscription_568222, schemes: {Scheme.Https})
type
  Call_LabsListByResourceGroup_568233 = ref object of OpenApiRestCall_567650
proc url_LabsListByResourceGroup_568235(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsListByResourceGroup_568234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568236 = path.getOrDefault("resourceGroupName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "resourceGroupName", valid_568236
  var valid_568237 = path.getOrDefault("subscriptionId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "subscriptionId", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568238 = query.getOrDefault("$orderby")
  valid_568238 = validateParameter(valid_568238, JString, required = false,
                                 default = nil)
  if valid_568238 != nil:
    section.add "$orderby", valid_568238
  var valid_568239 = query.getOrDefault("$expand")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = nil)
  if valid_568239 != nil:
    section.add "$expand", valid_568239
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  var valid_568241 = query.getOrDefault("$top")
  valid_568241 = validateParameter(valid_568241, JInt, required = false, default = nil)
  if valid_568241 != nil:
    section.add "$top", valid_568241
  var valid_568242 = query.getOrDefault("$filter")
  valid_568242 = validateParameter(valid_568242, JString, required = false,
                                 default = nil)
  if valid_568242 != nil:
    section.add "$filter", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_LabsListByResourceGroup_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a resource group.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_LabsListByResourceGroup_568233;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## labsListByResourceGroup
  ## List labs in a resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(query_568246, "$orderby", newJString(Orderby))
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "$expand", newJString(Expand))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  add(query_568246, "$top", newJInt(Top))
  add(query_568246, "$filter", newJString(Filter))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var labsListByResourceGroup* = Call_LabsListByResourceGroup_568233(
    name: "labsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListByResourceGroup_568234, base: "",
    url: url_LabsListByResourceGroup_568235, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesList_568247 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourcesList_568249(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesList_568248(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List artifact sources in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568250 = path.getOrDefault("resourceGroupName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "resourceGroupName", valid_568250
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  var valid_568252 = path.getOrDefault("labName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "labName", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568253 = query.getOrDefault("$orderby")
  valid_568253 = validateParameter(valid_568253, JString, required = false,
                                 default = nil)
  if valid_568253 != nil:
    section.add "$orderby", valid_568253
  var valid_568254 = query.getOrDefault("$expand")
  valid_568254 = validateParameter(valid_568254, JString, required = false,
                                 default = nil)
  if valid_568254 != nil:
    section.add "$expand", valid_568254
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  var valid_568256 = query.getOrDefault("$top")
  valid_568256 = validateParameter(valid_568256, JInt, required = false, default = nil)
  if valid_568256 != nil:
    section.add "$top", valid_568256
  var valid_568257 = query.getOrDefault("$filter")
  valid_568257 = validateParameter(valid_568257, JString, required = false,
                                 default = nil)
  if valid_568257 != nil:
    section.add "$filter", valid_568257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_ArtifactSourcesList_568247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifact sources in a given lab.
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_ArtifactSourcesList_568247; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## artifactSourcesList
  ## List artifact sources in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  add(query_568261, "$orderby", newJString(Orderby))
  add(path_568260, "resourceGroupName", newJString(resourceGroupName))
  add(query_568261, "$expand", newJString(Expand))
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "subscriptionId", newJString(subscriptionId))
  add(query_568261, "$top", newJInt(Top))
  add(path_568260, "labName", newJString(labName))
  add(query_568261, "$filter", newJString(Filter))
  result = call_568259.call(path_568260, query_568261, nil, nil, nil)

var artifactSourcesList* = Call_ArtifactSourcesList_568247(
    name: "artifactSourcesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources",
    validator: validate_ArtifactSourcesList_568248, base: "",
    url: url_ArtifactSourcesList_568249, schemes: {Scheme.Https})
type
  Call_ArmTemplatesList_568262 = ref object of OpenApiRestCall_567650
proc url_ArmTemplatesList_568264(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/armtemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArmTemplatesList_568263(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List azure resource manager templates in a given artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568265 = path.getOrDefault("resourceGroupName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "resourceGroupName", valid_568265
  var valid_568266 = path.getOrDefault("subscriptionId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "subscriptionId", valid_568266
  var valid_568267 = path.getOrDefault("artifactSourceName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "artifactSourceName", valid_568267
  var valid_568268 = path.getOrDefault("labName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "labName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568269 = query.getOrDefault("$orderby")
  valid_568269 = validateParameter(valid_568269, JString, required = false,
                                 default = nil)
  if valid_568269 != nil:
    section.add "$orderby", valid_568269
  var valid_568270 = query.getOrDefault("$expand")
  valid_568270 = validateParameter(valid_568270, JString, required = false,
                                 default = nil)
  if valid_568270 != nil:
    section.add "$expand", valid_568270
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  var valid_568272 = query.getOrDefault("$top")
  valid_568272 = validateParameter(valid_568272, JInt, required = false, default = nil)
  if valid_568272 != nil:
    section.add "$top", valid_568272
  var valid_568273 = query.getOrDefault("$filter")
  valid_568273 = validateParameter(valid_568273, JString, required = false,
                                 default = nil)
  if valid_568273 != nil:
    section.add "$filter", valid_568273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_ArmTemplatesList_568262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List azure resource manager templates in a given artifact source.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_ArmTemplatesList_568262; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## armTemplatesList
  ## List azure resource manager templates in a given artifact source.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(query_568277, "$orderby", newJString(Orderby))
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "$expand", newJString(Expand))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  add(query_568277, "$top", newJInt(Top))
  add(path_568276, "artifactSourceName", newJString(artifactSourceName))
  add(path_568276, "labName", newJString(labName))
  add(query_568277, "$filter", newJString(Filter))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var armTemplatesList* = Call_ArmTemplatesList_568262(name: "armTemplatesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates",
    validator: validate_ArmTemplatesList_568263, base: "",
    url: url_ArmTemplatesList_568264, schemes: {Scheme.Https})
type
  Call_ArmTemplatesGet_568278 = ref object of OpenApiRestCall_567650
proc url_ArmTemplatesGet_568280(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/armtemplates/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArmTemplatesGet_568279(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get azure resource manager template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the azure Resource Manager template.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("name")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "name", valid_568282
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  var valid_568284 = path.getOrDefault("artifactSourceName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "artifactSourceName", valid_568284
  var valid_568285 = path.getOrDefault("labName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "labName", valid_568285
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568286 = query.getOrDefault("$expand")
  valid_568286 = validateParameter(valid_568286, JString, required = false,
                                 default = nil)
  if valid_568286 != nil:
    section.add "$expand", valid_568286
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_ArmTemplatesGet_568278; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get azure resource manager template.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_ArmTemplatesGet_568278; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
  ## armTemplatesGet
  ## Get azure resource manager template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   name: string (required)
  ##       : The name of the azure Resource Manager template.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "$expand", newJString(Expand))
  add(path_568290, "name", newJString(name))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  add(path_568290, "artifactSourceName", newJString(artifactSourceName))
  add(path_568290, "labName", newJString(labName))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var armTemplatesGet* = Call_ArmTemplatesGet_568278(name: "armTemplatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates/{name}",
    validator: validate_ArmTemplatesGet_568279, base: "", url: url_ArmTemplatesGet_568280,
    schemes: {Scheme.Https})
type
  Call_ArtifactsList_568292 = ref object of OpenApiRestCall_567650
proc url_ArtifactsList_568294(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsList_568293(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts in a given artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568295 = path.getOrDefault("resourceGroupName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "resourceGroupName", valid_568295
  var valid_568296 = path.getOrDefault("subscriptionId")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "subscriptionId", valid_568296
  var valid_568297 = path.getOrDefault("artifactSourceName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "artifactSourceName", valid_568297
  var valid_568298 = path.getOrDefault("labName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "labName", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568299 = query.getOrDefault("$orderby")
  valid_568299 = validateParameter(valid_568299, JString, required = false,
                                 default = nil)
  if valid_568299 != nil:
    section.add "$orderby", valid_568299
  var valid_568300 = query.getOrDefault("$expand")
  valid_568300 = validateParameter(valid_568300, JString, required = false,
                                 default = nil)
  if valid_568300 != nil:
    section.add "$expand", valid_568300
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  var valid_568302 = query.getOrDefault("$top")
  valid_568302 = validateParameter(valid_568302, JInt, required = false, default = nil)
  if valid_568302 != nil:
    section.add "$top", valid_568302
  var valid_568303 = query.getOrDefault("$filter")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "$filter", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568304: Call_ArtifactsList_568292; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts in a given artifact source.
  ## 
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_ArtifactsList_568292; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## artifactsList
  ## List artifacts in a given artifact source.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=title)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  add(query_568307, "$orderby", newJString(Orderby))
  add(path_568306, "resourceGroupName", newJString(resourceGroupName))
  add(query_568307, "$expand", newJString(Expand))
  add(query_568307, "api-version", newJString(apiVersion))
  add(path_568306, "subscriptionId", newJString(subscriptionId))
  add(query_568307, "$top", newJInt(Top))
  add(path_568306, "artifactSourceName", newJString(artifactSourceName))
  add(path_568306, "labName", newJString(labName))
  add(query_568307, "$filter", newJString(Filter))
  result = call_568305.call(path_568306, query_568307, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_568292(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts",
    validator: validate_ArtifactsList_568293, base: "", url: url_ArtifactsList_568294,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGet_568308 = ref object of OpenApiRestCall_567650
proc url_ArtifactsGet_568310(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGet_568309(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("name")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "name", valid_568312
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  var valid_568314 = path.getOrDefault("artifactSourceName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "artifactSourceName", valid_568314
  var valid_568315 = path.getOrDefault("labName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "labName", valid_568315
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568316 = query.getOrDefault("$expand")
  valid_568316 = validateParameter(valid_568316, JString, required = false,
                                 default = nil)
  if valid_568316 != nil:
    section.add "$expand", valid_568316
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_ArtifactsGet_568308; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact.
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_ArtifactsGet_568308; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
  ## artifactsGet
  ## Get artifact.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=title)'
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(query_568321, "$expand", newJString(Expand))
  add(path_568320, "name", newJString(name))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  add(path_568320, "artifactSourceName", newJString(artifactSourceName))
  add(path_568320, "labName", newJString(labName))
  result = call_568319.call(path_568320, query_568321, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_568308(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}",
    validator: validate_ArtifactsGet_568309, base: "", url: url_ArtifactsGet_568310,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGenerateArmTemplate_568322 = ref object of OpenApiRestCall_567650
proc url_ArtifactsGenerateArmTemplate_568324(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "artifactSourceName" in path,
        "`artifactSourceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "artifactSourceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/generateArmTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGenerateArmTemplate_568323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568325 = path.getOrDefault("resourceGroupName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "resourceGroupName", valid_568325
  var valid_568326 = path.getOrDefault("name")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "name", valid_568326
  var valid_568327 = path.getOrDefault("subscriptionId")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "subscriptionId", valid_568327
  var valid_568328 = path.getOrDefault("artifactSourceName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "artifactSourceName", valid_568328
  var valid_568329 = path.getOrDefault("labName")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "labName", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568330 = query.getOrDefault("api-version")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568330 != nil:
    section.add "api-version", valid_568330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   generateArmTemplateRequest: JObject (required)
  ##                             : Parameters for generating an ARM template for deploying artifacts.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568332: Call_ArtifactsGenerateArmTemplate_568322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  let valid = call_568332.validator(path, query, header, formData, body)
  let scheme = call_568332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568332.url(scheme.get, call_568332.host, call_568332.base,
                         call_568332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568332, url, valid)

proc call*(call_568333: Call_ArtifactsGenerateArmTemplate_568322;
          resourceGroupName: string; name: string; subscriptionId: string;
          artifactSourceName: string; labName: string;
          generateArmTemplateRequest: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## artifactsGenerateArmTemplate
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   generateArmTemplateRequest: JObject (required)
  ##                             : Parameters for generating an ARM template for deploying artifacts.
  var path_568334 = newJObject()
  var query_568335 = newJObject()
  var body_568336 = newJObject()
  add(path_568334, "resourceGroupName", newJString(resourceGroupName))
  add(query_568335, "api-version", newJString(apiVersion))
  add(path_568334, "name", newJString(name))
  add(path_568334, "subscriptionId", newJString(subscriptionId))
  add(path_568334, "artifactSourceName", newJString(artifactSourceName))
  add(path_568334, "labName", newJString(labName))
  if generateArmTemplateRequest != nil:
    body_568336 = generateArmTemplateRequest
  result = call_568333.call(path_568334, query_568335, nil, nil, body_568336)

var artifactsGenerateArmTemplate* = Call_ArtifactsGenerateArmTemplate_568322(
    name: "artifactsGenerateArmTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}/generateArmTemplate",
    validator: validate_ArtifactsGenerateArmTemplate_568323, base: "",
    url: url_ArtifactsGenerateArmTemplate_568324, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesCreateOrUpdate_568350 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourcesCreateOrUpdate_568352(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesCreateOrUpdate_568351(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("name")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "name", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  var valid_568356 = path.getOrDefault("labName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "labName", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568359: Call_ArtifactSourcesCreateOrUpdate_568350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing artifact source.
  ## 
  let valid = call_568359.validator(path, query, header, formData, body)
  let scheme = call_568359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568359.url(scheme.get, call_568359.host, call_568359.base,
                         call_568359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568359, url, valid)

proc call*(call_568360: Call_ArtifactSourcesCreateOrUpdate_568350;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## artifactSourcesCreateOrUpdate
  ## Create or replace an existing artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568361 = newJObject()
  var query_568362 = newJObject()
  var body_568363 = newJObject()
  add(path_568361, "resourceGroupName", newJString(resourceGroupName))
  add(query_568362, "api-version", newJString(apiVersion))
  add(path_568361, "name", newJString(name))
  if artifactSource != nil:
    body_568363 = artifactSource
  add(path_568361, "subscriptionId", newJString(subscriptionId))
  add(path_568361, "labName", newJString(labName))
  result = call_568360.call(path_568361, query_568362, nil, nil, body_568363)

var artifactSourcesCreateOrUpdate* = Call_ArtifactSourcesCreateOrUpdate_568350(
    name: "artifactSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesCreateOrUpdate_568351, base: "",
    url: url_ArtifactSourcesCreateOrUpdate_568352, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesGet_568337 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourcesGet_568339(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesGet_568338(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("name")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "name", valid_568341
  var valid_568342 = path.getOrDefault("subscriptionId")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "subscriptionId", valid_568342
  var valid_568343 = path.getOrDefault("labName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "labName", valid_568343
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568344 = query.getOrDefault("$expand")
  valid_568344 = validateParameter(valid_568344, JString, required = false,
                                 default = nil)
  if valid_568344 != nil:
    section.add "$expand", valid_568344
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568345 != nil:
    section.add "api-version", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_ArtifactSourcesGet_568337; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact source.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_ArtifactSourcesGet_568337; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## artifactSourcesGet
  ## Get artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568348 = newJObject()
  var query_568349 = newJObject()
  add(path_568348, "resourceGroupName", newJString(resourceGroupName))
  add(query_568349, "$expand", newJString(Expand))
  add(path_568348, "name", newJString(name))
  add(query_568349, "api-version", newJString(apiVersion))
  add(path_568348, "subscriptionId", newJString(subscriptionId))
  add(path_568348, "labName", newJString(labName))
  result = call_568347.call(path_568348, query_568349, nil, nil, nil)

var artifactSourcesGet* = Call_ArtifactSourcesGet_568337(
    name: "artifactSourcesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesGet_568338, base: "",
    url: url_ArtifactSourcesGet_568339, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesUpdate_568376 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourcesUpdate_568378(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesUpdate_568377(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of artifact sources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568379 = path.getOrDefault("resourceGroupName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "resourceGroupName", valid_568379
  var valid_568380 = path.getOrDefault("name")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "name", valid_568380
  var valid_568381 = path.getOrDefault("subscriptionId")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "subscriptionId", valid_568381
  var valid_568382 = path.getOrDefault("labName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "labName", valid_568382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568383 = query.getOrDefault("api-version")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568383 != nil:
    section.add "api-version", valid_568383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568385: Call_ArtifactSourcesUpdate_568376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of artifact sources.
  ## 
  let valid = call_568385.validator(path, query, header, formData, body)
  let scheme = call_568385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568385.url(scheme.get, call_568385.host, call_568385.base,
                         call_568385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568385, url, valid)

proc call*(call_568386: Call_ArtifactSourcesUpdate_568376;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## artifactSourcesUpdate
  ## Modify properties of artifact sources.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568387 = newJObject()
  var query_568388 = newJObject()
  var body_568389 = newJObject()
  add(path_568387, "resourceGroupName", newJString(resourceGroupName))
  add(query_568388, "api-version", newJString(apiVersion))
  add(path_568387, "name", newJString(name))
  if artifactSource != nil:
    body_568389 = artifactSource
  add(path_568387, "subscriptionId", newJString(subscriptionId))
  add(path_568387, "labName", newJString(labName))
  result = call_568386.call(path_568387, query_568388, nil, nil, body_568389)

var artifactSourcesUpdate* = Call_ArtifactSourcesUpdate_568376(
    name: "artifactSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesUpdate_568377, base: "",
    url: url_ArtifactSourcesUpdate_568378, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesDelete_568364 = ref object of OpenApiRestCall_567650
proc url_ArtifactSourcesDelete_568366(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/artifactsources/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactSourcesDelete_568365(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568367 = path.getOrDefault("resourceGroupName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "resourceGroupName", valid_568367
  var valid_568368 = path.getOrDefault("name")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "name", valid_568368
  var valid_568369 = path.getOrDefault("subscriptionId")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "subscriptionId", valid_568369
  var valid_568370 = path.getOrDefault("labName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "labName", valid_568370
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568371 = query.getOrDefault("api-version")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568371 != nil:
    section.add "api-version", valid_568371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568372: Call_ArtifactSourcesDelete_568364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete artifact source.
  ## 
  let valid = call_568372.validator(path, query, header, formData, body)
  let scheme = call_568372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568372.url(scheme.get, call_568372.host, call_568372.base,
                         call_568372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568372, url, valid)

proc call*(call_568373: Call_ArtifactSourcesDelete_568364;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## artifactSourcesDelete
  ## Delete artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568374 = newJObject()
  var query_568375 = newJObject()
  add(path_568374, "resourceGroupName", newJString(resourceGroupName))
  add(query_568375, "api-version", newJString(apiVersion))
  add(path_568374, "name", newJString(name))
  add(path_568374, "subscriptionId", newJString(subscriptionId))
  add(path_568374, "labName", newJString(labName))
  result = call_568373.call(path_568374, query_568375, nil, nil, nil)

var artifactSourcesDelete* = Call_ArtifactSourcesDelete_568364(
    name: "artifactSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesDelete_568365, base: "",
    url: url_ArtifactSourcesDelete_568366, schemes: {Scheme.Https})
type
  Call_CostsCreateOrUpdate_568403 = ref object of OpenApiRestCall_567650
proc url_CostsCreateOrUpdate_568405(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostsCreateOrUpdate_568404(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing cost.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568406 = path.getOrDefault("resourceGroupName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "resourceGroupName", valid_568406
  var valid_568407 = path.getOrDefault("name")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "name", valid_568407
  var valid_568408 = path.getOrDefault("subscriptionId")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "subscriptionId", valid_568408
  var valid_568409 = path.getOrDefault("labName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "labName", valid_568409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568410 = query.getOrDefault("api-version")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568410 != nil:
    section.add "api-version", valid_568410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labCost: JObject (required)
  ##          : A cost item.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568412: Call_CostsCreateOrUpdate_568403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing cost.
  ## 
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_CostsCreateOrUpdate_568403; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; labCost: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## costsCreateOrUpdate
  ## Create or replace an existing cost.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labCost: JObject (required)
  ##          : A cost item.
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  var body_568416 = newJObject()
  add(path_568414, "resourceGroupName", newJString(resourceGroupName))
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "name", newJString(name))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  add(path_568414, "labName", newJString(labName))
  if labCost != nil:
    body_568416 = labCost
  result = call_568413.call(path_568414, query_568415, nil, nil, body_568416)

var costsCreateOrUpdate* = Call_CostsCreateOrUpdate_568403(
    name: "costsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
    validator: validate_CostsCreateOrUpdate_568404, base: "",
    url: url_CostsCreateOrUpdate_568405, schemes: {Scheme.Https})
type
  Call_CostsGet_568390 = ref object of OpenApiRestCall_567650
proc url_CostsGet_568392(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/costs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CostsGet_568391(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cost.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568393 = path.getOrDefault("resourceGroupName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "resourceGroupName", valid_568393
  var valid_568394 = path.getOrDefault("name")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "name", valid_568394
  var valid_568395 = path.getOrDefault("subscriptionId")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "subscriptionId", valid_568395
  var valid_568396 = path.getOrDefault("labName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "labName", valid_568396
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=labCostDetails)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568397 = query.getOrDefault("$expand")
  valid_568397 = validateParameter(valid_568397, JString, required = false,
                                 default = nil)
  if valid_568397 != nil:
    section.add "$expand", valid_568397
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568398 = query.getOrDefault("api-version")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568398 != nil:
    section.add "api-version", valid_568398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568399: Call_CostsGet_568390; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost.
  ## 
  let valid = call_568399.validator(path, query, header, formData, body)
  let scheme = call_568399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568399.url(scheme.get, call_568399.host, call_568399.base,
                         call_568399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568399, url, valid)

proc call*(call_568400: Call_CostsGet_568390; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## costsGet
  ## Get cost.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=labCostDetails)'
  ##   name: string (required)
  ##       : The name of the cost.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568401 = newJObject()
  var query_568402 = newJObject()
  add(path_568401, "resourceGroupName", newJString(resourceGroupName))
  add(query_568402, "$expand", newJString(Expand))
  add(path_568401, "name", newJString(name))
  add(query_568402, "api-version", newJString(apiVersion))
  add(path_568401, "subscriptionId", newJString(subscriptionId))
  add(path_568401, "labName", newJString(labName))
  result = call_568400.call(path_568401, query_568402, nil, nil, nil)

var costsGet* = Call_CostsGet_568390(name: "costsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
                                  validator: validate_CostsGet_568391, base: "",
                                  url: url_CostsGet_568392,
                                  schemes: {Scheme.Https})
type
  Call_CustomImagesList_568417 = ref object of OpenApiRestCall_567650
proc url_CustomImagesList_568419(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImagesList_568418(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List custom images in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568420 = path.getOrDefault("resourceGroupName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "resourceGroupName", valid_568420
  var valid_568421 = path.getOrDefault("subscriptionId")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "subscriptionId", valid_568421
  var valid_568422 = path.getOrDefault("labName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "labName", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568423 = query.getOrDefault("$orderby")
  valid_568423 = validateParameter(valid_568423, JString, required = false,
                                 default = nil)
  if valid_568423 != nil:
    section.add "$orderby", valid_568423
  var valid_568424 = query.getOrDefault("$expand")
  valid_568424 = validateParameter(valid_568424, JString, required = false,
                                 default = nil)
  if valid_568424 != nil:
    section.add "$expand", valid_568424
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568425 != nil:
    section.add "api-version", valid_568425
  var valid_568426 = query.getOrDefault("$top")
  valid_568426 = validateParameter(valid_568426, JInt, required = false, default = nil)
  if valid_568426 != nil:
    section.add "$top", valid_568426
  var valid_568427 = query.getOrDefault("$filter")
  valid_568427 = validateParameter(valid_568427, JString, required = false,
                                 default = nil)
  if valid_568427 != nil:
    section.add "$filter", valid_568427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568428: Call_CustomImagesList_568417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List custom images in a given lab.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_CustomImagesList_568417; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## customImagesList
  ## List custom images in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=vm)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  add(query_568431, "$orderby", newJString(Orderby))
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(query_568431, "$expand", newJString(Expand))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  add(query_568431, "$top", newJInt(Top))
  add(path_568430, "labName", newJString(labName))
  add(query_568431, "$filter", newJString(Filter))
  result = call_568429.call(path_568430, query_568431, nil, nil, nil)

var customImagesList* = Call_CustomImagesList_568417(name: "customImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages",
    validator: validate_CustomImagesList_568418, base: "",
    url: url_CustomImagesList_568419, schemes: {Scheme.Https})
type
  Call_CustomImagesCreateOrUpdate_568445 = ref object of OpenApiRestCall_567650
proc url_CustomImagesCreateOrUpdate_568447(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImagesCreateOrUpdate_568446(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568448 = path.getOrDefault("resourceGroupName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "resourceGroupName", valid_568448
  var valid_568449 = path.getOrDefault("name")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "name", valid_568449
  var valid_568450 = path.getOrDefault("subscriptionId")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "subscriptionId", valid_568450
  var valid_568451 = path.getOrDefault("labName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "labName", valid_568451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568452 = query.getOrDefault("api-version")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568452 != nil:
    section.add "api-version", valid_568452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customImage: JObject (required)
  ##              : A custom image.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568454: Call_CustomImagesCreateOrUpdate_568445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  let valid = call_568454.validator(path, query, header, formData, body)
  let scheme = call_568454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568454.url(scheme.get, call_568454.host, call_568454.base,
                         call_568454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568454, url, valid)

proc call*(call_568455: Call_CustomImagesCreateOrUpdate_568445;
          resourceGroupName: string; name: string; subscriptionId: string;
          customImage: JsonNode; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## customImagesCreateOrUpdate
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   customImage: JObject (required)
  ##              : A custom image.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568456 = newJObject()
  var query_568457 = newJObject()
  var body_568458 = newJObject()
  add(path_568456, "resourceGroupName", newJString(resourceGroupName))
  add(query_568457, "api-version", newJString(apiVersion))
  add(path_568456, "name", newJString(name))
  add(path_568456, "subscriptionId", newJString(subscriptionId))
  if customImage != nil:
    body_568458 = customImage
  add(path_568456, "labName", newJString(labName))
  result = call_568455.call(path_568456, query_568457, nil, nil, body_568458)

var customImagesCreateOrUpdate* = Call_CustomImagesCreateOrUpdate_568445(
    name: "customImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesCreateOrUpdate_568446, base: "",
    url: url_CustomImagesCreateOrUpdate_568447, schemes: {Scheme.Https})
type
  Call_CustomImagesGet_568432 = ref object of OpenApiRestCall_567650
proc url_CustomImagesGet_568434(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImagesGet_568433(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get custom image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568435 = path.getOrDefault("resourceGroupName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "resourceGroupName", valid_568435
  var valid_568436 = path.getOrDefault("name")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "name", valid_568436
  var valid_568437 = path.getOrDefault("subscriptionId")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "subscriptionId", valid_568437
  var valid_568438 = path.getOrDefault("labName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "labName", valid_568438
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568439 = query.getOrDefault("$expand")
  valid_568439 = validateParameter(valid_568439, JString, required = false,
                                 default = nil)
  if valid_568439 != nil:
    section.add "$expand", valid_568439
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568440 = query.getOrDefault("api-version")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568440 != nil:
    section.add "api-version", valid_568440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568441: Call_CustomImagesGet_568432; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get custom image.
  ## 
  let valid = call_568441.validator(path, query, header, formData, body)
  let scheme = call_568441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568441.url(scheme.get, call_568441.host, call_568441.base,
                         call_568441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568441, url, valid)

proc call*(call_568442: Call_CustomImagesGet_568432; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## customImagesGet
  ## Get custom image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=vm)'
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568443 = newJObject()
  var query_568444 = newJObject()
  add(path_568443, "resourceGroupName", newJString(resourceGroupName))
  add(query_568444, "$expand", newJString(Expand))
  add(path_568443, "name", newJString(name))
  add(query_568444, "api-version", newJString(apiVersion))
  add(path_568443, "subscriptionId", newJString(subscriptionId))
  add(path_568443, "labName", newJString(labName))
  result = call_568442.call(path_568443, query_568444, nil, nil, nil)

var customImagesGet* = Call_CustomImagesGet_568432(name: "customImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesGet_568433, base: "", url: url_CustomImagesGet_568434,
    schemes: {Scheme.Https})
type
  Call_CustomImagesDelete_568459 = ref object of OpenApiRestCall_567650
proc url_CustomImagesDelete_568461(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/customimages/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomImagesDelete_568460(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568462 = path.getOrDefault("resourceGroupName")
  valid_568462 = validateParameter(valid_568462, JString, required = true,
                                 default = nil)
  if valid_568462 != nil:
    section.add "resourceGroupName", valid_568462
  var valid_568463 = path.getOrDefault("name")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "name", valid_568463
  var valid_568464 = path.getOrDefault("subscriptionId")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "subscriptionId", valid_568464
  var valid_568465 = path.getOrDefault("labName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "labName", valid_568465
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568466 = query.getOrDefault("api-version")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568466 != nil:
    section.add "api-version", valid_568466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568467: Call_CustomImagesDelete_568459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  let valid = call_568467.validator(path, query, header, formData, body)
  let scheme = call_568467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568467.url(scheme.get, call_568467.host, call_568467.base,
                         call_568467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568467, url, valid)

proc call*(call_568468: Call_CustomImagesDelete_568459; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## customImagesDelete
  ## Delete custom image. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568469 = newJObject()
  var query_568470 = newJObject()
  add(path_568469, "resourceGroupName", newJString(resourceGroupName))
  add(query_568470, "api-version", newJString(apiVersion))
  add(path_568469, "name", newJString(name))
  add(path_568469, "subscriptionId", newJString(subscriptionId))
  add(path_568469, "labName", newJString(labName))
  result = call_568468.call(path_568469, query_568470, nil, nil, nil)

var customImagesDelete* = Call_CustomImagesDelete_568459(
    name: "customImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesDelete_568460, base: "",
    url: url_CustomImagesDelete_568461, schemes: {Scheme.Https})
type
  Call_FormulasList_568471 = ref object of OpenApiRestCall_567650
proc url_FormulasList_568473(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulasList_568472(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List formulas in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568474 = path.getOrDefault("resourceGroupName")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "resourceGroupName", valid_568474
  var valid_568475 = path.getOrDefault("subscriptionId")
  valid_568475 = validateParameter(valid_568475, JString, required = true,
                                 default = nil)
  if valid_568475 != nil:
    section.add "subscriptionId", valid_568475
  var valid_568476 = path.getOrDefault("labName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "labName", valid_568476
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568477 = query.getOrDefault("$orderby")
  valid_568477 = validateParameter(valid_568477, JString, required = false,
                                 default = nil)
  if valid_568477 != nil:
    section.add "$orderby", valid_568477
  var valid_568478 = query.getOrDefault("$expand")
  valid_568478 = validateParameter(valid_568478, JString, required = false,
                                 default = nil)
  if valid_568478 != nil:
    section.add "$expand", valid_568478
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568479 = query.getOrDefault("api-version")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568479 != nil:
    section.add "api-version", valid_568479
  var valid_568480 = query.getOrDefault("$top")
  valid_568480 = validateParameter(valid_568480, JInt, required = false, default = nil)
  if valid_568480 != nil:
    section.add "$top", valid_568480
  var valid_568481 = query.getOrDefault("$filter")
  valid_568481 = validateParameter(valid_568481, JString, required = false,
                                 default = nil)
  if valid_568481 != nil:
    section.add "$filter", valid_568481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568482: Call_FormulasList_568471; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List formulas in a given lab.
  ## 
  let valid = call_568482.validator(path, query, header, formData, body)
  let scheme = call_568482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568482.url(scheme.get, call_568482.host, call_568482.base,
                         call_568482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568482, url, valid)

proc call*(call_568483: Call_FormulasList_568471; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## formulasList
  ## List formulas in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568484 = newJObject()
  var query_568485 = newJObject()
  add(query_568485, "$orderby", newJString(Orderby))
  add(path_568484, "resourceGroupName", newJString(resourceGroupName))
  add(query_568485, "$expand", newJString(Expand))
  add(query_568485, "api-version", newJString(apiVersion))
  add(path_568484, "subscriptionId", newJString(subscriptionId))
  add(query_568485, "$top", newJInt(Top))
  add(path_568484, "labName", newJString(labName))
  add(query_568485, "$filter", newJString(Filter))
  result = call_568483.call(path_568484, query_568485, nil, nil, nil)

var formulasList* = Call_FormulasList_568471(name: "formulasList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas",
    validator: validate_FormulasList_568472, base: "", url: url_FormulasList_568473,
    schemes: {Scheme.Https})
type
  Call_FormulasCreateOrUpdate_568499 = ref object of OpenApiRestCall_567650
proc url_FormulasCreateOrUpdate_568501(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulasCreateOrUpdate_568500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568502 = path.getOrDefault("resourceGroupName")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "resourceGroupName", valid_568502
  var valid_568503 = path.getOrDefault("name")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "name", valid_568503
  var valid_568504 = path.getOrDefault("subscriptionId")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "subscriptionId", valid_568504
  var valid_568505 = path.getOrDefault("labName")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "labName", valid_568505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568506 = query.getOrDefault("api-version")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568506 != nil:
    section.add "api-version", valid_568506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   formula: JObject (required)
  ##          : A formula for creating a VM, specifying an image base and other parameters
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568508: Call_FormulasCreateOrUpdate_568499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  let valid = call_568508.validator(path, query, header, formData, body)
  let scheme = call_568508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568508.url(scheme.get, call_568508.host, call_568508.base,
                         call_568508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568508, url, valid)

proc call*(call_568509: Call_FormulasCreateOrUpdate_568499;
          resourceGroupName: string; formula: JsonNode; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## formulasCreateOrUpdate
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   formula: JObject (required)
  ##          : A formula for creating a VM, specifying an image base and other parameters
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568510 = newJObject()
  var query_568511 = newJObject()
  var body_568512 = newJObject()
  add(path_568510, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_568512 = formula
  add(query_568511, "api-version", newJString(apiVersion))
  add(path_568510, "name", newJString(name))
  add(path_568510, "subscriptionId", newJString(subscriptionId))
  add(path_568510, "labName", newJString(labName))
  result = call_568509.call(path_568510, query_568511, nil, nil, body_568512)

var formulasCreateOrUpdate* = Call_FormulasCreateOrUpdate_568499(
    name: "formulasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasCreateOrUpdate_568500, base: "",
    url: url_FormulasCreateOrUpdate_568501, schemes: {Scheme.Https})
type
  Call_FormulasGet_568486 = ref object of OpenApiRestCall_567650
proc url_FormulasGet_568488(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulasGet_568487(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568489 = path.getOrDefault("resourceGroupName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "resourceGroupName", valid_568489
  var valid_568490 = path.getOrDefault("name")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "name", valid_568490
  var valid_568491 = path.getOrDefault("subscriptionId")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "subscriptionId", valid_568491
  var valid_568492 = path.getOrDefault("labName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "labName", valid_568492
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568493 = query.getOrDefault("$expand")
  valid_568493 = validateParameter(valid_568493, JString, required = false,
                                 default = nil)
  if valid_568493 != nil:
    section.add "$expand", valid_568493
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568494 = query.getOrDefault("api-version")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568494 != nil:
    section.add "api-version", valid_568494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568495: Call_FormulasGet_568486; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get formula.
  ## 
  let valid = call_568495.validator(path, query, header, formData, body)
  let scheme = call_568495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568495.url(scheme.get, call_568495.host, call_568495.base,
                         call_568495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568495, url, valid)

proc call*(call_568496: Call_FormulasGet_568486; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## formulasGet
  ## Get formula.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   name: string (required)
  ##       : The name of the formula.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568497 = newJObject()
  var query_568498 = newJObject()
  add(path_568497, "resourceGroupName", newJString(resourceGroupName))
  add(query_568498, "$expand", newJString(Expand))
  add(path_568497, "name", newJString(name))
  add(query_568498, "api-version", newJString(apiVersion))
  add(path_568497, "subscriptionId", newJString(subscriptionId))
  add(path_568497, "labName", newJString(labName))
  result = call_568496.call(path_568497, query_568498, nil, nil, nil)

var formulasGet* = Call_FormulasGet_568486(name: "formulasGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
                                        validator: validate_FormulasGet_568487,
                                        base: "", url: url_FormulasGet_568488,
                                        schemes: {Scheme.Https})
type
  Call_FormulasDelete_568513 = ref object of OpenApiRestCall_567650
proc url_FormulasDelete_568515(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/formulas/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FormulasDelete_568514(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568516 = path.getOrDefault("resourceGroupName")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "resourceGroupName", valid_568516
  var valid_568517 = path.getOrDefault("name")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "name", valid_568517
  var valid_568518 = path.getOrDefault("subscriptionId")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "subscriptionId", valid_568518
  var valid_568519 = path.getOrDefault("labName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "labName", valid_568519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568520 = query.getOrDefault("api-version")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568520 != nil:
    section.add "api-version", valid_568520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568521: Call_FormulasDelete_568513; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete formula.
  ## 
  let valid = call_568521.validator(path, query, header, formData, body)
  let scheme = call_568521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568521.url(scheme.get, call_568521.host, call_568521.base,
                         call_568521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568521, url, valid)

proc call*(call_568522: Call_FormulasDelete_568513; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## formulasDelete
  ## Delete formula.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568523 = newJObject()
  var query_568524 = newJObject()
  add(path_568523, "resourceGroupName", newJString(resourceGroupName))
  add(query_568524, "api-version", newJString(apiVersion))
  add(path_568523, "name", newJString(name))
  add(path_568523, "subscriptionId", newJString(subscriptionId))
  add(path_568523, "labName", newJString(labName))
  result = call_568522.call(path_568523, query_568524, nil, nil, nil)

var formulasDelete* = Call_FormulasDelete_568513(name: "formulasDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasDelete_568514, base: "", url: url_FormulasDelete_568515,
    schemes: {Scheme.Https})
type
  Call_GalleryImagesList_568525 = ref object of OpenApiRestCall_567650
proc url_GalleryImagesList_568527(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/galleryimages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryImagesList_568526(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List gallery images in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568528 = path.getOrDefault("resourceGroupName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceGroupName", valid_568528
  var valid_568529 = path.getOrDefault("subscriptionId")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "subscriptionId", valid_568529
  var valid_568530 = path.getOrDefault("labName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "labName", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568531 = query.getOrDefault("$orderby")
  valid_568531 = validateParameter(valid_568531, JString, required = false,
                                 default = nil)
  if valid_568531 != nil:
    section.add "$orderby", valid_568531
  var valid_568532 = query.getOrDefault("$expand")
  valid_568532 = validateParameter(valid_568532, JString, required = false,
                                 default = nil)
  if valid_568532 != nil:
    section.add "$expand", valid_568532
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568533 = query.getOrDefault("api-version")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568533 != nil:
    section.add "api-version", valid_568533
  var valid_568534 = query.getOrDefault("$top")
  valid_568534 = validateParameter(valid_568534, JInt, required = false, default = nil)
  if valid_568534 != nil:
    section.add "$top", valid_568534
  var valid_568535 = query.getOrDefault("$filter")
  valid_568535 = validateParameter(valid_568535, JString, required = false,
                                 default = nil)
  if valid_568535 != nil:
    section.add "$filter", valid_568535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568536: Call_GalleryImagesList_568525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images in a given lab.
  ## 
  let valid = call_568536.validator(path, query, header, formData, body)
  let scheme = call_568536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568536.url(scheme.get, call_568536.host, call_568536.base,
                         call_568536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568536, url, valid)

proc call*(call_568537: Call_GalleryImagesList_568525; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## galleryImagesList
  ## List gallery images in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568538 = newJObject()
  var query_568539 = newJObject()
  add(query_568539, "$orderby", newJString(Orderby))
  add(path_568538, "resourceGroupName", newJString(resourceGroupName))
  add(query_568539, "$expand", newJString(Expand))
  add(query_568539, "api-version", newJString(apiVersion))
  add(path_568538, "subscriptionId", newJString(subscriptionId))
  add(query_568539, "$top", newJInt(Top))
  add(path_568538, "labName", newJString(labName))
  add(query_568539, "$filter", newJString(Filter))
  result = call_568537.call(path_568538, query_568539, nil, nil, nil)

var galleryImagesList* = Call_GalleryImagesList_568525(name: "galleryImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/galleryimages",
    validator: validate_GalleryImagesList_568526, base: "",
    url: url_GalleryImagesList_568527, schemes: {Scheme.Https})
type
  Call_NotificationChannelsList_568540 = ref object of OpenApiRestCall_567650
proc url_NotificationChannelsList_568542(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsList_568541(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List notification channels in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568543 = path.getOrDefault("resourceGroupName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "resourceGroupName", valid_568543
  var valid_568544 = path.getOrDefault("subscriptionId")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "subscriptionId", valid_568544
  var valid_568545 = path.getOrDefault("labName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "labName", valid_568545
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568546 = query.getOrDefault("$orderby")
  valid_568546 = validateParameter(valid_568546, JString, required = false,
                                 default = nil)
  if valid_568546 != nil:
    section.add "$orderby", valid_568546
  var valid_568547 = query.getOrDefault("$expand")
  valid_568547 = validateParameter(valid_568547, JString, required = false,
                                 default = nil)
  if valid_568547 != nil:
    section.add "$expand", valid_568547
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568548 = query.getOrDefault("api-version")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568548 != nil:
    section.add "api-version", valid_568548
  var valid_568549 = query.getOrDefault("$top")
  valid_568549 = validateParameter(valid_568549, JInt, required = false, default = nil)
  if valid_568549 != nil:
    section.add "$top", valid_568549
  var valid_568550 = query.getOrDefault("$filter")
  valid_568550 = validateParameter(valid_568550, JString, required = false,
                                 default = nil)
  if valid_568550 != nil:
    section.add "$filter", valid_568550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568551: Call_NotificationChannelsList_568540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List notification channels in a given lab.
  ## 
  let valid = call_568551.validator(path, query, header, formData, body)
  let scheme = call_568551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568551.url(scheme.get, call_568551.host, call_568551.base,
                         call_568551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568551, url, valid)

proc call*(call_568552: Call_NotificationChannelsList_568540;
          resourceGroupName: string; subscriptionId: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## notificationChannelsList
  ## List notification channels in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568553 = newJObject()
  var query_568554 = newJObject()
  add(query_568554, "$orderby", newJString(Orderby))
  add(path_568553, "resourceGroupName", newJString(resourceGroupName))
  add(query_568554, "$expand", newJString(Expand))
  add(query_568554, "api-version", newJString(apiVersion))
  add(path_568553, "subscriptionId", newJString(subscriptionId))
  add(query_568554, "$top", newJInt(Top))
  add(path_568553, "labName", newJString(labName))
  add(query_568554, "$filter", newJString(Filter))
  result = call_568552.call(path_568553, query_568554, nil, nil, nil)

var notificationChannelsList* = Call_NotificationChannelsList_568540(
    name: "notificationChannelsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels",
    validator: validate_NotificationChannelsList_568541, base: "",
    url: url_NotificationChannelsList_568542, schemes: {Scheme.Https})
type
  Call_NotificationChannelsCreateOrUpdate_568568 = ref object of OpenApiRestCall_567650
proc url_NotificationChannelsCreateOrUpdate_568570(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsCreateOrUpdate_568569(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing notificationChannel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568571 = path.getOrDefault("resourceGroupName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "resourceGroupName", valid_568571
  var valid_568572 = path.getOrDefault("name")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "name", valid_568572
  var valid_568573 = path.getOrDefault("subscriptionId")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "subscriptionId", valid_568573
  var valid_568574 = path.getOrDefault("labName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "labName", valid_568574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568575 = query.getOrDefault("api-version")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568575 != nil:
    section.add "api-version", valid_568575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568577: Call_NotificationChannelsCreateOrUpdate_568568;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing notificationChannel.
  ## 
  let valid = call_568577.validator(path, query, header, formData, body)
  let scheme = call_568577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568577.url(scheme.get, call_568577.host, call_568577.base,
                         call_568577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568577, url, valid)

proc call*(call_568578: Call_NotificationChannelsCreateOrUpdate_568568;
          notificationChannel: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsCreateOrUpdate
  ## Create or replace an existing notificationChannel.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568579 = newJObject()
  var query_568580 = newJObject()
  var body_568581 = newJObject()
  if notificationChannel != nil:
    body_568581 = notificationChannel
  add(path_568579, "resourceGroupName", newJString(resourceGroupName))
  add(query_568580, "api-version", newJString(apiVersion))
  add(path_568579, "name", newJString(name))
  add(path_568579, "subscriptionId", newJString(subscriptionId))
  add(path_568579, "labName", newJString(labName))
  result = call_568578.call(path_568579, query_568580, nil, nil, body_568581)

var notificationChannelsCreateOrUpdate* = Call_NotificationChannelsCreateOrUpdate_568568(
    name: "notificationChannelsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsCreateOrUpdate_568569, base: "",
    url: url_NotificationChannelsCreateOrUpdate_568570, schemes: {Scheme.Https})
type
  Call_NotificationChannelsGet_568555 = ref object of OpenApiRestCall_567650
proc url_NotificationChannelsGet_568557(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsGet_568556(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get notification channels.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568558 = path.getOrDefault("resourceGroupName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "resourceGroupName", valid_568558
  var valid_568559 = path.getOrDefault("name")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "name", valid_568559
  var valid_568560 = path.getOrDefault("subscriptionId")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "subscriptionId", valid_568560
  var valid_568561 = path.getOrDefault("labName")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "labName", valid_568561
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568562 = query.getOrDefault("$expand")
  valid_568562 = validateParameter(valid_568562, JString, required = false,
                                 default = nil)
  if valid_568562 != nil:
    section.add "$expand", valid_568562
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568563 = query.getOrDefault("api-version")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568563 != nil:
    section.add "api-version", valid_568563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568564: Call_NotificationChannelsGet_568555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get notification channels.
  ## 
  let valid = call_568564.validator(path, query, header, formData, body)
  let scheme = call_568564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568564.url(scheme.get, call_568564.host, call_568564.base,
                         call_568564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568564, url, valid)

proc call*(call_568565: Call_NotificationChannelsGet_568555;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsGet
  ## Get notification channels.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568566 = newJObject()
  var query_568567 = newJObject()
  add(path_568566, "resourceGroupName", newJString(resourceGroupName))
  add(query_568567, "$expand", newJString(Expand))
  add(path_568566, "name", newJString(name))
  add(query_568567, "api-version", newJString(apiVersion))
  add(path_568566, "subscriptionId", newJString(subscriptionId))
  add(path_568566, "labName", newJString(labName))
  result = call_568565.call(path_568566, query_568567, nil, nil, nil)

var notificationChannelsGet* = Call_NotificationChannelsGet_568555(
    name: "notificationChannelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsGet_568556, base: "",
    url: url_NotificationChannelsGet_568557, schemes: {Scheme.Https})
type
  Call_NotificationChannelsUpdate_568594 = ref object of OpenApiRestCall_567650
proc url_NotificationChannelsUpdate_568596(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsUpdate_568595(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of notification channels.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568597 = path.getOrDefault("resourceGroupName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "resourceGroupName", valid_568597
  var valid_568598 = path.getOrDefault("name")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "name", valid_568598
  var valid_568599 = path.getOrDefault("subscriptionId")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "subscriptionId", valid_568599
  var valid_568600 = path.getOrDefault("labName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "labName", valid_568600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568601 = query.getOrDefault("api-version")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568601 != nil:
    section.add "api-version", valid_568601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568603: Call_NotificationChannelsUpdate_568594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of notification channels.
  ## 
  let valid = call_568603.validator(path, query, header, formData, body)
  let scheme = call_568603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568603.url(scheme.get, call_568603.host, call_568603.base,
                         call_568603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568603, url, valid)

proc call*(call_568604: Call_NotificationChannelsUpdate_568594;
          notificationChannel: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsUpdate
  ## Modify properties of notification channels.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568605 = newJObject()
  var query_568606 = newJObject()
  var body_568607 = newJObject()
  if notificationChannel != nil:
    body_568607 = notificationChannel
  add(path_568605, "resourceGroupName", newJString(resourceGroupName))
  add(query_568606, "api-version", newJString(apiVersion))
  add(path_568605, "name", newJString(name))
  add(path_568605, "subscriptionId", newJString(subscriptionId))
  add(path_568605, "labName", newJString(labName))
  result = call_568604.call(path_568605, query_568606, nil, nil, body_568607)

var notificationChannelsUpdate* = Call_NotificationChannelsUpdate_568594(
    name: "notificationChannelsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsUpdate_568595, base: "",
    url: url_NotificationChannelsUpdate_568596, schemes: {Scheme.Https})
type
  Call_NotificationChannelsDelete_568582 = ref object of OpenApiRestCall_567650
proc url_NotificationChannelsDelete_568584(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsDelete_568583(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568585 = path.getOrDefault("resourceGroupName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "resourceGroupName", valid_568585
  var valid_568586 = path.getOrDefault("name")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "name", valid_568586
  var valid_568587 = path.getOrDefault("subscriptionId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "subscriptionId", valid_568587
  var valid_568588 = path.getOrDefault("labName")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "labName", valid_568588
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568589 = query.getOrDefault("api-version")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568589 != nil:
    section.add "api-version", valid_568589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568590: Call_NotificationChannelsDelete_568582; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete notification channel.
  ## 
  let valid = call_568590.validator(path, query, header, formData, body)
  let scheme = call_568590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568590.url(scheme.get, call_568590.host, call_568590.base,
                         call_568590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568590, url, valid)

proc call*(call_568591: Call_NotificationChannelsDelete_568582;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsDelete
  ## Delete notification channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568592 = newJObject()
  var query_568593 = newJObject()
  add(path_568592, "resourceGroupName", newJString(resourceGroupName))
  add(query_568593, "api-version", newJString(apiVersion))
  add(path_568592, "name", newJString(name))
  add(path_568592, "subscriptionId", newJString(subscriptionId))
  add(path_568592, "labName", newJString(labName))
  result = call_568591.call(path_568592, query_568593, nil, nil, nil)

var notificationChannelsDelete* = Call_NotificationChannelsDelete_568582(
    name: "notificationChannelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsDelete_568583, base: "",
    url: url_NotificationChannelsDelete_568584, schemes: {Scheme.Https})
type
  Call_NotificationChannelsNotify_568608 = ref object of OpenApiRestCall_567650
proc url_NotificationChannelsNotify_568610(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/notificationchannels/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationChannelsNotify_568609(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send notification to provided channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568611 = path.getOrDefault("resourceGroupName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "resourceGroupName", valid_568611
  var valid_568612 = path.getOrDefault("name")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "name", valid_568612
  var valid_568613 = path.getOrDefault("subscriptionId")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "subscriptionId", valid_568613
  var valid_568614 = path.getOrDefault("labName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "labName", valid_568614
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568615 = query.getOrDefault("api-version")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568615 != nil:
    section.add "api-version", valid_568615
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   notifyParameters: JObject (required)
  ##                   : Properties for generating a Notification.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568617: Call_NotificationChannelsNotify_568608; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send notification to provided channel.
  ## 
  let valid = call_568617.validator(path, query, header, formData, body)
  let scheme = call_568617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568617.url(scheme.get, call_568617.host, call_568617.base,
                         call_568617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568617, url, valid)

proc call*(call_568618: Call_NotificationChannelsNotify_568608;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; notifyParameters: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsNotify
  ## Send notification to provided channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   notifyParameters: JObject (required)
  ##                   : Properties for generating a Notification.
  var path_568619 = newJObject()
  var query_568620 = newJObject()
  var body_568621 = newJObject()
  add(path_568619, "resourceGroupName", newJString(resourceGroupName))
  add(query_568620, "api-version", newJString(apiVersion))
  add(path_568619, "name", newJString(name))
  add(path_568619, "subscriptionId", newJString(subscriptionId))
  add(path_568619, "labName", newJString(labName))
  if notifyParameters != nil:
    body_568621 = notifyParameters
  result = call_568618.call(path_568619, query_568620, nil, nil, body_568621)

var notificationChannelsNotify* = Call_NotificationChannelsNotify_568608(
    name: "notificationChannelsNotify", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}/notify",
    validator: validate_NotificationChannelsNotify_568609, base: "",
    url: url_NotificationChannelsNotify_568610, schemes: {Scheme.Https})
type
  Call_PolicySetsEvaluatePolicies_568622 = ref object of OpenApiRestCall_567650
proc url_PolicySetsEvaluatePolicies_568624(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/evaluatePolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicySetsEvaluatePolicies_568623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Evaluates lab policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568625 = path.getOrDefault("resourceGroupName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "resourceGroupName", valid_568625
  var valid_568626 = path.getOrDefault("name")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "name", valid_568626
  var valid_568627 = path.getOrDefault("subscriptionId")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "subscriptionId", valid_568627
  var valid_568628 = path.getOrDefault("labName")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "labName", valid_568628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568629 = query.getOrDefault("api-version")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568629 != nil:
    section.add "api-version", valid_568629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   evaluatePoliciesRequest: JObject (required)
  ##                          : Request body for evaluating a policy set.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568631: Call_PolicySetsEvaluatePolicies_568622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Evaluates lab policy.
  ## 
  let valid = call_568631.validator(path, query, header, formData, body)
  let scheme = call_568631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568631.url(scheme.get, call_568631.host, call_568631.base,
                         call_568631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568631, url, valid)

proc call*(call_568632: Call_PolicySetsEvaluatePolicies_568622;
          resourceGroupName: string; name: string; subscriptionId: string;
          evaluatePoliciesRequest: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## policySetsEvaluatePolicies
  ## Evaluates lab policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   evaluatePoliciesRequest: JObject (required)
  ##                          : Request body for evaluating a policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568633 = newJObject()
  var query_568634 = newJObject()
  var body_568635 = newJObject()
  add(path_568633, "resourceGroupName", newJString(resourceGroupName))
  add(query_568634, "api-version", newJString(apiVersion))
  add(path_568633, "name", newJString(name))
  add(path_568633, "subscriptionId", newJString(subscriptionId))
  if evaluatePoliciesRequest != nil:
    body_568635 = evaluatePoliciesRequest
  add(path_568633, "labName", newJString(labName))
  result = call_568632.call(path_568633, query_568634, nil, nil, body_568635)

var policySetsEvaluatePolicies* = Call_PolicySetsEvaluatePolicies_568622(
    name: "policySetsEvaluatePolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{name}/evaluatePolicies",
    validator: validate_PolicySetsEvaluatePolicies_568623, base: "",
    url: url_PolicySetsEvaluatePolicies_568624, schemes: {Scheme.Https})
type
  Call_PoliciesList_568636 = ref object of OpenApiRestCall_567650
proc url_PoliciesList_568638(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesList_568637(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List policies in a given policy set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568639 = path.getOrDefault("resourceGroupName")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "resourceGroupName", valid_568639
  var valid_568640 = path.getOrDefault("subscriptionId")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "subscriptionId", valid_568640
  var valid_568641 = path.getOrDefault("policySetName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "policySetName", valid_568641
  var valid_568642 = path.getOrDefault("labName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "labName", valid_568642
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568643 = query.getOrDefault("$orderby")
  valid_568643 = validateParameter(valid_568643, JString, required = false,
                                 default = nil)
  if valid_568643 != nil:
    section.add "$orderby", valid_568643
  var valid_568644 = query.getOrDefault("$expand")
  valid_568644 = validateParameter(valid_568644, JString, required = false,
                                 default = nil)
  if valid_568644 != nil:
    section.add "$expand", valid_568644
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568645 = query.getOrDefault("api-version")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568645 != nil:
    section.add "api-version", valid_568645
  var valid_568646 = query.getOrDefault("$top")
  valid_568646 = validateParameter(valid_568646, JInt, required = false, default = nil)
  if valid_568646 != nil:
    section.add "$top", valid_568646
  var valid_568647 = query.getOrDefault("$filter")
  valid_568647 = validateParameter(valid_568647, JString, required = false,
                                 default = nil)
  if valid_568647 != nil:
    section.add "$filter", valid_568647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568648: Call_PoliciesList_568636; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List policies in a given policy set.
  ## 
  let valid = call_568648.validator(path, query, header, formData, body)
  let scheme = call_568648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568648.url(scheme.get, call_568648.host, call_568648.base,
                         call_568648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568648, url, valid)

proc call*(call_568649: Call_PoliciesList_568636; resourceGroupName: string;
          subscriptionId: string; policySetName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## policiesList
  ## List policies in a given policy set.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568650 = newJObject()
  var query_568651 = newJObject()
  add(query_568651, "$orderby", newJString(Orderby))
  add(path_568650, "resourceGroupName", newJString(resourceGroupName))
  add(query_568651, "$expand", newJString(Expand))
  add(query_568651, "api-version", newJString(apiVersion))
  add(path_568650, "subscriptionId", newJString(subscriptionId))
  add(query_568651, "$top", newJInt(Top))
  add(path_568650, "policySetName", newJString(policySetName))
  add(path_568650, "labName", newJString(labName))
  add(query_568651, "$filter", newJString(Filter))
  result = call_568649.call(path_568650, query_568651, nil, nil, nil)

var policiesList* = Call_PoliciesList_568636(name: "policiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies",
    validator: validate_PoliciesList_568637, base: "", url: url_PoliciesList_568638,
    schemes: {Scheme.Https})
type
  Call_PoliciesCreateOrUpdate_568666 = ref object of OpenApiRestCall_567650
proc url_PoliciesCreateOrUpdate_568668(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesCreateOrUpdate_568667(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568669 = path.getOrDefault("resourceGroupName")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "resourceGroupName", valid_568669
  var valid_568670 = path.getOrDefault("name")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "name", valid_568670
  var valid_568671 = path.getOrDefault("subscriptionId")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "subscriptionId", valid_568671
  var valid_568672 = path.getOrDefault("policySetName")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "policySetName", valid_568672
  var valid_568673 = path.getOrDefault("labName")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "labName", valid_568673
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568674 = query.getOrDefault("api-version")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568674 != nil:
    section.add "api-version", valid_568674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   policy: JObject (required)
  ##         : A Policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568676: Call_PoliciesCreateOrUpdate_568666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing policy.
  ## 
  let valid = call_568676.validator(path, query, header, formData, body)
  let scheme = call_568676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568676.url(scheme.get, call_568676.host, call_568676.base,
                         call_568676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568676, url, valid)

proc call*(call_568677: Call_PoliciesCreateOrUpdate_568666;
          resourceGroupName: string; name: string; subscriptionId: string;
          policySetName: string; labName: string; policy: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## policiesCreateOrUpdate
  ## Create or replace an existing policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   policy: JObject (required)
  ##         : A Policy.
  var path_568678 = newJObject()
  var query_568679 = newJObject()
  var body_568680 = newJObject()
  add(path_568678, "resourceGroupName", newJString(resourceGroupName))
  add(query_568679, "api-version", newJString(apiVersion))
  add(path_568678, "name", newJString(name))
  add(path_568678, "subscriptionId", newJString(subscriptionId))
  add(path_568678, "policySetName", newJString(policySetName))
  add(path_568678, "labName", newJString(labName))
  if policy != nil:
    body_568680 = policy
  result = call_568677.call(path_568678, query_568679, nil, nil, body_568680)

var policiesCreateOrUpdate* = Call_PoliciesCreateOrUpdate_568666(
    name: "policiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesCreateOrUpdate_568667, base: "",
    url: url_PoliciesCreateOrUpdate_568668, schemes: {Scheme.Https})
type
  Call_PoliciesGet_568652 = ref object of OpenApiRestCall_567650
proc url_PoliciesGet_568654(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesGet_568653(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568655 = path.getOrDefault("resourceGroupName")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "resourceGroupName", valid_568655
  var valid_568656 = path.getOrDefault("name")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "name", valid_568656
  var valid_568657 = path.getOrDefault("subscriptionId")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "subscriptionId", valid_568657
  var valid_568658 = path.getOrDefault("policySetName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "policySetName", valid_568658
  var valid_568659 = path.getOrDefault("labName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "labName", valid_568659
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568660 = query.getOrDefault("$expand")
  valid_568660 = validateParameter(valid_568660, JString, required = false,
                                 default = nil)
  if valid_568660 != nil:
    section.add "$expand", valid_568660
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568661 = query.getOrDefault("api-version")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568661 != nil:
    section.add "api-version", valid_568661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568662: Call_PoliciesGet_568652; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get policy.
  ## 
  let valid = call_568662.validator(path, query, header, formData, body)
  let scheme = call_568662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568662.url(scheme.get, call_568662.host, call_568662.base,
                         call_568662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568662, url, valid)

proc call*(call_568663: Call_PoliciesGet_568652; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
  ## policiesGet
  ## Get policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   name: string (required)
  ##       : The name of the policy.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568664 = newJObject()
  var query_568665 = newJObject()
  add(path_568664, "resourceGroupName", newJString(resourceGroupName))
  add(query_568665, "$expand", newJString(Expand))
  add(path_568664, "name", newJString(name))
  add(query_568665, "api-version", newJString(apiVersion))
  add(path_568664, "subscriptionId", newJString(subscriptionId))
  add(path_568664, "policySetName", newJString(policySetName))
  add(path_568664, "labName", newJString(labName))
  result = call_568663.call(path_568664, query_568665, nil, nil, nil)

var policiesGet* = Call_PoliciesGet_568652(name: "policiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
                                        validator: validate_PoliciesGet_568653,
                                        base: "", url: url_PoliciesGet_568654,
                                        schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_568694 = ref object of OpenApiRestCall_567650
proc url_PoliciesUpdate_568696(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesUpdate_568695(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Modify properties of policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568697 = path.getOrDefault("resourceGroupName")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "resourceGroupName", valid_568697
  var valid_568698 = path.getOrDefault("name")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "name", valid_568698
  var valid_568699 = path.getOrDefault("subscriptionId")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "subscriptionId", valid_568699
  var valid_568700 = path.getOrDefault("policySetName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "policySetName", valid_568700
  var valid_568701 = path.getOrDefault("labName")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "labName", valid_568701
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568702 = query.getOrDefault("api-version")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568702 != nil:
    section.add "api-version", valid_568702
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   policy: JObject (required)
  ##         : A Policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568704: Call_PoliciesUpdate_568694; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of policies.
  ## 
  let valid = call_568704.validator(path, query, header, formData, body)
  let scheme = call_568704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568704.url(scheme.get, call_568704.host, call_568704.base,
                         call_568704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568704, url, valid)

proc call*(call_568705: Call_PoliciesUpdate_568694; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; policy: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## policiesUpdate
  ## Modify properties of policies.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   policy: JObject (required)
  ##         : A Policy.
  var path_568706 = newJObject()
  var query_568707 = newJObject()
  var body_568708 = newJObject()
  add(path_568706, "resourceGroupName", newJString(resourceGroupName))
  add(query_568707, "api-version", newJString(apiVersion))
  add(path_568706, "name", newJString(name))
  add(path_568706, "subscriptionId", newJString(subscriptionId))
  add(path_568706, "policySetName", newJString(policySetName))
  add(path_568706, "labName", newJString(labName))
  if policy != nil:
    body_568708 = policy
  result = call_568705.call(path_568706, query_568707, nil, nil, body_568708)

var policiesUpdate* = Call_PoliciesUpdate_568694(name: "policiesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesUpdate_568695, base: "", url: url_PoliciesUpdate_568696,
    schemes: {Scheme.Https})
type
  Call_PoliciesDelete_568681 = ref object of OpenApiRestCall_567650
proc url_PoliciesDelete_568683(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "policySetName" in path, "`policySetName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/policysets/"),
               (kind: VariableSegment, value: "policySetName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesDelete_568682(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568684 = path.getOrDefault("resourceGroupName")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "resourceGroupName", valid_568684
  var valid_568685 = path.getOrDefault("name")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "name", valid_568685
  var valid_568686 = path.getOrDefault("subscriptionId")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "subscriptionId", valid_568686
  var valid_568687 = path.getOrDefault("policySetName")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "policySetName", valid_568687
  var valid_568688 = path.getOrDefault("labName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "labName", valid_568688
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568689 = query.getOrDefault("api-version")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568689 != nil:
    section.add "api-version", valid_568689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568690: Call_PoliciesDelete_568681; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy.
  ## 
  let valid = call_568690.validator(path, query, header, formData, body)
  let scheme = call_568690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568690.url(scheme.get, call_568690.host, call_568690.base,
                         call_568690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568690, url, valid)

proc call*(call_568691: Call_PoliciesDelete_568681; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## policiesDelete
  ## Delete policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568692 = newJObject()
  var query_568693 = newJObject()
  add(path_568692, "resourceGroupName", newJString(resourceGroupName))
  add(query_568693, "api-version", newJString(apiVersion))
  add(path_568692, "name", newJString(name))
  add(path_568692, "subscriptionId", newJString(subscriptionId))
  add(path_568692, "policySetName", newJString(policySetName))
  add(path_568692, "labName", newJString(labName))
  result = call_568691.call(path_568692, query_568693, nil, nil, nil)

var policiesDelete* = Call_PoliciesDelete_568681(name: "policiesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesDelete_568682, base: "", url: url_PoliciesDelete_568683,
    schemes: {Scheme.Https})
type
  Call_SchedulesList_568709 = ref object of OpenApiRestCall_567650
proc url_SchedulesList_568711(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesList_568710(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568712 = path.getOrDefault("resourceGroupName")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "resourceGroupName", valid_568712
  var valid_568713 = path.getOrDefault("subscriptionId")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "subscriptionId", valid_568713
  var valid_568714 = path.getOrDefault("labName")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "labName", valid_568714
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568715 = query.getOrDefault("$orderby")
  valid_568715 = validateParameter(valid_568715, JString, required = false,
                                 default = nil)
  if valid_568715 != nil:
    section.add "$orderby", valid_568715
  var valid_568716 = query.getOrDefault("$expand")
  valid_568716 = validateParameter(valid_568716, JString, required = false,
                                 default = nil)
  if valid_568716 != nil:
    section.add "$expand", valid_568716
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568717 = query.getOrDefault("api-version")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568717 != nil:
    section.add "api-version", valid_568717
  var valid_568718 = query.getOrDefault("$top")
  valid_568718 = validateParameter(valid_568718, JInt, required = false, default = nil)
  if valid_568718 != nil:
    section.add "$top", valid_568718
  var valid_568719 = query.getOrDefault("$filter")
  valid_568719 = validateParameter(valid_568719, JString, required = false,
                                 default = nil)
  if valid_568719 != nil:
    section.add "$filter", valid_568719
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568720: Call_SchedulesList_568709; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given lab.
  ## 
  let valid = call_568720.validator(path, query, header, formData, body)
  let scheme = call_568720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568720.url(scheme.get, call_568720.host, call_568720.base,
                         call_568720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568720, url, valid)

proc call*(call_568721: Call_SchedulesList_568709; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## schedulesList
  ## List schedules in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568722 = newJObject()
  var query_568723 = newJObject()
  add(query_568723, "$orderby", newJString(Orderby))
  add(path_568722, "resourceGroupName", newJString(resourceGroupName))
  add(query_568723, "$expand", newJString(Expand))
  add(query_568723, "api-version", newJString(apiVersion))
  add(path_568722, "subscriptionId", newJString(subscriptionId))
  add(query_568723, "$top", newJInt(Top))
  add(path_568722, "labName", newJString(labName))
  add(query_568723, "$filter", newJString(Filter))
  result = call_568721.call(path_568722, query_568723, nil, nil, nil)

var schedulesList* = Call_SchedulesList_568709(name: "schedulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules",
    validator: validate_SchedulesList_568710, base: "", url: url_SchedulesList_568711,
    schemes: {Scheme.Https})
type
  Call_SchedulesCreateOrUpdate_568737 = ref object of OpenApiRestCall_567650
proc url_SchedulesCreateOrUpdate_568739(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesCreateOrUpdate_568738(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568740 = path.getOrDefault("resourceGroupName")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "resourceGroupName", valid_568740
  var valid_568741 = path.getOrDefault("name")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "name", valid_568741
  var valid_568742 = path.getOrDefault("subscriptionId")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "subscriptionId", valid_568742
  var valid_568743 = path.getOrDefault("labName")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = nil)
  if valid_568743 != nil:
    section.add "labName", valid_568743
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568744 = query.getOrDefault("api-version")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568744 != nil:
    section.add "api-version", valid_568744
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568746: Call_SchedulesCreateOrUpdate_568737; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_568746.validator(path, query, header, formData, body)
  let scheme = call_568746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568746.url(scheme.get, call_568746.host, call_568746.base,
                         call_568746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568746, url, valid)

proc call*(call_568747: Call_SchedulesCreateOrUpdate_568737;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; schedule: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_568748 = newJObject()
  var query_568749 = newJObject()
  var body_568750 = newJObject()
  add(path_568748, "resourceGroupName", newJString(resourceGroupName))
  add(query_568749, "api-version", newJString(apiVersion))
  add(path_568748, "name", newJString(name))
  add(path_568748, "subscriptionId", newJString(subscriptionId))
  add(path_568748, "labName", newJString(labName))
  if schedule != nil:
    body_568750 = schedule
  result = call_568747.call(path_568748, query_568749, nil, nil, body_568750)

var schedulesCreateOrUpdate* = Call_SchedulesCreateOrUpdate_568737(
    name: "schedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesCreateOrUpdate_568738, base: "",
    url: url_SchedulesCreateOrUpdate_568739, schemes: {Scheme.Https})
type
  Call_SchedulesGet_568724 = ref object of OpenApiRestCall_567650
proc url_SchedulesGet_568726(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesGet_568725(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568727 = path.getOrDefault("resourceGroupName")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "resourceGroupName", valid_568727
  var valid_568728 = path.getOrDefault("name")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "name", valid_568728
  var valid_568729 = path.getOrDefault("subscriptionId")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "subscriptionId", valid_568729
  var valid_568730 = path.getOrDefault("labName")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "labName", valid_568730
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568731 = query.getOrDefault("$expand")
  valid_568731 = validateParameter(valid_568731, JString, required = false,
                                 default = nil)
  if valid_568731 != nil:
    section.add "$expand", valid_568731
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568732 = query.getOrDefault("api-version")
  valid_568732 = validateParameter(valid_568732, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568732 != nil:
    section.add "api-version", valid_568732
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568733: Call_SchedulesGet_568724; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_568733.validator(path, query, header, formData, body)
  let scheme = call_568733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568733.url(scheme.get, call_568733.host, call_568733.base,
                         call_568733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568733, url, valid)

proc call*(call_568734: Call_SchedulesGet_568724; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesGet
  ## Get schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568735 = newJObject()
  var query_568736 = newJObject()
  add(path_568735, "resourceGroupName", newJString(resourceGroupName))
  add(query_568736, "$expand", newJString(Expand))
  add(path_568735, "name", newJString(name))
  add(query_568736, "api-version", newJString(apiVersion))
  add(path_568735, "subscriptionId", newJString(subscriptionId))
  add(path_568735, "labName", newJString(labName))
  result = call_568734.call(path_568735, query_568736, nil, nil, nil)

var schedulesGet* = Call_SchedulesGet_568724(name: "schedulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesGet_568725, base: "", url: url_SchedulesGet_568726,
    schemes: {Scheme.Https})
type
  Call_SchedulesUpdate_568763 = ref object of OpenApiRestCall_567650
proc url_SchedulesUpdate_568765(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesUpdate_568764(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Modify properties of schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568766 = path.getOrDefault("resourceGroupName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "resourceGroupName", valid_568766
  var valid_568767 = path.getOrDefault("name")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "name", valid_568767
  var valid_568768 = path.getOrDefault("subscriptionId")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "subscriptionId", valid_568768
  var valid_568769 = path.getOrDefault("labName")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "labName", valid_568769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568770 = query.getOrDefault("api-version")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568770 != nil:
    section.add "api-version", valid_568770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568772: Call_SchedulesUpdate_568763; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_568772.validator(path, query, header, formData, body)
  let scheme = call_568772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568772.url(scheme.get, call_568772.host, call_568772.base,
                         call_568772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568772, url, valid)

proc call*(call_568773: Call_SchedulesUpdate_568763; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesUpdate
  ## Modify properties of schedules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_568774 = newJObject()
  var query_568775 = newJObject()
  var body_568776 = newJObject()
  add(path_568774, "resourceGroupName", newJString(resourceGroupName))
  add(query_568775, "api-version", newJString(apiVersion))
  add(path_568774, "name", newJString(name))
  add(path_568774, "subscriptionId", newJString(subscriptionId))
  add(path_568774, "labName", newJString(labName))
  if schedule != nil:
    body_568776 = schedule
  result = call_568773.call(path_568774, query_568775, nil, nil, body_568776)

var schedulesUpdate* = Call_SchedulesUpdate_568763(name: "schedulesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesUpdate_568764, base: "", url: url_SchedulesUpdate_568765,
    schemes: {Scheme.Https})
type
  Call_SchedulesDelete_568751 = ref object of OpenApiRestCall_567650
proc url_SchedulesDelete_568753(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesDelete_568752(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568754 = path.getOrDefault("resourceGroupName")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "resourceGroupName", valid_568754
  var valid_568755 = path.getOrDefault("name")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "name", valid_568755
  var valid_568756 = path.getOrDefault("subscriptionId")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "subscriptionId", valid_568756
  var valid_568757 = path.getOrDefault("labName")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "labName", valid_568757
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568758 = query.getOrDefault("api-version")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568758 != nil:
    section.add "api-version", valid_568758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568759: Call_SchedulesDelete_568751; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_568759.validator(path, query, header, formData, body)
  let scheme = call_568759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568759.url(scheme.get, call_568759.host, call_568759.base,
                         call_568759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568759, url, valid)

proc call*(call_568760: Call_SchedulesDelete_568751; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesDelete
  ## Delete schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568761 = newJObject()
  var query_568762 = newJObject()
  add(path_568761, "resourceGroupName", newJString(resourceGroupName))
  add(query_568762, "api-version", newJString(apiVersion))
  add(path_568761, "name", newJString(name))
  add(path_568761, "subscriptionId", newJString(subscriptionId))
  add(path_568761, "labName", newJString(labName))
  result = call_568760.call(path_568761, query_568762, nil, nil, nil)

var schedulesDelete* = Call_SchedulesDelete_568751(name: "schedulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesDelete_568752, base: "", url: url_SchedulesDelete_568753,
    schemes: {Scheme.Https})
type
  Call_SchedulesExecute_568777 = ref object of OpenApiRestCall_567650
proc url_SchedulesExecute_568779(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesExecute_568778(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568780 = path.getOrDefault("resourceGroupName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "resourceGroupName", valid_568780
  var valid_568781 = path.getOrDefault("name")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "name", valid_568781
  var valid_568782 = path.getOrDefault("subscriptionId")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "subscriptionId", valid_568782
  var valid_568783 = path.getOrDefault("labName")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "labName", valid_568783
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568784 = query.getOrDefault("api-version")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568784 != nil:
    section.add "api-version", valid_568784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568785: Call_SchedulesExecute_568777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_568785.validator(path, query, header, formData, body)
  let scheme = call_568785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568785.url(scheme.get, call_568785.host, call_568785.base,
                         call_568785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568785, url, valid)

proc call*(call_568786: Call_SchedulesExecute_568777; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568787 = newJObject()
  var query_568788 = newJObject()
  add(path_568787, "resourceGroupName", newJString(resourceGroupName))
  add(query_568788, "api-version", newJString(apiVersion))
  add(path_568787, "name", newJString(name))
  add(path_568787, "subscriptionId", newJString(subscriptionId))
  add(path_568787, "labName", newJString(labName))
  result = call_568786.call(path_568787, query_568788, nil, nil, nil)

var schedulesExecute* = Call_SchedulesExecute_568777(name: "schedulesExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/execute",
    validator: validate_SchedulesExecute_568778, base: "",
    url: url_SchedulesExecute_568779, schemes: {Scheme.Https})
type
  Call_SchedulesListApplicable_568789 = ref object of OpenApiRestCall_567650
proc url_SchedulesListApplicable_568791(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listApplicable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SchedulesListApplicable_568790(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all applicable schedules
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568792 = path.getOrDefault("resourceGroupName")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "resourceGroupName", valid_568792
  var valid_568793 = path.getOrDefault("name")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "name", valid_568793
  var valid_568794 = path.getOrDefault("subscriptionId")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "subscriptionId", valid_568794
  var valid_568795 = path.getOrDefault("labName")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = nil)
  if valid_568795 != nil:
    section.add "labName", valid_568795
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568796 = query.getOrDefault("api-version")
  valid_568796 = validateParameter(valid_568796, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568796 != nil:
    section.add "api-version", valid_568796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568797: Call_SchedulesListApplicable_568789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all applicable schedules
  ## 
  let valid = call_568797.validator(path, query, header, formData, body)
  let scheme = call_568797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568797.url(scheme.get, call_568797.host, call_568797.base,
                         call_568797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568797, url, valid)

proc call*(call_568798: Call_SchedulesListApplicable_568789;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesListApplicable
  ## Lists all applicable schedules
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568799 = newJObject()
  var query_568800 = newJObject()
  add(path_568799, "resourceGroupName", newJString(resourceGroupName))
  add(query_568800, "api-version", newJString(apiVersion))
  add(path_568799, "name", newJString(name))
  add(path_568799, "subscriptionId", newJString(subscriptionId))
  add(path_568799, "labName", newJString(labName))
  result = call_568798.call(path_568799, query_568800, nil, nil, nil)

var schedulesListApplicable* = Call_SchedulesListApplicable_568789(
    name: "schedulesListApplicable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/listApplicable",
    validator: validate_SchedulesListApplicable_568790, base: "",
    url: url_SchedulesListApplicable_568791, schemes: {Scheme.Https})
type
  Call_ServiceRunnersList_568801 = ref object of OpenApiRestCall_567650
proc url_ServiceRunnersList_568803(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/servicerunners")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceRunnersList_568802(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List service runners in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568804 = path.getOrDefault("resourceGroupName")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "resourceGroupName", valid_568804
  var valid_568805 = path.getOrDefault("subscriptionId")
  valid_568805 = validateParameter(valid_568805, JString, required = true,
                                 default = nil)
  if valid_568805 != nil:
    section.add "subscriptionId", valid_568805
  var valid_568806 = path.getOrDefault("labName")
  valid_568806 = validateParameter(valid_568806, JString, required = true,
                                 default = nil)
  if valid_568806 != nil:
    section.add "labName", valid_568806
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568807 = query.getOrDefault("$orderby")
  valid_568807 = validateParameter(valid_568807, JString, required = false,
                                 default = nil)
  if valid_568807 != nil:
    section.add "$orderby", valid_568807
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568808 = query.getOrDefault("api-version")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568808 != nil:
    section.add "api-version", valid_568808
  var valid_568809 = query.getOrDefault("$top")
  valid_568809 = validateParameter(valid_568809, JInt, required = false, default = nil)
  if valid_568809 != nil:
    section.add "$top", valid_568809
  var valid_568810 = query.getOrDefault("$filter")
  valid_568810 = validateParameter(valid_568810, JString, required = false,
                                 default = nil)
  if valid_568810 != nil:
    section.add "$filter", valid_568810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568811: Call_ServiceRunnersList_568801; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List service runners in a given lab.
  ## 
  let valid = call_568811.validator(path, query, header, formData, body)
  let scheme = call_568811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568811.url(scheme.get, call_568811.host, call_568811.base,
                         call_568811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568811, url, valid)

proc call*(call_568812: Call_ServiceRunnersList_568801; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          apiVersion: string = "2016-05-15"; Top: int = 0; Filter: string = ""): Recallable =
  ## serviceRunnersList
  ## List service runners in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568813 = newJObject()
  var query_568814 = newJObject()
  add(query_568814, "$orderby", newJString(Orderby))
  add(path_568813, "resourceGroupName", newJString(resourceGroupName))
  add(query_568814, "api-version", newJString(apiVersion))
  add(path_568813, "subscriptionId", newJString(subscriptionId))
  add(query_568814, "$top", newJInt(Top))
  add(path_568813, "labName", newJString(labName))
  add(query_568814, "$filter", newJString(Filter))
  result = call_568812.call(path_568813, query_568814, nil, nil, nil)

var serviceRunnersList* = Call_ServiceRunnersList_568801(
    name: "serviceRunnersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners",
    validator: validate_ServiceRunnersList_568802, base: "",
    url: url_ServiceRunnersList_568803, schemes: {Scheme.Https})
type
  Call_ServiceRunnersCreateOrUpdate_568827 = ref object of OpenApiRestCall_567650
proc url_ServiceRunnersCreateOrUpdate_568829(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/servicerunners/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceRunnersCreateOrUpdate_568828(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Service runner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service runner.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568830 = path.getOrDefault("resourceGroupName")
  valid_568830 = validateParameter(valid_568830, JString, required = true,
                                 default = nil)
  if valid_568830 != nil:
    section.add "resourceGroupName", valid_568830
  var valid_568831 = path.getOrDefault("name")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = nil)
  if valid_568831 != nil:
    section.add "name", valid_568831
  var valid_568832 = path.getOrDefault("subscriptionId")
  valid_568832 = validateParameter(valid_568832, JString, required = true,
                                 default = nil)
  if valid_568832 != nil:
    section.add "subscriptionId", valid_568832
  var valid_568833 = path.getOrDefault("labName")
  valid_568833 = validateParameter(valid_568833, JString, required = true,
                                 default = nil)
  if valid_568833 != nil:
    section.add "labName", valid_568833
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568834 = query.getOrDefault("api-version")
  valid_568834 = validateParameter(valid_568834, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568834 != nil:
    section.add "api-version", valid_568834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceRunner: JObject (required)
  ##                : A container for a managed identity to execute DevTest lab services.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568836: Call_ServiceRunnersCreateOrUpdate_568827; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Service runner.
  ## 
  let valid = call_568836.validator(path, query, header, formData, body)
  let scheme = call_568836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568836.url(scheme.get, call_568836.host, call_568836.base,
                         call_568836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568836, url, valid)

proc call*(call_568837: Call_ServiceRunnersCreateOrUpdate_568827;
          resourceGroupName: string; name: string; subscriptionId: string;
          serviceRunner: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## serviceRunnersCreateOrUpdate
  ## Create or replace an existing Service runner.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service runner.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   serviceRunner: JObject (required)
  ##                : A container for a managed identity to execute DevTest lab services.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568838 = newJObject()
  var query_568839 = newJObject()
  var body_568840 = newJObject()
  add(path_568838, "resourceGroupName", newJString(resourceGroupName))
  add(query_568839, "api-version", newJString(apiVersion))
  add(path_568838, "name", newJString(name))
  add(path_568838, "subscriptionId", newJString(subscriptionId))
  if serviceRunner != nil:
    body_568840 = serviceRunner
  add(path_568838, "labName", newJString(labName))
  result = call_568837.call(path_568838, query_568839, nil, nil, body_568840)

var serviceRunnersCreateOrUpdate* = Call_ServiceRunnersCreateOrUpdate_568827(
    name: "serviceRunnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersCreateOrUpdate_568828, base: "",
    url: url_ServiceRunnersCreateOrUpdate_568829, schemes: {Scheme.Https})
type
  Call_ServiceRunnersGet_568815 = ref object of OpenApiRestCall_567650
proc url_ServiceRunnersGet_568817(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/servicerunners/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceRunnersGet_568816(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get service runner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service runner.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568818 = path.getOrDefault("resourceGroupName")
  valid_568818 = validateParameter(valid_568818, JString, required = true,
                                 default = nil)
  if valid_568818 != nil:
    section.add "resourceGroupName", valid_568818
  var valid_568819 = path.getOrDefault("name")
  valid_568819 = validateParameter(valid_568819, JString, required = true,
                                 default = nil)
  if valid_568819 != nil:
    section.add "name", valid_568819
  var valid_568820 = path.getOrDefault("subscriptionId")
  valid_568820 = validateParameter(valid_568820, JString, required = true,
                                 default = nil)
  if valid_568820 != nil:
    section.add "subscriptionId", valid_568820
  var valid_568821 = path.getOrDefault("labName")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = nil)
  if valid_568821 != nil:
    section.add "labName", valid_568821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568822 = query.getOrDefault("api-version")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568822 != nil:
    section.add "api-version", valid_568822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568823: Call_ServiceRunnersGet_568815; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service runner.
  ## 
  let valid = call_568823.validator(path, query, header, formData, body)
  let scheme = call_568823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568823.url(scheme.get, call_568823.host, call_568823.base,
                         call_568823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568823, url, valid)

proc call*(call_568824: Call_ServiceRunnersGet_568815; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## serviceRunnersGet
  ## Get service runner.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service runner.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568825 = newJObject()
  var query_568826 = newJObject()
  add(path_568825, "resourceGroupName", newJString(resourceGroupName))
  add(query_568826, "api-version", newJString(apiVersion))
  add(path_568825, "name", newJString(name))
  add(path_568825, "subscriptionId", newJString(subscriptionId))
  add(path_568825, "labName", newJString(labName))
  result = call_568824.call(path_568825, query_568826, nil, nil, nil)

var serviceRunnersGet* = Call_ServiceRunnersGet_568815(name: "serviceRunnersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersGet_568816, base: "",
    url: url_ServiceRunnersGet_568817, schemes: {Scheme.Https})
type
  Call_ServiceRunnersDelete_568841 = ref object of OpenApiRestCall_567650
proc url_ServiceRunnersDelete_568843(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/servicerunners/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceRunnersDelete_568842(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete service runner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service runner.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568844 = path.getOrDefault("resourceGroupName")
  valid_568844 = validateParameter(valid_568844, JString, required = true,
                                 default = nil)
  if valid_568844 != nil:
    section.add "resourceGroupName", valid_568844
  var valid_568845 = path.getOrDefault("name")
  valid_568845 = validateParameter(valid_568845, JString, required = true,
                                 default = nil)
  if valid_568845 != nil:
    section.add "name", valid_568845
  var valid_568846 = path.getOrDefault("subscriptionId")
  valid_568846 = validateParameter(valid_568846, JString, required = true,
                                 default = nil)
  if valid_568846 != nil:
    section.add "subscriptionId", valid_568846
  var valid_568847 = path.getOrDefault("labName")
  valid_568847 = validateParameter(valid_568847, JString, required = true,
                                 default = nil)
  if valid_568847 != nil:
    section.add "labName", valid_568847
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568848 = query.getOrDefault("api-version")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568848 != nil:
    section.add "api-version", valid_568848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568849: Call_ServiceRunnersDelete_568841; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete service runner.
  ## 
  let valid = call_568849.validator(path, query, header, formData, body)
  let scheme = call_568849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568849.url(scheme.get, call_568849.host, call_568849.base,
                         call_568849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568849, url, valid)

proc call*(call_568850: Call_ServiceRunnersDelete_568841;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## serviceRunnersDelete
  ## Delete service runner.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service runner.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568851 = newJObject()
  var query_568852 = newJObject()
  add(path_568851, "resourceGroupName", newJString(resourceGroupName))
  add(query_568852, "api-version", newJString(apiVersion))
  add(path_568851, "name", newJString(name))
  add(path_568851, "subscriptionId", newJString(subscriptionId))
  add(path_568851, "labName", newJString(labName))
  result = call_568850.call(path_568851, query_568852, nil, nil, nil)

var serviceRunnersDelete* = Call_ServiceRunnersDelete_568841(
    name: "serviceRunnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersDelete_568842, base: "",
    url: url_ServiceRunnersDelete_568843, schemes: {Scheme.Https})
type
  Call_UsersList_568853 = ref object of OpenApiRestCall_567650
proc url_UsersList_568855(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersList_568854(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List user profiles in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568856 = path.getOrDefault("resourceGroupName")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = nil)
  if valid_568856 != nil:
    section.add "resourceGroupName", valid_568856
  var valid_568857 = path.getOrDefault("subscriptionId")
  valid_568857 = validateParameter(valid_568857, JString, required = true,
                                 default = nil)
  if valid_568857 != nil:
    section.add "subscriptionId", valid_568857
  var valid_568858 = path.getOrDefault("labName")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "labName", valid_568858
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568859 = query.getOrDefault("$orderby")
  valid_568859 = validateParameter(valid_568859, JString, required = false,
                                 default = nil)
  if valid_568859 != nil:
    section.add "$orderby", valid_568859
  var valid_568860 = query.getOrDefault("$expand")
  valid_568860 = validateParameter(valid_568860, JString, required = false,
                                 default = nil)
  if valid_568860 != nil:
    section.add "$expand", valid_568860
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568861 = query.getOrDefault("api-version")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568861 != nil:
    section.add "api-version", valid_568861
  var valid_568862 = query.getOrDefault("$top")
  valid_568862 = validateParameter(valid_568862, JInt, required = false, default = nil)
  if valid_568862 != nil:
    section.add "$top", valid_568862
  var valid_568863 = query.getOrDefault("$filter")
  valid_568863 = validateParameter(valid_568863, JString, required = false,
                                 default = nil)
  if valid_568863 != nil:
    section.add "$filter", valid_568863
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568864: Call_UsersList_568853; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List user profiles in a given lab.
  ## 
  let valid = call_568864.validator(path, query, header, formData, body)
  let scheme = call_568864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568864.url(scheme.get, call_568864.host, call_568864.base,
                         call_568864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568864, url, valid)

proc call*(call_568865: Call_UsersList_568853; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## usersList
  ## List user profiles in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=identity)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568866 = newJObject()
  var query_568867 = newJObject()
  add(query_568867, "$orderby", newJString(Orderby))
  add(path_568866, "resourceGroupName", newJString(resourceGroupName))
  add(query_568867, "$expand", newJString(Expand))
  add(query_568867, "api-version", newJString(apiVersion))
  add(path_568866, "subscriptionId", newJString(subscriptionId))
  add(query_568867, "$top", newJInt(Top))
  add(path_568866, "labName", newJString(labName))
  add(query_568867, "$filter", newJString(Filter))
  result = call_568865.call(path_568866, query_568867, nil, nil, nil)

var usersList* = Call_UsersList_568853(name: "usersList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users",
                                    validator: validate_UsersList_568854,
                                    base: "", url: url_UsersList_568855,
                                    schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_568881 = ref object of OpenApiRestCall_567650
proc url_UsersCreateOrUpdate_568883(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersCreateOrUpdate_568882(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568884 = path.getOrDefault("resourceGroupName")
  valid_568884 = validateParameter(valid_568884, JString, required = true,
                                 default = nil)
  if valid_568884 != nil:
    section.add "resourceGroupName", valid_568884
  var valid_568885 = path.getOrDefault("name")
  valid_568885 = validateParameter(valid_568885, JString, required = true,
                                 default = nil)
  if valid_568885 != nil:
    section.add "name", valid_568885
  var valid_568886 = path.getOrDefault("subscriptionId")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "subscriptionId", valid_568886
  var valid_568887 = path.getOrDefault("labName")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "labName", valid_568887
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568888 = query.getOrDefault("api-version")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568888 != nil:
    section.add "api-version", valid_568888
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568890: Call_UsersCreateOrUpdate_568881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing user profile.
  ## 
  let valid = call_568890.validator(path, query, header, formData, body)
  let scheme = call_568890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568890.url(scheme.get, call_568890.host, call_568890.base,
                         call_568890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568890, url, valid)

proc call*(call_568891: Call_UsersCreateOrUpdate_568881; resourceGroupName: string;
          name: string; user: JsonNode; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## usersCreateOrUpdate
  ## Create or replace an existing user profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568892 = newJObject()
  var query_568893 = newJObject()
  var body_568894 = newJObject()
  add(path_568892, "resourceGroupName", newJString(resourceGroupName))
  add(query_568893, "api-version", newJString(apiVersion))
  add(path_568892, "name", newJString(name))
  if user != nil:
    body_568894 = user
  add(path_568892, "subscriptionId", newJString(subscriptionId))
  add(path_568892, "labName", newJString(labName))
  result = call_568891.call(path_568892, query_568893, nil, nil, body_568894)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_568881(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_568882, base: "",
    url: url_UsersCreateOrUpdate_568883, schemes: {Scheme.Https})
type
  Call_UsersGet_568868 = ref object of OpenApiRestCall_567650
proc url_UsersGet_568870(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersGet_568869(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568871 = path.getOrDefault("resourceGroupName")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "resourceGroupName", valid_568871
  var valid_568872 = path.getOrDefault("name")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "name", valid_568872
  var valid_568873 = path.getOrDefault("subscriptionId")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "subscriptionId", valid_568873
  var valid_568874 = path.getOrDefault("labName")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "labName", valid_568874
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568875 = query.getOrDefault("$expand")
  valid_568875 = validateParameter(valid_568875, JString, required = false,
                                 default = nil)
  if valid_568875 != nil:
    section.add "$expand", valid_568875
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568876 = query.getOrDefault("api-version")
  valid_568876 = validateParameter(valid_568876, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568876 != nil:
    section.add "api-version", valid_568876
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568877: Call_UsersGet_568868; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user profile.
  ## 
  let valid = call_568877.validator(path, query, header, formData, body)
  let scheme = call_568877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568877.url(scheme.get, call_568877.host, call_568877.base,
                         call_568877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568877, url, valid)

proc call*(call_568878: Call_UsersGet_568868; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## usersGet
  ## Get user profile.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=identity)'
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568879 = newJObject()
  var query_568880 = newJObject()
  add(path_568879, "resourceGroupName", newJString(resourceGroupName))
  add(query_568880, "$expand", newJString(Expand))
  add(path_568879, "name", newJString(name))
  add(query_568880, "api-version", newJString(apiVersion))
  add(path_568879, "subscriptionId", newJString(subscriptionId))
  add(path_568879, "labName", newJString(labName))
  result = call_568878.call(path_568879, query_568880, nil, nil, nil)

var usersGet* = Call_UsersGet_568868(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                  validator: validate_UsersGet_568869, base: "",
                                  url: url_UsersGet_568870,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_568907 = ref object of OpenApiRestCall_567650
proc url_UsersUpdate_568909(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersUpdate_568908(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of user profiles.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568910 = path.getOrDefault("resourceGroupName")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = nil)
  if valid_568910 != nil:
    section.add "resourceGroupName", valid_568910
  var valid_568911 = path.getOrDefault("name")
  valid_568911 = validateParameter(valid_568911, JString, required = true,
                                 default = nil)
  if valid_568911 != nil:
    section.add "name", valid_568911
  var valid_568912 = path.getOrDefault("subscriptionId")
  valid_568912 = validateParameter(valid_568912, JString, required = true,
                                 default = nil)
  if valid_568912 != nil:
    section.add "subscriptionId", valid_568912
  var valid_568913 = path.getOrDefault("labName")
  valid_568913 = validateParameter(valid_568913, JString, required = true,
                                 default = nil)
  if valid_568913 != nil:
    section.add "labName", valid_568913
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568914 = query.getOrDefault("api-version")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568914 != nil:
    section.add "api-version", valid_568914
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568916: Call_UsersUpdate_568907; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of user profiles.
  ## 
  let valid = call_568916.validator(path, query, header, formData, body)
  let scheme = call_568916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568916.url(scheme.get, call_568916.host, call_568916.base,
                         call_568916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568916, url, valid)

proc call*(call_568917: Call_UsersUpdate_568907; resourceGroupName: string;
          name: string; user: JsonNode; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## usersUpdate
  ## Modify properties of user profiles.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568918 = newJObject()
  var query_568919 = newJObject()
  var body_568920 = newJObject()
  add(path_568918, "resourceGroupName", newJString(resourceGroupName))
  add(query_568919, "api-version", newJString(apiVersion))
  add(path_568918, "name", newJString(name))
  if user != nil:
    body_568920 = user
  add(path_568918, "subscriptionId", newJString(subscriptionId))
  add(path_568918, "labName", newJString(labName))
  result = call_568917.call(path_568918, query_568919, nil, nil, body_568920)

var usersUpdate* = Call_UsersUpdate_568907(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersUpdate_568908,
                                        base: "", url: url_UsersUpdate_568909,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_568895 = ref object of OpenApiRestCall_567650
proc url_UsersDelete_568897(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsersDelete_568896(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete user profile. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568898 = path.getOrDefault("resourceGroupName")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "resourceGroupName", valid_568898
  var valid_568899 = path.getOrDefault("name")
  valid_568899 = validateParameter(valid_568899, JString, required = true,
                                 default = nil)
  if valid_568899 != nil:
    section.add "name", valid_568899
  var valid_568900 = path.getOrDefault("subscriptionId")
  valid_568900 = validateParameter(valid_568900, JString, required = true,
                                 default = nil)
  if valid_568900 != nil:
    section.add "subscriptionId", valid_568900
  var valid_568901 = path.getOrDefault("labName")
  valid_568901 = validateParameter(valid_568901, JString, required = true,
                                 default = nil)
  if valid_568901 != nil:
    section.add "labName", valid_568901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568902 = query.getOrDefault("api-version")
  valid_568902 = validateParameter(valid_568902, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568902 != nil:
    section.add "api-version", valid_568902
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568903: Call_UsersDelete_568895; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user profile. This operation can take a while to complete.
  ## 
  let valid = call_568903.validator(path, query, header, formData, body)
  let scheme = call_568903.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568903.url(scheme.get, call_568903.host, call_568903.base,
                         call_568903.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568903, url, valid)

proc call*(call_568904: Call_UsersDelete_568895; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## usersDelete
  ## Delete user profile. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568905 = newJObject()
  var query_568906 = newJObject()
  add(path_568905, "resourceGroupName", newJString(resourceGroupName))
  add(query_568906, "api-version", newJString(apiVersion))
  add(path_568905, "name", newJString(name))
  add(path_568905, "subscriptionId", newJString(subscriptionId))
  add(path_568905, "labName", newJString(labName))
  result = call_568904.call(path_568905, query_568906, nil, nil, nil)

var usersDelete* = Call_UsersDelete_568895(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersDelete_568896,
                                        base: "", url: url_UsersDelete_568897,
                                        schemes: {Scheme.Https})
type
  Call_DisksList_568921 = ref object of OpenApiRestCall_567650
proc url_DisksList_568923(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksList_568922(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List disks in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568924 = path.getOrDefault("resourceGroupName")
  valid_568924 = validateParameter(valid_568924, JString, required = true,
                                 default = nil)
  if valid_568924 != nil:
    section.add "resourceGroupName", valid_568924
  var valid_568925 = path.getOrDefault("subscriptionId")
  valid_568925 = validateParameter(valid_568925, JString, required = true,
                                 default = nil)
  if valid_568925 != nil:
    section.add "subscriptionId", valid_568925
  var valid_568926 = path.getOrDefault("userName")
  valid_568926 = validateParameter(valid_568926, JString, required = true,
                                 default = nil)
  if valid_568926 != nil:
    section.add "userName", valid_568926
  var valid_568927 = path.getOrDefault("labName")
  valid_568927 = validateParameter(valid_568927, JString, required = true,
                                 default = nil)
  if valid_568927 != nil:
    section.add "labName", valid_568927
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568928 = query.getOrDefault("$orderby")
  valid_568928 = validateParameter(valid_568928, JString, required = false,
                                 default = nil)
  if valid_568928 != nil:
    section.add "$orderby", valid_568928
  var valid_568929 = query.getOrDefault("$expand")
  valid_568929 = validateParameter(valid_568929, JString, required = false,
                                 default = nil)
  if valid_568929 != nil:
    section.add "$expand", valid_568929
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568930 = query.getOrDefault("api-version")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568930 != nil:
    section.add "api-version", valid_568930
  var valid_568931 = query.getOrDefault("$top")
  valid_568931 = validateParameter(valid_568931, JInt, required = false, default = nil)
  if valid_568931 != nil:
    section.add "$top", valid_568931
  var valid_568932 = query.getOrDefault("$filter")
  valid_568932 = validateParameter(valid_568932, JString, required = false,
                                 default = nil)
  if valid_568932 != nil:
    section.add "$filter", valid_568932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568933: Call_DisksList_568921; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disks in a given user profile.
  ## 
  let valid = call_568933.validator(path, query, header, formData, body)
  let scheme = call_568933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568933.url(scheme.get, call_568933.host, call_568933.base,
                         call_568933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568933, url, valid)

proc call*(call_568934: Call_DisksList_568921; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## disksList
  ## List disks in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568935 = newJObject()
  var query_568936 = newJObject()
  add(query_568936, "$orderby", newJString(Orderby))
  add(path_568935, "resourceGroupName", newJString(resourceGroupName))
  add(query_568936, "$expand", newJString(Expand))
  add(query_568936, "api-version", newJString(apiVersion))
  add(path_568935, "subscriptionId", newJString(subscriptionId))
  add(query_568936, "$top", newJInt(Top))
  add(path_568935, "userName", newJString(userName))
  add(path_568935, "labName", newJString(labName))
  add(query_568936, "$filter", newJString(Filter))
  result = call_568934.call(path_568935, query_568936, nil, nil, nil)

var disksList* = Call_DisksList_568921(name: "disksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks",
                                    validator: validate_DisksList_568922,
                                    base: "", url: url_DisksList_568923,
                                    schemes: {Scheme.Https})
type
  Call_DisksCreateOrUpdate_568951 = ref object of OpenApiRestCall_567650
proc url_DisksCreateOrUpdate_568953(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksCreateOrUpdate_568952(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing disk. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568954 = path.getOrDefault("resourceGroupName")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "resourceGroupName", valid_568954
  var valid_568955 = path.getOrDefault("name")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "name", valid_568955
  var valid_568956 = path.getOrDefault("subscriptionId")
  valid_568956 = validateParameter(valid_568956, JString, required = true,
                                 default = nil)
  if valid_568956 != nil:
    section.add "subscriptionId", valid_568956
  var valid_568957 = path.getOrDefault("userName")
  valid_568957 = validateParameter(valid_568957, JString, required = true,
                                 default = nil)
  if valid_568957 != nil:
    section.add "userName", valid_568957
  var valid_568958 = path.getOrDefault("labName")
  valid_568958 = validateParameter(valid_568958, JString, required = true,
                                 default = nil)
  if valid_568958 != nil:
    section.add "labName", valid_568958
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568959 = query.getOrDefault("api-version")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568959 != nil:
    section.add "api-version", valid_568959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   disk: JObject (required)
  ##       : A Disk.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568961: Call_DisksCreateOrUpdate_568951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing disk. This operation can take a while to complete.
  ## 
  let valid = call_568961.validator(path, query, header, formData, body)
  let scheme = call_568961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568961.url(scheme.get, call_568961.host, call_568961.base,
                         call_568961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568961, url, valid)

proc call*(call_568962: Call_DisksCreateOrUpdate_568951; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; disk: JsonNode;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## disksCreateOrUpdate
  ## Create or replace an existing disk. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   disk: JObject (required)
  ##       : A Disk.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568963 = newJObject()
  var query_568964 = newJObject()
  var body_568965 = newJObject()
  add(path_568963, "resourceGroupName", newJString(resourceGroupName))
  add(query_568964, "api-version", newJString(apiVersion))
  add(path_568963, "name", newJString(name))
  add(path_568963, "subscriptionId", newJString(subscriptionId))
  add(path_568963, "userName", newJString(userName))
  if disk != nil:
    body_568965 = disk
  add(path_568963, "labName", newJString(labName))
  result = call_568962.call(path_568963, query_568964, nil, nil, body_568965)

var disksCreateOrUpdate* = Call_DisksCreateOrUpdate_568951(
    name: "disksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
    validator: validate_DisksCreateOrUpdate_568952, base: "",
    url: url_DisksCreateOrUpdate_568953, schemes: {Scheme.Https})
type
  Call_DisksGet_568937 = ref object of OpenApiRestCall_567650
proc url_DisksGet_568939(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksGet_568938(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get disk.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568940 = path.getOrDefault("resourceGroupName")
  valid_568940 = validateParameter(valid_568940, JString, required = true,
                                 default = nil)
  if valid_568940 != nil:
    section.add "resourceGroupName", valid_568940
  var valid_568941 = path.getOrDefault("name")
  valid_568941 = validateParameter(valid_568941, JString, required = true,
                                 default = nil)
  if valid_568941 != nil:
    section.add "name", valid_568941
  var valid_568942 = path.getOrDefault("subscriptionId")
  valid_568942 = validateParameter(valid_568942, JString, required = true,
                                 default = nil)
  if valid_568942 != nil:
    section.add "subscriptionId", valid_568942
  var valid_568943 = path.getOrDefault("userName")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "userName", valid_568943
  var valid_568944 = path.getOrDefault("labName")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "labName", valid_568944
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568945 = query.getOrDefault("$expand")
  valid_568945 = validateParameter(valid_568945, JString, required = false,
                                 default = nil)
  if valid_568945 != nil:
    section.add "$expand", valid_568945
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568946 = query.getOrDefault("api-version")
  valid_568946 = validateParameter(valid_568946, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568946 != nil:
    section.add "api-version", valid_568946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568947: Call_DisksGet_568937; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get disk.
  ## 
  let valid = call_568947.validator(path, query, header, formData, body)
  let scheme = call_568947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568947.url(scheme.get, call_568947.host, call_568947.base,
                         call_568947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568947, url, valid)

proc call*(call_568948: Call_DisksGet_568937; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
  ## disksGet
  ## Get disk.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   name: string (required)
  ##       : The name of the disk.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568949 = newJObject()
  var query_568950 = newJObject()
  add(path_568949, "resourceGroupName", newJString(resourceGroupName))
  add(query_568950, "$expand", newJString(Expand))
  add(path_568949, "name", newJString(name))
  add(query_568950, "api-version", newJString(apiVersion))
  add(path_568949, "subscriptionId", newJString(subscriptionId))
  add(path_568949, "userName", newJString(userName))
  add(path_568949, "labName", newJString(labName))
  result = call_568948.call(path_568949, query_568950, nil, nil, nil)

var disksGet* = Call_DisksGet_568937(name: "disksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                  validator: validate_DisksGet_568938, base: "",
                                  url: url_DisksGet_568939,
                                  schemes: {Scheme.Https})
type
  Call_DisksDelete_568966 = ref object of OpenApiRestCall_567650
proc url_DisksDelete_568968(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksDelete_568967(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete disk. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568969 = path.getOrDefault("resourceGroupName")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "resourceGroupName", valid_568969
  var valid_568970 = path.getOrDefault("name")
  valid_568970 = validateParameter(valid_568970, JString, required = true,
                                 default = nil)
  if valid_568970 != nil:
    section.add "name", valid_568970
  var valid_568971 = path.getOrDefault("subscriptionId")
  valid_568971 = validateParameter(valid_568971, JString, required = true,
                                 default = nil)
  if valid_568971 != nil:
    section.add "subscriptionId", valid_568971
  var valid_568972 = path.getOrDefault("userName")
  valid_568972 = validateParameter(valid_568972, JString, required = true,
                                 default = nil)
  if valid_568972 != nil:
    section.add "userName", valid_568972
  var valid_568973 = path.getOrDefault("labName")
  valid_568973 = validateParameter(valid_568973, JString, required = true,
                                 default = nil)
  if valid_568973 != nil:
    section.add "labName", valid_568973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568974 = query.getOrDefault("api-version")
  valid_568974 = validateParameter(valid_568974, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568974 != nil:
    section.add "api-version", valid_568974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568975: Call_DisksDelete_568966; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete disk. This operation can take a while to complete.
  ## 
  let valid = call_568975.validator(path, query, header, formData, body)
  let scheme = call_568975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568975.url(scheme.get, call_568975.host, call_568975.base,
                         call_568975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568975, url, valid)

proc call*(call_568976: Call_DisksDelete_568966; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## disksDelete
  ## Delete disk. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568977 = newJObject()
  var query_568978 = newJObject()
  add(path_568977, "resourceGroupName", newJString(resourceGroupName))
  add(query_568978, "api-version", newJString(apiVersion))
  add(path_568977, "name", newJString(name))
  add(path_568977, "subscriptionId", newJString(subscriptionId))
  add(path_568977, "userName", newJString(userName))
  add(path_568977, "labName", newJString(labName))
  result = call_568976.call(path_568977, query_568978, nil, nil, nil)

var disksDelete* = Call_DisksDelete_568966(name: "disksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                        validator: validate_DisksDelete_568967,
                                        base: "", url: url_DisksDelete_568968,
                                        schemes: {Scheme.Https})
type
  Call_DisksAttach_568979 = ref object of OpenApiRestCall_567650
proc url_DisksAttach_568981(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/attach")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksAttach_568980(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568982 = path.getOrDefault("resourceGroupName")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "resourceGroupName", valid_568982
  var valid_568983 = path.getOrDefault("name")
  valid_568983 = validateParameter(valid_568983, JString, required = true,
                                 default = nil)
  if valid_568983 != nil:
    section.add "name", valid_568983
  var valid_568984 = path.getOrDefault("subscriptionId")
  valid_568984 = validateParameter(valid_568984, JString, required = true,
                                 default = nil)
  if valid_568984 != nil:
    section.add "subscriptionId", valid_568984
  var valid_568985 = path.getOrDefault("userName")
  valid_568985 = validateParameter(valid_568985, JString, required = true,
                                 default = nil)
  if valid_568985 != nil:
    section.add "userName", valid_568985
  var valid_568986 = path.getOrDefault("labName")
  valid_568986 = validateParameter(valid_568986, JString, required = true,
                                 default = nil)
  if valid_568986 != nil:
    section.add "labName", valid_568986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568987 = query.getOrDefault("api-version")
  valid_568987 = validateParameter(valid_568987, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_568987 != nil:
    section.add "api-version", valid_568987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   attachDiskProperties: JObject (required)
  ##                       : Properties of the disk to attach.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568989: Call_DisksAttach_568979; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_568989.validator(path, query, header, formData, body)
  let scheme = call_568989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568989.url(scheme.get, call_568989.host, call_568989.base,
                         call_568989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568989, url, valid)

proc call*(call_568990: Call_DisksAttach_568979; resourceGroupName: string;
          name: string; subscriptionId: string; attachDiskProperties: JsonNode;
          userName: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## disksAttach
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   attachDiskProperties: JObject (required)
  ##                       : Properties of the disk to attach.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568991 = newJObject()
  var query_568992 = newJObject()
  var body_568993 = newJObject()
  add(path_568991, "resourceGroupName", newJString(resourceGroupName))
  add(query_568992, "api-version", newJString(apiVersion))
  add(path_568991, "name", newJString(name))
  add(path_568991, "subscriptionId", newJString(subscriptionId))
  if attachDiskProperties != nil:
    body_568993 = attachDiskProperties
  add(path_568991, "userName", newJString(userName))
  add(path_568991, "labName", newJString(labName))
  result = call_568990.call(path_568991, query_568992, nil, nil, body_568993)

var disksAttach* = Call_DisksAttach_568979(name: "disksAttach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/attach",
                                        validator: validate_DisksAttach_568980,
                                        base: "", url: url_DisksAttach_568981,
                                        schemes: {Scheme.Https})
type
  Call_DisksDetach_568994 = ref object of OpenApiRestCall_567650
proc url_DisksDetach_568996(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/disks/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/detach")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisksDetach_568995(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568997 = path.getOrDefault("resourceGroupName")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "resourceGroupName", valid_568997
  var valid_568998 = path.getOrDefault("name")
  valid_568998 = validateParameter(valid_568998, JString, required = true,
                                 default = nil)
  if valid_568998 != nil:
    section.add "name", valid_568998
  var valid_568999 = path.getOrDefault("subscriptionId")
  valid_568999 = validateParameter(valid_568999, JString, required = true,
                                 default = nil)
  if valid_568999 != nil:
    section.add "subscriptionId", valid_568999
  var valid_569000 = path.getOrDefault("userName")
  valid_569000 = validateParameter(valid_569000, JString, required = true,
                                 default = nil)
  if valid_569000 != nil:
    section.add "userName", valid_569000
  var valid_569001 = path.getOrDefault("labName")
  valid_569001 = validateParameter(valid_569001, JString, required = true,
                                 default = nil)
  if valid_569001 != nil:
    section.add "labName", valid_569001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569002 = query.getOrDefault("api-version")
  valid_569002 = validateParameter(valid_569002, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569002 != nil:
    section.add "api-version", valid_569002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   detachDiskProperties: JObject (required)
  ##                       : Properties of the disk to detach.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569004: Call_DisksDetach_568994; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569004.validator(path, query, header, formData, body)
  let scheme = call_569004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569004.url(scheme.get, call_569004.host, call_569004.base,
                         call_569004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569004, url, valid)

proc call*(call_569005: Call_DisksDetach_568994; resourceGroupName: string;
          name: string; subscriptionId: string; detachDiskProperties: JsonNode;
          userName: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## disksDetach
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   detachDiskProperties: JObject (required)
  ##                       : Properties of the disk to detach.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569006 = newJObject()
  var query_569007 = newJObject()
  var body_569008 = newJObject()
  add(path_569006, "resourceGroupName", newJString(resourceGroupName))
  add(query_569007, "api-version", newJString(apiVersion))
  add(path_569006, "name", newJString(name))
  add(path_569006, "subscriptionId", newJString(subscriptionId))
  if detachDiskProperties != nil:
    body_569008 = detachDiskProperties
  add(path_569006, "userName", newJString(userName))
  add(path_569006, "labName", newJString(labName))
  result = call_569005.call(path_569006, query_569007, nil, nil, body_569008)

var disksDetach* = Call_DisksDetach_568994(name: "disksDetach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/detach",
                                        validator: validate_DisksDetach_568995,
                                        base: "", url: url_DisksDetach_568996,
                                        schemes: {Scheme.Https})
type
  Call_EnvironmentsList_569009 = ref object of OpenApiRestCall_567650
proc url_EnvironmentsList_569011(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/environments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsList_569010(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List environments in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569012 = path.getOrDefault("resourceGroupName")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = nil)
  if valid_569012 != nil:
    section.add "resourceGroupName", valid_569012
  var valid_569013 = path.getOrDefault("subscriptionId")
  valid_569013 = validateParameter(valid_569013, JString, required = true,
                                 default = nil)
  if valid_569013 != nil:
    section.add "subscriptionId", valid_569013
  var valid_569014 = path.getOrDefault("userName")
  valid_569014 = validateParameter(valid_569014, JString, required = true,
                                 default = nil)
  if valid_569014 != nil:
    section.add "userName", valid_569014
  var valid_569015 = path.getOrDefault("labName")
  valid_569015 = validateParameter(valid_569015, JString, required = true,
                                 default = nil)
  if valid_569015 != nil:
    section.add "labName", valid_569015
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_569016 = query.getOrDefault("$orderby")
  valid_569016 = validateParameter(valid_569016, JString, required = false,
                                 default = nil)
  if valid_569016 != nil:
    section.add "$orderby", valid_569016
  var valid_569017 = query.getOrDefault("$expand")
  valid_569017 = validateParameter(valid_569017, JString, required = false,
                                 default = nil)
  if valid_569017 != nil:
    section.add "$expand", valid_569017
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569018 = query.getOrDefault("api-version")
  valid_569018 = validateParameter(valid_569018, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569018 != nil:
    section.add "api-version", valid_569018
  var valid_569019 = query.getOrDefault("$top")
  valid_569019 = validateParameter(valid_569019, JInt, required = false, default = nil)
  if valid_569019 != nil:
    section.add "$top", valid_569019
  var valid_569020 = query.getOrDefault("$filter")
  valid_569020 = validateParameter(valid_569020, JString, required = false,
                                 default = nil)
  if valid_569020 != nil:
    section.add "$filter", valid_569020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569021: Call_EnvironmentsList_569009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environments in a given user profile.
  ## 
  let valid = call_569021.validator(path, query, header, formData, body)
  let scheme = call_569021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569021.url(scheme.get, call_569021.host, call_569021.base,
                         call_569021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569021, url, valid)

proc call*(call_569022: Call_EnvironmentsList_569009; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## environmentsList
  ## List environments in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_569023 = newJObject()
  var query_569024 = newJObject()
  add(query_569024, "$orderby", newJString(Orderby))
  add(path_569023, "resourceGroupName", newJString(resourceGroupName))
  add(query_569024, "$expand", newJString(Expand))
  add(query_569024, "api-version", newJString(apiVersion))
  add(path_569023, "subscriptionId", newJString(subscriptionId))
  add(query_569024, "$top", newJInt(Top))
  add(path_569023, "userName", newJString(userName))
  add(path_569023, "labName", newJString(labName))
  add(query_569024, "$filter", newJString(Filter))
  result = call_569022.call(path_569023, query_569024, nil, nil, nil)

var environmentsList* = Call_EnvironmentsList_569009(name: "environmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments",
    validator: validate_EnvironmentsList_569010, base: "",
    url: url_EnvironmentsList_569011, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_569039 = ref object of OpenApiRestCall_567650
proc url_EnvironmentsCreateOrUpdate_569041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsCreateOrUpdate_569040(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing environment. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569042 = path.getOrDefault("resourceGroupName")
  valid_569042 = validateParameter(valid_569042, JString, required = true,
                                 default = nil)
  if valid_569042 != nil:
    section.add "resourceGroupName", valid_569042
  var valid_569043 = path.getOrDefault("name")
  valid_569043 = validateParameter(valid_569043, JString, required = true,
                                 default = nil)
  if valid_569043 != nil:
    section.add "name", valid_569043
  var valid_569044 = path.getOrDefault("subscriptionId")
  valid_569044 = validateParameter(valid_569044, JString, required = true,
                                 default = nil)
  if valid_569044 != nil:
    section.add "subscriptionId", valid_569044
  var valid_569045 = path.getOrDefault("userName")
  valid_569045 = validateParameter(valid_569045, JString, required = true,
                                 default = nil)
  if valid_569045 != nil:
    section.add "userName", valid_569045
  var valid_569046 = path.getOrDefault("labName")
  valid_569046 = validateParameter(valid_569046, JString, required = true,
                                 default = nil)
  if valid_569046 != nil:
    section.add "labName", valid_569046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569047 = query.getOrDefault("api-version")
  valid_569047 = validateParameter(valid_569047, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569047 != nil:
    section.add "api-version", valid_569047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dtlEnvironment: JObject (required)
  ##                 : An environment, which is essentially an ARM template deployment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569049: Call_EnvironmentsCreateOrUpdate_569039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing environment. This operation can take a while to complete.
  ## 
  let valid = call_569049.validator(path, query, header, formData, body)
  let scheme = call_569049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569049.url(scheme.get, call_569049.host, call_569049.base,
                         call_569049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569049, url, valid)

proc call*(call_569050: Call_EnvironmentsCreateOrUpdate_569039;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; dtlEnvironment: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## environmentsCreateOrUpdate
  ## Create or replace an existing environment. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   dtlEnvironment: JObject (required)
  ##                 : An environment, which is essentially an ARM template deployment.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569051 = newJObject()
  var query_569052 = newJObject()
  var body_569053 = newJObject()
  add(path_569051, "resourceGroupName", newJString(resourceGroupName))
  add(query_569052, "api-version", newJString(apiVersion))
  add(path_569051, "name", newJString(name))
  add(path_569051, "subscriptionId", newJString(subscriptionId))
  add(path_569051, "userName", newJString(userName))
  if dtlEnvironment != nil:
    body_569053 = dtlEnvironment
  add(path_569051, "labName", newJString(labName))
  result = call_569050.call(path_569051, query_569052, nil, nil, body_569053)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_569039(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsCreateOrUpdate_569040, base: "",
    url: url_EnvironmentsCreateOrUpdate_569041, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_569025 = ref object of OpenApiRestCall_567650
proc url_EnvironmentsGet_569027(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsGet_569026(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569028 = path.getOrDefault("resourceGroupName")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "resourceGroupName", valid_569028
  var valid_569029 = path.getOrDefault("name")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "name", valid_569029
  var valid_569030 = path.getOrDefault("subscriptionId")
  valid_569030 = validateParameter(valid_569030, JString, required = true,
                                 default = nil)
  if valid_569030 != nil:
    section.add "subscriptionId", valid_569030
  var valid_569031 = path.getOrDefault("userName")
  valid_569031 = validateParameter(valid_569031, JString, required = true,
                                 default = nil)
  if valid_569031 != nil:
    section.add "userName", valid_569031
  var valid_569032 = path.getOrDefault("labName")
  valid_569032 = validateParameter(valid_569032, JString, required = true,
                                 default = nil)
  if valid_569032 != nil:
    section.add "labName", valid_569032
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569033 = query.getOrDefault("$expand")
  valid_569033 = validateParameter(valid_569033, JString, required = false,
                                 default = nil)
  if valid_569033 != nil:
    section.add "$expand", valid_569033
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569034 = query.getOrDefault("api-version")
  valid_569034 = validateParameter(valid_569034, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569034 != nil:
    section.add "api-version", valid_569034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569035: Call_EnvironmentsGet_569025; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment.
  ## 
  let valid = call_569035.validator(path, query, header, formData, body)
  let scheme = call_569035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569035.url(scheme.get, call_569035.host, call_569035.base,
                         call_569035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569035, url, valid)

proc call*(call_569036: Call_EnvironmentsGet_569025; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
  ## environmentsGet
  ## Get environment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   name: string (required)
  ##       : The name of the environment.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569037 = newJObject()
  var query_569038 = newJObject()
  add(path_569037, "resourceGroupName", newJString(resourceGroupName))
  add(query_569038, "$expand", newJString(Expand))
  add(path_569037, "name", newJString(name))
  add(query_569038, "api-version", newJString(apiVersion))
  add(path_569037, "subscriptionId", newJString(subscriptionId))
  add(path_569037, "userName", newJString(userName))
  add(path_569037, "labName", newJString(labName))
  result = call_569036.call(path_569037, query_569038, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_569025(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsGet_569026, base: "", url: url_EnvironmentsGet_569027,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_569054 = ref object of OpenApiRestCall_567650
proc url_EnvironmentsDelete_569056(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnvironmentsDelete_569055(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete environment. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569057 = path.getOrDefault("resourceGroupName")
  valid_569057 = validateParameter(valid_569057, JString, required = true,
                                 default = nil)
  if valid_569057 != nil:
    section.add "resourceGroupName", valid_569057
  var valid_569058 = path.getOrDefault("name")
  valid_569058 = validateParameter(valid_569058, JString, required = true,
                                 default = nil)
  if valid_569058 != nil:
    section.add "name", valid_569058
  var valid_569059 = path.getOrDefault("subscriptionId")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "subscriptionId", valid_569059
  var valid_569060 = path.getOrDefault("userName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "userName", valid_569060
  var valid_569061 = path.getOrDefault("labName")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "labName", valid_569061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569062 = query.getOrDefault("api-version")
  valid_569062 = validateParameter(valid_569062, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569062 != nil:
    section.add "api-version", valid_569062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569063: Call_EnvironmentsDelete_569054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment. This operation can take a while to complete.
  ## 
  let valid = call_569063.validator(path, query, header, formData, body)
  let scheme = call_569063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569063.url(scheme.get, call_569063.host, call_569063.base,
                         call_569063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569063, url, valid)

proc call*(call_569064: Call_EnvironmentsDelete_569054; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## environmentsDelete
  ## Delete environment. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569065 = newJObject()
  var query_569066 = newJObject()
  add(path_569065, "resourceGroupName", newJString(resourceGroupName))
  add(query_569066, "api-version", newJString(apiVersion))
  add(path_569065, "name", newJString(name))
  add(path_569065, "subscriptionId", newJString(subscriptionId))
  add(path_569065, "userName", newJString(userName))
  add(path_569065, "labName", newJString(labName))
  result = call_569064.call(path_569065, query_569066, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_569054(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsDelete_569055, base: "",
    url: url_EnvironmentsDelete_569056, schemes: {Scheme.Https})
type
  Call_SecretsList_569067 = ref object of OpenApiRestCall_567650
proc url_SecretsList_569069(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/secrets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretsList_569068(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List secrets in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569070 = path.getOrDefault("resourceGroupName")
  valid_569070 = validateParameter(valid_569070, JString, required = true,
                                 default = nil)
  if valid_569070 != nil:
    section.add "resourceGroupName", valid_569070
  var valid_569071 = path.getOrDefault("subscriptionId")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "subscriptionId", valid_569071
  var valid_569072 = path.getOrDefault("userName")
  valid_569072 = validateParameter(valid_569072, JString, required = true,
                                 default = nil)
  if valid_569072 != nil:
    section.add "userName", valid_569072
  var valid_569073 = path.getOrDefault("labName")
  valid_569073 = validateParameter(valid_569073, JString, required = true,
                                 default = nil)
  if valid_569073 != nil:
    section.add "labName", valid_569073
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_569074 = query.getOrDefault("$orderby")
  valid_569074 = validateParameter(valid_569074, JString, required = false,
                                 default = nil)
  if valid_569074 != nil:
    section.add "$orderby", valid_569074
  var valid_569075 = query.getOrDefault("$expand")
  valid_569075 = validateParameter(valid_569075, JString, required = false,
                                 default = nil)
  if valid_569075 != nil:
    section.add "$expand", valid_569075
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569076 = query.getOrDefault("api-version")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569076 != nil:
    section.add "api-version", valid_569076
  var valid_569077 = query.getOrDefault("$top")
  valid_569077 = validateParameter(valid_569077, JInt, required = false, default = nil)
  if valid_569077 != nil:
    section.add "$top", valid_569077
  var valid_569078 = query.getOrDefault("$filter")
  valid_569078 = validateParameter(valid_569078, JString, required = false,
                                 default = nil)
  if valid_569078 != nil:
    section.add "$filter", valid_569078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569079: Call_SecretsList_569067; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List secrets in a given user profile.
  ## 
  let valid = call_569079.validator(path, query, header, formData, body)
  let scheme = call_569079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569079.url(scheme.get, call_569079.host, call_569079.base,
                         call_569079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569079, url, valid)

proc call*(call_569080: Call_SecretsList_569067; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2016-05-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## secretsList
  ## List secrets in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=value)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_569081 = newJObject()
  var query_569082 = newJObject()
  add(query_569082, "$orderby", newJString(Orderby))
  add(path_569081, "resourceGroupName", newJString(resourceGroupName))
  add(query_569082, "$expand", newJString(Expand))
  add(query_569082, "api-version", newJString(apiVersion))
  add(path_569081, "subscriptionId", newJString(subscriptionId))
  add(query_569082, "$top", newJInt(Top))
  add(path_569081, "userName", newJString(userName))
  add(path_569081, "labName", newJString(labName))
  add(query_569082, "$filter", newJString(Filter))
  result = call_569080.call(path_569081, query_569082, nil, nil, nil)

var secretsList* = Call_SecretsList_569067(name: "secretsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets",
                                        validator: validate_SecretsList_569068,
                                        base: "", url: url_SecretsList_569069,
                                        schemes: {Scheme.Https})
type
  Call_SecretsCreateOrUpdate_569097 = ref object of OpenApiRestCall_567650
proc url_SecretsCreateOrUpdate_569099(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretsCreateOrUpdate_569098(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569100 = path.getOrDefault("resourceGroupName")
  valid_569100 = validateParameter(valid_569100, JString, required = true,
                                 default = nil)
  if valid_569100 != nil:
    section.add "resourceGroupName", valid_569100
  var valid_569101 = path.getOrDefault("name")
  valid_569101 = validateParameter(valid_569101, JString, required = true,
                                 default = nil)
  if valid_569101 != nil:
    section.add "name", valid_569101
  var valid_569102 = path.getOrDefault("subscriptionId")
  valid_569102 = validateParameter(valid_569102, JString, required = true,
                                 default = nil)
  if valid_569102 != nil:
    section.add "subscriptionId", valid_569102
  var valid_569103 = path.getOrDefault("userName")
  valid_569103 = validateParameter(valid_569103, JString, required = true,
                                 default = nil)
  if valid_569103 != nil:
    section.add "userName", valid_569103
  var valid_569104 = path.getOrDefault("labName")
  valid_569104 = validateParameter(valid_569104, JString, required = true,
                                 default = nil)
  if valid_569104 != nil:
    section.add "labName", valid_569104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569105 = query.getOrDefault("api-version")
  valid_569105 = validateParameter(valid_569105, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569105 != nil:
    section.add "api-version", valid_569105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   secret: JObject (required)
  ##         : A secret.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569107: Call_SecretsCreateOrUpdate_569097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing secret.
  ## 
  let valid = call_569107.validator(path, query, header, formData, body)
  let scheme = call_569107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569107.url(scheme.get, call_569107.host, call_569107.base,
                         call_569107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569107, url, valid)

proc call*(call_569108: Call_SecretsCreateOrUpdate_569097;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; secret: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## secretsCreateOrUpdate
  ## Create or replace an existing secret.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the secret.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   secret: JObject (required)
  ##         : A secret.
  var path_569109 = newJObject()
  var query_569110 = newJObject()
  var body_569111 = newJObject()
  add(path_569109, "resourceGroupName", newJString(resourceGroupName))
  add(query_569110, "api-version", newJString(apiVersion))
  add(path_569109, "name", newJString(name))
  add(path_569109, "subscriptionId", newJString(subscriptionId))
  add(path_569109, "userName", newJString(userName))
  add(path_569109, "labName", newJString(labName))
  if secret != nil:
    body_569111 = secret
  result = call_569108.call(path_569109, query_569110, nil, nil, body_569111)

var secretsCreateOrUpdate* = Call_SecretsCreateOrUpdate_569097(
    name: "secretsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsCreateOrUpdate_569098, base: "",
    url: url_SecretsCreateOrUpdate_569099, schemes: {Scheme.Https})
type
  Call_SecretsGet_569083 = ref object of OpenApiRestCall_567650
proc url_SecretsGet_569085(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretsGet_569084(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569086 = path.getOrDefault("resourceGroupName")
  valid_569086 = validateParameter(valid_569086, JString, required = true,
                                 default = nil)
  if valid_569086 != nil:
    section.add "resourceGroupName", valid_569086
  var valid_569087 = path.getOrDefault("name")
  valid_569087 = validateParameter(valid_569087, JString, required = true,
                                 default = nil)
  if valid_569087 != nil:
    section.add "name", valid_569087
  var valid_569088 = path.getOrDefault("subscriptionId")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = nil)
  if valid_569088 != nil:
    section.add "subscriptionId", valid_569088
  var valid_569089 = path.getOrDefault("userName")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "userName", valid_569089
  var valid_569090 = path.getOrDefault("labName")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "labName", valid_569090
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569091 = query.getOrDefault("$expand")
  valid_569091 = validateParameter(valid_569091, JString, required = false,
                                 default = nil)
  if valid_569091 != nil:
    section.add "$expand", valid_569091
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569092 = query.getOrDefault("api-version")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569092 != nil:
    section.add "api-version", valid_569092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569093: Call_SecretsGet_569083; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get secret.
  ## 
  let valid = call_569093.validator(path, query, header, formData, body)
  let scheme = call_569093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569093.url(scheme.get, call_569093.host, call_569093.base,
                         call_569093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569093, url, valid)

proc call*(call_569094: Call_SecretsGet_569083; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2016-05-15"): Recallable =
  ## secretsGet
  ## Get secret.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=value)'
  ##   name: string (required)
  ##       : The name of the secret.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569095 = newJObject()
  var query_569096 = newJObject()
  add(path_569095, "resourceGroupName", newJString(resourceGroupName))
  add(query_569096, "$expand", newJString(Expand))
  add(path_569095, "name", newJString(name))
  add(query_569096, "api-version", newJString(apiVersion))
  add(path_569095, "subscriptionId", newJString(subscriptionId))
  add(path_569095, "userName", newJString(userName))
  add(path_569095, "labName", newJString(labName))
  result = call_569094.call(path_569095, query_569096, nil, nil, nil)

var secretsGet* = Call_SecretsGet_569083(name: "secretsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
                                      validator: validate_SecretsGet_569084,
                                      base: "", url: url_SecretsGet_569085,
                                      schemes: {Scheme.Https})
type
  Call_SecretsDelete_569112 = ref object of OpenApiRestCall_567650
proc url_SecretsDelete_569114(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/secrets/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecretsDelete_569113(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569115 = path.getOrDefault("resourceGroupName")
  valid_569115 = validateParameter(valid_569115, JString, required = true,
                                 default = nil)
  if valid_569115 != nil:
    section.add "resourceGroupName", valid_569115
  var valid_569116 = path.getOrDefault("name")
  valid_569116 = validateParameter(valid_569116, JString, required = true,
                                 default = nil)
  if valid_569116 != nil:
    section.add "name", valid_569116
  var valid_569117 = path.getOrDefault("subscriptionId")
  valid_569117 = validateParameter(valid_569117, JString, required = true,
                                 default = nil)
  if valid_569117 != nil:
    section.add "subscriptionId", valid_569117
  var valid_569118 = path.getOrDefault("userName")
  valid_569118 = validateParameter(valid_569118, JString, required = true,
                                 default = nil)
  if valid_569118 != nil:
    section.add "userName", valid_569118
  var valid_569119 = path.getOrDefault("labName")
  valid_569119 = validateParameter(valid_569119, JString, required = true,
                                 default = nil)
  if valid_569119 != nil:
    section.add "labName", valid_569119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569120 = query.getOrDefault("api-version")
  valid_569120 = validateParameter(valid_569120, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569120 != nil:
    section.add "api-version", valid_569120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569121: Call_SecretsDelete_569112; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete secret.
  ## 
  let valid = call_569121.validator(path, query, header, formData, body)
  let scheme = call_569121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569121.url(scheme.get, call_569121.host, call_569121.base,
                         call_569121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569121, url, valid)

proc call*(call_569122: Call_SecretsDelete_569112; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## secretsDelete
  ## Delete secret.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the secret.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569123 = newJObject()
  var query_569124 = newJObject()
  add(path_569123, "resourceGroupName", newJString(resourceGroupName))
  add(query_569124, "api-version", newJString(apiVersion))
  add(path_569123, "name", newJString(name))
  add(path_569123, "subscriptionId", newJString(subscriptionId))
  add(path_569123, "userName", newJString(userName))
  add(path_569123, "labName", newJString(labName))
  result = call_569122.call(path_569123, query_569124, nil, nil, nil)

var secretsDelete* = Call_SecretsDelete_569112(name: "secretsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsDelete_569113, base: "", url: url_SecretsDelete_569114,
    schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_569125 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesList_569127(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesList_569126(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List virtual machines in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569128 = path.getOrDefault("resourceGroupName")
  valid_569128 = validateParameter(valid_569128, JString, required = true,
                                 default = nil)
  if valid_569128 != nil:
    section.add "resourceGroupName", valid_569128
  var valid_569129 = path.getOrDefault("subscriptionId")
  valid_569129 = validateParameter(valid_569129, JString, required = true,
                                 default = nil)
  if valid_569129 != nil:
    section.add "subscriptionId", valid_569129
  var valid_569130 = path.getOrDefault("labName")
  valid_569130 = validateParameter(valid_569130, JString, required = true,
                                 default = nil)
  if valid_569130 != nil:
    section.add "labName", valid_569130
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_569131 = query.getOrDefault("$orderby")
  valid_569131 = validateParameter(valid_569131, JString, required = false,
                                 default = nil)
  if valid_569131 != nil:
    section.add "$orderby", valid_569131
  var valid_569132 = query.getOrDefault("$expand")
  valid_569132 = validateParameter(valid_569132, JString, required = false,
                                 default = nil)
  if valid_569132 != nil:
    section.add "$expand", valid_569132
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569133 = query.getOrDefault("api-version")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569133 != nil:
    section.add "api-version", valid_569133
  var valid_569134 = query.getOrDefault("$top")
  valid_569134 = validateParameter(valid_569134, JInt, required = false, default = nil)
  if valid_569134 != nil:
    section.add "$top", valid_569134
  var valid_569135 = query.getOrDefault("$filter")
  valid_569135 = validateParameter(valid_569135, JString, required = false,
                                 default = nil)
  if valid_569135 != nil:
    section.add "$filter", valid_569135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569136: Call_VirtualMachinesList_569125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual machines in a given lab.
  ## 
  let valid = call_569136.validator(path, query, header, formData, body)
  let scheme = call_569136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569136.url(scheme.get, call_569136.host, call_569136.base,
                         call_569136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569136, url, valid)

proc call*(call_569137: Call_VirtualMachinesList_569125; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachinesList
  ## List virtual machines in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_569138 = newJObject()
  var query_569139 = newJObject()
  add(query_569139, "$orderby", newJString(Orderby))
  add(path_569138, "resourceGroupName", newJString(resourceGroupName))
  add(query_569139, "$expand", newJString(Expand))
  add(query_569139, "api-version", newJString(apiVersion))
  add(path_569138, "subscriptionId", newJString(subscriptionId))
  add(query_569139, "$top", newJInt(Top))
  add(path_569138, "labName", newJString(labName))
  add(query_569139, "$filter", newJString(Filter))
  result = call_569137.call(path_569138, query_569139, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_569125(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines",
    validator: validate_VirtualMachinesList_569126, base: "",
    url: url_VirtualMachinesList_569127, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_569153 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesCreateOrUpdate_569155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesCreateOrUpdate_569154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569156 = path.getOrDefault("resourceGroupName")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "resourceGroupName", valid_569156
  var valid_569157 = path.getOrDefault("name")
  valid_569157 = validateParameter(valid_569157, JString, required = true,
                                 default = nil)
  if valid_569157 != nil:
    section.add "name", valid_569157
  var valid_569158 = path.getOrDefault("subscriptionId")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = nil)
  if valid_569158 != nil:
    section.add "subscriptionId", valid_569158
  var valid_569159 = path.getOrDefault("labName")
  valid_569159 = validateParameter(valid_569159, JString, required = true,
                                 default = nil)
  if valid_569159 != nil:
    section.add "labName", valid_569159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569160 = query.getOrDefault("api-version")
  valid_569160 = validateParameter(valid_569160, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569160 != nil:
    section.add "api-version", valid_569160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569162: Call_VirtualMachinesCreateOrUpdate_569153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569162.validator(path, query, header, formData, body)
  let scheme = call_569162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569162.url(scheme.get, call_569162.host, call_569162.base,
                         call_569162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569162, url, valid)

proc call*(call_569163: Call_VirtualMachinesCreateOrUpdate_569153;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesCreateOrUpdate
  ## Create or replace an existing Virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  var path_569164 = newJObject()
  var query_569165 = newJObject()
  var body_569166 = newJObject()
  add(path_569164, "resourceGroupName", newJString(resourceGroupName))
  add(query_569165, "api-version", newJString(apiVersion))
  add(path_569164, "name", newJString(name))
  add(path_569164, "subscriptionId", newJString(subscriptionId))
  add(path_569164, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_569166 = labVirtualMachine
  result = call_569163.call(path_569164, query_569165, nil, nil, body_569166)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_569153(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesCreateOrUpdate_569154, base: "",
    url: url_VirtualMachinesCreateOrUpdate_569155, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_569140 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesGet_569142(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesGet_569141(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569143 = path.getOrDefault("resourceGroupName")
  valid_569143 = validateParameter(valid_569143, JString, required = true,
                                 default = nil)
  if valid_569143 != nil:
    section.add "resourceGroupName", valid_569143
  var valid_569144 = path.getOrDefault("name")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "name", valid_569144
  var valid_569145 = path.getOrDefault("subscriptionId")
  valid_569145 = validateParameter(valid_569145, JString, required = true,
                                 default = nil)
  if valid_569145 != nil:
    section.add "subscriptionId", valid_569145
  var valid_569146 = path.getOrDefault("labName")
  valid_569146 = validateParameter(valid_569146, JString, required = true,
                                 default = nil)
  if valid_569146 != nil:
    section.add "labName", valid_569146
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569147 = query.getOrDefault("$expand")
  valid_569147 = validateParameter(valid_569147, JString, required = false,
                                 default = nil)
  if valid_569147 != nil:
    section.add "$expand", valid_569147
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569148 = query.getOrDefault("api-version")
  valid_569148 = validateParameter(valid_569148, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569148 != nil:
    section.add "api-version", valid_569148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569149: Call_VirtualMachinesGet_569140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine.
  ## 
  let valid = call_569149.validator(path, query, header, formData, body)
  let scheme = call_569149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569149.url(scheme.get, call_569149.host, call_569149.base,
                         call_569149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569149, url, valid)

proc call*(call_569150: Call_VirtualMachinesGet_569140; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesGet
  ## Get virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569151 = newJObject()
  var query_569152 = newJObject()
  add(path_569151, "resourceGroupName", newJString(resourceGroupName))
  add(query_569152, "$expand", newJString(Expand))
  add(path_569151, "name", newJString(name))
  add(query_569152, "api-version", newJString(apiVersion))
  add(path_569151, "subscriptionId", newJString(subscriptionId))
  add(path_569151, "labName", newJString(labName))
  result = call_569150.call(path_569151, query_569152, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_569140(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesGet_569141, base: "",
    url: url_VirtualMachinesGet_569142, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_569179 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesUpdate_569181(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesUpdate_569180(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569182 = path.getOrDefault("resourceGroupName")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "resourceGroupName", valid_569182
  var valid_569183 = path.getOrDefault("name")
  valid_569183 = validateParameter(valid_569183, JString, required = true,
                                 default = nil)
  if valid_569183 != nil:
    section.add "name", valid_569183
  var valid_569184 = path.getOrDefault("subscriptionId")
  valid_569184 = validateParameter(valid_569184, JString, required = true,
                                 default = nil)
  if valid_569184 != nil:
    section.add "subscriptionId", valid_569184
  var valid_569185 = path.getOrDefault("labName")
  valid_569185 = validateParameter(valid_569185, JString, required = true,
                                 default = nil)
  if valid_569185 != nil:
    section.add "labName", valid_569185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569186 = query.getOrDefault("api-version")
  valid_569186 = validateParameter(valid_569186, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569186 != nil:
    section.add "api-version", valid_569186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569188: Call_VirtualMachinesUpdate_569179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual machines.
  ## 
  let valid = call_569188.validator(path, query, header, formData, body)
  let scheme = call_569188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569188.url(scheme.get, call_569188.host, call_569188.base,
                         call_569188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569188, url, valid)

proc call*(call_569189: Call_VirtualMachinesUpdate_569179;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesUpdate
  ## Modify properties of virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  var path_569190 = newJObject()
  var query_569191 = newJObject()
  var body_569192 = newJObject()
  add(path_569190, "resourceGroupName", newJString(resourceGroupName))
  add(query_569191, "api-version", newJString(apiVersion))
  add(path_569190, "name", newJString(name))
  add(path_569190, "subscriptionId", newJString(subscriptionId))
  add(path_569190, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_569192 = labVirtualMachine
  result = call_569189.call(path_569190, query_569191, nil, nil, body_569192)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_569179(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesUpdate_569180, base: "",
    url: url_VirtualMachinesUpdate_569181, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_569167 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesDelete_569169(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesDelete_569168(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569170 = path.getOrDefault("resourceGroupName")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = nil)
  if valid_569170 != nil:
    section.add "resourceGroupName", valid_569170
  var valid_569171 = path.getOrDefault("name")
  valid_569171 = validateParameter(valid_569171, JString, required = true,
                                 default = nil)
  if valid_569171 != nil:
    section.add "name", valid_569171
  var valid_569172 = path.getOrDefault("subscriptionId")
  valid_569172 = validateParameter(valid_569172, JString, required = true,
                                 default = nil)
  if valid_569172 != nil:
    section.add "subscriptionId", valid_569172
  var valid_569173 = path.getOrDefault("labName")
  valid_569173 = validateParameter(valid_569173, JString, required = true,
                                 default = nil)
  if valid_569173 != nil:
    section.add "labName", valid_569173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569174 = query.getOrDefault("api-version")
  valid_569174 = validateParameter(valid_569174, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569174 != nil:
    section.add "api-version", valid_569174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569175: Call_VirtualMachinesDelete_569167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569175.validator(path, query, header, formData, body)
  let scheme = call_569175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569175.url(scheme.get, call_569175.host, call_569175.base,
                         call_569175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569175, url, valid)

proc call*(call_569176: Call_VirtualMachinesDelete_569167;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesDelete
  ## Delete virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569177 = newJObject()
  var query_569178 = newJObject()
  add(path_569177, "resourceGroupName", newJString(resourceGroupName))
  add(query_569178, "api-version", newJString(apiVersion))
  add(path_569177, "name", newJString(name))
  add(path_569177, "subscriptionId", newJString(subscriptionId))
  add(path_569177, "labName", newJString(labName))
  result = call_569176.call(path_569177, query_569178, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_569167(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesDelete_569168, base: "",
    url: url_VirtualMachinesDelete_569169, schemes: {Scheme.Https})
type
  Call_VirtualMachinesAddDataDisk_569193 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesAddDataDisk_569195(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/addDataDisk")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesAddDataDisk_569194(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569196 = path.getOrDefault("resourceGroupName")
  valid_569196 = validateParameter(valid_569196, JString, required = true,
                                 default = nil)
  if valid_569196 != nil:
    section.add "resourceGroupName", valid_569196
  var valid_569197 = path.getOrDefault("name")
  valid_569197 = validateParameter(valid_569197, JString, required = true,
                                 default = nil)
  if valid_569197 != nil:
    section.add "name", valid_569197
  var valid_569198 = path.getOrDefault("subscriptionId")
  valid_569198 = validateParameter(valid_569198, JString, required = true,
                                 default = nil)
  if valid_569198 != nil:
    section.add "subscriptionId", valid_569198
  var valid_569199 = path.getOrDefault("labName")
  valid_569199 = validateParameter(valid_569199, JString, required = true,
                                 default = nil)
  if valid_569199 != nil:
    section.add "labName", valid_569199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569200 = query.getOrDefault("api-version")
  valid_569200 = validateParameter(valid_569200, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569200 != nil:
    section.add "api-version", valid_569200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataDiskProperties: JObject (required)
  ##                     : Request body for adding a new or existing data disk to a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569202: Call_VirtualMachinesAddDataDisk_569193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569202.validator(path, query, header, formData, body)
  let scheme = call_569202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569202.url(scheme.get, call_569202.host, call_569202.base,
                         call_569202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569202, url, valid)

proc call*(call_569203: Call_VirtualMachinesAddDataDisk_569193;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; dataDiskProperties: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesAddDataDisk
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   dataDiskProperties: JObject (required)
  ##                     : Request body for adding a new or existing data disk to a virtual machine.
  var path_569204 = newJObject()
  var query_569205 = newJObject()
  var body_569206 = newJObject()
  add(path_569204, "resourceGroupName", newJString(resourceGroupName))
  add(query_569205, "api-version", newJString(apiVersion))
  add(path_569204, "name", newJString(name))
  add(path_569204, "subscriptionId", newJString(subscriptionId))
  add(path_569204, "labName", newJString(labName))
  if dataDiskProperties != nil:
    body_569206 = dataDiskProperties
  result = call_569203.call(path_569204, query_569205, nil, nil, body_569206)

var virtualMachinesAddDataDisk* = Call_VirtualMachinesAddDataDisk_569193(
    name: "virtualMachinesAddDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/addDataDisk",
    validator: validate_VirtualMachinesAddDataDisk_569194, base: "",
    url: url_VirtualMachinesAddDataDisk_569195, schemes: {Scheme.Https})
type
  Call_VirtualMachinesApplyArtifacts_569207 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesApplyArtifacts_569209(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/applyArtifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesApplyArtifacts_569208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569210 = path.getOrDefault("resourceGroupName")
  valid_569210 = validateParameter(valid_569210, JString, required = true,
                                 default = nil)
  if valid_569210 != nil:
    section.add "resourceGroupName", valid_569210
  var valid_569211 = path.getOrDefault("name")
  valid_569211 = validateParameter(valid_569211, JString, required = true,
                                 default = nil)
  if valid_569211 != nil:
    section.add "name", valid_569211
  var valid_569212 = path.getOrDefault("subscriptionId")
  valid_569212 = validateParameter(valid_569212, JString, required = true,
                                 default = nil)
  if valid_569212 != nil:
    section.add "subscriptionId", valid_569212
  var valid_569213 = path.getOrDefault("labName")
  valid_569213 = validateParameter(valid_569213, JString, required = true,
                                 default = nil)
  if valid_569213 != nil:
    section.add "labName", valid_569213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569214 = query.getOrDefault("api-version")
  valid_569214 = validateParameter(valid_569214, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569214 != nil:
    section.add "api-version", valid_569214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applyArtifactsRequest: JObject (required)
  ##                        : Request body for applying artifacts to a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569216: Call_VirtualMachinesApplyArtifacts_569207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569216.validator(path, query, header, formData, body)
  let scheme = call_569216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569216.url(scheme.get, call_569216.host, call_569216.base,
                         call_569216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569216, url, valid)

proc call*(call_569217: Call_VirtualMachinesApplyArtifacts_569207;
          resourceGroupName: string; name: string; subscriptionId: string;
          applyArtifactsRequest: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesApplyArtifacts
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   applyArtifactsRequest: JObject (required)
  ##                        : Request body for applying artifacts to a virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569218 = newJObject()
  var query_569219 = newJObject()
  var body_569220 = newJObject()
  add(path_569218, "resourceGroupName", newJString(resourceGroupName))
  add(query_569219, "api-version", newJString(apiVersion))
  add(path_569218, "name", newJString(name))
  add(path_569218, "subscriptionId", newJString(subscriptionId))
  if applyArtifactsRequest != nil:
    body_569220 = applyArtifactsRequest
  add(path_569218, "labName", newJString(labName))
  result = call_569217.call(path_569218, query_569219, nil, nil, body_569220)

var virtualMachinesApplyArtifacts* = Call_VirtualMachinesApplyArtifacts_569207(
    name: "virtualMachinesApplyArtifacts", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/applyArtifacts",
    validator: validate_VirtualMachinesApplyArtifacts_569208, base: "",
    url: url_VirtualMachinesApplyArtifacts_569209, schemes: {Scheme.Https})
type
  Call_VirtualMachinesClaim_569221 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesClaim_569223(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/claim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesClaim_569222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569224 = path.getOrDefault("resourceGroupName")
  valid_569224 = validateParameter(valid_569224, JString, required = true,
                                 default = nil)
  if valid_569224 != nil:
    section.add "resourceGroupName", valid_569224
  var valid_569225 = path.getOrDefault("name")
  valid_569225 = validateParameter(valid_569225, JString, required = true,
                                 default = nil)
  if valid_569225 != nil:
    section.add "name", valid_569225
  var valid_569226 = path.getOrDefault("subscriptionId")
  valid_569226 = validateParameter(valid_569226, JString, required = true,
                                 default = nil)
  if valid_569226 != nil:
    section.add "subscriptionId", valid_569226
  var valid_569227 = path.getOrDefault("labName")
  valid_569227 = validateParameter(valid_569227, JString, required = true,
                                 default = nil)
  if valid_569227 != nil:
    section.add "labName", valid_569227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569228 = query.getOrDefault("api-version")
  valid_569228 = validateParameter(valid_569228, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569228 != nil:
    section.add "api-version", valid_569228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569229: Call_VirtualMachinesClaim_569221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  let valid = call_569229.validator(path, query, header, formData, body)
  let scheme = call_569229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569229.url(scheme.get, call_569229.host, call_569229.base,
                         call_569229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569229, url, valid)

proc call*(call_569230: Call_VirtualMachinesClaim_569221;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesClaim
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569231 = newJObject()
  var query_569232 = newJObject()
  add(path_569231, "resourceGroupName", newJString(resourceGroupName))
  add(query_569232, "api-version", newJString(apiVersion))
  add(path_569231, "name", newJString(name))
  add(path_569231, "subscriptionId", newJString(subscriptionId))
  add(path_569231, "labName", newJString(labName))
  result = call_569230.call(path_569231, query_569232, nil, nil, nil)

var virtualMachinesClaim* = Call_VirtualMachinesClaim_569221(
    name: "virtualMachinesClaim", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/claim",
    validator: validate_VirtualMachinesClaim_569222, base: "",
    url: url_VirtualMachinesClaim_569223, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDetachDataDisk_569233 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesDetachDataDisk_569235(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/detachDataDisk")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesDetachDataDisk_569234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569236 = path.getOrDefault("resourceGroupName")
  valid_569236 = validateParameter(valid_569236, JString, required = true,
                                 default = nil)
  if valid_569236 != nil:
    section.add "resourceGroupName", valid_569236
  var valid_569237 = path.getOrDefault("name")
  valid_569237 = validateParameter(valid_569237, JString, required = true,
                                 default = nil)
  if valid_569237 != nil:
    section.add "name", valid_569237
  var valid_569238 = path.getOrDefault("subscriptionId")
  valid_569238 = validateParameter(valid_569238, JString, required = true,
                                 default = nil)
  if valid_569238 != nil:
    section.add "subscriptionId", valid_569238
  var valid_569239 = path.getOrDefault("labName")
  valid_569239 = validateParameter(valid_569239, JString, required = true,
                                 default = nil)
  if valid_569239 != nil:
    section.add "labName", valid_569239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569240 = query.getOrDefault("api-version")
  valid_569240 = validateParameter(valid_569240, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569240 != nil:
    section.add "api-version", valid_569240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   detachDataDiskProperties: JObject (required)
  ##                           : Request body for detaching data disk from a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569242: Call_VirtualMachinesDetachDataDisk_569233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569242.validator(path, query, header, formData, body)
  let scheme = call_569242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569242.url(scheme.get, call_569242.host, call_569242.base,
                         call_569242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569242, url, valid)

proc call*(call_569243: Call_VirtualMachinesDetachDataDisk_569233;
          resourceGroupName: string; name: string; subscriptionId: string;
          detachDataDiskProperties: JsonNode; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesDetachDataDisk
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   detachDataDiskProperties: JObject (required)
  ##                           : Request body for detaching data disk from a virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569244 = newJObject()
  var query_569245 = newJObject()
  var body_569246 = newJObject()
  add(path_569244, "resourceGroupName", newJString(resourceGroupName))
  add(query_569245, "api-version", newJString(apiVersion))
  add(path_569244, "name", newJString(name))
  add(path_569244, "subscriptionId", newJString(subscriptionId))
  if detachDataDiskProperties != nil:
    body_569246 = detachDataDiskProperties
  add(path_569244, "labName", newJString(labName))
  result = call_569243.call(path_569244, query_569245, nil, nil, body_569246)

var virtualMachinesDetachDataDisk* = Call_VirtualMachinesDetachDataDisk_569233(
    name: "virtualMachinesDetachDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/detachDataDisk",
    validator: validate_VirtualMachinesDetachDataDisk_569234, base: "",
    url: url_VirtualMachinesDetachDataDisk_569235, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListApplicableSchedules_569247 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesListApplicableSchedules_569249(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listApplicableSchedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesListApplicableSchedules_569248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all applicable schedules
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569250 = path.getOrDefault("resourceGroupName")
  valid_569250 = validateParameter(valid_569250, JString, required = true,
                                 default = nil)
  if valid_569250 != nil:
    section.add "resourceGroupName", valid_569250
  var valid_569251 = path.getOrDefault("name")
  valid_569251 = validateParameter(valid_569251, JString, required = true,
                                 default = nil)
  if valid_569251 != nil:
    section.add "name", valid_569251
  var valid_569252 = path.getOrDefault("subscriptionId")
  valid_569252 = validateParameter(valid_569252, JString, required = true,
                                 default = nil)
  if valid_569252 != nil:
    section.add "subscriptionId", valid_569252
  var valid_569253 = path.getOrDefault("labName")
  valid_569253 = validateParameter(valid_569253, JString, required = true,
                                 default = nil)
  if valid_569253 != nil:
    section.add "labName", valid_569253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569254 = query.getOrDefault("api-version")
  valid_569254 = validateParameter(valid_569254, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569254 != nil:
    section.add "api-version", valid_569254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569255: Call_VirtualMachinesListApplicableSchedules_569247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all applicable schedules
  ## 
  let valid = call_569255.validator(path, query, header, formData, body)
  let scheme = call_569255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569255.url(scheme.get, call_569255.host, call_569255.base,
                         call_569255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569255, url, valid)

proc call*(call_569256: Call_VirtualMachinesListApplicableSchedules_569247;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesListApplicableSchedules
  ## Lists all applicable schedules
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569257 = newJObject()
  var query_569258 = newJObject()
  add(path_569257, "resourceGroupName", newJString(resourceGroupName))
  add(query_569258, "api-version", newJString(apiVersion))
  add(path_569257, "name", newJString(name))
  add(path_569257, "subscriptionId", newJString(subscriptionId))
  add(path_569257, "labName", newJString(labName))
  result = call_569256.call(path_569257, query_569258, nil, nil, nil)

var virtualMachinesListApplicableSchedules* = Call_VirtualMachinesListApplicableSchedules_569247(
    name: "virtualMachinesListApplicableSchedules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/listApplicableSchedules",
    validator: validate_VirtualMachinesListApplicableSchedules_569248, base: "",
    url: url_VirtualMachinesListApplicableSchedules_569249,
    schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_569259 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesStart_569261(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesStart_569260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start a virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569262 = path.getOrDefault("resourceGroupName")
  valid_569262 = validateParameter(valid_569262, JString, required = true,
                                 default = nil)
  if valid_569262 != nil:
    section.add "resourceGroupName", valid_569262
  var valid_569263 = path.getOrDefault("name")
  valid_569263 = validateParameter(valid_569263, JString, required = true,
                                 default = nil)
  if valid_569263 != nil:
    section.add "name", valid_569263
  var valid_569264 = path.getOrDefault("subscriptionId")
  valid_569264 = validateParameter(valid_569264, JString, required = true,
                                 default = nil)
  if valid_569264 != nil:
    section.add "subscriptionId", valid_569264
  var valid_569265 = path.getOrDefault("labName")
  valid_569265 = validateParameter(valid_569265, JString, required = true,
                                 default = nil)
  if valid_569265 != nil:
    section.add "labName", valid_569265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569266 = query.getOrDefault("api-version")
  valid_569266 = validateParameter(valid_569266, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569266 != nil:
    section.add "api-version", valid_569266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569267: Call_VirtualMachinesStart_569259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569267.validator(path, query, header, formData, body)
  let scheme = call_569267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569267.url(scheme.get, call_569267.host, call_569267.base,
                         call_569267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569267, url, valid)

proc call*(call_569268: Call_VirtualMachinesStart_569259;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesStart
  ## Start a virtual machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569269 = newJObject()
  var query_569270 = newJObject()
  add(path_569269, "resourceGroupName", newJString(resourceGroupName))
  add(query_569270, "api-version", newJString(apiVersion))
  add(path_569269, "name", newJString(name))
  add(path_569269, "subscriptionId", newJString(subscriptionId))
  add(path_569269, "labName", newJString(labName))
  result = call_569268.call(path_569269, query_569270, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_569259(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/start",
    validator: validate_VirtualMachinesStart_569260, base: "",
    url: url_VirtualMachinesStart_569261, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStop_569271 = ref object of OpenApiRestCall_567650
proc url_VirtualMachinesStop_569273(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesStop_569272(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Stop a virtual machine This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569274 = path.getOrDefault("resourceGroupName")
  valid_569274 = validateParameter(valid_569274, JString, required = true,
                                 default = nil)
  if valid_569274 != nil:
    section.add "resourceGroupName", valid_569274
  var valid_569275 = path.getOrDefault("name")
  valid_569275 = validateParameter(valid_569275, JString, required = true,
                                 default = nil)
  if valid_569275 != nil:
    section.add "name", valid_569275
  var valid_569276 = path.getOrDefault("subscriptionId")
  valid_569276 = validateParameter(valid_569276, JString, required = true,
                                 default = nil)
  if valid_569276 != nil:
    section.add "subscriptionId", valid_569276
  var valid_569277 = path.getOrDefault("labName")
  valid_569277 = validateParameter(valid_569277, JString, required = true,
                                 default = nil)
  if valid_569277 != nil:
    section.add "labName", valid_569277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569278 = query.getOrDefault("api-version")
  valid_569278 = validateParameter(valid_569278, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569278 != nil:
    section.add "api-version", valid_569278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569279: Call_VirtualMachinesStop_569271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a virtual machine This operation can take a while to complete.
  ## 
  let valid = call_569279.validator(path, query, header, formData, body)
  let scheme = call_569279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569279.url(scheme.get, call_569279.host, call_569279.base,
                         call_569279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569279, url, valid)

proc call*(call_569280: Call_VirtualMachinesStop_569271; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesStop
  ## Stop a virtual machine This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569281 = newJObject()
  var query_569282 = newJObject()
  add(path_569281, "resourceGroupName", newJString(resourceGroupName))
  add(query_569282, "api-version", newJString(apiVersion))
  add(path_569281, "name", newJString(name))
  add(path_569281, "subscriptionId", newJString(subscriptionId))
  add(path_569281, "labName", newJString(labName))
  result = call_569280.call(path_569281, query_569282, nil, nil, nil)

var virtualMachinesStop* = Call_VirtualMachinesStop_569271(
    name: "virtualMachinesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/stop",
    validator: validate_VirtualMachinesStop_569272, base: "",
    url: url_VirtualMachinesStop_569273, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesList_569283 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineSchedulesList_569285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesList_569284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a given virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569286 = path.getOrDefault("resourceGroupName")
  valid_569286 = validateParameter(valid_569286, JString, required = true,
                                 default = nil)
  if valid_569286 != nil:
    section.add "resourceGroupName", valid_569286
  var valid_569287 = path.getOrDefault("virtualMachineName")
  valid_569287 = validateParameter(valid_569287, JString, required = true,
                                 default = nil)
  if valid_569287 != nil:
    section.add "virtualMachineName", valid_569287
  var valid_569288 = path.getOrDefault("subscriptionId")
  valid_569288 = validateParameter(valid_569288, JString, required = true,
                                 default = nil)
  if valid_569288 != nil:
    section.add "subscriptionId", valid_569288
  var valid_569289 = path.getOrDefault("labName")
  valid_569289 = validateParameter(valid_569289, JString, required = true,
                                 default = nil)
  if valid_569289 != nil:
    section.add "labName", valid_569289
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_569290 = query.getOrDefault("$orderby")
  valid_569290 = validateParameter(valid_569290, JString, required = false,
                                 default = nil)
  if valid_569290 != nil:
    section.add "$orderby", valid_569290
  var valid_569291 = query.getOrDefault("$expand")
  valid_569291 = validateParameter(valid_569291, JString, required = false,
                                 default = nil)
  if valid_569291 != nil:
    section.add "$expand", valid_569291
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569292 = query.getOrDefault("api-version")
  valid_569292 = validateParameter(valid_569292, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569292 != nil:
    section.add "api-version", valid_569292
  var valid_569293 = query.getOrDefault("$top")
  valid_569293 = validateParameter(valid_569293, JInt, required = false, default = nil)
  if valid_569293 != nil:
    section.add "$top", valid_569293
  var valid_569294 = query.getOrDefault("$filter")
  valid_569294 = validateParameter(valid_569294, JString, required = false,
                                 default = nil)
  if valid_569294 != nil:
    section.add "$filter", valid_569294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569295: Call_VirtualMachineSchedulesList_569283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given virtual machine.
  ## 
  let valid = call_569295.validator(path, query, header, formData, body)
  let scheme = call_569295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569295.url(scheme.get, call_569295.host, call_569295.base,
                         call_569295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569295, url, valid)

proc call*(call_569296: Call_VirtualMachineSchedulesList_569283;
          resourceGroupName: string; virtualMachineName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachineSchedulesList
  ## List schedules in a given virtual machine.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_569297 = newJObject()
  var query_569298 = newJObject()
  add(query_569298, "$orderby", newJString(Orderby))
  add(path_569297, "resourceGroupName", newJString(resourceGroupName))
  add(query_569298, "$expand", newJString(Expand))
  add(path_569297, "virtualMachineName", newJString(virtualMachineName))
  add(query_569298, "api-version", newJString(apiVersion))
  add(path_569297, "subscriptionId", newJString(subscriptionId))
  add(query_569298, "$top", newJInt(Top))
  add(path_569297, "labName", newJString(labName))
  add(query_569298, "$filter", newJString(Filter))
  result = call_569296.call(path_569297, query_569298, nil, nil, nil)

var virtualMachineSchedulesList* = Call_VirtualMachineSchedulesList_569283(
    name: "virtualMachineSchedulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules",
    validator: validate_VirtualMachineSchedulesList_569284, base: "",
    url: url_VirtualMachineSchedulesList_569285, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesCreateOrUpdate_569313 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineSchedulesCreateOrUpdate_569315(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesCreateOrUpdate_569314(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569316 = path.getOrDefault("resourceGroupName")
  valid_569316 = validateParameter(valid_569316, JString, required = true,
                                 default = nil)
  if valid_569316 != nil:
    section.add "resourceGroupName", valid_569316
  var valid_569317 = path.getOrDefault("virtualMachineName")
  valid_569317 = validateParameter(valid_569317, JString, required = true,
                                 default = nil)
  if valid_569317 != nil:
    section.add "virtualMachineName", valid_569317
  var valid_569318 = path.getOrDefault("name")
  valid_569318 = validateParameter(valid_569318, JString, required = true,
                                 default = nil)
  if valid_569318 != nil:
    section.add "name", valid_569318
  var valid_569319 = path.getOrDefault("subscriptionId")
  valid_569319 = validateParameter(valid_569319, JString, required = true,
                                 default = nil)
  if valid_569319 != nil:
    section.add "subscriptionId", valid_569319
  var valid_569320 = path.getOrDefault("labName")
  valid_569320 = validateParameter(valid_569320, JString, required = true,
                                 default = nil)
  if valid_569320 != nil:
    section.add "labName", valid_569320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569321 = query.getOrDefault("api-version")
  valid_569321 = validateParameter(valid_569321, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569321 != nil:
    section.add "api-version", valid_569321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569323: Call_VirtualMachineSchedulesCreateOrUpdate_569313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_569323.validator(path, query, header, formData, body)
  let scheme = call_569323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569323.url(scheme.get, call_569323.host, call_569323.base,
                         call_569323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569323, url, valid)

proc call*(call_569324: Call_VirtualMachineSchedulesCreateOrUpdate_569313;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_569325 = newJObject()
  var query_569326 = newJObject()
  var body_569327 = newJObject()
  add(path_569325, "resourceGroupName", newJString(resourceGroupName))
  add(query_569326, "api-version", newJString(apiVersion))
  add(path_569325, "virtualMachineName", newJString(virtualMachineName))
  add(path_569325, "name", newJString(name))
  add(path_569325, "subscriptionId", newJString(subscriptionId))
  add(path_569325, "labName", newJString(labName))
  if schedule != nil:
    body_569327 = schedule
  result = call_569324.call(path_569325, query_569326, nil, nil, body_569327)

var virtualMachineSchedulesCreateOrUpdate* = Call_VirtualMachineSchedulesCreateOrUpdate_569313(
    name: "virtualMachineSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesCreateOrUpdate_569314, base: "",
    url: url_VirtualMachineSchedulesCreateOrUpdate_569315, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesGet_569299 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineSchedulesGet_569301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesGet_569300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569302 = path.getOrDefault("resourceGroupName")
  valid_569302 = validateParameter(valid_569302, JString, required = true,
                                 default = nil)
  if valid_569302 != nil:
    section.add "resourceGroupName", valid_569302
  var valid_569303 = path.getOrDefault("virtualMachineName")
  valid_569303 = validateParameter(valid_569303, JString, required = true,
                                 default = nil)
  if valid_569303 != nil:
    section.add "virtualMachineName", valid_569303
  var valid_569304 = path.getOrDefault("name")
  valid_569304 = validateParameter(valid_569304, JString, required = true,
                                 default = nil)
  if valid_569304 != nil:
    section.add "name", valid_569304
  var valid_569305 = path.getOrDefault("subscriptionId")
  valid_569305 = validateParameter(valid_569305, JString, required = true,
                                 default = nil)
  if valid_569305 != nil:
    section.add "subscriptionId", valid_569305
  var valid_569306 = path.getOrDefault("labName")
  valid_569306 = validateParameter(valid_569306, JString, required = true,
                                 default = nil)
  if valid_569306 != nil:
    section.add "labName", valid_569306
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569307 = query.getOrDefault("$expand")
  valid_569307 = validateParameter(valid_569307, JString, required = false,
                                 default = nil)
  if valid_569307 != nil:
    section.add "$expand", valid_569307
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569308 = query.getOrDefault("api-version")
  valid_569308 = validateParameter(valid_569308, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569308 != nil:
    section.add "api-version", valid_569308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569309: Call_VirtualMachineSchedulesGet_569299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_569309.validator(path, query, header, formData, body)
  let scheme = call_569309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569309.url(scheme.get, call_569309.host, call_569309.base,
                         call_569309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569309, url, valid)

proc call*(call_569310: Call_VirtualMachineSchedulesGet_569299;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesGet
  ## Get schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569311 = newJObject()
  var query_569312 = newJObject()
  add(path_569311, "resourceGroupName", newJString(resourceGroupName))
  add(query_569312, "$expand", newJString(Expand))
  add(path_569311, "virtualMachineName", newJString(virtualMachineName))
  add(path_569311, "name", newJString(name))
  add(query_569312, "api-version", newJString(apiVersion))
  add(path_569311, "subscriptionId", newJString(subscriptionId))
  add(path_569311, "labName", newJString(labName))
  result = call_569310.call(path_569311, query_569312, nil, nil, nil)

var virtualMachineSchedulesGet* = Call_VirtualMachineSchedulesGet_569299(
    name: "virtualMachineSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesGet_569300, base: "",
    url: url_VirtualMachineSchedulesGet_569301, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesUpdate_569341 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineSchedulesUpdate_569343(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesUpdate_569342(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569344 = path.getOrDefault("resourceGroupName")
  valid_569344 = validateParameter(valid_569344, JString, required = true,
                                 default = nil)
  if valid_569344 != nil:
    section.add "resourceGroupName", valid_569344
  var valid_569345 = path.getOrDefault("virtualMachineName")
  valid_569345 = validateParameter(valid_569345, JString, required = true,
                                 default = nil)
  if valid_569345 != nil:
    section.add "virtualMachineName", valid_569345
  var valid_569346 = path.getOrDefault("name")
  valid_569346 = validateParameter(valid_569346, JString, required = true,
                                 default = nil)
  if valid_569346 != nil:
    section.add "name", valid_569346
  var valid_569347 = path.getOrDefault("subscriptionId")
  valid_569347 = validateParameter(valid_569347, JString, required = true,
                                 default = nil)
  if valid_569347 != nil:
    section.add "subscriptionId", valid_569347
  var valid_569348 = path.getOrDefault("labName")
  valid_569348 = validateParameter(valid_569348, JString, required = true,
                                 default = nil)
  if valid_569348 != nil:
    section.add "labName", valid_569348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569349 = query.getOrDefault("api-version")
  valid_569349 = validateParameter(valid_569349, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569349 != nil:
    section.add "api-version", valid_569349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569351: Call_VirtualMachineSchedulesUpdate_569341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_569351.validator(path, query, header, formData, body)
  let scheme = call_569351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569351.url(scheme.get, call_569351.host, call_569351.base,
                         call_569351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569351, url, valid)

proc call*(call_569352: Call_VirtualMachineSchedulesUpdate_569341;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesUpdate
  ## Modify properties of schedules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_569353 = newJObject()
  var query_569354 = newJObject()
  var body_569355 = newJObject()
  add(path_569353, "resourceGroupName", newJString(resourceGroupName))
  add(query_569354, "api-version", newJString(apiVersion))
  add(path_569353, "virtualMachineName", newJString(virtualMachineName))
  add(path_569353, "name", newJString(name))
  add(path_569353, "subscriptionId", newJString(subscriptionId))
  add(path_569353, "labName", newJString(labName))
  if schedule != nil:
    body_569355 = schedule
  result = call_569352.call(path_569353, query_569354, nil, nil, body_569355)

var virtualMachineSchedulesUpdate* = Call_VirtualMachineSchedulesUpdate_569341(
    name: "virtualMachineSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesUpdate_569342, base: "",
    url: url_VirtualMachineSchedulesUpdate_569343, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesDelete_569328 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineSchedulesDelete_569330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesDelete_569329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569331 = path.getOrDefault("resourceGroupName")
  valid_569331 = validateParameter(valid_569331, JString, required = true,
                                 default = nil)
  if valid_569331 != nil:
    section.add "resourceGroupName", valid_569331
  var valid_569332 = path.getOrDefault("virtualMachineName")
  valid_569332 = validateParameter(valid_569332, JString, required = true,
                                 default = nil)
  if valid_569332 != nil:
    section.add "virtualMachineName", valid_569332
  var valid_569333 = path.getOrDefault("name")
  valid_569333 = validateParameter(valid_569333, JString, required = true,
                                 default = nil)
  if valid_569333 != nil:
    section.add "name", valid_569333
  var valid_569334 = path.getOrDefault("subscriptionId")
  valid_569334 = validateParameter(valid_569334, JString, required = true,
                                 default = nil)
  if valid_569334 != nil:
    section.add "subscriptionId", valid_569334
  var valid_569335 = path.getOrDefault("labName")
  valid_569335 = validateParameter(valid_569335, JString, required = true,
                                 default = nil)
  if valid_569335 != nil:
    section.add "labName", valid_569335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569336 = query.getOrDefault("api-version")
  valid_569336 = validateParameter(valid_569336, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569336 != nil:
    section.add "api-version", valid_569336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569337: Call_VirtualMachineSchedulesDelete_569328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_569337.validator(path, query, header, formData, body)
  let scheme = call_569337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569337.url(scheme.get, call_569337.host, call_569337.base,
                         call_569337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569337, url, valid)

proc call*(call_569338: Call_VirtualMachineSchedulesDelete_569328;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesDelete
  ## Delete schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569339 = newJObject()
  var query_569340 = newJObject()
  add(path_569339, "resourceGroupName", newJString(resourceGroupName))
  add(query_569340, "api-version", newJString(apiVersion))
  add(path_569339, "virtualMachineName", newJString(virtualMachineName))
  add(path_569339, "name", newJString(name))
  add(path_569339, "subscriptionId", newJString(subscriptionId))
  add(path_569339, "labName", newJString(labName))
  result = call_569338.call(path_569339, query_569340, nil, nil, nil)

var virtualMachineSchedulesDelete* = Call_VirtualMachineSchedulesDelete_569328(
    name: "virtualMachineSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesDelete_569329, base: "",
    url: url_VirtualMachineSchedulesDelete_569330, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesExecute_569356 = ref object of OpenApiRestCall_567650
proc url_VirtualMachineSchedulesExecute_569358(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "virtualMachineName" in path,
        "`virtualMachineName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "virtualMachineName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSchedulesExecute_569357(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569359 = path.getOrDefault("resourceGroupName")
  valid_569359 = validateParameter(valid_569359, JString, required = true,
                                 default = nil)
  if valid_569359 != nil:
    section.add "resourceGroupName", valid_569359
  var valid_569360 = path.getOrDefault("virtualMachineName")
  valid_569360 = validateParameter(valid_569360, JString, required = true,
                                 default = nil)
  if valid_569360 != nil:
    section.add "virtualMachineName", valid_569360
  var valid_569361 = path.getOrDefault("name")
  valid_569361 = validateParameter(valid_569361, JString, required = true,
                                 default = nil)
  if valid_569361 != nil:
    section.add "name", valid_569361
  var valid_569362 = path.getOrDefault("subscriptionId")
  valid_569362 = validateParameter(valid_569362, JString, required = true,
                                 default = nil)
  if valid_569362 != nil:
    section.add "subscriptionId", valid_569362
  var valid_569363 = path.getOrDefault("labName")
  valid_569363 = validateParameter(valid_569363, JString, required = true,
                                 default = nil)
  if valid_569363 != nil:
    section.add "labName", valid_569363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569364 = query.getOrDefault("api-version")
  valid_569364 = validateParameter(valid_569364, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569364 != nil:
    section.add "api-version", valid_569364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569365: Call_VirtualMachineSchedulesExecute_569356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_569365.validator(path, query, header, formData, body)
  let scheme = call_569365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569365.url(scheme.get, call_569365.host, call_569365.base,
                         call_569365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569365, url, valid)

proc call*(call_569366: Call_VirtualMachineSchedulesExecute_569356;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569367 = newJObject()
  var query_569368 = newJObject()
  add(path_569367, "resourceGroupName", newJString(resourceGroupName))
  add(query_569368, "api-version", newJString(apiVersion))
  add(path_569367, "virtualMachineName", newJString(virtualMachineName))
  add(path_569367, "name", newJString(name))
  add(path_569367, "subscriptionId", newJString(subscriptionId))
  add(path_569367, "labName", newJString(labName))
  result = call_569366.call(path_569367, query_569368, nil, nil, nil)

var virtualMachineSchedulesExecute* = Call_VirtualMachineSchedulesExecute_569356(
    name: "virtualMachineSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}/execute",
    validator: validate_VirtualMachineSchedulesExecute_569357, base: "",
    url: url_VirtualMachineSchedulesExecute_569358, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_569369 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksList_569371(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksList_569370(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List virtual networks in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569372 = path.getOrDefault("resourceGroupName")
  valid_569372 = validateParameter(valid_569372, JString, required = true,
                                 default = nil)
  if valid_569372 != nil:
    section.add "resourceGroupName", valid_569372
  var valid_569373 = path.getOrDefault("subscriptionId")
  valid_569373 = validateParameter(valid_569373, JString, required = true,
                                 default = nil)
  if valid_569373 != nil:
    section.add "subscriptionId", valid_569373
  var valid_569374 = path.getOrDefault("labName")
  valid_569374 = validateParameter(valid_569374, JString, required = true,
                                 default = nil)
  if valid_569374 != nil:
    section.add "labName", valid_569374
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_569375 = query.getOrDefault("$orderby")
  valid_569375 = validateParameter(valid_569375, JString, required = false,
                                 default = nil)
  if valid_569375 != nil:
    section.add "$orderby", valid_569375
  var valid_569376 = query.getOrDefault("$expand")
  valid_569376 = validateParameter(valid_569376, JString, required = false,
                                 default = nil)
  if valid_569376 != nil:
    section.add "$expand", valid_569376
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569377 = query.getOrDefault("api-version")
  valid_569377 = validateParameter(valid_569377, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569377 != nil:
    section.add "api-version", valid_569377
  var valid_569378 = query.getOrDefault("$top")
  valid_569378 = validateParameter(valid_569378, JInt, required = false, default = nil)
  if valid_569378 != nil:
    section.add "$top", valid_569378
  var valid_569379 = query.getOrDefault("$filter")
  valid_569379 = validateParameter(valid_569379, JString, required = false,
                                 default = nil)
  if valid_569379 != nil:
    section.add "$filter", valid_569379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569380: Call_VirtualNetworksList_569369; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual networks in a given lab.
  ## 
  let valid = call_569380.validator(path, query, header, formData, body)
  let scheme = call_569380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569380.url(scheme.get, call_569380.host, call_569380.base,
                         call_569380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569380, url, valid)

proc call*(call_569381: Call_VirtualNetworksList_569369; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualNetworksList
  ## List virtual networks in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_569382 = newJObject()
  var query_569383 = newJObject()
  add(query_569383, "$orderby", newJString(Orderby))
  add(path_569382, "resourceGroupName", newJString(resourceGroupName))
  add(query_569383, "$expand", newJString(Expand))
  add(query_569383, "api-version", newJString(apiVersion))
  add(path_569382, "subscriptionId", newJString(subscriptionId))
  add(query_569383, "$top", newJInt(Top))
  add(path_569382, "labName", newJString(labName))
  add(query_569383, "$filter", newJString(Filter))
  result = call_569381.call(path_569382, query_569383, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_569369(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks",
    validator: validate_VirtualNetworksList_569370, base: "",
    url: url_VirtualNetworksList_569371, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_569397 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksCreateOrUpdate_569399(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksCreateOrUpdate_569398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569400 = path.getOrDefault("resourceGroupName")
  valid_569400 = validateParameter(valid_569400, JString, required = true,
                                 default = nil)
  if valid_569400 != nil:
    section.add "resourceGroupName", valid_569400
  var valid_569401 = path.getOrDefault("name")
  valid_569401 = validateParameter(valid_569401, JString, required = true,
                                 default = nil)
  if valid_569401 != nil:
    section.add "name", valid_569401
  var valid_569402 = path.getOrDefault("subscriptionId")
  valid_569402 = validateParameter(valid_569402, JString, required = true,
                                 default = nil)
  if valid_569402 != nil:
    section.add "subscriptionId", valid_569402
  var valid_569403 = path.getOrDefault("labName")
  valid_569403 = validateParameter(valid_569403, JString, required = true,
                                 default = nil)
  if valid_569403 != nil:
    section.add "labName", valid_569403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569404 = query.getOrDefault("api-version")
  valid_569404 = validateParameter(valid_569404, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569404 != nil:
    section.add "api-version", valid_569404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569406: Call_VirtualNetworksCreateOrUpdate_569397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  let valid = call_569406.validator(path, query, header, formData, body)
  let scheme = call_569406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569406.url(scheme.get, call_569406.host, call_569406.base,
                         call_569406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569406, url, valid)

proc call*(call_569407: Call_VirtualNetworksCreateOrUpdate_569397;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualNetworksCreateOrUpdate
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  var path_569408 = newJObject()
  var query_569409 = newJObject()
  var body_569410 = newJObject()
  add(path_569408, "resourceGroupName", newJString(resourceGroupName))
  add(query_569409, "api-version", newJString(apiVersion))
  add(path_569408, "name", newJString(name))
  add(path_569408, "subscriptionId", newJString(subscriptionId))
  add(path_569408, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_569410 = virtualNetwork
  result = call_569407.call(path_569408, query_569409, nil, nil, body_569410)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_569397(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksCreateOrUpdate_569398, base: "",
    url: url_VirtualNetworksCreateOrUpdate_569399, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_569384 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksGet_569386(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksGet_569385(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569387 = path.getOrDefault("resourceGroupName")
  valid_569387 = validateParameter(valid_569387, JString, required = true,
                                 default = nil)
  if valid_569387 != nil:
    section.add "resourceGroupName", valid_569387
  var valid_569388 = path.getOrDefault("name")
  valid_569388 = validateParameter(valid_569388, JString, required = true,
                                 default = nil)
  if valid_569388 != nil:
    section.add "name", valid_569388
  var valid_569389 = path.getOrDefault("subscriptionId")
  valid_569389 = validateParameter(valid_569389, JString, required = true,
                                 default = nil)
  if valid_569389 != nil:
    section.add "subscriptionId", valid_569389
  var valid_569390 = path.getOrDefault("labName")
  valid_569390 = validateParameter(valid_569390, JString, required = true,
                                 default = nil)
  if valid_569390 != nil:
    section.add "labName", valid_569390
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569391 = query.getOrDefault("$expand")
  valid_569391 = validateParameter(valid_569391, JString, required = false,
                                 default = nil)
  if valid_569391 != nil:
    section.add "$expand", valid_569391
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569392 = query.getOrDefault("api-version")
  valid_569392 = validateParameter(valid_569392, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569392 != nil:
    section.add "api-version", valid_569392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569393: Call_VirtualNetworksGet_569384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual network.
  ## 
  let valid = call_569393.validator(path, query, header, formData, body)
  let scheme = call_569393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569393.url(scheme.get, call_569393.host, call_569393.base,
                         call_569393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569393, url, valid)

proc call*(call_569394: Call_VirtualNetworksGet_569384; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualNetworksGet
  ## Get virtual network.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569395 = newJObject()
  var query_569396 = newJObject()
  add(path_569395, "resourceGroupName", newJString(resourceGroupName))
  add(query_569396, "$expand", newJString(Expand))
  add(path_569395, "name", newJString(name))
  add(query_569396, "api-version", newJString(apiVersion))
  add(path_569395, "subscriptionId", newJString(subscriptionId))
  add(path_569395, "labName", newJString(labName))
  result = call_569394.call(path_569395, query_569396, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_569384(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksGet_569385, base: "",
    url: url_VirtualNetworksGet_569386, schemes: {Scheme.Https})
type
  Call_VirtualNetworksUpdate_569423 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksUpdate_569425(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksUpdate_569424(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual networks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569426 = path.getOrDefault("resourceGroupName")
  valid_569426 = validateParameter(valid_569426, JString, required = true,
                                 default = nil)
  if valid_569426 != nil:
    section.add "resourceGroupName", valid_569426
  var valid_569427 = path.getOrDefault("name")
  valid_569427 = validateParameter(valid_569427, JString, required = true,
                                 default = nil)
  if valid_569427 != nil:
    section.add "name", valid_569427
  var valid_569428 = path.getOrDefault("subscriptionId")
  valid_569428 = validateParameter(valid_569428, JString, required = true,
                                 default = nil)
  if valid_569428 != nil:
    section.add "subscriptionId", valid_569428
  var valid_569429 = path.getOrDefault("labName")
  valid_569429 = validateParameter(valid_569429, JString, required = true,
                                 default = nil)
  if valid_569429 != nil:
    section.add "labName", valid_569429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569430 = query.getOrDefault("api-version")
  valid_569430 = validateParameter(valid_569430, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569430 != nil:
    section.add "api-version", valid_569430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569432: Call_VirtualNetworksUpdate_569423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual networks.
  ## 
  let valid = call_569432.validator(path, query, header, formData, body)
  let scheme = call_569432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569432.url(scheme.get, call_569432.host, call_569432.base,
                         call_569432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569432, url, valid)

proc call*(call_569433: Call_VirtualNetworksUpdate_569423;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualNetworksUpdate
  ## Modify properties of virtual networks.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  var path_569434 = newJObject()
  var query_569435 = newJObject()
  var body_569436 = newJObject()
  add(path_569434, "resourceGroupName", newJString(resourceGroupName))
  add(query_569435, "api-version", newJString(apiVersion))
  add(path_569434, "name", newJString(name))
  add(path_569434, "subscriptionId", newJString(subscriptionId))
  add(path_569434, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_569436 = virtualNetwork
  result = call_569433.call(path_569434, query_569435, nil, nil, body_569436)

var virtualNetworksUpdate* = Call_VirtualNetworksUpdate_569423(
    name: "virtualNetworksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksUpdate_569424, base: "",
    url: url_VirtualNetworksUpdate_569425, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_569411 = ref object of OpenApiRestCall_567650
proc url_VirtualNetworksDelete_569413(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/virtualnetworks/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualNetworksDelete_569412(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569414 = path.getOrDefault("resourceGroupName")
  valid_569414 = validateParameter(valid_569414, JString, required = true,
                                 default = nil)
  if valid_569414 != nil:
    section.add "resourceGroupName", valid_569414
  var valid_569415 = path.getOrDefault("name")
  valid_569415 = validateParameter(valid_569415, JString, required = true,
                                 default = nil)
  if valid_569415 != nil:
    section.add "name", valid_569415
  var valid_569416 = path.getOrDefault("subscriptionId")
  valid_569416 = validateParameter(valid_569416, JString, required = true,
                                 default = nil)
  if valid_569416 != nil:
    section.add "subscriptionId", valid_569416
  var valid_569417 = path.getOrDefault("labName")
  valid_569417 = validateParameter(valid_569417, JString, required = true,
                                 default = nil)
  if valid_569417 != nil:
    section.add "labName", valid_569417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569418 = query.getOrDefault("api-version")
  valid_569418 = validateParameter(valid_569418, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569418 != nil:
    section.add "api-version", valid_569418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569419: Call_VirtualNetworksDelete_569411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  let valid = call_569419.validator(path, query, header, formData, body)
  let scheme = call_569419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569419.url(scheme.get, call_569419.host, call_569419.base,
                         call_569419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569419, url, valid)

proc call*(call_569420: Call_VirtualNetworksDelete_569411;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualNetworksDelete
  ## Delete virtual network. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569421 = newJObject()
  var query_569422 = newJObject()
  add(path_569421, "resourceGroupName", newJString(resourceGroupName))
  add(query_569422, "api-version", newJString(apiVersion))
  add(path_569421, "name", newJString(name))
  add(path_569421, "subscriptionId", newJString(subscriptionId))
  add(path_569421, "labName", newJString(labName))
  result = call_569420.call(path_569421, query_569422, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_569411(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksDelete_569412, base: "",
    url: url_VirtualNetworksDelete_569413, schemes: {Scheme.Https})
type
  Call_LabsCreateOrUpdate_569449 = ref object of OpenApiRestCall_567650
proc url_LabsCreateOrUpdate_569451(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsCreateOrUpdate_569450(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create or replace an existing lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569452 = path.getOrDefault("resourceGroupName")
  valid_569452 = validateParameter(valid_569452, JString, required = true,
                                 default = nil)
  if valid_569452 != nil:
    section.add "resourceGroupName", valid_569452
  var valid_569453 = path.getOrDefault("name")
  valid_569453 = validateParameter(valid_569453, JString, required = true,
                                 default = nil)
  if valid_569453 != nil:
    section.add "name", valid_569453
  var valid_569454 = path.getOrDefault("subscriptionId")
  valid_569454 = validateParameter(valid_569454, JString, required = true,
                                 default = nil)
  if valid_569454 != nil:
    section.add "subscriptionId", valid_569454
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569455 = query.getOrDefault("api-version")
  valid_569455 = validateParameter(valid_569455, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569455 != nil:
    section.add "api-version", valid_569455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  ##      : A lab.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569457: Call_LabsCreateOrUpdate_569449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing lab. This operation can take a while to complete.
  ## 
  let valid = call_569457.validator(path, query, header, formData, body)
  let scheme = call_569457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569457.url(scheme.get, call_569457.host, call_569457.base,
                         call_569457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569457, url, valid)

proc call*(call_569458: Call_LabsCreateOrUpdate_569449; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsCreateOrUpdate
  ## Create or replace an existing lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   lab: JObject (required)
  ##      : A lab.
  var path_569459 = newJObject()
  var query_569460 = newJObject()
  var body_569461 = newJObject()
  add(path_569459, "resourceGroupName", newJString(resourceGroupName))
  add(query_569460, "api-version", newJString(apiVersion))
  add(path_569459, "name", newJString(name))
  add(path_569459, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_569461 = lab
  result = call_569458.call(path_569459, query_569460, nil, nil, body_569461)

var labsCreateOrUpdate* = Call_LabsCreateOrUpdate_569449(
    name: "labsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabsCreateOrUpdate_569450, base: "",
    url: url_LabsCreateOrUpdate_569451, schemes: {Scheme.Https})
type
  Call_LabsGet_569437 = ref object of OpenApiRestCall_567650
proc url_LabsGet_569439(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsGet_569438(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569440 = path.getOrDefault("resourceGroupName")
  valid_569440 = validateParameter(valid_569440, JString, required = true,
                                 default = nil)
  if valid_569440 != nil:
    section.add "resourceGroupName", valid_569440
  var valid_569441 = path.getOrDefault("name")
  valid_569441 = validateParameter(valid_569441, JString, required = true,
                                 default = nil)
  if valid_569441 != nil:
    section.add "name", valid_569441
  var valid_569442 = path.getOrDefault("subscriptionId")
  valid_569442 = validateParameter(valid_569442, JString, required = true,
                                 default = nil)
  if valid_569442 != nil:
    section.add "subscriptionId", valid_569442
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569443 = query.getOrDefault("$expand")
  valid_569443 = validateParameter(valid_569443, JString, required = false,
                                 default = nil)
  if valid_569443 != nil:
    section.add "$expand", valid_569443
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569444 = query.getOrDefault("api-version")
  valid_569444 = validateParameter(valid_569444, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569444 != nil:
    section.add "api-version", valid_569444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569445: Call_LabsGet_569437; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab.
  ## 
  let valid = call_569445.validator(path, query, header, formData, body)
  let scheme = call_569445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569445.url(scheme.get, call_569445.host, call_569445.base,
                         call_569445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569445, url, valid)

proc call*(call_569446: Call_LabsGet_569437; resourceGroupName: string; name: string;
          subscriptionId: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsGet
  ## Get lab.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   name: string (required)
  ##       : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_569447 = newJObject()
  var query_569448 = newJObject()
  add(path_569447, "resourceGroupName", newJString(resourceGroupName))
  add(query_569448, "$expand", newJString(Expand))
  add(path_569447, "name", newJString(name))
  add(query_569448, "api-version", newJString(apiVersion))
  add(path_569447, "subscriptionId", newJString(subscriptionId))
  result = call_569446.call(path_569447, query_569448, nil, nil, nil)

var labsGet* = Call_LabsGet_569437(name: "labsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                validator: validate_LabsGet_569438, base: "",
                                url: url_LabsGet_569439, schemes: {Scheme.Https})
type
  Call_LabsUpdate_569473 = ref object of OpenApiRestCall_567650
proc url_LabsUpdate_569475(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsUpdate_569474(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569476 = path.getOrDefault("resourceGroupName")
  valid_569476 = validateParameter(valid_569476, JString, required = true,
                                 default = nil)
  if valid_569476 != nil:
    section.add "resourceGroupName", valid_569476
  var valid_569477 = path.getOrDefault("name")
  valid_569477 = validateParameter(valid_569477, JString, required = true,
                                 default = nil)
  if valid_569477 != nil:
    section.add "name", valid_569477
  var valid_569478 = path.getOrDefault("subscriptionId")
  valid_569478 = validateParameter(valid_569478, JString, required = true,
                                 default = nil)
  if valid_569478 != nil:
    section.add "subscriptionId", valid_569478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569479 = query.getOrDefault("api-version")
  valid_569479 = validateParameter(valid_569479, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569479 != nil:
    section.add "api-version", valid_569479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   lab: JObject (required)
  ##      : A lab.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569481: Call_LabsUpdate_569473; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of labs.
  ## 
  let valid = call_569481.validator(path, query, header, formData, body)
  let scheme = call_569481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569481.url(scheme.get, call_569481.host, call_569481.base,
                         call_569481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569481, url, valid)

proc call*(call_569482: Call_LabsUpdate_569473; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsUpdate
  ## Modify properties of labs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   lab: JObject (required)
  ##      : A lab.
  var path_569483 = newJObject()
  var query_569484 = newJObject()
  var body_569485 = newJObject()
  add(path_569483, "resourceGroupName", newJString(resourceGroupName))
  add(query_569484, "api-version", newJString(apiVersion))
  add(path_569483, "name", newJString(name))
  add(path_569483, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_569485 = lab
  result = call_569482.call(path_569483, query_569484, nil, nil, body_569485)

var labsUpdate* = Call_LabsUpdate_569473(name: "labsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsUpdate_569474,
                                      base: "", url: url_LabsUpdate_569475,
                                      schemes: {Scheme.Https})
type
  Call_LabsDelete_569462 = ref object of OpenApiRestCall_567650
proc url_LabsDelete_569464(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsDelete_569463(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569465 = path.getOrDefault("resourceGroupName")
  valid_569465 = validateParameter(valid_569465, JString, required = true,
                                 default = nil)
  if valid_569465 != nil:
    section.add "resourceGroupName", valid_569465
  var valid_569466 = path.getOrDefault("name")
  valid_569466 = validateParameter(valid_569466, JString, required = true,
                                 default = nil)
  if valid_569466 != nil:
    section.add "name", valid_569466
  var valid_569467 = path.getOrDefault("subscriptionId")
  valid_569467 = validateParameter(valid_569467, JString, required = true,
                                 default = nil)
  if valid_569467 != nil:
    section.add "subscriptionId", valid_569467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569468 = query.getOrDefault("api-version")
  valid_569468 = validateParameter(valid_569468, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569468 != nil:
    section.add "api-version", valid_569468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569469: Call_LabsDelete_569462; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete.
  ## 
  let valid = call_569469.validator(path, query, header, formData, body)
  let scheme = call_569469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569469.url(scheme.get, call_569469.host, call_569469.base,
                         call_569469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569469, url, valid)

proc call*(call_569470: Call_LabsDelete_569462; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2016-05-15"): Recallable =
  ## labsDelete
  ## Delete lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_569471 = newJObject()
  var query_569472 = newJObject()
  add(path_569471, "resourceGroupName", newJString(resourceGroupName))
  add(query_569472, "api-version", newJString(apiVersion))
  add(path_569471, "name", newJString(name))
  add(path_569471, "subscriptionId", newJString(subscriptionId))
  result = call_569470.call(path_569471, query_569472, nil, nil, nil)

var labsDelete* = Call_LabsDelete_569462(name: "labsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsDelete_569463,
                                      base: "", url: url_LabsDelete_569464,
                                      schemes: {Scheme.Https})
type
  Call_LabsClaimAnyVm_569486 = ref object of OpenApiRestCall_567650
proc url_LabsClaimAnyVm_569488(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/claimAnyVm")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsClaimAnyVm_569487(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569489 = path.getOrDefault("resourceGroupName")
  valid_569489 = validateParameter(valid_569489, JString, required = true,
                                 default = nil)
  if valid_569489 != nil:
    section.add "resourceGroupName", valid_569489
  var valid_569490 = path.getOrDefault("name")
  valid_569490 = validateParameter(valid_569490, JString, required = true,
                                 default = nil)
  if valid_569490 != nil:
    section.add "name", valid_569490
  var valid_569491 = path.getOrDefault("subscriptionId")
  valid_569491 = validateParameter(valid_569491, JString, required = true,
                                 default = nil)
  if valid_569491 != nil:
    section.add "subscriptionId", valid_569491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569492 = query.getOrDefault("api-version")
  valid_569492 = validateParameter(valid_569492, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569492 != nil:
    section.add "api-version", valid_569492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569493: Call_LabsClaimAnyVm_569486; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ## 
  let valid = call_569493.validator(path, query, header, formData, body)
  let scheme = call_569493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569493.url(scheme.get, call_569493.host, call_569493.base,
                         call_569493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569493, url, valid)

proc call*(call_569494: Call_LabsClaimAnyVm_569486; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2016-05-15"): Recallable =
  ## labsClaimAnyVm
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_569495 = newJObject()
  var query_569496 = newJObject()
  add(path_569495, "resourceGroupName", newJString(resourceGroupName))
  add(query_569496, "api-version", newJString(apiVersion))
  add(path_569495, "name", newJString(name))
  add(path_569495, "subscriptionId", newJString(subscriptionId))
  result = call_569494.call(path_569495, query_569496, nil, nil, nil)

var labsClaimAnyVm* = Call_LabsClaimAnyVm_569486(name: "labsClaimAnyVm",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/claimAnyVm",
    validator: validate_LabsClaimAnyVm_569487, base: "", url: url_LabsClaimAnyVm_569488,
    schemes: {Scheme.Https})
type
  Call_LabsCreateEnvironment_569497 = ref object of OpenApiRestCall_567650
proc url_LabsCreateEnvironment_569499(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/createEnvironment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsCreateEnvironment_569498(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569500 = path.getOrDefault("resourceGroupName")
  valid_569500 = validateParameter(valid_569500, JString, required = true,
                                 default = nil)
  if valid_569500 != nil:
    section.add "resourceGroupName", valid_569500
  var valid_569501 = path.getOrDefault("name")
  valid_569501 = validateParameter(valid_569501, JString, required = true,
                                 default = nil)
  if valid_569501 != nil:
    section.add "name", valid_569501
  var valid_569502 = path.getOrDefault("subscriptionId")
  valid_569502 = validateParameter(valid_569502, JString, required = true,
                                 default = nil)
  if valid_569502 != nil:
    section.add "subscriptionId", valid_569502
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569503 = query.getOrDefault("api-version")
  valid_569503 = validateParameter(valid_569503, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569503 != nil:
    section.add "api-version", valid_569503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   labVirtualMachineCreationParameter: JObject (required)
  ##                                     : Properties for creating a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569505: Call_LabsCreateEnvironment_569497; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ## 
  let valid = call_569505.validator(path, query, header, formData, body)
  let scheme = call_569505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569505.url(scheme.get, call_569505.host, call_569505.base,
                         call_569505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569505, url, valid)

proc call*(call_569506: Call_LabsCreateEnvironment_569497;
          resourceGroupName: string; name: string;
          labVirtualMachineCreationParameter: JsonNode; subscriptionId: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsCreateEnvironment
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   labVirtualMachineCreationParameter: JObject (required)
  ##                                     : Properties for creating a virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_569507 = newJObject()
  var query_569508 = newJObject()
  var body_569509 = newJObject()
  add(path_569507, "resourceGroupName", newJString(resourceGroupName))
  add(query_569508, "api-version", newJString(apiVersion))
  add(path_569507, "name", newJString(name))
  if labVirtualMachineCreationParameter != nil:
    body_569509 = labVirtualMachineCreationParameter
  add(path_569507, "subscriptionId", newJString(subscriptionId))
  result = call_569506.call(path_569507, query_569508, nil, nil, body_569509)

var labsCreateEnvironment* = Call_LabsCreateEnvironment_569497(
    name: "labsCreateEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment",
    validator: validate_LabsCreateEnvironment_569498, base: "",
    url: url_LabsCreateEnvironment_569499, schemes: {Scheme.Https})
type
  Call_LabsExportResourceUsage_569510 = ref object of OpenApiRestCall_567650
proc url_LabsExportResourceUsage_569512(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/exportResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsExportResourceUsage_569511(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569513 = path.getOrDefault("resourceGroupName")
  valid_569513 = validateParameter(valid_569513, JString, required = true,
                                 default = nil)
  if valid_569513 != nil:
    section.add "resourceGroupName", valid_569513
  var valid_569514 = path.getOrDefault("name")
  valid_569514 = validateParameter(valid_569514, JString, required = true,
                                 default = nil)
  if valid_569514 != nil:
    section.add "name", valid_569514
  var valid_569515 = path.getOrDefault("subscriptionId")
  valid_569515 = validateParameter(valid_569515, JString, required = true,
                                 default = nil)
  if valid_569515 != nil:
    section.add "subscriptionId", valid_569515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569516 = query.getOrDefault("api-version")
  valid_569516 = validateParameter(valid_569516, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569516 != nil:
    section.add "api-version", valid_569516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exportResourceUsageParameters: JObject (required)
  ##                                : The parameters of the export operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569518: Call_LabsExportResourceUsage_569510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ## 
  let valid = call_569518.validator(path, query, header, formData, body)
  let scheme = call_569518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569518.url(scheme.get, call_569518.host, call_569518.base,
                         call_569518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569518, url, valid)

proc call*(call_569519: Call_LabsExportResourceUsage_569510;
          resourceGroupName: string; name: string; subscriptionId: string;
          exportResourceUsageParameters: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsExportResourceUsage
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   exportResourceUsageParameters: JObject (required)
  ##                                : The parameters of the export operation.
  var path_569520 = newJObject()
  var query_569521 = newJObject()
  var body_569522 = newJObject()
  add(path_569520, "resourceGroupName", newJString(resourceGroupName))
  add(query_569521, "api-version", newJString(apiVersion))
  add(path_569520, "name", newJString(name))
  add(path_569520, "subscriptionId", newJString(subscriptionId))
  if exportResourceUsageParameters != nil:
    body_569522 = exportResourceUsageParameters
  result = call_569519.call(path_569520, query_569521, nil, nil, body_569522)

var labsExportResourceUsage* = Call_LabsExportResourceUsage_569510(
    name: "labsExportResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/exportResourceUsage",
    validator: validate_LabsExportResourceUsage_569511, base: "",
    url: url_LabsExportResourceUsage_569512, schemes: {Scheme.Https})
type
  Call_LabsGenerateUploadUri_569523 = ref object of OpenApiRestCall_567650
proc url_LabsGenerateUploadUri_569525(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/generateUploadUri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsGenerateUploadUri_569524(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569526 = path.getOrDefault("resourceGroupName")
  valid_569526 = validateParameter(valid_569526, JString, required = true,
                                 default = nil)
  if valid_569526 != nil:
    section.add "resourceGroupName", valid_569526
  var valid_569527 = path.getOrDefault("name")
  valid_569527 = validateParameter(valid_569527, JString, required = true,
                                 default = nil)
  if valid_569527 != nil:
    section.add "name", valid_569527
  var valid_569528 = path.getOrDefault("subscriptionId")
  valid_569528 = validateParameter(valid_569528, JString, required = true,
                                 default = nil)
  if valid_569528 != nil:
    section.add "subscriptionId", valid_569528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569529 = query.getOrDefault("api-version")
  valid_569529 = validateParameter(valid_569529, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569529 != nil:
    section.add "api-version", valid_569529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   generateUploadUriParameter: JObject (required)
  ##                             : Properties for generating an upload URI.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569531: Call_LabsGenerateUploadUri_569523; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  let valid = call_569531.validator(path, query, header, formData, body)
  let scheme = call_569531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569531.url(scheme.get, call_569531.host, call_569531.base,
                         call_569531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569531, url, valid)

proc call*(call_569532: Call_LabsGenerateUploadUri_569523;
          resourceGroupName: string; name: string; subscriptionId: string;
          generateUploadUriParameter: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## labsGenerateUploadUri
  ## Generate a URI for uploading custom disk images to a Lab.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   generateUploadUriParameter: JObject (required)
  ##                             : Properties for generating an upload URI.
  var path_569533 = newJObject()
  var query_569534 = newJObject()
  var body_569535 = newJObject()
  add(path_569533, "resourceGroupName", newJString(resourceGroupName))
  add(query_569534, "api-version", newJString(apiVersion))
  add(path_569533, "name", newJString(name))
  add(path_569533, "subscriptionId", newJString(subscriptionId))
  if generateUploadUriParameter != nil:
    body_569535 = generateUploadUriParameter
  result = call_569532.call(path_569533, query_569534, nil, nil, body_569535)

var labsGenerateUploadUri* = Call_LabsGenerateUploadUri_569523(
    name: "labsGenerateUploadUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri",
    validator: validate_LabsGenerateUploadUri_569524, base: "",
    url: url_LabsGenerateUploadUri_569525, schemes: {Scheme.Https})
type
  Call_LabsListVhds_569536 = ref object of OpenApiRestCall_567650
proc url_LabsListVhds_569538(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listVhds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsListVhds_569537(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List disk images available for custom image creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569539 = path.getOrDefault("resourceGroupName")
  valid_569539 = validateParameter(valid_569539, JString, required = true,
                                 default = nil)
  if valid_569539 != nil:
    section.add "resourceGroupName", valid_569539
  var valid_569540 = path.getOrDefault("name")
  valid_569540 = validateParameter(valid_569540, JString, required = true,
                                 default = nil)
  if valid_569540 != nil:
    section.add "name", valid_569540
  var valid_569541 = path.getOrDefault("subscriptionId")
  valid_569541 = validateParameter(valid_569541, JString, required = true,
                                 default = nil)
  if valid_569541 != nil:
    section.add "subscriptionId", valid_569541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569542 = query.getOrDefault("api-version")
  valid_569542 = validateParameter(valid_569542, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569542 != nil:
    section.add "api-version", valid_569542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569543: Call_LabsListVhds_569536; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disk images available for custom image creation.
  ## 
  let valid = call_569543.validator(path, query, header, formData, body)
  let scheme = call_569543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569543.url(scheme.get, call_569543.host, call_569543.base,
                         call_569543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569543, url, valid)

proc call*(call_569544: Call_LabsListVhds_569536; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2016-05-15"): Recallable =
  ## labsListVhds
  ## List disk images available for custom image creation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_569545 = newJObject()
  var query_569546 = newJObject()
  add(path_569545, "resourceGroupName", newJString(resourceGroupName))
  add(query_569546, "api-version", newJString(apiVersion))
  add(path_569545, "name", newJString(name))
  add(path_569545, "subscriptionId", newJString(subscriptionId))
  result = call_569544.call(path_569545, query_569546, nil, nil, nil)

var labsListVhds* = Call_LabsListVhds_569536(name: "labsListVhds",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds",
    validator: validate_LabsListVhds_569537, base: "", url: url_LabsListVhds_569538,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListByResourceGroup_569547 = ref object of OpenApiRestCall_567650
proc url_GlobalSchedulesListByResourceGroup_569549(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesListByResourceGroup_569548(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569550 = path.getOrDefault("resourceGroupName")
  valid_569550 = validateParameter(valid_569550, JString, required = true,
                                 default = nil)
  if valid_569550 != nil:
    section.add "resourceGroupName", valid_569550
  var valid_569551 = path.getOrDefault("subscriptionId")
  valid_569551 = validateParameter(valid_569551, JString, required = true,
                                 default = nil)
  if valid_569551 != nil:
    section.add "subscriptionId", valid_569551
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_569552 = query.getOrDefault("$orderby")
  valid_569552 = validateParameter(valid_569552, JString, required = false,
                                 default = nil)
  if valid_569552 != nil:
    section.add "$orderby", valid_569552
  var valid_569553 = query.getOrDefault("$expand")
  valid_569553 = validateParameter(valid_569553, JString, required = false,
                                 default = nil)
  if valid_569553 != nil:
    section.add "$expand", valid_569553
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569554 = query.getOrDefault("api-version")
  valid_569554 = validateParameter(valid_569554, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569554 != nil:
    section.add "api-version", valid_569554
  var valid_569555 = query.getOrDefault("$top")
  valid_569555 = validateParameter(valid_569555, JInt, required = false, default = nil)
  if valid_569555 != nil:
    section.add "$top", valid_569555
  var valid_569556 = query.getOrDefault("$filter")
  valid_569556 = validateParameter(valid_569556, JString, required = false,
                                 default = nil)
  if valid_569556 != nil:
    section.add "$filter", valid_569556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569557: Call_GlobalSchedulesListByResourceGroup_569547;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a resource group.
  ## 
  let valid = call_569557.validator(path, query, header, formData, body)
  let scheme = call_569557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569557.url(scheme.get, call_569557.host, call_569557.base,
                         call_569557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569557, url, valid)

proc call*(call_569558: Call_GlobalSchedulesListByResourceGroup_569547;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2016-05-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## globalSchedulesListByResourceGroup
  ## List schedules in a resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_569559 = newJObject()
  var query_569560 = newJObject()
  add(query_569560, "$orderby", newJString(Orderby))
  add(path_569559, "resourceGroupName", newJString(resourceGroupName))
  add(query_569560, "$expand", newJString(Expand))
  add(query_569560, "api-version", newJString(apiVersion))
  add(path_569559, "subscriptionId", newJString(subscriptionId))
  add(query_569560, "$top", newJInt(Top))
  add(query_569560, "$filter", newJString(Filter))
  result = call_569558.call(path_569559, query_569560, nil, nil, nil)

var globalSchedulesListByResourceGroup* = Call_GlobalSchedulesListByResourceGroup_569547(
    name: "globalSchedulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListByResourceGroup_569548, base: "",
    url: url_GlobalSchedulesListByResourceGroup_569549, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesCreateOrUpdate_569573 = ref object of OpenApiRestCall_567650
proc url_GlobalSchedulesCreateOrUpdate_569575(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesCreateOrUpdate_569574(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569576 = path.getOrDefault("resourceGroupName")
  valid_569576 = validateParameter(valid_569576, JString, required = true,
                                 default = nil)
  if valid_569576 != nil:
    section.add "resourceGroupName", valid_569576
  var valid_569577 = path.getOrDefault("name")
  valid_569577 = validateParameter(valid_569577, JString, required = true,
                                 default = nil)
  if valid_569577 != nil:
    section.add "name", valid_569577
  var valid_569578 = path.getOrDefault("subscriptionId")
  valid_569578 = validateParameter(valid_569578, JString, required = true,
                                 default = nil)
  if valid_569578 != nil:
    section.add "subscriptionId", valid_569578
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569579 = query.getOrDefault("api-version")
  valid_569579 = validateParameter(valid_569579, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569579 != nil:
    section.add "api-version", valid_569579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569581: Call_GlobalSchedulesCreateOrUpdate_569573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_569581.validator(path, query, header, formData, body)
  let scheme = call_569581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569581.url(scheme.get, call_569581.host, call_569581.base,
                         call_569581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569581, url, valid)

proc call*(call_569582: Call_GlobalSchedulesCreateOrUpdate_569573;
          resourceGroupName: string; name: string; subscriptionId: string;
          schedule: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_569583 = newJObject()
  var query_569584 = newJObject()
  var body_569585 = newJObject()
  add(path_569583, "resourceGroupName", newJString(resourceGroupName))
  add(query_569584, "api-version", newJString(apiVersion))
  add(path_569583, "name", newJString(name))
  add(path_569583, "subscriptionId", newJString(subscriptionId))
  if schedule != nil:
    body_569585 = schedule
  result = call_569582.call(path_569583, query_569584, nil, nil, body_569585)

var globalSchedulesCreateOrUpdate* = Call_GlobalSchedulesCreateOrUpdate_569573(
    name: "globalSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesCreateOrUpdate_569574, base: "",
    url: url_GlobalSchedulesCreateOrUpdate_569575, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesGet_569561 = ref object of OpenApiRestCall_567650
proc url_GlobalSchedulesGet_569563(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesGet_569562(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569564 = path.getOrDefault("resourceGroupName")
  valid_569564 = validateParameter(valid_569564, JString, required = true,
                                 default = nil)
  if valid_569564 != nil:
    section.add "resourceGroupName", valid_569564
  var valid_569565 = path.getOrDefault("name")
  valid_569565 = validateParameter(valid_569565, JString, required = true,
                                 default = nil)
  if valid_569565 != nil:
    section.add "name", valid_569565
  var valid_569566 = path.getOrDefault("subscriptionId")
  valid_569566 = validateParameter(valid_569566, JString, required = true,
                                 default = nil)
  if valid_569566 != nil:
    section.add "subscriptionId", valid_569566
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569567 = query.getOrDefault("$expand")
  valid_569567 = validateParameter(valid_569567, JString, required = false,
                                 default = nil)
  if valid_569567 != nil:
    section.add "$expand", valid_569567
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569568 = query.getOrDefault("api-version")
  valid_569568 = validateParameter(valid_569568, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569568 != nil:
    section.add "api-version", valid_569568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569569: Call_GlobalSchedulesGet_569561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_569569.validator(path, query, header, formData, body)
  let scheme = call_569569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569569.url(scheme.get, call_569569.host, call_569569.base,
                         call_569569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569569, url, valid)

proc call*(call_569570: Call_GlobalSchedulesGet_569561; resourceGroupName: string;
          name: string; subscriptionId: string; Expand: string = "";
          apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesGet
  ## Get schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_569571 = newJObject()
  var query_569572 = newJObject()
  add(path_569571, "resourceGroupName", newJString(resourceGroupName))
  add(query_569572, "$expand", newJString(Expand))
  add(path_569571, "name", newJString(name))
  add(query_569572, "api-version", newJString(apiVersion))
  add(path_569571, "subscriptionId", newJString(subscriptionId))
  result = call_569570.call(path_569571, query_569572, nil, nil, nil)

var globalSchedulesGet* = Call_GlobalSchedulesGet_569561(
    name: "globalSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesGet_569562, base: "",
    url: url_GlobalSchedulesGet_569563, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesUpdate_569597 = ref object of OpenApiRestCall_567650
proc url_GlobalSchedulesUpdate_569599(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesUpdate_569598(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569600 = path.getOrDefault("resourceGroupName")
  valid_569600 = validateParameter(valid_569600, JString, required = true,
                                 default = nil)
  if valid_569600 != nil:
    section.add "resourceGroupName", valid_569600
  var valid_569601 = path.getOrDefault("name")
  valid_569601 = validateParameter(valid_569601, JString, required = true,
                                 default = nil)
  if valid_569601 != nil:
    section.add "name", valid_569601
  var valid_569602 = path.getOrDefault("subscriptionId")
  valid_569602 = validateParameter(valid_569602, JString, required = true,
                                 default = nil)
  if valid_569602 != nil:
    section.add "subscriptionId", valid_569602
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569603 = query.getOrDefault("api-version")
  valid_569603 = validateParameter(valid_569603, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569603 != nil:
    section.add "api-version", valid_569603
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   schedule: JObject (required)
  ##           : A schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569605: Call_GlobalSchedulesUpdate_569597; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_569605.validator(path, query, header, formData, body)
  let scheme = call_569605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569605.url(scheme.get, call_569605.host, call_569605.base,
                         call_569605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569605, url, valid)

proc call*(call_569606: Call_GlobalSchedulesUpdate_569597;
          resourceGroupName: string; name: string; subscriptionId: string;
          schedule: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesUpdate
  ## Modify properties of schedules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_569607 = newJObject()
  var query_569608 = newJObject()
  var body_569609 = newJObject()
  add(path_569607, "resourceGroupName", newJString(resourceGroupName))
  add(query_569608, "api-version", newJString(apiVersion))
  add(path_569607, "name", newJString(name))
  add(path_569607, "subscriptionId", newJString(subscriptionId))
  if schedule != nil:
    body_569609 = schedule
  result = call_569606.call(path_569607, query_569608, nil, nil, body_569609)

var globalSchedulesUpdate* = Call_GlobalSchedulesUpdate_569597(
    name: "globalSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesUpdate_569598, base: "",
    url: url_GlobalSchedulesUpdate_569599, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesDelete_569586 = ref object of OpenApiRestCall_567650
proc url_GlobalSchedulesDelete_569588(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesDelete_569587(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569589 = path.getOrDefault("resourceGroupName")
  valid_569589 = validateParameter(valid_569589, JString, required = true,
                                 default = nil)
  if valid_569589 != nil:
    section.add "resourceGroupName", valid_569589
  var valid_569590 = path.getOrDefault("name")
  valid_569590 = validateParameter(valid_569590, JString, required = true,
                                 default = nil)
  if valid_569590 != nil:
    section.add "name", valid_569590
  var valid_569591 = path.getOrDefault("subscriptionId")
  valid_569591 = validateParameter(valid_569591, JString, required = true,
                                 default = nil)
  if valid_569591 != nil:
    section.add "subscriptionId", valid_569591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569592 = query.getOrDefault("api-version")
  valid_569592 = validateParameter(valid_569592, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569592 != nil:
    section.add "api-version", valid_569592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569593: Call_GlobalSchedulesDelete_569586; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_569593.validator(path, query, header, formData, body)
  let scheme = call_569593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569593.url(scheme.get, call_569593.host, call_569593.base,
                         call_569593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569593, url, valid)

proc call*(call_569594: Call_GlobalSchedulesDelete_569586;
          resourceGroupName: string; name: string; subscriptionId: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesDelete
  ## Delete schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_569595 = newJObject()
  var query_569596 = newJObject()
  add(path_569595, "resourceGroupName", newJString(resourceGroupName))
  add(query_569596, "api-version", newJString(apiVersion))
  add(path_569595, "name", newJString(name))
  add(path_569595, "subscriptionId", newJString(subscriptionId))
  result = call_569594.call(path_569595, query_569596, nil, nil, nil)

var globalSchedulesDelete* = Call_GlobalSchedulesDelete_569586(
    name: "globalSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesDelete_569587, base: "",
    url: url_GlobalSchedulesDelete_569588, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesExecute_569610 = ref object of OpenApiRestCall_567650
proc url_GlobalSchedulesExecute_569612(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesExecute_569611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569613 = path.getOrDefault("resourceGroupName")
  valid_569613 = validateParameter(valid_569613, JString, required = true,
                                 default = nil)
  if valid_569613 != nil:
    section.add "resourceGroupName", valid_569613
  var valid_569614 = path.getOrDefault("name")
  valid_569614 = validateParameter(valid_569614, JString, required = true,
                                 default = nil)
  if valid_569614 != nil:
    section.add "name", valid_569614
  var valid_569615 = path.getOrDefault("subscriptionId")
  valid_569615 = validateParameter(valid_569615, JString, required = true,
                                 default = nil)
  if valid_569615 != nil:
    section.add "subscriptionId", valid_569615
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569616 = query.getOrDefault("api-version")
  valid_569616 = validateParameter(valid_569616, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569616 != nil:
    section.add "api-version", valid_569616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569617: Call_GlobalSchedulesExecute_569610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_569617.validator(path, query, header, formData, body)
  let scheme = call_569617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569617.url(scheme.get, call_569617.host, call_569617.base,
                         call_569617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569617, url, valid)

proc call*(call_569618: Call_GlobalSchedulesExecute_569610;
          resourceGroupName: string; name: string; subscriptionId: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_569619 = newJObject()
  var query_569620 = newJObject()
  add(path_569619, "resourceGroupName", newJString(resourceGroupName))
  add(query_569620, "api-version", newJString(apiVersion))
  add(path_569619, "name", newJString(name))
  add(path_569619, "subscriptionId", newJString(subscriptionId))
  result = call_569618.call(path_569619, query_569620, nil, nil, nil)

var globalSchedulesExecute* = Call_GlobalSchedulesExecute_569610(
    name: "globalSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/execute",
    validator: validate_GlobalSchedulesExecute_569611, base: "",
    url: url_GlobalSchedulesExecute_569612, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesRetarget_569621 = ref object of OpenApiRestCall_567650
proc url_GlobalSchedulesRetarget_569623(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/retarget")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GlobalSchedulesRetarget_569622(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569624 = path.getOrDefault("resourceGroupName")
  valid_569624 = validateParameter(valid_569624, JString, required = true,
                                 default = nil)
  if valid_569624 != nil:
    section.add "resourceGroupName", valid_569624
  var valid_569625 = path.getOrDefault("name")
  valid_569625 = validateParameter(valid_569625, JString, required = true,
                                 default = nil)
  if valid_569625 != nil:
    section.add "name", valid_569625
  var valid_569626 = path.getOrDefault("subscriptionId")
  valid_569626 = validateParameter(valid_569626, JString, required = true,
                                 default = nil)
  if valid_569626 != nil:
    section.add "subscriptionId", valid_569626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569627 = query.getOrDefault("api-version")
  valid_569627 = validateParameter(valid_569627, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_569627 != nil:
    section.add "api-version", valid_569627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   retargetScheduleProperties: JObject (required)
  ##                             : Properties for retargeting a virtual machine schedule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569629: Call_GlobalSchedulesRetarget_569621; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ## 
  let valid = call_569629.validator(path, query, header, formData, body)
  let scheme = call_569629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569629.url(scheme.get, call_569629.host, call_569629.base,
                         call_569629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569629, url, valid)

proc call*(call_569630: Call_GlobalSchedulesRetarget_569621;
          resourceGroupName: string; name: string; subscriptionId: string;
          retargetScheduleProperties: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesRetarget
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   retargetScheduleProperties: JObject (required)
  ##                             : Properties for retargeting a virtual machine schedule.
  var path_569631 = newJObject()
  var query_569632 = newJObject()
  var body_569633 = newJObject()
  add(path_569631, "resourceGroupName", newJString(resourceGroupName))
  add(query_569632, "api-version", newJString(apiVersion))
  add(path_569631, "name", newJString(name))
  add(path_569631, "subscriptionId", newJString(subscriptionId))
  if retargetScheduleProperties != nil:
    body_569633 = retargetScheduleProperties
  result = call_569630.call(path_569631, query_569632, nil, nil, body_569633)

var globalSchedulesRetarget* = Call_GlobalSchedulesRetarget_569621(
    name: "globalSchedulesRetarget", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/retarget",
    validator: validate_GlobalSchedulesRetarget_569622, base: "",
    url: url_GlobalSchedulesRetarget_569623, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
