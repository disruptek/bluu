
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DevTestLabsClient
## version: 2018-09-15
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  Call_ProviderOperationsList_567888 = ref object of OpenApiRestCall_567666
proc url_ProviderOperationsList_567890(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsList_567889(path: JsonNode; query: JsonNode;
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
  var valid_568062 = query.getOrDefault("api-version")
  valid_568062 = validateParameter(valid_568062, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568062 != nil:
    section.add "api-version", valid_568062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568085: Call_ProviderOperationsList_567888; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Result of the request to list REST API operations
  ## 
  let valid = call_568085.validator(path, query, header, formData, body)
  let scheme = call_568085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568085.url(scheme.get, call_568085.host, call_568085.base,
                         call_568085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568085, url, valid)

proc call*(call_568156: Call_ProviderOperationsList_567888;
          apiVersion: string = "2018-09-15"): Recallable =
  ## providerOperationsList
  ## Result of the request to list REST API operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568157 = newJObject()
  add(query_568157, "api-version", newJString(apiVersion))
  result = call_568156.call(nil, query_568157, nil, nil, nil)

var providerOperationsList* = Call_ProviderOperationsList_567888(
    name: "providerOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DevTestLab/operations",
    validator: validate_ProviderOperationsList_567889, base: "",
    url: url_ProviderOperationsList_567890, schemes: {Scheme.Https})
type
  Call_LabsListBySubscription_568197 = ref object of OpenApiRestCall_567666
proc url_LabsListBySubscription_568199(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListBySubscription_568198(path: JsonNode; query: JsonNode;
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
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568216 = query.getOrDefault("$orderby")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "$orderby", valid_568216
  var valid_568217 = query.getOrDefault("$expand")
  valid_568217 = validateParameter(valid_568217, JString, required = false,
                                 default = nil)
  if valid_568217 != nil:
    section.add "$expand", valid_568217
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  var valid_568219 = query.getOrDefault("$top")
  valid_568219 = validateParameter(valid_568219, JInt, required = false, default = nil)
  if valid_568219 != nil:
    section.add "$top", valid_568219
  var valid_568220 = query.getOrDefault("$filter")
  valid_568220 = validateParameter(valid_568220, JString, required = false,
                                 default = nil)
  if valid_568220 != nil:
    section.add "$filter", valid_568220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568221: Call_LabsListBySubscription_568197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a subscription.
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_LabsListBySubscription_568197; subscriptionId: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## labsListBySubscription
  ## List labs in a subscription.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568223 = newJObject()
  var query_568224 = newJObject()
  add(query_568224, "$orderby", newJString(Orderby))
  add(query_568224, "$expand", newJString(Expand))
  add(query_568224, "api-version", newJString(apiVersion))
  add(path_568223, "subscriptionId", newJString(subscriptionId))
  add(query_568224, "$top", newJInt(Top))
  add(query_568224, "$filter", newJString(Filter))
  result = call_568222.call(path_568223, query_568224, nil, nil, nil)

var labsListBySubscription* = Call_LabsListBySubscription_568197(
    name: "labsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListBySubscription_568198, base: "",
    url: url_LabsListBySubscription_568199, schemes: {Scheme.Https})
type
  Call_OperationsGet_568225 = ref object of OpenApiRestCall_567666
proc url_OperationsGet_568227(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsGet_568226(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568228 = path.getOrDefault("name")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "name", valid_568228
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  var valid_568230 = path.getOrDefault("locationName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "locationName", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_OperationsGet_568225; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get operation.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_OperationsGet_568225; name: string;
          subscriptionId: string; locationName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "name", newJString(name))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  add(path_568234, "locationName", newJString(locationName))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var operationsGet* = Call_OperationsGet_568225(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/locations/{locationName}/operations/{name}",
    validator: validate_OperationsGet_568226, base: "", url: url_OperationsGet_568227,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListBySubscription_568236 = ref object of OpenApiRestCall_567666
proc url_GlobalSchedulesListBySubscription_568238(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesListBySubscription_568237(path: JsonNode;
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
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568240 = query.getOrDefault("$orderby")
  valid_568240 = validateParameter(valid_568240, JString, required = false,
                                 default = nil)
  if valid_568240 != nil:
    section.add "$orderby", valid_568240
  var valid_568241 = query.getOrDefault("$expand")
  valid_568241 = validateParameter(valid_568241, JString, required = false,
                                 default = nil)
  if valid_568241 != nil:
    section.add "$expand", valid_568241
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  var valid_568243 = query.getOrDefault("$top")
  valid_568243 = validateParameter(valid_568243, JInt, required = false, default = nil)
  if valid_568243 != nil:
    section.add "$top", valid_568243
  var valid_568244 = query.getOrDefault("$filter")
  valid_568244 = validateParameter(valid_568244, JString, required = false,
                                 default = nil)
  if valid_568244 != nil:
    section.add "$filter", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_GlobalSchedulesListBySubscription_568236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a subscription.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_GlobalSchedulesListBySubscription_568236;
          subscriptionId: string; Orderby: string = ""; Expand: string = "";
          apiVersion: string = "2018-09-15"; Top: int = 0; Filter: string = ""): Recallable =
  ## globalSchedulesListBySubscription
  ## List schedules in a subscription.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(query_568248, "$orderby", newJString(Orderby))
  add(query_568248, "$expand", newJString(Expand))
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  add(query_568248, "$top", newJInt(Top))
  add(query_568248, "$filter", newJString(Filter))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var globalSchedulesListBySubscription* = Call_GlobalSchedulesListBySubscription_568236(
    name: "globalSchedulesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListBySubscription_568237, base: "",
    url: url_GlobalSchedulesListBySubscription_568238, schemes: {Scheme.Https})
type
  Call_LabsListByResourceGroup_568249 = ref object of OpenApiRestCall_567666
proc url_LabsListByResourceGroup_568251(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListByResourceGroup_568250(path: JsonNode; query: JsonNode;
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
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("subscriptionId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "subscriptionId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568254 = query.getOrDefault("$orderby")
  valid_568254 = validateParameter(valid_568254, JString, required = false,
                                 default = nil)
  if valid_568254 != nil:
    section.add "$orderby", valid_568254
  var valid_568255 = query.getOrDefault("$expand")
  valid_568255 = validateParameter(valid_568255, JString, required = false,
                                 default = nil)
  if valid_568255 != nil:
    section.add "$expand", valid_568255
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  var valid_568257 = query.getOrDefault("$top")
  valid_568257 = validateParameter(valid_568257, JInt, required = false, default = nil)
  if valid_568257 != nil:
    section.add "$top", valid_568257
  var valid_568258 = query.getOrDefault("$filter")
  valid_568258 = validateParameter(valid_568258, JString, required = false,
                                 default = nil)
  if valid_568258 != nil:
    section.add "$filter", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_LabsListByResourceGroup_568249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a resource group.
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_LabsListByResourceGroup_568249;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## labsListByResourceGroup
  ## List labs in a resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(query_568262, "$orderby", newJString(Orderby))
  add(path_568261, "resourceGroupName", newJString(resourceGroupName))
  add(query_568262, "$expand", newJString(Expand))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  add(query_568262, "$top", newJInt(Top))
  add(query_568262, "$filter", newJString(Filter))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var labsListByResourceGroup* = Call_LabsListByResourceGroup_568249(
    name: "labsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListByResourceGroup_568250, base: "",
    url: url_LabsListByResourceGroup_568251, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesList_568263 = ref object of OpenApiRestCall_567666
proc url_ArtifactSourcesList_568265(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesList_568264(path: JsonNode; query: JsonNode;
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
  var valid_568266 = path.getOrDefault("resourceGroupName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "resourceGroupName", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  var valid_568268 = path.getOrDefault("labName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "labName", valid_568268
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
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
                                 default = newJString("2018-09-15"))
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

proc call*(call_568274: Call_ArtifactSourcesList_568263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifact sources in a given lab.
  ## 
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_ArtifactSourcesList_568263; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## artifactSourcesList
  ## List artifact sources in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(query_568277, "$orderby", newJString(Orderby))
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "$expand", newJString(Expand))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  add(query_568277, "$top", newJInt(Top))
  add(path_568276, "labName", newJString(labName))
  add(query_568277, "$filter", newJString(Filter))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var artifactSourcesList* = Call_ArtifactSourcesList_568263(
    name: "artifactSourcesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources",
    validator: validate_ArtifactSourcesList_568264, base: "",
    url: url_ArtifactSourcesList_568265, schemes: {Scheme.Https})
type
  Call_ArmTemplatesList_568278 = ref object of OpenApiRestCall_567666
proc url_ArmTemplatesList_568280(protocol: Scheme; host: string; base: string;
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

proc validate_ArmTemplatesList_568279(path: JsonNode; query: JsonNode;
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
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  var valid_568283 = path.getOrDefault("artifactSourceName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "artifactSourceName", valid_568283
  var valid_568284 = path.getOrDefault("labName")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "labName", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568285 = query.getOrDefault("$orderby")
  valid_568285 = validateParameter(valid_568285, JString, required = false,
                                 default = nil)
  if valid_568285 != nil:
    section.add "$orderby", valid_568285
  var valid_568286 = query.getOrDefault("$expand")
  valid_568286 = validateParameter(valid_568286, JString, required = false,
                                 default = nil)
  if valid_568286 != nil:
    section.add "$expand", valid_568286
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  var valid_568288 = query.getOrDefault("$top")
  valid_568288 = validateParameter(valid_568288, JInt, required = false, default = nil)
  if valid_568288 != nil:
    section.add "$top", valid_568288
  var valid_568289 = query.getOrDefault("$filter")
  valid_568289 = validateParameter(valid_568289, JString, required = false,
                                 default = nil)
  if valid_568289 != nil:
    section.add "$filter", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568290: Call_ArmTemplatesList_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List azure resource manager templates in a given artifact source.
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_ArmTemplatesList_568278; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## armTemplatesList
  ## List azure resource manager templates in a given artifact source.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  add(query_568293, "$orderby", newJString(Orderby))
  add(path_568292, "resourceGroupName", newJString(resourceGroupName))
  add(query_568293, "$expand", newJString(Expand))
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "subscriptionId", newJString(subscriptionId))
  add(query_568293, "$top", newJInt(Top))
  add(path_568292, "artifactSourceName", newJString(artifactSourceName))
  add(path_568292, "labName", newJString(labName))
  add(query_568293, "$filter", newJString(Filter))
  result = call_568291.call(path_568292, query_568293, nil, nil, nil)

var armTemplatesList* = Call_ArmTemplatesList_568278(name: "armTemplatesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates",
    validator: validate_ArmTemplatesList_568279, base: "",
    url: url_ArmTemplatesList_568280, schemes: {Scheme.Https})
type
  Call_ArmTemplatesGet_568294 = ref object of OpenApiRestCall_567666
proc url_ArmTemplatesGet_568296(protocol: Scheme; host: string; base: string;
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

proc validate_ArmTemplatesGet_568295(path: JsonNode; query: JsonNode;
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
  ##       : The name of the azure resource manager template.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568297 = path.getOrDefault("resourceGroupName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "resourceGroupName", valid_568297
  var valid_568298 = path.getOrDefault("name")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "name", valid_568298
  var valid_568299 = path.getOrDefault("subscriptionId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "subscriptionId", valid_568299
  var valid_568300 = path.getOrDefault("artifactSourceName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "artifactSourceName", valid_568300
  var valid_568301 = path.getOrDefault("labName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "labName", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568302 = query.getOrDefault("$expand")
  valid_568302 = validateParameter(valid_568302, JString, required = false,
                                 default = nil)
  if valid_568302 != nil:
    section.add "$expand", valid_568302
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568304: Call_ArmTemplatesGet_568294; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get azure resource manager template.
  ## 
  let valid = call_568304.validator(path, query, header, formData, body)
  let scheme = call_568304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568304.url(scheme.get, call_568304.host, call_568304.base,
                         call_568304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568304, url, valid)

proc call*(call_568305: Call_ArmTemplatesGet_568294; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## armTemplatesGet
  ## Get azure resource manager template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   name: string (required)
  ##       : The name of the azure resource manager template.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568306 = newJObject()
  var query_568307 = newJObject()
  add(path_568306, "resourceGroupName", newJString(resourceGroupName))
  add(query_568307, "$expand", newJString(Expand))
  add(path_568306, "name", newJString(name))
  add(query_568307, "api-version", newJString(apiVersion))
  add(path_568306, "subscriptionId", newJString(subscriptionId))
  add(path_568306, "artifactSourceName", newJString(artifactSourceName))
  add(path_568306, "labName", newJString(labName))
  result = call_568305.call(path_568306, query_568307, nil, nil, nil)

var armTemplatesGet* = Call_ArmTemplatesGet_568294(name: "armTemplatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates/{name}",
    validator: validate_ArmTemplatesGet_568295, base: "", url: url_ArmTemplatesGet_568296,
    schemes: {Scheme.Https})
type
  Call_ArtifactsList_568308 = ref object of OpenApiRestCall_567666
proc url_ArtifactsList_568310(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsList_568309(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("subscriptionId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "subscriptionId", valid_568312
  var valid_568313 = path.getOrDefault("artifactSourceName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "artifactSourceName", valid_568313
  var valid_568314 = path.getOrDefault("labName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "labName", valid_568314
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568315 = query.getOrDefault("$orderby")
  valid_568315 = validateParameter(valid_568315, JString, required = false,
                                 default = nil)
  if valid_568315 != nil:
    section.add "$orderby", valid_568315
  var valid_568316 = query.getOrDefault("$expand")
  valid_568316 = validateParameter(valid_568316, JString, required = false,
                                 default = nil)
  if valid_568316 != nil:
    section.add "$expand", valid_568316
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  var valid_568318 = query.getOrDefault("$top")
  valid_568318 = validateParameter(valid_568318, JInt, required = false, default = nil)
  if valid_568318 != nil:
    section.add "$top", valid_568318
  var valid_568319 = query.getOrDefault("$filter")
  valid_568319 = validateParameter(valid_568319, JString, required = false,
                                 default = nil)
  if valid_568319 != nil:
    section.add "$filter", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_ArtifactsList_568308; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts in a given artifact source.
  ## 
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_ArtifactsList_568308; resourceGroupName: string;
          subscriptionId: string; artifactSourceName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## artifactsList
  ## List artifacts in a given artifact source.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=title)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(query_568323, "$orderby", newJString(Orderby))
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "$expand", newJString(Expand))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  add(query_568323, "$top", newJInt(Top))
  add(path_568322, "artifactSourceName", newJString(artifactSourceName))
  add(path_568322, "labName", newJString(labName))
  add(query_568323, "$filter", newJString(Filter))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_568308(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts",
    validator: validate_ArtifactsList_568309, base: "", url: url_ArtifactsList_568310,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGet_568324 = ref object of OpenApiRestCall_567666
proc url_ArtifactsGet_568326(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsGet_568325(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("name")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "name", valid_568328
  var valid_568329 = path.getOrDefault("subscriptionId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "subscriptionId", valid_568329
  var valid_568330 = path.getOrDefault("artifactSourceName")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "artifactSourceName", valid_568330
  var valid_568331 = path.getOrDefault("labName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "labName", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568332 = query.getOrDefault("$expand")
  valid_568332 = validateParameter(valid_568332, JString, required = false,
                                 default = nil)
  if valid_568332 != nil:
    section.add "$expand", valid_568332
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568333 = query.getOrDefault("api-version")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568333 != nil:
    section.add "api-version", valid_568333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_ArtifactsGet_568324; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_ArtifactsGet_568324; resourceGroupName: string;
          name: string; subscriptionId: string; artifactSourceName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(query_568337, "$expand", newJString(Expand))
  add(path_568336, "name", newJString(name))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(path_568336, "artifactSourceName", newJString(artifactSourceName))
  add(path_568336, "labName", newJString(labName))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_568324(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}",
    validator: validate_ArtifactsGet_568325, base: "", url: url_ArtifactsGet_568326,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGenerateArmTemplate_568338 = ref object of OpenApiRestCall_567666
proc url_ArtifactsGenerateArmTemplate_568340(protocol: Scheme; host: string;
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

proc validate_ArtifactsGenerateArmTemplate_568339(path: JsonNode; query: JsonNode;
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
  var valid_568341 = path.getOrDefault("resourceGroupName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "resourceGroupName", valid_568341
  var valid_568342 = path.getOrDefault("name")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "name", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("artifactSourceName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "artifactSourceName", valid_568344
  var valid_568345 = path.getOrDefault("labName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "labName", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568346 != nil:
    section.add "api-version", valid_568346
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

proc call*(call_568348: Call_ArtifactsGenerateArmTemplate_568338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  let valid = call_568348.validator(path, query, header, formData, body)
  let scheme = call_568348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568348.url(scheme.get, call_568348.host, call_568348.base,
                         call_568348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568348, url, valid)

proc call*(call_568349: Call_ArtifactsGenerateArmTemplate_568338;
          resourceGroupName: string; name: string; subscriptionId: string;
          artifactSourceName: string; labName: string;
          generateArmTemplateRequest: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568350 = newJObject()
  var query_568351 = newJObject()
  var body_568352 = newJObject()
  add(path_568350, "resourceGroupName", newJString(resourceGroupName))
  add(query_568351, "api-version", newJString(apiVersion))
  add(path_568350, "name", newJString(name))
  add(path_568350, "subscriptionId", newJString(subscriptionId))
  add(path_568350, "artifactSourceName", newJString(artifactSourceName))
  add(path_568350, "labName", newJString(labName))
  if generateArmTemplateRequest != nil:
    body_568352 = generateArmTemplateRequest
  result = call_568349.call(path_568350, query_568351, nil, nil, body_568352)

var artifactsGenerateArmTemplate* = Call_ArtifactsGenerateArmTemplate_568338(
    name: "artifactsGenerateArmTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}/generateArmTemplate",
    validator: validate_ArtifactsGenerateArmTemplate_568339, base: "",
    url: url_ArtifactsGenerateArmTemplate_568340, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesCreateOrUpdate_568366 = ref object of OpenApiRestCall_567666
proc url_ArtifactSourcesCreateOrUpdate_568368(protocol: Scheme; host: string;
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

proc validate_ArtifactSourcesCreateOrUpdate_568367(path: JsonNode; query: JsonNode;
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
  var valid_568369 = path.getOrDefault("resourceGroupName")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "resourceGroupName", valid_568369
  var valid_568370 = path.getOrDefault("name")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "name", valid_568370
  var valid_568371 = path.getOrDefault("subscriptionId")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "subscriptionId", valid_568371
  var valid_568372 = path.getOrDefault("labName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "labName", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568373 != nil:
    section.add "api-version", valid_568373
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

proc call*(call_568375: Call_ArtifactSourcesCreateOrUpdate_568366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing artifact source.
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_ArtifactSourcesCreateOrUpdate_568366;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  var body_568379 = newJObject()
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "name", newJString(name))
  if artifactSource != nil:
    body_568379 = artifactSource
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  add(path_568377, "labName", newJString(labName))
  result = call_568376.call(path_568377, query_568378, nil, nil, body_568379)

var artifactSourcesCreateOrUpdate* = Call_ArtifactSourcesCreateOrUpdate_568366(
    name: "artifactSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesCreateOrUpdate_568367, base: "",
    url: url_ArtifactSourcesCreateOrUpdate_568368, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesGet_568353 = ref object of OpenApiRestCall_567666
proc url_ArtifactSourcesGet_568355(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesGet_568354(path: JsonNode; query: JsonNode;
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
  var valid_568356 = path.getOrDefault("resourceGroupName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "resourceGroupName", valid_568356
  var valid_568357 = path.getOrDefault("name")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "name", valid_568357
  var valid_568358 = path.getOrDefault("subscriptionId")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "subscriptionId", valid_568358
  var valid_568359 = path.getOrDefault("labName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "labName", valid_568359
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568360 = query.getOrDefault("$expand")
  valid_568360 = validateParameter(valid_568360, JString, required = false,
                                 default = nil)
  if valid_568360 != nil:
    section.add "$expand", valid_568360
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568361 != nil:
    section.add "api-version", valid_568361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568362: Call_ArtifactSourcesGet_568353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact source.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_ArtifactSourcesGet_568353; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(query_568365, "$expand", newJString(Expand))
  add(path_568364, "name", newJString(name))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  add(path_568364, "labName", newJString(labName))
  result = call_568363.call(path_568364, query_568365, nil, nil, nil)

var artifactSourcesGet* = Call_ArtifactSourcesGet_568353(
    name: "artifactSourcesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesGet_568354, base: "",
    url: url_ArtifactSourcesGet_568355, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesUpdate_568392 = ref object of OpenApiRestCall_567666
proc url_ArtifactSourcesUpdate_568394(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesUpdate_568393(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of artifact sources. All other properties will be ignored.
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
  var valid_568395 = path.getOrDefault("resourceGroupName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "resourceGroupName", valid_568395
  var valid_568396 = path.getOrDefault("name")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "name", valid_568396
  var valid_568397 = path.getOrDefault("subscriptionId")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "subscriptionId", valid_568397
  var valid_568398 = path.getOrDefault("labName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "labName", valid_568398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568399 = query.getOrDefault("api-version")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568399 != nil:
    section.add "api-version", valid_568399
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

proc call*(call_568401: Call_ArtifactSourcesUpdate_568392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of artifact sources. All other properties will be ignored.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_ArtifactSourcesUpdate_568392;
          resourceGroupName: string; name: string; artifactSource: JsonNode;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## artifactSourcesUpdate
  ## Allows modifying tags of artifact sources. All other properties will be ignored.
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
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  var body_568405 = newJObject()
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "name", newJString(name))
  if artifactSource != nil:
    body_568405 = artifactSource
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  add(path_568403, "labName", newJString(labName))
  result = call_568402.call(path_568403, query_568404, nil, nil, body_568405)

var artifactSourcesUpdate* = Call_ArtifactSourcesUpdate_568392(
    name: "artifactSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesUpdate_568393, base: "",
    url: url_ArtifactSourcesUpdate_568394, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesDelete_568380 = ref object of OpenApiRestCall_567666
proc url_ArtifactSourcesDelete_568382(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesDelete_568381(path: JsonNode; query: JsonNode;
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
  var valid_568383 = path.getOrDefault("resourceGroupName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "resourceGroupName", valid_568383
  var valid_568384 = path.getOrDefault("name")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "name", valid_568384
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  var valid_568386 = path.getOrDefault("labName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "labName", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_ArtifactSourcesDelete_568380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete artifact source.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_ArtifactSourcesDelete_568380;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "name", newJString(name))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "labName", newJString(labName))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var artifactSourcesDelete* = Call_ArtifactSourcesDelete_568380(
    name: "artifactSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesDelete_568381, base: "",
    url: url_ArtifactSourcesDelete_568382, schemes: {Scheme.Https})
type
  Call_CostsCreateOrUpdate_568419 = ref object of OpenApiRestCall_567666
proc url_CostsCreateOrUpdate_568421(protocol: Scheme; host: string; base: string;
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

proc validate_CostsCreateOrUpdate_568420(path: JsonNode; query: JsonNode;
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
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("name")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "name", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  var valid_568425 = path.getOrDefault("labName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "labName", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568426 != nil:
    section.add "api-version", valid_568426
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

proc call*(call_568428: Call_CostsCreateOrUpdate_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing cost.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_CostsCreateOrUpdate_568419; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; labCost: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  var body_568432 = newJObject()
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "name", newJString(name))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  add(path_568430, "labName", newJString(labName))
  if labCost != nil:
    body_568432 = labCost
  result = call_568429.call(path_568430, query_568431, nil, nil, body_568432)

var costsCreateOrUpdate* = Call_CostsCreateOrUpdate_568419(
    name: "costsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
    validator: validate_CostsCreateOrUpdate_568420, base: "",
    url: url_CostsCreateOrUpdate_568421, schemes: {Scheme.Https})
type
  Call_CostsGet_568406 = ref object of OpenApiRestCall_567666
proc url_CostsGet_568408(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CostsGet_568407(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568409 = path.getOrDefault("resourceGroupName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "resourceGroupName", valid_568409
  var valid_568410 = path.getOrDefault("name")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "name", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  var valid_568412 = path.getOrDefault("labName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "labName", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=labCostDetails)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568413 = query.getOrDefault("$expand")
  valid_568413 = validateParameter(valid_568413, JString, required = false,
                                 default = nil)
  if valid_568413 != nil:
    section.add "$expand", valid_568413
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_CostsGet_568406; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost.
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_CostsGet_568406; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(path_568417, "resourceGroupName", newJString(resourceGroupName))
  add(query_568418, "$expand", newJString(Expand))
  add(path_568417, "name", newJString(name))
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  add(path_568417, "labName", newJString(labName))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var costsGet* = Call_CostsGet_568406(name: "costsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
                                  validator: validate_CostsGet_568407, base: "",
                                  url: url_CostsGet_568408,
                                  schemes: {Scheme.Https})
type
  Call_CustomImagesList_568433 = ref object of OpenApiRestCall_567666
proc url_CustomImagesList_568435(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesList_568434(path: JsonNode; query: JsonNode;
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
  var valid_568436 = path.getOrDefault("resourceGroupName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "resourceGroupName", valid_568436
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
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568439 = query.getOrDefault("$orderby")
  valid_568439 = validateParameter(valid_568439, JString, required = false,
                                 default = nil)
  if valid_568439 != nil:
    section.add "$orderby", valid_568439
  var valid_568440 = query.getOrDefault("$expand")
  valid_568440 = validateParameter(valid_568440, JString, required = false,
                                 default = nil)
  if valid_568440 != nil:
    section.add "$expand", valid_568440
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568441 = query.getOrDefault("api-version")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568441 != nil:
    section.add "api-version", valid_568441
  var valid_568442 = query.getOrDefault("$top")
  valid_568442 = validateParameter(valid_568442, JInt, required = false, default = nil)
  if valid_568442 != nil:
    section.add "$top", valid_568442
  var valid_568443 = query.getOrDefault("$filter")
  valid_568443 = validateParameter(valid_568443, JString, required = false,
                                 default = nil)
  if valid_568443 != nil:
    section.add "$filter", valid_568443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568444: Call_CustomImagesList_568433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List custom images in a given lab.
  ## 
  let valid = call_568444.validator(path, query, header, formData, body)
  let scheme = call_568444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568444.url(scheme.get, call_568444.host, call_568444.base,
                         call_568444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568444, url, valid)

proc call*(call_568445: Call_CustomImagesList_568433; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## customImagesList
  ## List custom images in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=vm)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568446 = newJObject()
  var query_568447 = newJObject()
  add(query_568447, "$orderby", newJString(Orderby))
  add(path_568446, "resourceGroupName", newJString(resourceGroupName))
  add(query_568447, "$expand", newJString(Expand))
  add(query_568447, "api-version", newJString(apiVersion))
  add(path_568446, "subscriptionId", newJString(subscriptionId))
  add(query_568447, "$top", newJInt(Top))
  add(path_568446, "labName", newJString(labName))
  add(query_568447, "$filter", newJString(Filter))
  result = call_568445.call(path_568446, query_568447, nil, nil, nil)

var customImagesList* = Call_CustomImagesList_568433(name: "customImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages",
    validator: validate_CustomImagesList_568434, base: "",
    url: url_CustomImagesList_568435, schemes: {Scheme.Https})
type
  Call_CustomImagesCreateOrUpdate_568461 = ref object of OpenApiRestCall_567666
proc url_CustomImagesCreateOrUpdate_568463(protocol: Scheme; host: string;
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

proc validate_CustomImagesCreateOrUpdate_568462(path: JsonNode; query: JsonNode;
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
  var valid_568464 = path.getOrDefault("resourceGroupName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "resourceGroupName", valid_568464
  var valid_568465 = path.getOrDefault("name")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "name", valid_568465
  var valid_568466 = path.getOrDefault("subscriptionId")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "subscriptionId", valid_568466
  var valid_568467 = path.getOrDefault("labName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "labName", valid_568467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568468 = query.getOrDefault("api-version")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568468 != nil:
    section.add "api-version", valid_568468
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

proc call*(call_568470: Call_CustomImagesCreateOrUpdate_568461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  let valid = call_568470.validator(path, query, header, formData, body)
  let scheme = call_568470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568470.url(scheme.get, call_568470.host, call_568470.base,
                         call_568470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568470, url, valid)

proc call*(call_568471: Call_CustomImagesCreateOrUpdate_568461;
          resourceGroupName: string; name: string; subscriptionId: string;
          customImage: JsonNode; labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568472 = newJObject()
  var query_568473 = newJObject()
  var body_568474 = newJObject()
  add(path_568472, "resourceGroupName", newJString(resourceGroupName))
  add(query_568473, "api-version", newJString(apiVersion))
  add(path_568472, "name", newJString(name))
  add(path_568472, "subscriptionId", newJString(subscriptionId))
  if customImage != nil:
    body_568474 = customImage
  add(path_568472, "labName", newJString(labName))
  result = call_568471.call(path_568472, query_568473, nil, nil, body_568474)

var customImagesCreateOrUpdate* = Call_CustomImagesCreateOrUpdate_568461(
    name: "customImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesCreateOrUpdate_568462, base: "",
    url: url_CustomImagesCreateOrUpdate_568463, schemes: {Scheme.Https})
type
  Call_CustomImagesGet_568448 = ref object of OpenApiRestCall_567666
proc url_CustomImagesGet_568450(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesGet_568449(path: JsonNode; query: JsonNode;
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
  var valid_568451 = path.getOrDefault("resourceGroupName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "resourceGroupName", valid_568451
  var valid_568452 = path.getOrDefault("name")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "name", valid_568452
  var valid_568453 = path.getOrDefault("subscriptionId")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "subscriptionId", valid_568453
  var valid_568454 = path.getOrDefault("labName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "labName", valid_568454
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568455 = query.getOrDefault("$expand")
  valid_568455 = validateParameter(valid_568455, JString, required = false,
                                 default = nil)
  if valid_568455 != nil:
    section.add "$expand", valid_568455
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568456 = query.getOrDefault("api-version")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568456 != nil:
    section.add "api-version", valid_568456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568457: Call_CustomImagesGet_568448; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get custom image.
  ## 
  let valid = call_568457.validator(path, query, header, formData, body)
  let scheme = call_568457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568457.url(scheme.get, call_568457.host, call_568457.base,
                         call_568457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568457, url, valid)

proc call*(call_568458: Call_CustomImagesGet_568448; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568459 = newJObject()
  var query_568460 = newJObject()
  add(path_568459, "resourceGroupName", newJString(resourceGroupName))
  add(query_568460, "$expand", newJString(Expand))
  add(path_568459, "name", newJString(name))
  add(query_568460, "api-version", newJString(apiVersion))
  add(path_568459, "subscriptionId", newJString(subscriptionId))
  add(path_568459, "labName", newJString(labName))
  result = call_568458.call(path_568459, query_568460, nil, nil, nil)

var customImagesGet* = Call_CustomImagesGet_568448(name: "customImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesGet_568449, base: "", url: url_CustomImagesGet_568450,
    schemes: {Scheme.Https})
type
  Call_CustomImagesUpdate_568487 = ref object of OpenApiRestCall_567666
proc url_CustomImagesUpdate_568489(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesUpdate_568488(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Allows modifying tags of custom images. All other properties will be ignored.
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
  var valid_568490 = path.getOrDefault("resourceGroupName")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "resourceGroupName", valid_568490
  var valid_568491 = path.getOrDefault("name")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "name", valid_568491
  var valid_568492 = path.getOrDefault("subscriptionId")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "subscriptionId", valid_568492
  var valid_568493 = path.getOrDefault("labName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "labName", valid_568493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568494 = query.getOrDefault("api-version")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568494 != nil:
    section.add "api-version", valid_568494
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

proc call*(call_568496: Call_CustomImagesUpdate_568487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of custom images. All other properties will be ignored.
  ## 
  let valid = call_568496.validator(path, query, header, formData, body)
  let scheme = call_568496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568496.url(scheme.get, call_568496.host, call_568496.base,
                         call_568496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568496, url, valid)

proc call*(call_568497: Call_CustomImagesUpdate_568487; resourceGroupName: string;
          name: string; subscriptionId: string; customImage: JsonNode;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## customImagesUpdate
  ## Allows modifying tags of custom images. All other properties will be ignored.
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
  var path_568498 = newJObject()
  var query_568499 = newJObject()
  var body_568500 = newJObject()
  add(path_568498, "resourceGroupName", newJString(resourceGroupName))
  add(query_568499, "api-version", newJString(apiVersion))
  add(path_568498, "name", newJString(name))
  add(path_568498, "subscriptionId", newJString(subscriptionId))
  if customImage != nil:
    body_568500 = customImage
  add(path_568498, "labName", newJString(labName))
  result = call_568497.call(path_568498, query_568499, nil, nil, body_568500)

var customImagesUpdate* = Call_CustomImagesUpdate_568487(
    name: "customImagesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesUpdate_568488, base: "",
    url: url_CustomImagesUpdate_568489, schemes: {Scheme.Https})
type
  Call_CustomImagesDelete_568475 = ref object of OpenApiRestCall_567666
proc url_CustomImagesDelete_568477(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesDelete_568476(path: JsonNode; query: JsonNode;
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
  var valid_568478 = path.getOrDefault("resourceGroupName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "resourceGroupName", valid_568478
  var valid_568479 = path.getOrDefault("name")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "name", valid_568479
  var valid_568480 = path.getOrDefault("subscriptionId")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "subscriptionId", valid_568480
  var valid_568481 = path.getOrDefault("labName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "labName", valid_568481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568482 = query.getOrDefault("api-version")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568482 != nil:
    section.add "api-version", valid_568482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568483: Call_CustomImagesDelete_568475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  let valid = call_568483.validator(path, query, header, formData, body)
  let scheme = call_568483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568483.url(scheme.get, call_568483.host, call_568483.base,
                         call_568483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568483, url, valid)

proc call*(call_568484: Call_CustomImagesDelete_568475; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568485 = newJObject()
  var query_568486 = newJObject()
  add(path_568485, "resourceGroupName", newJString(resourceGroupName))
  add(query_568486, "api-version", newJString(apiVersion))
  add(path_568485, "name", newJString(name))
  add(path_568485, "subscriptionId", newJString(subscriptionId))
  add(path_568485, "labName", newJString(labName))
  result = call_568484.call(path_568485, query_568486, nil, nil, nil)

var customImagesDelete* = Call_CustomImagesDelete_568475(
    name: "customImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesDelete_568476, base: "",
    url: url_CustomImagesDelete_568477, schemes: {Scheme.Https})
type
  Call_FormulasList_568501 = ref object of OpenApiRestCall_567666
proc url_FormulasList_568503(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasList_568502(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568504 = path.getOrDefault("resourceGroupName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "resourceGroupName", valid_568504
  var valid_568505 = path.getOrDefault("subscriptionId")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "subscriptionId", valid_568505
  var valid_568506 = path.getOrDefault("labName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "labName", valid_568506
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568507 = query.getOrDefault("$orderby")
  valid_568507 = validateParameter(valid_568507, JString, required = false,
                                 default = nil)
  if valid_568507 != nil:
    section.add "$orderby", valid_568507
  var valid_568508 = query.getOrDefault("$expand")
  valid_568508 = validateParameter(valid_568508, JString, required = false,
                                 default = nil)
  if valid_568508 != nil:
    section.add "$expand", valid_568508
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568509 = query.getOrDefault("api-version")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568509 != nil:
    section.add "api-version", valid_568509
  var valid_568510 = query.getOrDefault("$top")
  valid_568510 = validateParameter(valid_568510, JInt, required = false, default = nil)
  if valid_568510 != nil:
    section.add "$top", valid_568510
  var valid_568511 = query.getOrDefault("$filter")
  valid_568511 = validateParameter(valid_568511, JString, required = false,
                                 default = nil)
  if valid_568511 != nil:
    section.add "$filter", valid_568511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568512: Call_FormulasList_568501; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List formulas in a given lab.
  ## 
  let valid = call_568512.validator(path, query, header, formData, body)
  let scheme = call_568512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568512.url(scheme.get, call_568512.host, call_568512.base,
                         call_568512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568512, url, valid)

proc call*(call_568513: Call_FormulasList_568501; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## formulasList
  ## List formulas in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568514 = newJObject()
  var query_568515 = newJObject()
  add(query_568515, "$orderby", newJString(Orderby))
  add(path_568514, "resourceGroupName", newJString(resourceGroupName))
  add(query_568515, "$expand", newJString(Expand))
  add(query_568515, "api-version", newJString(apiVersion))
  add(path_568514, "subscriptionId", newJString(subscriptionId))
  add(query_568515, "$top", newJInt(Top))
  add(path_568514, "labName", newJString(labName))
  add(query_568515, "$filter", newJString(Filter))
  result = call_568513.call(path_568514, query_568515, nil, nil, nil)

var formulasList* = Call_FormulasList_568501(name: "formulasList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas",
    validator: validate_FormulasList_568502, base: "", url: url_FormulasList_568503,
    schemes: {Scheme.Https})
type
  Call_FormulasCreateOrUpdate_568529 = ref object of OpenApiRestCall_567666
proc url_FormulasCreateOrUpdate_568531(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasCreateOrUpdate_568530(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing formula. This operation can take a while to complete.
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
  var valid_568532 = path.getOrDefault("resourceGroupName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "resourceGroupName", valid_568532
  var valid_568533 = path.getOrDefault("name")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "name", valid_568533
  var valid_568534 = path.getOrDefault("subscriptionId")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "subscriptionId", valid_568534
  var valid_568535 = path.getOrDefault("labName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "labName", valid_568535
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568536 = query.getOrDefault("api-version")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568536 != nil:
    section.add "api-version", valid_568536
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

proc call*(call_568538: Call_FormulasCreateOrUpdate_568529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing formula. This operation can take a while to complete.
  ## 
  let valid = call_568538.validator(path, query, header, formData, body)
  let scheme = call_568538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568538.url(scheme.get, call_568538.host, call_568538.base,
                         call_568538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568538, url, valid)

proc call*(call_568539: Call_FormulasCreateOrUpdate_568529;
          resourceGroupName: string; formula: JsonNode; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## formulasCreateOrUpdate
  ## Create or replace an existing formula. This operation can take a while to complete.
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
  var path_568540 = newJObject()
  var query_568541 = newJObject()
  var body_568542 = newJObject()
  add(path_568540, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_568542 = formula
  add(query_568541, "api-version", newJString(apiVersion))
  add(path_568540, "name", newJString(name))
  add(path_568540, "subscriptionId", newJString(subscriptionId))
  add(path_568540, "labName", newJString(labName))
  result = call_568539.call(path_568540, query_568541, nil, nil, body_568542)

var formulasCreateOrUpdate* = Call_FormulasCreateOrUpdate_568529(
    name: "formulasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasCreateOrUpdate_568530, base: "",
    url: url_FormulasCreateOrUpdate_568531, schemes: {Scheme.Https})
type
  Call_FormulasGet_568516 = ref object of OpenApiRestCall_567666
proc url_FormulasGet_568518(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasGet_568517(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568519 = path.getOrDefault("resourceGroupName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "resourceGroupName", valid_568519
  var valid_568520 = path.getOrDefault("name")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "name", valid_568520
  var valid_568521 = path.getOrDefault("subscriptionId")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "subscriptionId", valid_568521
  var valid_568522 = path.getOrDefault("labName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "labName", valid_568522
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568523 = query.getOrDefault("$expand")
  valid_568523 = validateParameter(valid_568523, JString, required = false,
                                 default = nil)
  if valid_568523 != nil:
    section.add "$expand", valid_568523
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568524 != nil:
    section.add "api-version", valid_568524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_FormulasGet_568516; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get formula.
  ## 
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_FormulasGet_568516; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  add(path_568527, "resourceGroupName", newJString(resourceGroupName))
  add(query_568528, "$expand", newJString(Expand))
  add(path_568527, "name", newJString(name))
  add(query_568528, "api-version", newJString(apiVersion))
  add(path_568527, "subscriptionId", newJString(subscriptionId))
  add(path_568527, "labName", newJString(labName))
  result = call_568526.call(path_568527, query_568528, nil, nil, nil)

var formulasGet* = Call_FormulasGet_568516(name: "formulasGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
                                        validator: validate_FormulasGet_568517,
                                        base: "", url: url_FormulasGet_568518,
                                        schemes: {Scheme.Https})
type
  Call_FormulasUpdate_568555 = ref object of OpenApiRestCall_567666
proc url_FormulasUpdate_568557(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasUpdate_568556(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Allows modifying tags of formulas. All other properties will be ignored.
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
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568562 = query.getOrDefault("api-version")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568562 != nil:
    section.add "api-version", valid_568562
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

proc call*(call_568564: Call_FormulasUpdate_568555; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of formulas. All other properties will be ignored.
  ## 
  let valid = call_568564.validator(path, query, header, formData, body)
  let scheme = call_568564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568564.url(scheme.get, call_568564.host, call_568564.base,
                         call_568564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568564, url, valid)

proc call*(call_568565: Call_FormulasUpdate_568555; resourceGroupName: string;
          formula: JsonNode; name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## formulasUpdate
  ## Allows modifying tags of formulas. All other properties will be ignored.
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
  var path_568566 = newJObject()
  var query_568567 = newJObject()
  var body_568568 = newJObject()
  add(path_568566, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_568568 = formula
  add(query_568567, "api-version", newJString(apiVersion))
  add(path_568566, "name", newJString(name))
  add(path_568566, "subscriptionId", newJString(subscriptionId))
  add(path_568566, "labName", newJString(labName))
  result = call_568565.call(path_568566, query_568567, nil, nil, body_568568)

var formulasUpdate* = Call_FormulasUpdate_568555(name: "formulasUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasUpdate_568556, base: "", url: url_FormulasUpdate_568557,
    schemes: {Scheme.Https})
type
  Call_FormulasDelete_568543 = ref object of OpenApiRestCall_567666
proc url_FormulasDelete_568545(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasDelete_568544(path: JsonNode; query: JsonNode;
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
  var valid_568546 = path.getOrDefault("resourceGroupName")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "resourceGroupName", valid_568546
  var valid_568547 = path.getOrDefault("name")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "name", valid_568547
  var valid_568548 = path.getOrDefault("subscriptionId")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "subscriptionId", valid_568548
  var valid_568549 = path.getOrDefault("labName")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "labName", valid_568549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568550 = query.getOrDefault("api-version")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568550 != nil:
    section.add "api-version", valid_568550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568551: Call_FormulasDelete_568543; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete formula.
  ## 
  let valid = call_568551.validator(path, query, header, formData, body)
  let scheme = call_568551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568551.url(scheme.get, call_568551.host, call_568551.base,
                         call_568551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568551, url, valid)

proc call*(call_568552: Call_FormulasDelete_568543; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568553 = newJObject()
  var query_568554 = newJObject()
  add(path_568553, "resourceGroupName", newJString(resourceGroupName))
  add(query_568554, "api-version", newJString(apiVersion))
  add(path_568553, "name", newJString(name))
  add(path_568553, "subscriptionId", newJString(subscriptionId))
  add(path_568553, "labName", newJString(labName))
  result = call_568552.call(path_568553, query_568554, nil, nil, nil)

var formulasDelete* = Call_FormulasDelete_568543(name: "formulasDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasDelete_568544, base: "", url: url_FormulasDelete_568545,
    schemes: {Scheme.Https})
type
  Call_GalleryImagesList_568569 = ref object of OpenApiRestCall_567666
proc url_GalleryImagesList_568571(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesList_568570(path: JsonNode; query: JsonNode;
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
  var valid_568572 = path.getOrDefault("resourceGroupName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "resourceGroupName", valid_568572
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
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568575 = query.getOrDefault("$orderby")
  valid_568575 = validateParameter(valid_568575, JString, required = false,
                                 default = nil)
  if valid_568575 != nil:
    section.add "$orderby", valid_568575
  var valid_568576 = query.getOrDefault("$expand")
  valid_568576 = validateParameter(valid_568576, JString, required = false,
                                 default = nil)
  if valid_568576 != nil:
    section.add "$expand", valid_568576
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568577 = query.getOrDefault("api-version")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568577 != nil:
    section.add "api-version", valid_568577
  var valid_568578 = query.getOrDefault("$top")
  valid_568578 = validateParameter(valid_568578, JInt, required = false, default = nil)
  if valid_568578 != nil:
    section.add "$top", valid_568578
  var valid_568579 = query.getOrDefault("$filter")
  valid_568579 = validateParameter(valid_568579, JString, required = false,
                                 default = nil)
  if valid_568579 != nil:
    section.add "$filter", valid_568579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568580: Call_GalleryImagesList_568569; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images in a given lab.
  ## 
  let valid = call_568580.validator(path, query, header, formData, body)
  let scheme = call_568580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568580.url(scheme.get, call_568580.host, call_568580.base,
                         call_568580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568580, url, valid)

proc call*(call_568581: Call_GalleryImagesList_568569; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## galleryImagesList
  ## List gallery images in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568582 = newJObject()
  var query_568583 = newJObject()
  add(query_568583, "$orderby", newJString(Orderby))
  add(path_568582, "resourceGroupName", newJString(resourceGroupName))
  add(query_568583, "$expand", newJString(Expand))
  add(query_568583, "api-version", newJString(apiVersion))
  add(path_568582, "subscriptionId", newJString(subscriptionId))
  add(query_568583, "$top", newJInt(Top))
  add(path_568582, "labName", newJString(labName))
  add(query_568583, "$filter", newJString(Filter))
  result = call_568581.call(path_568582, query_568583, nil, nil, nil)

var galleryImagesList* = Call_GalleryImagesList_568569(name: "galleryImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/galleryimages",
    validator: validate_GalleryImagesList_568570, base: "",
    url: url_GalleryImagesList_568571, schemes: {Scheme.Https})
type
  Call_NotificationChannelsList_568584 = ref object of OpenApiRestCall_567666
proc url_NotificationChannelsList_568586(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsList_568585(path: JsonNode; query: JsonNode;
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
  var valid_568587 = path.getOrDefault("resourceGroupName")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "resourceGroupName", valid_568587
  var valid_568588 = path.getOrDefault("subscriptionId")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "subscriptionId", valid_568588
  var valid_568589 = path.getOrDefault("labName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "labName", valid_568589
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568590 = query.getOrDefault("$orderby")
  valid_568590 = validateParameter(valid_568590, JString, required = false,
                                 default = nil)
  if valid_568590 != nil:
    section.add "$orderby", valid_568590
  var valid_568591 = query.getOrDefault("$expand")
  valid_568591 = validateParameter(valid_568591, JString, required = false,
                                 default = nil)
  if valid_568591 != nil:
    section.add "$expand", valid_568591
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568592 = query.getOrDefault("api-version")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568592 != nil:
    section.add "api-version", valid_568592
  var valid_568593 = query.getOrDefault("$top")
  valid_568593 = validateParameter(valid_568593, JInt, required = false, default = nil)
  if valid_568593 != nil:
    section.add "$top", valid_568593
  var valid_568594 = query.getOrDefault("$filter")
  valid_568594 = validateParameter(valid_568594, JString, required = false,
                                 default = nil)
  if valid_568594 != nil:
    section.add "$filter", valid_568594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568595: Call_NotificationChannelsList_568584; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List notification channels in a given lab.
  ## 
  let valid = call_568595.validator(path, query, header, formData, body)
  let scheme = call_568595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568595.url(scheme.get, call_568595.host, call_568595.base,
                         call_568595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568595, url, valid)

proc call*(call_568596: Call_NotificationChannelsList_568584;
          resourceGroupName: string; subscriptionId: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## notificationChannelsList
  ## List notification channels in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568597 = newJObject()
  var query_568598 = newJObject()
  add(query_568598, "$orderby", newJString(Orderby))
  add(path_568597, "resourceGroupName", newJString(resourceGroupName))
  add(query_568598, "$expand", newJString(Expand))
  add(query_568598, "api-version", newJString(apiVersion))
  add(path_568597, "subscriptionId", newJString(subscriptionId))
  add(query_568598, "$top", newJInt(Top))
  add(path_568597, "labName", newJString(labName))
  add(query_568598, "$filter", newJString(Filter))
  result = call_568596.call(path_568597, query_568598, nil, nil, nil)

var notificationChannelsList* = Call_NotificationChannelsList_568584(
    name: "notificationChannelsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels",
    validator: validate_NotificationChannelsList_568585, base: "",
    url: url_NotificationChannelsList_568586, schemes: {Scheme.Https})
type
  Call_NotificationChannelsCreateOrUpdate_568612 = ref object of OpenApiRestCall_567666
proc url_NotificationChannelsCreateOrUpdate_568614(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsCreateOrUpdate_568613(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568615 = path.getOrDefault("resourceGroupName")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "resourceGroupName", valid_568615
  var valid_568616 = path.getOrDefault("name")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "name", valid_568616
  var valid_568617 = path.getOrDefault("subscriptionId")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "subscriptionId", valid_568617
  var valid_568618 = path.getOrDefault("labName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "labName", valid_568618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568619 = query.getOrDefault("api-version")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568619 != nil:
    section.add "api-version", valid_568619
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

proc call*(call_568621: Call_NotificationChannelsCreateOrUpdate_568612;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing notification channel.
  ## 
  let valid = call_568621.validator(path, query, header, formData, body)
  let scheme = call_568621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568621.url(scheme.get, call_568621.host, call_568621.base,
                         call_568621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568621, url, valid)

proc call*(call_568622: Call_NotificationChannelsCreateOrUpdate_568612;
          notificationChannel: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsCreateOrUpdate
  ## Create or replace an existing notification channel.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568623 = newJObject()
  var query_568624 = newJObject()
  var body_568625 = newJObject()
  if notificationChannel != nil:
    body_568625 = notificationChannel
  add(path_568623, "resourceGroupName", newJString(resourceGroupName))
  add(query_568624, "api-version", newJString(apiVersion))
  add(path_568623, "name", newJString(name))
  add(path_568623, "subscriptionId", newJString(subscriptionId))
  add(path_568623, "labName", newJString(labName))
  result = call_568622.call(path_568623, query_568624, nil, nil, body_568625)

var notificationChannelsCreateOrUpdate* = Call_NotificationChannelsCreateOrUpdate_568612(
    name: "notificationChannelsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsCreateOrUpdate_568613, base: "",
    url: url_NotificationChannelsCreateOrUpdate_568614, schemes: {Scheme.Https})
type
  Call_NotificationChannelsGet_568599 = ref object of OpenApiRestCall_567666
proc url_NotificationChannelsGet_568601(protocol: Scheme; host: string; base: string;
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

proc validate_NotificationChannelsGet_568600(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568602 = path.getOrDefault("resourceGroupName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "resourceGroupName", valid_568602
  var valid_568603 = path.getOrDefault("name")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "name", valid_568603
  var valid_568604 = path.getOrDefault("subscriptionId")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "subscriptionId", valid_568604
  var valid_568605 = path.getOrDefault("labName")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = nil)
  if valid_568605 != nil:
    section.add "labName", valid_568605
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568606 = query.getOrDefault("$expand")
  valid_568606 = validateParameter(valid_568606, JString, required = false,
                                 default = nil)
  if valid_568606 != nil:
    section.add "$expand", valid_568606
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568607 = query.getOrDefault("api-version")
  valid_568607 = validateParameter(valid_568607, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568607 != nil:
    section.add "api-version", valid_568607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568608: Call_NotificationChannelsGet_568599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get notification channel.
  ## 
  let valid = call_568608.validator(path, query, header, formData, body)
  let scheme = call_568608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568608.url(scheme.get, call_568608.host, call_568608.base,
                         call_568608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568608, url, valid)

proc call*(call_568609: Call_NotificationChannelsGet_568599;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsGet
  ## Get notification channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568610 = newJObject()
  var query_568611 = newJObject()
  add(path_568610, "resourceGroupName", newJString(resourceGroupName))
  add(query_568611, "$expand", newJString(Expand))
  add(path_568610, "name", newJString(name))
  add(query_568611, "api-version", newJString(apiVersion))
  add(path_568610, "subscriptionId", newJString(subscriptionId))
  add(path_568610, "labName", newJString(labName))
  result = call_568609.call(path_568610, query_568611, nil, nil, nil)

var notificationChannelsGet* = Call_NotificationChannelsGet_568599(
    name: "notificationChannelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsGet_568600, base: "",
    url: url_NotificationChannelsGet_568601, schemes: {Scheme.Https})
type
  Call_NotificationChannelsUpdate_568638 = ref object of OpenApiRestCall_567666
proc url_NotificationChannelsUpdate_568640(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsUpdate_568639(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of notification channels. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568641 = path.getOrDefault("resourceGroupName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "resourceGroupName", valid_568641
  var valid_568642 = path.getOrDefault("name")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "name", valid_568642
  var valid_568643 = path.getOrDefault("subscriptionId")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "subscriptionId", valid_568643
  var valid_568644 = path.getOrDefault("labName")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "labName", valid_568644
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568645 = query.getOrDefault("api-version")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568645 != nil:
    section.add "api-version", valid_568645
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

proc call*(call_568647: Call_NotificationChannelsUpdate_568638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of notification channels. All other properties will be ignored.
  ## 
  let valid = call_568647.validator(path, query, header, formData, body)
  let scheme = call_568647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568647.url(scheme.get, call_568647.host, call_568647.base,
                         call_568647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568647, url, valid)

proc call*(call_568648: Call_NotificationChannelsUpdate_568638;
          notificationChannel: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsUpdate
  ## Allows modifying tags of notification channels. All other properties will be ignored.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568649 = newJObject()
  var query_568650 = newJObject()
  var body_568651 = newJObject()
  if notificationChannel != nil:
    body_568651 = notificationChannel
  add(path_568649, "resourceGroupName", newJString(resourceGroupName))
  add(query_568650, "api-version", newJString(apiVersion))
  add(path_568649, "name", newJString(name))
  add(path_568649, "subscriptionId", newJString(subscriptionId))
  add(path_568649, "labName", newJString(labName))
  result = call_568648.call(path_568649, query_568650, nil, nil, body_568651)

var notificationChannelsUpdate* = Call_NotificationChannelsUpdate_568638(
    name: "notificationChannelsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsUpdate_568639, base: "",
    url: url_NotificationChannelsUpdate_568640, schemes: {Scheme.Https})
type
  Call_NotificationChannelsDelete_568626 = ref object of OpenApiRestCall_567666
proc url_NotificationChannelsDelete_568628(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsDelete_568627(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568629 = path.getOrDefault("resourceGroupName")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "resourceGroupName", valid_568629
  var valid_568630 = path.getOrDefault("name")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "name", valid_568630
  var valid_568631 = path.getOrDefault("subscriptionId")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "subscriptionId", valid_568631
  var valid_568632 = path.getOrDefault("labName")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "labName", valid_568632
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568633 = query.getOrDefault("api-version")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568633 != nil:
    section.add "api-version", valid_568633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568634: Call_NotificationChannelsDelete_568626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete notification channel.
  ## 
  let valid = call_568634.validator(path, query, header, formData, body)
  let scheme = call_568634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568634.url(scheme.get, call_568634.host, call_568634.base,
                         call_568634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568634, url, valid)

proc call*(call_568635: Call_NotificationChannelsDelete_568626;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsDelete
  ## Delete notification channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_568636 = newJObject()
  var query_568637 = newJObject()
  add(path_568636, "resourceGroupName", newJString(resourceGroupName))
  add(query_568637, "api-version", newJString(apiVersion))
  add(path_568636, "name", newJString(name))
  add(path_568636, "subscriptionId", newJString(subscriptionId))
  add(path_568636, "labName", newJString(labName))
  result = call_568635.call(path_568636, query_568637, nil, nil, nil)

var notificationChannelsDelete* = Call_NotificationChannelsDelete_568626(
    name: "notificationChannelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsDelete_568627, base: "",
    url: url_NotificationChannelsDelete_568628, schemes: {Scheme.Https})
type
  Call_NotificationChannelsNotify_568652 = ref object of OpenApiRestCall_567666
proc url_NotificationChannelsNotify_568654(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsNotify_568653(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send notification to provided channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
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
  var valid_568658 = path.getOrDefault("labName")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "labName", valid_568658
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568659 = query.getOrDefault("api-version")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568659 != nil:
    section.add "api-version", valid_568659
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

proc call*(call_568661: Call_NotificationChannelsNotify_568652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send notification to provided channel.
  ## 
  let valid = call_568661.validator(path, query, header, formData, body)
  let scheme = call_568661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568661.url(scheme.get, call_568661.host, call_568661.base,
                         call_568661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568661, url, valid)

proc call*(call_568662: Call_NotificationChannelsNotify_568652;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; notifyParameters: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsNotify
  ## Send notification to provided channel.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   notifyParameters: JObject (required)
  ##                   : Properties for generating a Notification.
  var path_568663 = newJObject()
  var query_568664 = newJObject()
  var body_568665 = newJObject()
  add(path_568663, "resourceGroupName", newJString(resourceGroupName))
  add(query_568664, "api-version", newJString(apiVersion))
  add(path_568663, "name", newJString(name))
  add(path_568663, "subscriptionId", newJString(subscriptionId))
  add(path_568663, "labName", newJString(labName))
  if notifyParameters != nil:
    body_568665 = notifyParameters
  result = call_568662.call(path_568663, query_568664, nil, nil, body_568665)

var notificationChannelsNotify* = Call_NotificationChannelsNotify_568652(
    name: "notificationChannelsNotify", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}/notify",
    validator: validate_NotificationChannelsNotify_568653, base: "",
    url: url_NotificationChannelsNotify_568654, schemes: {Scheme.Https})
type
  Call_PolicySetsEvaluatePolicies_568666 = ref object of OpenApiRestCall_567666
proc url_PolicySetsEvaluatePolicies_568668(protocol: Scheme; host: string;
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

proc validate_PolicySetsEvaluatePolicies_568667(path: JsonNode; query: JsonNode;
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
  var valid_568672 = path.getOrDefault("labName")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "labName", valid_568672
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568673 = query.getOrDefault("api-version")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568673 != nil:
    section.add "api-version", valid_568673
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

proc call*(call_568675: Call_PolicySetsEvaluatePolicies_568666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Evaluates lab policy.
  ## 
  let valid = call_568675.validator(path, query, header, formData, body)
  let scheme = call_568675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568675.url(scheme.get, call_568675.host, call_568675.base,
                         call_568675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568675, url, valid)

proc call*(call_568676: Call_PolicySetsEvaluatePolicies_568666;
          resourceGroupName: string; name: string; subscriptionId: string;
          evaluatePoliciesRequest: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568677 = newJObject()
  var query_568678 = newJObject()
  var body_568679 = newJObject()
  add(path_568677, "resourceGroupName", newJString(resourceGroupName))
  add(query_568678, "api-version", newJString(apiVersion))
  add(path_568677, "name", newJString(name))
  add(path_568677, "subscriptionId", newJString(subscriptionId))
  if evaluatePoliciesRequest != nil:
    body_568679 = evaluatePoliciesRequest
  add(path_568677, "labName", newJString(labName))
  result = call_568676.call(path_568677, query_568678, nil, nil, body_568679)

var policySetsEvaluatePolicies* = Call_PolicySetsEvaluatePolicies_568666(
    name: "policySetsEvaluatePolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{name}/evaluatePolicies",
    validator: validate_PolicySetsEvaluatePolicies_568667, base: "",
    url: url_PolicySetsEvaluatePolicies_568668, schemes: {Scheme.Https})
type
  Call_PoliciesList_568680 = ref object of OpenApiRestCall_567666
proc url_PoliciesList_568682(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesList_568681(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568683 = path.getOrDefault("resourceGroupName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "resourceGroupName", valid_568683
  var valid_568684 = path.getOrDefault("subscriptionId")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "subscriptionId", valid_568684
  var valid_568685 = path.getOrDefault("policySetName")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "policySetName", valid_568685
  var valid_568686 = path.getOrDefault("labName")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "labName", valid_568686
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568687 = query.getOrDefault("$orderby")
  valid_568687 = validateParameter(valid_568687, JString, required = false,
                                 default = nil)
  if valid_568687 != nil:
    section.add "$orderby", valid_568687
  var valid_568688 = query.getOrDefault("$expand")
  valid_568688 = validateParameter(valid_568688, JString, required = false,
                                 default = nil)
  if valid_568688 != nil:
    section.add "$expand", valid_568688
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568689 = query.getOrDefault("api-version")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568689 != nil:
    section.add "api-version", valid_568689
  var valid_568690 = query.getOrDefault("$top")
  valid_568690 = validateParameter(valid_568690, JInt, required = false, default = nil)
  if valid_568690 != nil:
    section.add "$top", valid_568690
  var valid_568691 = query.getOrDefault("$filter")
  valid_568691 = validateParameter(valid_568691, JString, required = false,
                                 default = nil)
  if valid_568691 != nil:
    section.add "$filter", valid_568691
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568692: Call_PoliciesList_568680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List policies in a given policy set.
  ## 
  let valid = call_568692.validator(path, query, header, formData, body)
  let scheme = call_568692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568692.url(scheme.get, call_568692.host, call_568692.base,
                         call_568692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568692, url, valid)

proc call*(call_568693: Call_PoliciesList_568680; resourceGroupName: string;
          subscriptionId: string; policySetName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## policiesList
  ## List policies in a given policy set.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568694 = newJObject()
  var query_568695 = newJObject()
  add(query_568695, "$orderby", newJString(Orderby))
  add(path_568694, "resourceGroupName", newJString(resourceGroupName))
  add(query_568695, "$expand", newJString(Expand))
  add(query_568695, "api-version", newJString(apiVersion))
  add(path_568694, "subscriptionId", newJString(subscriptionId))
  add(query_568695, "$top", newJInt(Top))
  add(path_568694, "policySetName", newJString(policySetName))
  add(path_568694, "labName", newJString(labName))
  add(query_568695, "$filter", newJString(Filter))
  result = call_568693.call(path_568694, query_568695, nil, nil, nil)

var policiesList* = Call_PoliciesList_568680(name: "policiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies",
    validator: validate_PoliciesList_568681, base: "", url: url_PoliciesList_568682,
    schemes: {Scheme.Https})
type
  Call_PoliciesCreateOrUpdate_568710 = ref object of OpenApiRestCall_567666
proc url_PoliciesCreateOrUpdate_568712(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesCreateOrUpdate_568711(path: JsonNode; query: JsonNode;
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
  var valid_568713 = path.getOrDefault("resourceGroupName")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "resourceGroupName", valid_568713
  var valid_568714 = path.getOrDefault("name")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "name", valid_568714
  var valid_568715 = path.getOrDefault("subscriptionId")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "subscriptionId", valid_568715
  var valid_568716 = path.getOrDefault("policySetName")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "policySetName", valid_568716
  var valid_568717 = path.getOrDefault("labName")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "labName", valid_568717
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568718 = query.getOrDefault("api-version")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568718 != nil:
    section.add "api-version", valid_568718
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

proc call*(call_568720: Call_PoliciesCreateOrUpdate_568710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing policy.
  ## 
  let valid = call_568720.validator(path, query, header, formData, body)
  let scheme = call_568720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568720.url(scheme.get, call_568720.host, call_568720.base,
                         call_568720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568720, url, valid)

proc call*(call_568721: Call_PoliciesCreateOrUpdate_568710;
          resourceGroupName: string; name: string; subscriptionId: string;
          policySetName: string; labName: string; policy: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568722 = newJObject()
  var query_568723 = newJObject()
  var body_568724 = newJObject()
  add(path_568722, "resourceGroupName", newJString(resourceGroupName))
  add(query_568723, "api-version", newJString(apiVersion))
  add(path_568722, "name", newJString(name))
  add(path_568722, "subscriptionId", newJString(subscriptionId))
  add(path_568722, "policySetName", newJString(policySetName))
  add(path_568722, "labName", newJString(labName))
  if policy != nil:
    body_568724 = policy
  result = call_568721.call(path_568722, query_568723, nil, nil, body_568724)

var policiesCreateOrUpdate* = Call_PoliciesCreateOrUpdate_568710(
    name: "policiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesCreateOrUpdate_568711, base: "",
    url: url_PoliciesCreateOrUpdate_568712, schemes: {Scheme.Https})
type
  Call_PoliciesGet_568696 = ref object of OpenApiRestCall_567666
proc url_PoliciesGet_568698(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesGet_568697(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568699 = path.getOrDefault("resourceGroupName")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "resourceGroupName", valid_568699
  var valid_568700 = path.getOrDefault("name")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "name", valid_568700
  var valid_568701 = path.getOrDefault("subscriptionId")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "subscriptionId", valid_568701
  var valid_568702 = path.getOrDefault("policySetName")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "policySetName", valid_568702
  var valid_568703 = path.getOrDefault("labName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "labName", valid_568703
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568704 = query.getOrDefault("$expand")
  valid_568704 = validateParameter(valid_568704, JString, required = false,
                                 default = nil)
  if valid_568704 != nil:
    section.add "$expand", valid_568704
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568705 = query.getOrDefault("api-version")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568705 != nil:
    section.add "api-version", valid_568705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568706: Call_PoliciesGet_568696; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get policy.
  ## 
  let valid = call_568706.validator(path, query, header, formData, body)
  let scheme = call_568706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568706.url(scheme.get, call_568706.host, call_568706.base,
                         call_568706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568706, url, valid)

proc call*(call_568707: Call_PoliciesGet_568696; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568708 = newJObject()
  var query_568709 = newJObject()
  add(path_568708, "resourceGroupName", newJString(resourceGroupName))
  add(query_568709, "$expand", newJString(Expand))
  add(path_568708, "name", newJString(name))
  add(query_568709, "api-version", newJString(apiVersion))
  add(path_568708, "subscriptionId", newJString(subscriptionId))
  add(path_568708, "policySetName", newJString(policySetName))
  add(path_568708, "labName", newJString(labName))
  result = call_568707.call(path_568708, query_568709, nil, nil, nil)

var policiesGet* = Call_PoliciesGet_568696(name: "policiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
                                        validator: validate_PoliciesGet_568697,
                                        base: "", url: url_PoliciesGet_568698,
                                        schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_568738 = ref object of OpenApiRestCall_567666
proc url_PoliciesUpdate_568740(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesUpdate_568739(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Allows modifying tags of policies. All other properties will be ignored.
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
  var valid_568741 = path.getOrDefault("resourceGroupName")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "resourceGroupName", valid_568741
  var valid_568742 = path.getOrDefault("name")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "name", valid_568742
  var valid_568743 = path.getOrDefault("subscriptionId")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = nil)
  if valid_568743 != nil:
    section.add "subscriptionId", valid_568743
  var valid_568744 = path.getOrDefault("policySetName")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "policySetName", valid_568744
  var valid_568745 = path.getOrDefault("labName")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = nil)
  if valid_568745 != nil:
    section.add "labName", valid_568745
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568746 = query.getOrDefault("api-version")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568746 != nil:
    section.add "api-version", valid_568746
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

proc call*(call_568748: Call_PoliciesUpdate_568738; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of policies. All other properties will be ignored.
  ## 
  let valid = call_568748.validator(path, query, header, formData, body)
  let scheme = call_568748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568748.url(scheme.get, call_568748.host, call_568748.base,
                         call_568748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568748, url, valid)

proc call*(call_568749: Call_PoliciesUpdate_568738; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; policy: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## policiesUpdate
  ## Allows modifying tags of policies. All other properties will be ignored.
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
  var path_568750 = newJObject()
  var query_568751 = newJObject()
  var body_568752 = newJObject()
  add(path_568750, "resourceGroupName", newJString(resourceGroupName))
  add(query_568751, "api-version", newJString(apiVersion))
  add(path_568750, "name", newJString(name))
  add(path_568750, "subscriptionId", newJString(subscriptionId))
  add(path_568750, "policySetName", newJString(policySetName))
  add(path_568750, "labName", newJString(labName))
  if policy != nil:
    body_568752 = policy
  result = call_568749.call(path_568750, query_568751, nil, nil, body_568752)

var policiesUpdate* = Call_PoliciesUpdate_568738(name: "policiesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesUpdate_568739, base: "", url: url_PoliciesUpdate_568740,
    schemes: {Scheme.Https})
type
  Call_PoliciesDelete_568725 = ref object of OpenApiRestCall_567666
proc url_PoliciesDelete_568727(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesDelete_568726(path: JsonNode; query: JsonNode;
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
  var valid_568728 = path.getOrDefault("resourceGroupName")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "resourceGroupName", valid_568728
  var valid_568729 = path.getOrDefault("name")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "name", valid_568729
  var valid_568730 = path.getOrDefault("subscriptionId")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "subscriptionId", valid_568730
  var valid_568731 = path.getOrDefault("policySetName")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "policySetName", valid_568731
  var valid_568732 = path.getOrDefault("labName")
  valid_568732 = validateParameter(valid_568732, JString, required = true,
                                 default = nil)
  if valid_568732 != nil:
    section.add "labName", valid_568732
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568733 = query.getOrDefault("api-version")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568733 != nil:
    section.add "api-version", valid_568733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568734: Call_PoliciesDelete_568725; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy.
  ## 
  let valid = call_568734.validator(path, query, header, formData, body)
  let scheme = call_568734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568734.url(scheme.get, call_568734.host, call_568734.base,
                         call_568734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568734, url, valid)

proc call*(call_568735: Call_PoliciesDelete_568725; resourceGroupName: string;
          name: string; subscriptionId: string; policySetName: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568736 = newJObject()
  var query_568737 = newJObject()
  add(path_568736, "resourceGroupName", newJString(resourceGroupName))
  add(query_568737, "api-version", newJString(apiVersion))
  add(path_568736, "name", newJString(name))
  add(path_568736, "subscriptionId", newJString(subscriptionId))
  add(path_568736, "policySetName", newJString(policySetName))
  add(path_568736, "labName", newJString(labName))
  result = call_568735.call(path_568736, query_568737, nil, nil, nil)

var policiesDelete* = Call_PoliciesDelete_568725(name: "policiesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesDelete_568726, base: "", url: url_PoliciesDelete_568727,
    schemes: {Scheme.Https})
type
  Call_SchedulesList_568753 = ref object of OpenApiRestCall_567666
proc url_SchedulesList_568755(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesList_568754(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568756 = path.getOrDefault("resourceGroupName")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "resourceGroupName", valid_568756
  var valid_568757 = path.getOrDefault("subscriptionId")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "subscriptionId", valid_568757
  var valid_568758 = path.getOrDefault("labName")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = nil)
  if valid_568758 != nil:
    section.add "labName", valid_568758
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568759 = query.getOrDefault("$orderby")
  valid_568759 = validateParameter(valid_568759, JString, required = false,
                                 default = nil)
  if valid_568759 != nil:
    section.add "$orderby", valid_568759
  var valid_568760 = query.getOrDefault("$expand")
  valid_568760 = validateParameter(valid_568760, JString, required = false,
                                 default = nil)
  if valid_568760 != nil:
    section.add "$expand", valid_568760
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568761 = query.getOrDefault("api-version")
  valid_568761 = validateParameter(valid_568761, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568761 != nil:
    section.add "api-version", valid_568761
  var valid_568762 = query.getOrDefault("$top")
  valid_568762 = validateParameter(valid_568762, JInt, required = false, default = nil)
  if valid_568762 != nil:
    section.add "$top", valid_568762
  var valid_568763 = query.getOrDefault("$filter")
  valid_568763 = validateParameter(valid_568763, JString, required = false,
                                 default = nil)
  if valid_568763 != nil:
    section.add "$filter", valid_568763
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568764: Call_SchedulesList_568753; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given lab.
  ## 
  let valid = call_568764.validator(path, query, header, formData, body)
  let scheme = call_568764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568764.url(scheme.get, call_568764.host, call_568764.base,
                         call_568764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568764, url, valid)

proc call*(call_568765: Call_SchedulesList_568753; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## schedulesList
  ## List schedules in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568766 = newJObject()
  var query_568767 = newJObject()
  add(query_568767, "$orderby", newJString(Orderby))
  add(path_568766, "resourceGroupName", newJString(resourceGroupName))
  add(query_568767, "$expand", newJString(Expand))
  add(query_568767, "api-version", newJString(apiVersion))
  add(path_568766, "subscriptionId", newJString(subscriptionId))
  add(query_568767, "$top", newJInt(Top))
  add(path_568766, "labName", newJString(labName))
  add(query_568767, "$filter", newJString(Filter))
  result = call_568765.call(path_568766, query_568767, nil, nil, nil)

var schedulesList* = Call_SchedulesList_568753(name: "schedulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules",
    validator: validate_SchedulesList_568754, base: "", url: url_SchedulesList_568755,
    schemes: {Scheme.Https})
type
  Call_SchedulesCreateOrUpdate_568781 = ref object of OpenApiRestCall_567666
proc url_SchedulesCreateOrUpdate_568783(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesCreateOrUpdate_568782(path: JsonNode; query: JsonNode;
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
  var valid_568784 = path.getOrDefault("resourceGroupName")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "resourceGroupName", valid_568784
  var valid_568785 = path.getOrDefault("name")
  valid_568785 = validateParameter(valid_568785, JString, required = true,
                                 default = nil)
  if valid_568785 != nil:
    section.add "name", valid_568785
  var valid_568786 = path.getOrDefault("subscriptionId")
  valid_568786 = validateParameter(valid_568786, JString, required = true,
                                 default = nil)
  if valid_568786 != nil:
    section.add "subscriptionId", valid_568786
  var valid_568787 = path.getOrDefault("labName")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "labName", valid_568787
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568788 = query.getOrDefault("api-version")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568788 != nil:
    section.add "api-version", valid_568788
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

proc call*(call_568790: Call_SchedulesCreateOrUpdate_568781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_568790.validator(path, query, header, formData, body)
  let scheme = call_568790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568790.url(scheme.get, call_568790.host, call_568790.base,
                         call_568790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568790, url, valid)

proc call*(call_568791: Call_SchedulesCreateOrUpdate_568781;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; schedule: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568792 = newJObject()
  var query_568793 = newJObject()
  var body_568794 = newJObject()
  add(path_568792, "resourceGroupName", newJString(resourceGroupName))
  add(query_568793, "api-version", newJString(apiVersion))
  add(path_568792, "name", newJString(name))
  add(path_568792, "subscriptionId", newJString(subscriptionId))
  add(path_568792, "labName", newJString(labName))
  if schedule != nil:
    body_568794 = schedule
  result = call_568791.call(path_568792, query_568793, nil, nil, body_568794)

var schedulesCreateOrUpdate* = Call_SchedulesCreateOrUpdate_568781(
    name: "schedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesCreateOrUpdate_568782, base: "",
    url: url_SchedulesCreateOrUpdate_568783, schemes: {Scheme.Https})
type
  Call_SchedulesGet_568768 = ref object of OpenApiRestCall_567666
proc url_SchedulesGet_568770(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesGet_568769(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568771 = path.getOrDefault("resourceGroupName")
  valid_568771 = validateParameter(valid_568771, JString, required = true,
                                 default = nil)
  if valid_568771 != nil:
    section.add "resourceGroupName", valid_568771
  var valid_568772 = path.getOrDefault("name")
  valid_568772 = validateParameter(valid_568772, JString, required = true,
                                 default = nil)
  if valid_568772 != nil:
    section.add "name", valid_568772
  var valid_568773 = path.getOrDefault("subscriptionId")
  valid_568773 = validateParameter(valid_568773, JString, required = true,
                                 default = nil)
  if valid_568773 != nil:
    section.add "subscriptionId", valid_568773
  var valid_568774 = path.getOrDefault("labName")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "labName", valid_568774
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568775 = query.getOrDefault("$expand")
  valid_568775 = validateParameter(valid_568775, JString, required = false,
                                 default = nil)
  if valid_568775 != nil:
    section.add "$expand", valid_568775
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568776 = query.getOrDefault("api-version")
  valid_568776 = validateParameter(valid_568776, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568776 != nil:
    section.add "api-version", valid_568776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568777: Call_SchedulesGet_568768; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_568777.validator(path, query, header, formData, body)
  let scheme = call_568777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568777.url(scheme.get, call_568777.host, call_568777.base,
                         call_568777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568777, url, valid)

proc call*(call_568778: Call_SchedulesGet_568768; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568779 = newJObject()
  var query_568780 = newJObject()
  add(path_568779, "resourceGroupName", newJString(resourceGroupName))
  add(query_568780, "$expand", newJString(Expand))
  add(path_568779, "name", newJString(name))
  add(query_568780, "api-version", newJString(apiVersion))
  add(path_568779, "subscriptionId", newJString(subscriptionId))
  add(path_568779, "labName", newJString(labName))
  result = call_568778.call(path_568779, query_568780, nil, nil, nil)

var schedulesGet* = Call_SchedulesGet_568768(name: "schedulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesGet_568769, base: "", url: url_SchedulesGet_568770,
    schemes: {Scheme.Https})
type
  Call_SchedulesUpdate_568807 = ref object of OpenApiRestCall_567666
proc url_SchedulesUpdate_568809(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesUpdate_568808(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var valid_568810 = path.getOrDefault("resourceGroupName")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "resourceGroupName", valid_568810
  var valid_568811 = path.getOrDefault("name")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "name", valid_568811
  var valid_568812 = path.getOrDefault("subscriptionId")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "subscriptionId", valid_568812
  var valid_568813 = path.getOrDefault("labName")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "labName", valid_568813
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568814 = query.getOrDefault("api-version")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568814 != nil:
    section.add "api-version", valid_568814
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

proc call*(call_568816: Call_SchedulesUpdate_568807; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_568816.validator(path, query, header, formData, body)
  let scheme = call_568816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568816.url(scheme.get, call_568816.host, call_568816.base,
                         call_568816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568816, url, valid)

proc call*(call_568817: Call_SchedulesUpdate_568807; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## schedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var path_568818 = newJObject()
  var query_568819 = newJObject()
  var body_568820 = newJObject()
  add(path_568818, "resourceGroupName", newJString(resourceGroupName))
  add(query_568819, "api-version", newJString(apiVersion))
  add(path_568818, "name", newJString(name))
  add(path_568818, "subscriptionId", newJString(subscriptionId))
  add(path_568818, "labName", newJString(labName))
  if schedule != nil:
    body_568820 = schedule
  result = call_568817.call(path_568818, query_568819, nil, nil, body_568820)

var schedulesUpdate* = Call_SchedulesUpdate_568807(name: "schedulesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesUpdate_568808, base: "", url: url_SchedulesUpdate_568809,
    schemes: {Scheme.Https})
type
  Call_SchedulesDelete_568795 = ref object of OpenApiRestCall_567666
proc url_SchedulesDelete_568797(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesDelete_568796(path: JsonNode; query: JsonNode;
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
  var valid_568798 = path.getOrDefault("resourceGroupName")
  valid_568798 = validateParameter(valid_568798, JString, required = true,
                                 default = nil)
  if valid_568798 != nil:
    section.add "resourceGroupName", valid_568798
  var valid_568799 = path.getOrDefault("name")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "name", valid_568799
  var valid_568800 = path.getOrDefault("subscriptionId")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "subscriptionId", valid_568800
  var valid_568801 = path.getOrDefault("labName")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "labName", valid_568801
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568802 = query.getOrDefault("api-version")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568802 != nil:
    section.add "api-version", valid_568802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568803: Call_SchedulesDelete_568795; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_568803.validator(path, query, header, formData, body)
  let scheme = call_568803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568803.url(scheme.get, call_568803.host, call_568803.base,
                         call_568803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568803, url, valid)

proc call*(call_568804: Call_SchedulesDelete_568795; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568805 = newJObject()
  var query_568806 = newJObject()
  add(path_568805, "resourceGroupName", newJString(resourceGroupName))
  add(query_568806, "api-version", newJString(apiVersion))
  add(path_568805, "name", newJString(name))
  add(path_568805, "subscriptionId", newJString(subscriptionId))
  add(path_568805, "labName", newJString(labName))
  result = call_568804.call(path_568805, query_568806, nil, nil, nil)

var schedulesDelete* = Call_SchedulesDelete_568795(name: "schedulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesDelete_568796, base: "", url: url_SchedulesDelete_568797,
    schemes: {Scheme.Https})
type
  Call_SchedulesExecute_568821 = ref object of OpenApiRestCall_567666
proc url_SchedulesExecute_568823(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesExecute_568822(path: JsonNode; query: JsonNode;
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
  var valid_568824 = path.getOrDefault("resourceGroupName")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "resourceGroupName", valid_568824
  var valid_568825 = path.getOrDefault("name")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "name", valid_568825
  var valid_568826 = path.getOrDefault("subscriptionId")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "subscriptionId", valid_568826
  var valid_568827 = path.getOrDefault("labName")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = nil)
  if valid_568827 != nil:
    section.add "labName", valid_568827
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568828 = query.getOrDefault("api-version")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568828 != nil:
    section.add "api-version", valid_568828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568829: Call_SchedulesExecute_568821; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_568829.validator(path, query, header, formData, body)
  let scheme = call_568829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568829.url(scheme.get, call_568829.host, call_568829.base,
                         call_568829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568829, url, valid)

proc call*(call_568830: Call_SchedulesExecute_568821; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568831 = newJObject()
  var query_568832 = newJObject()
  add(path_568831, "resourceGroupName", newJString(resourceGroupName))
  add(query_568832, "api-version", newJString(apiVersion))
  add(path_568831, "name", newJString(name))
  add(path_568831, "subscriptionId", newJString(subscriptionId))
  add(path_568831, "labName", newJString(labName))
  result = call_568830.call(path_568831, query_568832, nil, nil, nil)

var schedulesExecute* = Call_SchedulesExecute_568821(name: "schedulesExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/execute",
    validator: validate_SchedulesExecute_568822, base: "",
    url: url_SchedulesExecute_568823, schemes: {Scheme.Https})
type
  Call_SchedulesListApplicable_568833 = ref object of OpenApiRestCall_567666
proc url_SchedulesListApplicable_568835(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesListApplicable_568834(path: JsonNode; query: JsonNode;
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
  var valid_568836 = path.getOrDefault("resourceGroupName")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "resourceGroupName", valid_568836
  var valid_568837 = path.getOrDefault("name")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "name", valid_568837
  var valid_568838 = path.getOrDefault("subscriptionId")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "subscriptionId", valid_568838
  var valid_568839 = path.getOrDefault("labName")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "labName", valid_568839
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568840 = query.getOrDefault("api-version")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568840 != nil:
    section.add "api-version", valid_568840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568841: Call_SchedulesListApplicable_568833; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all applicable schedules
  ## 
  let valid = call_568841.validator(path, query, header, formData, body)
  let scheme = call_568841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568841.url(scheme.get, call_568841.host, call_568841.base,
                         call_568841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568841, url, valid)

proc call*(call_568842: Call_SchedulesListApplicable_568833;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568843 = newJObject()
  var query_568844 = newJObject()
  add(path_568843, "resourceGroupName", newJString(resourceGroupName))
  add(query_568844, "api-version", newJString(apiVersion))
  add(path_568843, "name", newJString(name))
  add(path_568843, "subscriptionId", newJString(subscriptionId))
  add(path_568843, "labName", newJString(labName))
  result = call_568842.call(path_568843, query_568844, nil, nil, nil)

var schedulesListApplicable* = Call_SchedulesListApplicable_568833(
    name: "schedulesListApplicable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/listApplicable",
    validator: validate_SchedulesListApplicable_568834, base: "",
    url: url_SchedulesListApplicable_568835, schemes: {Scheme.Https})
type
  Call_ServiceRunnersCreateOrUpdate_568857 = ref object of OpenApiRestCall_567666
proc url_ServiceRunnersCreateOrUpdate_568859(protocol: Scheme; host: string;
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

proc validate_ServiceRunnersCreateOrUpdate_568858(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing service runner.
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
  var valid_568860 = path.getOrDefault("resourceGroupName")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "resourceGroupName", valid_568860
  var valid_568861 = path.getOrDefault("name")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "name", valid_568861
  var valid_568862 = path.getOrDefault("subscriptionId")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "subscriptionId", valid_568862
  var valid_568863 = path.getOrDefault("labName")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "labName", valid_568863
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568864 = query.getOrDefault("api-version")
  valid_568864 = validateParameter(valid_568864, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568864 != nil:
    section.add "api-version", valid_568864
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

proc call*(call_568866: Call_ServiceRunnersCreateOrUpdate_568857; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing service runner.
  ## 
  let valid = call_568866.validator(path, query, header, formData, body)
  let scheme = call_568866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568866.url(scheme.get, call_568866.host, call_568866.base,
                         call_568866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568866, url, valid)

proc call*(call_568867: Call_ServiceRunnersCreateOrUpdate_568857;
          resourceGroupName: string; name: string; subscriptionId: string;
          serviceRunner: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceRunnersCreateOrUpdate
  ## Create or replace an existing service runner.
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
  var path_568868 = newJObject()
  var query_568869 = newJObject()
  var body_568870 = newJObject()
  add(path_568868, "resourceGroupName", newJString(resourceGroupName))
  add(query_568869, "api-version", newJString(apiVersion))
  add(path_568868, "name", newJString(name))
  add(path_568868, "subscriptionId", newJString(subscriptionId))
  if serviceRunner != nil:
    body_568870 = serviceRunner
  add(path_568868, "labName", newJString(labName))
  result = call_568867.call(path_568868, query_568869, nil, nil, body_568870)

var serviceRunnersCreateOrUpdate* = Call_ServiceRunnersCreateOrUpdate_568857(
    name: "serviceRunnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersCreateOrUpdate_568858, base: "",
    url: url_ServiceRunnersCreateOrUpdate_568859, schemes: {Scheme.Https})
type
  Call_ServiceRunnersGet_568845 = ref object of OpenApiRestCall_567666
proc url_ServiceRunnersGet_568847(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceRunnersGet_568846(path: JsonNode; query: JsonNode;
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
  var valid_568848 = path.getOrDefault("resourceGroupName")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "resourceGroupName", valid_568848
  var valid_568849 = path.getOrDefault("name")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "name", valid_568849
  var valid_568850 = path.getOrDefault("subscriptionId")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "subscriptionId", valid_568850
  var valid_568851 = path.getOrDefault("labName")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "labName", valid_568851
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568852 = query.getOrDefault("api-version")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568852 != nil:
    section.add "api-version", valid_568852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568853: Call_ServiceRunnersGet_568845; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service runner.
  ## 
  let valid = call_568853.validator(path, query, header, formData, body)
  let scheme = call_568853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568853.url(scheme.get, call_568853.host, call_568853.base,
                         call_568853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568853, url, valid)

proc call*(call_568854: Call_ServiceRunnersGet_568845; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568855 = newJObject()
  var query_568856 = newJObject()
  add(path_568855, "resourceGroupName", newJString(resourceGroupName))
  add(query_568856, "api-version", newJString(apiVersion))
  add(path_568855, "name", newJString(name))
  add(path_568855, "subscriptionId", newJString(subscriptionId))
  add(path_568855, "labName", newJString(labName))
  result = call_568854.call(path_568855, query_568856, nil, nil, nil)

var serviceRunnersGet* = Call_ServiceRunnersGet_568845(name: "serviceRunnersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersGet_568846, base: "",
    url: url_ServiceRunnersGet_568847, schemes: {Scheme.Https})
type
  Call_ServiceRunnersDelete_568871 = ref object of OpenApiRestCall_567666
proc url_ServiceRunnersDelete_568873(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceRunnersDelete_568872(path: JsonNode; query: JsonNode;
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
  var valid_568874 = path.getOrDefault("resourceGroupName")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "resourceGroupName", valid_568874
  var valid_568875 = path.getOrDefault("name")
  valid_568875 = validateParameter(valid_568875, JString, required = true,
                                 default = nil)
  if valid_568875 != nil:
    section.add "name", valid_568875
  var valid_568876 = path.getOrDefault("subscriptionId")
  valid_568876 = validateParameter(valid_568876, JString, required = true,
                                 default = nil)
  if valid_568876 != nil:
    section.add "subscriptionId", valid_568876
  var valid_568877 = path.getOrDefault("labName")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "labName", valid_568877
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568878 = query.getOrDefault("api-version")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568878 != nil:
    section.add "api-version", valid_568878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568879: Call_ServiceRunnersDelete_568871; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete service runner.
  ## 
  let valid = call_568879.validator(path, query, header, formData, body)
  let scheme = call_568879.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568879.url(scheme.get, call_568879.host, call_568879.base,
                         call_568879.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568879, url, valid)

proc call*(call_568880: Call_ServiceRunnersDelete_568871;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568881 = newJObject()
  var query_568882 = newJObject()
  add(path_568881, "resourceGroupName", newJString(resourceGroupName))
  add(query_568882, "api-version", newJString(apiVersion))
  add(path_568881, "name", newJString(name))
  add(path_568881, "subscriptionId", newJString(subscriptionId))
  add(path_568881, "labName", newJString(labName))
  result = call_568880.call(path_568881, query_568882, nil, nil, nil)

var serviceRunnersDelete* = Call_ServiceRunnersDelete_568871(
    name: "serviceRunnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersDelete_568872, base: "",
    url: url_ServiceRunnersDelete_568873, schemes: {Scheme.Https})
type
  Call_UsersList_568883 = ref object of OpenApiRestCall_567666
proc url_UsersList_568885(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersList_568884(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568886 = path.getOrDefault("resourceGroupName")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "resourceGroupName", valid_568886
  var valid_568887 = path.getOrDefault("subscriptionId")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "subscriptionId", valid_568887
  var valid_568888 = path.getOrDefault("labName")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "labName", valid_568888
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568889 = query.getOrDefault("$orderby")
  valid_568889 = validateParameter(valid_568889, JString, required = false,
                                 default = nil)
  if valid_568889 != nil:
    section.add "$orderby", valid_568889
  var valid_568890 = query.getOrDefault("$expand")
  valid_568890 = validateParameter(valid_568890, JString, required = false,
                                 default = nil)
  if valid_568890 != nil:
    section.add "$expand", valid_568890
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568891 = query.getOrDefault("api-version")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568891 != nil:
    section.add "api-version", valid_568891
  var valid_568892 = query.getOrDefault("$top")
  valid_568892 = validateParameter(valid_568892, JInt, required = false, default = nil)
  if valid_568892 != nil:
    section.add "$top", valid_568892
  var valid_568893 = query.getOrDefault("$filter")
  valid_568893 = validateParameter(valid_568893, JString, required = false,
                                 default = nil)
  if valid_568893 != nil:
    section.add "$filter", valid_568893
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568894: Call_UsersList_568883; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List user profiles in a given lab.
  ## 
  let valid = call_568894.validator(path, query, header, formData, body)
  let scheme = call_568894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568894.url(scheme.get, call_568894.host, call_568894.base,
                         call_568894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568894, url, valid)

proc call*(call_568895: Call_UsersList_568883; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## usersList
  ## List user profiles in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=identity)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568896 = newJObject()
  var query_568897 = newJObject()
  add(query_568897, "$orderby", newJString(Orderby))
  add(path_568896, "resourceGroupName", newJString(resourceGroupName))
  add(query_568897, "$expand", newJString(Expand))
  add(query_568897, "api-version", newJString(apiVersion))
  add(path_568896, "subscriptionId", newJString(subscriptionId))
  add(query_568897, "$top", newJInt(Top))
  add(path_568896, "labName", newJString(labName))
  add(query_568897, "$filter", newJString(Filter))
  result = call_568895.call(path_568896, query_568897, nil, nil, nil)

var usersList* = Call_UsersList_568883(name: "usersList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users",
                                    validator: validate_UsersList_568884,
                                    base: "", url: url_UsersList_568885,
                                    schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_568911 = ref object of OpenApiRestCall_567666
proc url_UsersCreateOrUpdate_568913(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_568912(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing user profile. This operation can take a while to complete.
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
  var valid_568914 = path.getOrDefault("resourceGroupName")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "resourceGroupName", valid_568914
  var valid_568915 = path.getOrDefault("name")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "name", valid_568915
  var valid_568916 = path.getOrDefault("subscriptionId")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "subscriptionId", valid_568916
  var valid_568917 = path.getOrDefault("labName")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "labName", valid_568917
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568918 = query.getOrDefault("api-version")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568918 != nil:
    section.add "api-version", valid_568918
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

proc call*(call_568920: Call_UsersCreateOrUpdate_568911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing user profile. This operation can take a while to complete.
  ## 
  let valid = call_568920.validator(path, query, header, formData, body)
  let scheme = call_568920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568920.url(scheme.get, call_568920.host, call_568920.base,
                         call_568920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568920, url, valid)

proc call*(call_568921: Call_UsersCreateOrUpdate_568911; resourceGroupName: string;
          name: string; user: JsonNode; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## usersCreateOrUpdate
  ## Create or replace an existing user profile. This operation can take a while to complete.
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
  var path_568922 = newJObject()
  var query_568923 = newJObject()
  var body_568924 = newJObject()
  add(path_568922, "resourceGroupName", newJString(resourceGroupName))
  add(query_568923, "api-version", newJString(apiVersion))
  add(path_568922, "name", newJString(name))
  if user != nil:
    body_568924 = user
  add(path_568922, "subscriptionId", newJString(subscriptionId))
  add(path_568922, "labName", newJString(labName))
  result = call_568921.call(path_568922, query_568923, nil, nil, body_568924)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_568911(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_568912, base: "",
    url: url_UsersCreateOrUpdate_568913, schemes: {Scheme.Https})
type
  Call_UsersGet_568898 = ref object of OpenApiRestCall_567666
proc url_UsersGet_568900(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_568899(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568901 = path.getOrDefault("resourceGroupName")
  valid_568901 = validateParameter(valid_568901, JString, required = true,
                                 default = nil)
  if valid_568901 != nil:
    section.add "resourceGroupName", valid_568901
  var valid_568902 = path.getOrDefault("name")
  valid_568902 = validateParameter(valid_568902, JString, required = true,
                                 default = nil)
  if valid_568902 != nil:
    section.add "name", valid_568902
  var valid_568903 = path.getOrDefault("subscriptionId")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "subscriptionId", valid_568903
  var valid_568904 = path.getOrDefault("labName")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "labName", valid_568904
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568905 = query.getOrDefault("$expand")
  valid_568905 = validateParameter(valid_568905, JString, required = false,
                                 default = nil)
  if valid_568905 != nil:
    section.add "$expand", valid_568905
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568906 = query.getOrDefault("api-version")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568906 != nil:
    section.add "api-version", valid_568906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568907: Call_UsersGet_568898; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user profile.
  ## 
  let valid = call_568907.validator(path, query, header, formData, body)
  let scheme = call_568907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568907.url(scheme.get, call_568907.host, call_568907.base,
                         call_568907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568907, url, valid)

proc call*(call_568908: Call_UsersGet_568898; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568909 = newJObject()
  var query_568910 = newJObject()
  add(path_568909, "resourceGroupName", newJString(resourceGroupName))
  add(query_568910, "$expand", newJString(Expand))
  add(path_568909, "name", newJString(name))
  add(query_568910, "api-version", newJString(apiVersion))
  add(path_568909, "subscriptionId", newJString(subscriptionId))
  add(path_568909, "labName", newJString(labName))
  result = call_568908.call(path_568909, query_568910, nil, nil, nil)

var usersGet* = Call_UsersGet_568898(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                  validator: validate_UsersGet_568899, base: "",
                                  url: url_UsersGet_568900,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_568937 = ref object of OpenApiRestCall_567666
proc url_UsersUpdate_568939(protocol: Scheme; host: string; base: string;
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

proc validate_UsersUpdate_568938(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of user profiles. All other properties will be ignored.
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
  var valid_568943 = path.getOrDefault("labName")
  valid_568943 = validateParameter(valid_568943, JString, required = true,
                                 default = nil)
  if valid_568943 != nil:
    section.add "labName", valid_568943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568944 = query.getOrDefault("api-version")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568944 != nil:
    section.add "api-version", valid_568944
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

proc call*(call_568946: Call_UsersUpdate_568937; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of user profiles. All other properties will be ignored.
  ## 
  let valid = call_568946.validator(path, query, header, formData, body)
  let scheme = call_568946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568946.url(scheme.get, call_568946.host, call_568946.base,
                         call_568946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568946, url, valid)

proc call*(call_568947: Call_UsersUpdate_568937; resourceGroupName: string;
          name: string; user: JsonNode; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## usersUpdate
  ## Allows modifying tags of user profiles. All other properties will be ignored.
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
  var path_568948 = newJObject()
  var query_568949 = newJObject()
  var body_568950 = newJObject()
  add(path_568948, "resourceGroupName", newJString(resourceGroupName))
  add(query_568949, "api-version", newJString(apiVersion))
  add(path_568948, "name", newJString(name))
  if user != nil:
    body_568950 = user
  add(path_568948, "subscriptionId", newJString(subscriptionId))
  add(path_568948, "labName", newJString(labName))
  result = call_568947.call(path_568948, query_568949, nil, nil, body_568950)

var usersUpdate* = Call_UsersUpdate_568937(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersUpdate_568938,
                                        base: "", url: url_UsersUpdate_568939,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_568925 = ref object of OpenApiRestCall_567666
proc url_UsersDelete_568927(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_568926(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568928 = path.getOrDefault("resourceGroupName")
  valid_568928 = validateParameter(valid_568928, JString, required = true,
                                 default = nil)
  if valid_568928 != nil:
    section.add "resourceGroupName", valid_568928
  var valid_568929 = path.getOrDefault("name")
  valid_568929 = validateParameter(valid_568929, JString, required = true,
                                 default = nil)
  if valid_568929 != nil:
    section.add "name", valid_568929
  var valid_568930 = path.getOrDefault("subscriptionId")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "subscriptionId", valid_568930
  var valid_568931 = path.getOrDefault("labName")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "labName", valid_568931
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568932 = query.getOrDefault("api-version")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568932 != nil:
    section.add "api-version", valid_568932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568933: Call_UsersDelete_568925; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user profile. This operation can take a while to complete.
  ## 
  let valid = call_568933.validator(path, query, header, formData, body)
  let scheme = call_568933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568933.url(scheme.get, call_568933.host, call_568933.base,
                         call_568933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568933, url, valid)

proc call*(call_568934: Call_UsersDelete_568925; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568935 = newJObject()
  var query_568936 = newJObject()
  add(path_568935, "resourceGroupName", newJString(resourceGroupName))
  add(query_568936, "api-version", newJString(apiVersion))
  add(path_568935, "name", newJString(name))
  add(path_568935, "subscriptionId", newJString(subscriptionId))
  add(path_568935, "labName", newJString(labName))
  result = call_568934.call(path_568935, query_568936, nil, nil, nil)

var usersDelete* = Call_UsersDelete_568925(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersDelete_568926,
                                        base: "", url: url_UsersDelete_568927,
                                        schemes: {Scheme.Https})
type
  Call_DisksList_568951 = ref object of OpenApiRestCall_567666
proc url_DisksList_568953(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksList_568952(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568954 = path.getOrDefault("resourceGroupName")
  valid_568954 = validateParameter(valid_568954, JString, required = true,
                                 default = nil)
  if valid_568954 != nil:
    section.add "resourceGroupName", valid_568954
  var valid_568955 = path.getOrDefault("subscriptionId")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "subscriptionId", valid_568955
  var valid_568956 = path.getOrDefault("userName")
  valid_568956 = validateParameter(valid_568956, JString, required = true,
                                 default = nil)
  if valid_568956 != nil:
    section.add "userName", valid_568956
  var valid_568957 = path.getOrDefault("labName")
  valid_568957 = validateParameter(valid_568957, JString, required = true,
                                 default = nil)
  if valid_568957 != nil:
    section.add "labName", valid_568957
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_568958 = query.getOrDefault("$orderby")
  valid_568958 = validateParameter(valid_568958, JString, required = false,
                                 default = nil)
  if valid_568958 != nil:
    section.add "$orderby", valid_568958
  var valid_568959 = query.getOrDefault("$expand")
  valid_568959 = validateParameter(valid_568959, JString, required = false,
                                 default = nil)
  if valid_568959 != nil:
    section.add "$expand", valid_568959
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568960 = query.getOrDefault("api-version")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568960 != nil:
    section.add "api-version", valid_568960
  var valid_568961 = query.getOrDefault("$top")
  valid_568961 = validateParameter(valid_568961, JInt, required = false, default = nil)
  if valid_568961 != nil:
    section.add "$top", valid_568961
  var valid_568962 = query.getOrDefault("$filter")
  valid_568962 = validateParameter(valid_568962, JString, required = false,
                                 default = nil)
  if valid_568962 != nil:
    section.add "$filter", valid_568962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568963: Call_DisksList_568951; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disks in a given user profile.
  ## 
  let valid = call_568963.validator(path, query, header, formData, body)
  let scheme = call_568963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568963.url(scheme.get, call_568963.host, call_568963.base,
                         call_568963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568963, url, valid)

proc call*(call_568964: Call_DisksList_568951; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## disksList
  ## List disks in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_568965 = newJObject()
  var query_568966 = newJObject()
  add(query_568966, "$orderby", newJString(Orderby))
  add(path_568965, "resourceGroupName", newJString(resourceGroupName))
  add(query_568966, "$expand", newJString(Expand))
  add(query_568966, "api-version", newJString(apiVersion))
  add(path_568965, "subscriptionId", newJString(subscriptionId))
  add(query_568966, "$top", newJInt(Top))
  add(path_568965, "userName", newJString(userName))
  add(path_568965, "labName", newJString(labName))
  add(query_568966, "$filter", newJString(Filter))
  result = call_568964.call(path_568965, query_568966, nil, nil, nil)

var disksList* = Call_DisksList_568951(name: "disksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks",
                                    validator: validate_DisksList_568952,
                                    base: "", url: url_DisksList_568953,
                                    schemes: {Scheme.Https})
type
  Call_DisksCreateOrUpdate_568981 = ref object of OpenApiRestCall_567666
proc url_DisksCreateOrUpdate_568983(protocol: Scheme; host: string; base: string;
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

proc validate_DisksCreateOrUpdate_568982(path: JsonNode; query: JsonNode;
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
  var valid_568984 = path.getOrDefault("resourceGroupName")
  valid_568984 = validateParameter(valid_568984, JString, required = true,
                                 default = nil)
  if valid_568984 != nil:
    section.add "resourceGroupName", valid_568984
  var valid_568985 = path.getOrDefault("name")
  valid_568985 = validateParameter(valid_568985, JString, required = true,
                                 default = nil)
  if valid_568985 != nil:
    section.add "name", valid_568985
  var valid_568986 = path.getOrDefault("subscriptionId")
  valid_568986 = validateParameter(valid_568986, JString, required = true,
                                 default = nil)
  if valid_568986 != nil:
    section.add "subscriptionId", valid_568986
  var valid_568987 = path.getOrDefault("userName")
  valid_568987 = validateParameter(valid_568987, JString, required = true,
                                 default = nil)
  if valid_568987 != nil:
    section.add "userName", valid_568987
  var valid_568988 = path.getOrDefault("labName")
  valid_568988 = validateParameter(valid_568988, JString, required = true,
                                 default = nil)
  if valid_568988 != nil:
    section.add "labName", valid_568988
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568989 = query.getOrDefault("api-version")
  valid_568989 = validateParameter(valid_568989, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568989 != nil:
    section.add "api-version", valid_568989
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

proc call*(call_568991: Call_DisksCreateOrUpdate_568981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing disk. This operation can take a while to complete.
  ## 
  let valid = call_568991.validator(path, query, header, formData, body)
  let scheme = call_568991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568991.url(scheme.get, call_568991.host, call_568991.base,
                         call_568991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568991, url, valid)

proc call*(call_568992: Call_DisksCreateOrUpdate_568981; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; disk: JsonNode;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568993 = newJObject()
  var query_568994 = newJObject()
  var body_568995 = newJObject()
  add(path_568993, "resourceGroupName", newJString(resourceGroupName))
  add(query_568994, "api-version", newJString(apiVersion))
  add(path_568993, "name", newJString(name))
  add(path_568993, "subscriptionId", newJString(subscriptionId))
  add(path_568993, "userName", newJString(userName))
  if disk != nil:
    body_568995 = disk
  add(path_568993, "labName", newJString(labName))
  result = call_568992.call(path_568993, query_568994, nil, nil, body_568995)

var disksCreateOrUpdate* = Call_DisksCreateOrUpdate_568981(
    name: "disksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
    validator: validate_DisksCreateOrUpdate_568982, base: "",
    url: url_DisksCreateOrUpdate_568983, schemes: {Scheme.Https})
type
  Call_DisksGet_568967 = ref object of OpenApiRestCall_567666
proc url_DisksGet_568969(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksGet_568968(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568970 = path.getOrDefault("resourceGroupName")
  valid_568970 = validateParameter(valid_568970, JString, required = true,
                                 default = nil)
  if valid_568970 != nil:
    section.add "resourceGroupName", valid_568970
  var valid_568971 = path.getOrDefault("name")
  valid_568971 = validateParameter(valid_568971, JString, required = true,
                                 default = nil)
  if valid_568971 != nil:
    section.add "name", valid_568971
  var valid_568972 = path.getOrDefault("subscriptionId")
  valid_568972 = validateParameter(valid_568972, JString, required = true,
                                 default = nil)
  if valid_568972 != nil:
    section.add "subscriptionId", valid_568972
  var valid_568973 = path.getOrDefault("userName")
  valid_568973 = validateParameter(valid_568973, JString, required = true,
                                 default = nil)
  if valid_568973 != nil:
    section.add "userName", valid_568973
  var valid_568974 = path.getOrDefault("labName")
  valid_568974 = validateParameter(valid_568974, JString, required = true,
                                 default = nil)
  if valid_568974 != nil:
    section.add "labName", valid_568974
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_568975 = query.getOrDefault("$expand")
  valid_568975 = validateParameter(valid_568975, JString, required = false,
                                 default = nil)
  if valid_568975 != nil:
    section.add "$expand", valid_568975
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568976 = query.getOrDefault("api-version")
  valid_568976 = validateParameter(valid_568976, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_568976 != nil:
    section.add "api-version", valid_568976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568977: Call_DisksGet_568967; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get disk.
  ## 
  let valid = call_568977.validator(path, query, header, formData, body)
  let scheme = call_568977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568977.url(scheme.get, call_568977.host, call_568977.base,
                         call_568977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568977, url, valid)

proc call*(call_568978: Call_DisksGet_568967; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_568979 = newJObject()
  var query_568980 = newJObject()
  add(path_568979, "resourceGroupName", newJString(resourceGroupName))
  add(query_568980, "$expand", newJString(Expand))
  add(path_568979, "name", newJString(name))
  add(query_568980, "api-version", newJString(apiVersion))
  add(path_568979, "subscriptionId", newJString(subscriptionId))
  add(path_568979, "userName", newJString(userName))
  add(path_568979, "labName", newJString(labName))
  result = call_568978.call(path_568979, query_568980, nil, nil, nil)

var disksGet* = Call_DisksGet_568967(name: "disksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                  validator: validate_DisksGet_568968, base: "",
                                  url: url_DisksGet_568969,
                                  schemes: {Scheme.Https})
type
  Call_DisksUpdate_569009 = ref object of OpenApiRestCall_567666
proc url_DisksUpdate_569011(protocol: Scheme; host: string; base: string;
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

proc validate_DisksUpdate_569010(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of disks. All other properties will be ignored.
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
  var valid_569012 = path.getOrDefault("resourceGroupName")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = nil)
  if valid_569012 != nil:
    section.add "resourceGroupName", valid_569012
  var valid_569013 = path.getOrDefault("name")
  valid_569013 = validateParameter(valid_569013, JString, required = true,
                                 default = nil)
  if valid_569013 != nil:
    section.add "name", valid_569013
  var valid_569014 = path.getOrDefault("subscriptionId")
  valid_569014 = validateParameter(valid_569014, JString, required = true,
                                 default = nil)
  if valid_569014 != nil:
    section.add "subscriptionId", valid_569014
  var valid_569015 = path.getOrDefault("userName")
  valid_569015 = validateParameter(valid_569015, JString, required = true,
                                 default = nil)
  if valid_569015 != nil:
    section.add "userName", valid_569015
  var valid_569016 = path.getOrDefault("labName")
  valid_569016 = validateParameter(valid_569016, JString, required = true,
                                 default = nil)
  if valid_569016 != nil:
    section.add "labName", valid_569016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569017 = query.getOrDefault("api-version")
  valid_569017 = validateParameter(valid_569017, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569017 != nil:
    section.add "api-version", valid_569017
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

proc call*(call_569019: Call_DisksUpdate_569009; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of disks. All other properties will be ignored.
  ## 
  let valid = call_569019.validator(path, query, header, formData, body)
  let scheme = call_569019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569019.url(scheme.get, call_569019.host, call_569019.base,
                         call_569019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569019, url, valid)

proc call*(call_569020: Call_DisksUpdate_569009; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; disk: JsonNode;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## disksUpdate
  ## Allows modifying tags of disks. All other properties will be ignored.
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
  var path_569021 = newJObject()
  var query_569022 = newJObject()
  var body_569023 = newJObject()
  add(path_569021, "resourceGroupName", newJString(resourceGroupName))
  add(query_569022, "api-version", newJString(apiVersion))
  add(path_569021, "name", newJString(name))
  add(path_569021, "subscriptionId", newJString(subscriptionId))
  add(path_569021, "userName", newJString(userName))
  if disk != nil:
    body_569023 = disk
  add(path_569021, "labName", newJString(labName))
  result = call_569020.call(path_569021, query_569022, nil, nil, body_569023)

var disksUpdate* = Call_DisksUpdate_569009(name: "disksUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                        validator: validate_DisksUpdate_569010,
                                        base: "", url: url_DisksUpdate_569011,
                                        schemes: {Scheme.Https})
type
  Call_DisksDelete_568996 = ref object of OpenApiRestCall_567666
proc url_DisksDelete_568998(protocol: Scheme; host: string; base: string;
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

proc validate_DisksDelete_568997(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568999 = path.getOrDefault("resourceGroupName")
  valid_568999 = validateParameter(valid_568999, JString, required = true,
                                 default = nil)
  if valid_568999 != nil:
    section.add "resourceGroupName", valid_568999
  var valid_569000 = path.getOrDefault("name")
  valid_569000 = validateParameter(valid_569000, JString, required = true,
                                 default = nil)
  if valid_569000 != nil:
    section.add "name", valid_569000
  var valid_569001 = path.getOrDefault("subscriptionId")
  valid_569001 = validateParameter(valid_569001, JString, required = true,
                                 default = nil)
  if valid_569001 != nil:
    section.add "subscriptionId", valid_569001
  var valid_569002 = path.getOrDefault("userName")
  valid_569002 = validateParameter(valid_569002, JString, required = true,
                                 default = nil)
  if valid_569002 != nil:
    section.add "userName", valid_569002
  var valid_569003 = path.getOrDefault("labName")
  valid_569003 = validateParameter(valid_569003, JString, required = true,
                                 default = nil)
  if valid_569003 != nil:
    section.add "labName", valid_569003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569004 = query.getOrDefault("api-version")
  valid_569004 = validateParameter(valid_569004, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569004 != nil:
    section.add "api-version", valid_569004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569005: Call_DisksDelete_568996; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete disk. This operation can take a while to complete.
  ## 
  let valid = call_569005.validator(path, query, header, formData, body)
  let scheme = call_569005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569005.url(scheme.get, call_569005.host, call_569005.base,
                         call_569005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569005, url, valid)

proc call*(call_569006: Call_DisksDelete_568996; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569007 = newJObject()
  var query_569008 = newJObject()
  add(path_569007, "resourceGroupName", newJString(resourceGroupName))
  add(query_569008, "api-version", newJString(apiVersion))
  add(path_569007, "name", newJString(name))
  add(path_569007, "subscriptionId", newJString(subscriptionId))
  add(path_569007, "userName", newJString(userName))
  add(path_569007, "labName", newJString(labName))
  result = call_569006.call(path_569007, query_569008, nil, nil, nil)

var disksDelete* = Call_DisksDelete_568996(name: "disksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                        validator: validate_DisksDelete_568997,
                                        base: "", url: url_DisksDelete_568998,
                                        schemes: {Scheme.Https})
type
  Call_DisksAttach_569024 = ref object of OpenApiRestCall_567666
proc url_DisksAttach_569026(protocol: Scheme; host: string; base: string;
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

proc validate_DisksAttach_569025(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569027 = path.getOrDefault("resourceGroupName")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = nil)
  if valid_569027 != nil:
    section.add "resourceGroupName", valid_569027
  var valid_569028 = path.getOrDefault("name")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "name", valid_569028
  var valid_569029 = path.getOrDefault("subscriptionId")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "subscriptionId", valid_569029
  var valid_569030 = path.getOrDefault("userName")
  valid_569030 = validateParameter(valid_569030, JString, required = true,
                                 default = nil)
  if valid_569030 != nil:
    section.add "userName", valid_569030
  var valid_569031 = path.getOrDefault("labName")
  valid_569031 = validateParameter(valid_569031, JString, required = true,
                                 default = nil)
  if valid_569031 != nil:
    section.add "labName", valid_569031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569032 = query.getOrDefault("api-version")
  valid_569032 = validateParameter(valid_569032, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569032 != nil:
    section.add "api-version", valid_569032
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

proc call*(call_569034: Call_DisksAttach_569024; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569034.validator(path, query, header, formData, body)
  let scheme = call_569034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569034.url(scheme.get, call_569034.host, call_569034.base,
                         call_569034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569034, url, valid)

proc call*(call_569035: Call_DisksAttach_569024; resourceGroupName: string;
          name: string; subscriptionId: string; attachDiskProperties: JsonNode;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569036 = newJObject()
  var query_569037 = newJObject()
  var body_569038 = newJObject()
  add(path_569036, "resourceGroupName", newJString(resourceGroupName))
  add(query_569037, "api-version", newJString(apiVersion))
  add(path_569036, "name", newJString(name))
  add(path_569036, "subscriptionId", newJString(subscriptionId))
  if attachDiskProperties != nil:
    body_569038 = attachDiskProperties
  add(path_569036, "userName", newJString(userName))
  add(path_569036, "labName", newJString(labName))
  result = call_569035.call(path_569036, query_569037, nil, nil, body_569038)

var disksAttach* = Call_DisksAttach_569024(name: "disksAttach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/attach",
                                        validator: validate_DisksAttach_569025,
                                        base: "", url: url_DisksAttach_569026,
                                        schemes: {Scheme.Https})
type
  Call_DisksDetach_569039 = ref object of OpenApiRestCall_567666
proc url_DisksDetach_569041(protocol: Scheme; host: string; base: string;
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

proc validate_DisksDetach_569040(path: JsonNode; query: JsonNode; header: JsonNode;
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
                                 default = newJString("2018-09-15"))
  if valid_569047 != nil:
    section.add "api-version", valid_569047
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

proc call*(call_569049: Call_DisksDetach_569039; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569049.validator(path, query, header, formData, body)
  let scheme = call_569049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569049.url(scheme.get, call_569049.host, call_569049.base,
                         call_569049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569049, url, valid)

proc call*(call_569050: Call_DisksDetach_569039; resourceGroupName: string;
          name: string; subscriptionId: string; detachDiskProperties: JsonNode;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569051 = newJObject()
  var query_569052 = newJObject()
  var body_569053 = newJObject()
  add(path_569051, "resourceGroupName", newJString(resourceGroupName))
  add(query_569052, "api-version", newJString(apiVersion))
  add(path_569051, "name", newJString(name))
  add(path_569051, "subscriptionId", newJString(subscriptionId))
  if detachDiskProperties != nil:
    body_569053 = detachDiskProperties
  add(path_569051, "userName", newJString(userName))
  add(path_569051, "labName", newJString(labName))
  result = call_569050.call(path_569051, query_569052, nil, nil, body_569053)

var disksDetach* = Call_DisksDetach_569039(name: "disksDetach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/detach",
                                        validator: validate_DisksDetach_569040,
                                        base: "", url: url_DisksDetach_569041,
                                        schemes: {Scheme.Https})
type
  Call_EnvironmentsList_569054 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsList_569056(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsList_569055(path: JsonNode; query: JsonNode;
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
  var valid_569057 = path.getOrDefault("resourceGroupName")
  valid_569057 = validateParameter(valid_569057, JString, required = true,
                                 default = nil)
  if valid_569057 != nil:
    section.add "resourceGroupName", valid_569057
  var valid_569058 = path.getOrDefault("subscriptionId")
  valid_569058 = validateParameter(valid_569058, JString, required = true,
                                 default = nil)
  if valid_569058 != nil:
    section.add "subscriptionId", valid_569058
  var valid_569059 = path.getOrDefault("userName")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "userName", valid_569059
  var valid_569060 = path.getOrDefault("labName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "labName", valid_569060
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_569061 = query.getOrDefault("$orderby")
  valid_569061 = validateParameter(valid_569061, JString, required = false,
                                 default = nil)
  if valid_569061 != nil:
    section.add "$orderby", valid_569061
  var valid_569062 = query.getOrDefault("$expand")
  valid_569062 = validateParameter(valid_569062, JString, required = false,
                                 default = nil)
  if valid_569062 != nil:
    section.add "$expand", valid_569062
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569063 = query.getOrDefault("api-version")
  valid_569063 = validateParameter(valid_569063, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569063 != nil:
    section.add "api-version", valid_569063
  var valid_569064 = query.getOrDefault("$top")
  valid_569064 = validateParameter(valid_569064, JInt, required = false, default = nil)
  if valid_569064 != nil:
    section.add "$top", valid_569064
  var valid_569065 = query.getOrDefault("$filter")
  valid_569065 = validateParameter(valid_569065, JString, required = false,
                                 default = nil)
  if valid_569065 != nil:
    section.add "$filter", valid_569065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569066: Call_EnvironmentsList_569054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environments in a given user profile.
  ## 
  let valid = call_569066.validator(path, query, header, formData, body)
  let scheme = call_569066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569066.url(scheme.get, call_569066.host, call_569066.base,
                         call_569066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569066, url, valid)

proc call*(call_569067: Call_EnvironmentsList_569054; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## environmentsList
  ## List environments in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_569068 = newJObject()
  var query_569069 = newJObject()
  add(query_569069, "$orderby", newJString(Orderby))
  add(path_569068, "resourceGroupName", newJString(resourceGroupName))
  add(query_569069, "$expand", newJString(Expand))
  add(query_569069, "api-version", newJString(apiVersion))
  add(path_569068, "subscriptionId", newJString(subscriptionId))
  add(query_569069, "$top", newJInt(Top))
  add(path_569068, "userName", newJString(userName))
  add(path_569068, "labName", newJString(labName))
  add(query_569069, "$filter", newJString(Filter))
  result = call_569067.call(path_569068, query_569069, nil, nil, nil)

var environmentsList* = Call_EnvironmentsList_569054(name: "environmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments",
    validator: validate_EnvironmentsList_569055, base: "",
    url: url_EnvironmentsList_569056, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_569084 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsCreateOrUpdate_569086(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_569085(path: JsonNode; query: JsonNode;
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
  var valid_569087 = path.getOrDefault("resourceGroupName")
  valid_569087 = validateParameter(valid_569087, JString, required = true,
                                 default = nil)
  if valid_569087 != nil:
    section.add "resourceGroupName", valid_569087
  var valid_569088 = path.getOrDefault("name")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = nil)
  if valid_569088 != nil:
    section.add "name", valid_569088
  var valid_569089 = path.getOrDefault("subscriptionId")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "subscriptionId", valid_569089
  var valid_569090 = path.getOrDefault("userName")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "userName", valid_569090
  var valid_569091 = path.getOrDefault("labName")
  valid_569091 = validateParameter(valid_569091, JString, required = true,
                                 default = nil)
  if valid_569091 != nil:
    section.add "labName", valid_569091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569092 = query.getOrDefault("api-version")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569092 != nil:
    section.add "api-version", valid_569092
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

proc call*(call_569094: Call_EnvironmentsCreateOrUpdate_569084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing environment. This operation can take a while to complete.
  ## 
  let valid = call_569094.validator(path, query, header, formData, body)
  let scheme = call_569094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569094.url(scheme.get, call_569094.host, call_569094.base,
                         call_569094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569094, url, valid)

proc call*(call_569095: Call_EnvironmentsCreateOrUpdate_569084;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; dtlEnvironment: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569096 = newJObject()
  var query_569097 = newJObject()
  var body_569098 = newJObject()
  add(path_569096, "resourceGroupName", newJString(resourceGroupName))
  add(query_569097, "api-version", newJString(apiVersion))
  add(path_569096, "name", newJString(name))
  add(path_569096, "subscriptionId", newJString(subscriptionId))
  add(path_569096, "userName", newJString(userName))
  if dtlEnvironment != nil:
    body_569098 = dtlEnvironment
  add(path_569096, "labName", newJString(labName))
  result = call_569095.call(path_569096, query_569097, nil, nil, body_569098)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_569084(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsCreateOrUpdate_569085, base: "",
    url: url_EnvironmentsCreateOrUpdate_569086, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_569070 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsGet_569072(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsGet_569071(path: JsonNode; query: JsonNode;
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
  var valid_569073 = path.getOrDefault("resourceGroupName")
  valid_569073 = validateParameter(valid_569073, JString, required = true,
                                 default = nil)
  if valid_569073 != nil:
    section.add "resourceGroupName", valid_569073
  var valid_569074 = path.getOrDefault("name")
  valid_569074 = validateParameter(valid_569074, JString, required = true,
                                 default = nil)
  if valid_569074 != nil:
    section.add "name", valid_569074
  var valid_569075 = path.getOrDefault("subscriptionId")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "subscriptionId", valid_569075
  var valid_569076 = path.getOrDefault("userName")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = nil)
  if valid_569076 != nil:
    section.add "userName", valid_569076
  var valid_569077 = path.getOrDefault("labName")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = nil)
  if valid_569077 != nil:
    section.add "labName", valid_569077
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569078 = query.getOrDefault("$expand")
  valid_569078 = validateParameter(valid_569078, JString, required = false,
                                 default = nil)
  if valid_569078 != nil:
    section.add "$expand", valid_569078
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569079 = query.getOrDefault("api-version")
  valid_569079 = validateParameter(valid_569079, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569079 != nil:
    section.add "api-version", valid_569079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569080: Call_EnvironmentsGet_569070; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment.
  ## 
  let valid = call_569080.validator(path, query, header, formData, body)
  let scheme = call_569080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569080.url(scheme.get, call_569080.host, call_569080.base,
                         call_569080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569080, url, valid)

proc call*(call_569081: Call_EnvironmentsGet_569070; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569082 = newJObject()
  var query_569083 = newJObject()
  add(path_569082, "resourceGroupName", newJString(resourceGroupName))
  add(query_569083, "$expand", newJString(Expand))
  add(path_569082, "name", newJString(name))
  add(query_569083, "api-version", newJString(apiVersion))
  add(path_569082, "subscriptionId", newJString(subscriptionId))
  add(path_569082, "userName", newJString(userName))
  add(path_569082, "labName", newJString(labName))
  result = call_569081.call(path_569082, query_569083, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_569070(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsGet_569071, base: "", url: url_EnvironmentsGet_569072,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_569112 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsUpdate_569114(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsUpdate_569113(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Allows modifying tags of environments. All other properties will be ignored.
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
                                 default = newJString("2018-09-15"))
  if valid_569120 != nil:
    section.add "api-version", valid_569120
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

proc call*(call_569122: Call_EnvironmentsUpdate_569112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of environments. All other properties will be ignored.
  ## 
  let valid = call_569122.validator(path, query, header, formData, body)
  let scheme = call_569122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569122.url(scheme.get, call_569122.host, call_569122.base,
                         call_569122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569122, url, valid)

proc call*(call_569123: Call_EnvironmentsUpdate_569112; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string;
          dtlEnvironment: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## environmentsUpdate
  ## Allows modifying tags of environments. All other properties will be ignored.
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
  var path_569124 = newJObject()
  var query_569125 = newJObject()
  var body_569126 = newJObject()
  add(path_569124, "resourceGroupName", newJString(resourceGroupName))
  add(query_569125, "api-version", newJString(apiVersion))
  add(path_569124, "name", newJString(name))
  add(path_569124, "subscriptionId", newJString(subscriptionId))
  add(path_569124, "userName", newJString(userName))
  if dtlEnvironment != nil:
    body_569126 = dtlEnvironment
  add(path_569124, "labName", newJString(labName))
  result = call_569123.call(path_569124, query_569125, nil, nil, body_569126)

var environmentsUpdate* = Call_EnvironmentsUpdate_569112(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsUpdate_569113, base: "",
    url: url_EnvironmentsUpdate_569114, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_569099 = ref object of OpenApiRestCall_567666
proc url_EnvironmentsDelete_569101(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_569100(path: JsonNode; query: JsonNode;
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
  var valid_569102 = path.getOrDefault("resourceGroupName")
  valid_569102 = validateParameter(valid_569102, JString, required = true,
                                 default = nil)
  if valid_569102 != nil:
    section.add "resourceGroupName", valid_569102
  var valid_569103 = path.getOrDefault("name")
  valid_569103 = validateParameter(valid_569103, JString, required = true,
                                 default = nil)
  if valid_569103 != nil:
    section.add "name", valid_569103
  var valid_569104 = path.getOrDefault("subscriptionId")
  valid_569104 = validateParameter(valid_569104, JString, required = true,
                                 default = nil)
  if valid_569104 != nil:
    section.add "subscriptionId", valid_569104
  var valid_569105 = path.getOrDefault("userName")
  valid_569105 = validateParameter(valid_569105, JString, required = true,
                                 default = nil)
  if valid_569105 != nil:
    section.add "userName", valid_569105
  var valid_569106 = path.getOrDefault("labName")
  valid_569106 = validateParameter(valid_569106, JString, required = true,
                                 default = nil)
  if valid_569106 != nil:
    section.add "labName", valid_569106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569107 = query.getOrDefault("api-version")
  valid_569107 = validateParameter(valid_569107, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569107 != nil:
    section.add "api-version", valid_569107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569108: Call_EnvironmentsDelete_569099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment. This operation can take a while to complete.
  ## 
  let valid = call_569108.validator(path, query, header, formData, body)
  let scheme = call_569108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569108.url(scheme.get, call_569108.host, call_569108.base,
                         call_569108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569108, url, valid)

proc call*(call_569109: Call_EnvironmentsDelete_569099; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569110 = newJObject()
  var query_569111 = newJObject()
  add(path_569110, "resourceGroupName", newJString(resourceGroupName))
  add(query_569111, "api-version", newJString(apiVersion))
  add(path_569110, "name", newJString(name))
  add(path_569110, "subscriptionId", newJString(subscriptionId))
  add(path_569110, "userName", newJString(userName))
  add(path_569110, "labName", newJString(labName))
  result = call_569109.call(path_569110, query_569111, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_569099(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsDelete_569100, base: "",
    url: url_EnvironmentsDelete_569101, schemes: {Scheme.Https})
type
  Call_SecretsList_569127 = ref object of OpenApiRestCall_567666
proc url_SecretsList_569129(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsList_569128(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569130 = path.getOrDefault("resourceGroupName")
  valid_569130 = validateParameter(valid_569130, JString, required = true,
                                 default = nil)
  if valid_569130 != nil:
    section.add "resourceGroupName", valid_569130
  var valid_569131 = path.getOrDefault("subscriptionId")
  valid_569131 = validateParameter(valid_569131, JString, required = true,
                                 default = nil)
  if valid_569131 != nil:
    section.add "subscriptionId", valid_569131
  var valid_569132 = path.getOrDefault("userName")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "userName", valid_569132
  var valid_569133 = path.getOrDefault("labName")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "labName", valid_569133
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_569134 = query.getOrDefault("$orderby")
  valid_569134 = validateParameter(valid_569134, JString, required = false,
                                 default = nil)
  if valid_569134 != nil:
    section.add "$orderby", valid_569134
  var valid_569135 = query.getOrDefault("$expand")
  valid_569135 = validateParameter(valid_569135, JString, required = false,
                                 default = nil)
  if valid_569135 != nil:
    section.add "$expand", valid_569135
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569136 = query.getOrDefault("api-version")
  valid_569136 = validateParameter(valid_569136, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569136 != nil:
    section.add "api-version", valid_569136
  var valid_569137 = query.getOrDefault("$top")
  valid_569137 = validateParameter(valid_569137, JInt, required = false, default = nil)
  if valid_569137 != nil:
    section.add "$top", valid_569137
  var valid_569138 = query.getOrDefault("$filter")
  valid_569138 = validateParameter(valid_569138, JString, required = false,
                                 default = nil)
  if valid_569138 != nil:
    section.add "$filter", valid_569138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569139: Call_SecretsList_569127; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List secrets in a given user profile.
  ## 
  let valid = call_569139.validator(path, query, header, formData, body)
  let scheme = call_569139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569139.url(scheme.get, call_569139.host, call_569139.base,
                         call_569139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569139, url, valid)

proc call*(call_569140: Call_SecretsList_569127; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## secretsList
  ## List secrets in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=value)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_569141 = newJObject()
  var query_569142 = newJObject()
  add(query_569142, "$orderby", newJString(Orderby))
  add(path_569141, "resourceGroupName", newJString(resourceGroupName))
  add(query_569142, "$expand", newJString(Expand))
  add(query_569142, "api-version", newJString(apiVersion))
  add(path_569141, "subscriptionId", newJString(subscriptionId))
  add(query_569142, "$top", newJInt(Top))
  add(path_569141, "userName", newJString(userName))
  add(path_569141, "labName", newJString(labName))
  add(query_569142, "$filter", newJString(Filter))
  result = call_569140.call(path_569141, query_569142, nil, nil, nil)

var secretsList* = Call_SecretsList_569127(name: "secretsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets",
                                        validator: validate_SecretsList_569128,
                                        base: "", url: url_SecretsList_569129,
                                        schemes: {Scheme.Https})
type
  Call_SecretsCreateOrUpdate_569157 = ref object of OpenApiRestCall_567666
proc url_SecretsCreateOrUpdate_569159(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsCreateOrUpdate_569158(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing secret. This operation can take a while to complete.
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
  var valid_569160 = path.getOrDefault("resourceGroupName")
  valid_569160 = validateParameter(valid_569160, JString, required = true,
                                 default = nil)
  if valid_569160 != nil:
    section.add "resourceGroupName", valid_569160
  var valid_569161 = path.getOrDefault("name")
  valid_569161 = validateParameter(valid_569161, JString, required = true,
                                 default = nil)
  if valid_569161 != nil:
    section.add "name", valid_569161
  var valid_569162 = path.getOrDefault("subscriptionId")
  valid_569162 = validateParameter(valid_569162, JString, required = true,
                                 default = nil)
  if valid_569162 != nil:
    section.add "subscriptionId", valid_569162
  var valid_569163 = path.getOrDefault("userName")
  valid_569163 = validateParameter(valid_569163, JString, required = true,
                                 default = nil)
  if valid_569163 != nil:
    section.add "userName", valid_569163
  var valid_569164 = path.getOrDefault("labName")
  valid_569164 = validateParameter(valid_569164, JString, required = true,
                                 default = nil)
  if valid_569164 != nil:
    section.add "labName", valid_569164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569165 = query.getOrDefault("api-version")
  valid_569165 = validateParameter(valid_569165, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569165 != nil:
    section.add "api-version", valid_569165
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

proc call*(call_569167: Call_SecretsCreateOrUpdate_569157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing secret. This operation can take a while to complete.
  ## 
  let valid = call_569167.validator(path, query, header, formData, body)
  let scheme = call_569167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569167.url(scheme.get, call_569167.host, call_569167.base,
                         call_569167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569167, url, valid)

proc call*(call_569168: Call_SecretsCreateOrUpdate_569157;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; secret: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## secretsCreateOrUpdate
  ## Create or replace an existing secret. This operation can take a while to complete.
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
  var path_569169 = newJObject()
  var query_569170 = newJObject()
  var body_569171 = newJObject()
  add(path_569169, "resourceGroupName", newJString(resourceGroupName))
  add(query_569170, "api-version", newJString(apiVersion))
  add(path_569169, "name", newJString(name))
  add(path_569169, "subscriptionId", newJString(subscriptionId))
  add(path_569169, "userName", newJString(userName))
  add(path_569169, "labName", newJString(labName))
  if secret != nil:
    body_569171 = secret
  result = call_569168.call(path_569169, query_569170, nil, nil, body_569171)

var secretsCreateOrUpdate* = Call_SecretsCreateOrUpdate_569157(
    name: "secretsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsCreateOrUpdate_569158, base: "",
    url: url_SecretsCreateOrUpdate_569159, schemes: {Scheme.Https})
type
  Call_SecretsGet_569143 = ref object of OpenApiRestCall_567666
proc url_SecretsGet_569145(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SecretsGet_569144(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569146 = path.getOrDefault("resourceGroupName")
  valid_569146 = validateParameter(valid_569146, JString, required = true,
                                 default = nil)
  if valid_569146 != nil:
    section.add "resourceGroupName", valid_569146
  var valid_569147 = path.getOrDefault("name")
  valid_569147 = validateParameter(valid_569147, JString, required = true,
                                 default = nil)
  if valid_569147 != nil:
    section.add "name", valid_569147
  var valid_569148 = path.getOrDefault("subscriptionId")
  valid_569148 = validateParameter(valid_569148, JString, required = true,
                                 default = nil)
  if valid_569148 != nil:
    section.add "subscriptionId", valid_569148
  var valid_569149 = path.getOrDefault("userName")
  valid_569149 = validateParameter(valid_569149, JString, required = true,
                                 default = nil)
  if valid_569149 != nil:
    section.add "userName", valid_569149
  var valid_569150 = path.getOrDefault("labName")
  valid_569150 = validateParameter(valid_569150, JString, required = true,
                                 default = nil)
  if valid_569150 != nil:
    section.add "labName", valid_569150
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569151 = query.getOrDefault("$expand")
  valid_569151 = validateParameter(valid_569151, JString, required = false,
                                 default = nil)
  if valid_569151 != nil:
    section.add "$expand", valid_569151
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569152 = query.getOrDefault("api-version")
  valid_569152 = validateParameter(valid_569152, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569152 != nil:
    section.add "api-version", valid_569152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569153: Call_SecretsGet_569143; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get secret.
  ## 
  let valid = call_569153.validator(path, query, header, formData, body)
  let scheme = call_569153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569153.url(scheme.get, call_569153.host, call_569153.base,
                         call_569153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569153, url, valid)

proc call*(call_569154: Call_SecretsGet_569143; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569155 = newJObject()
  var query_569156 = newJObject()
  add(path_569155, "resourceGroupName", newJString(resourceGroupName))
  add(query_569156, "$expand", newJString(Expand))
  add(path_569155, "name", newJString(name))
  add(query_569156, "api-version", newJString(apiVersion))
  add(path_569155, "subscriptionId", newJString(subscriptionId))
  add(path_569155, "userName", newJString(userName))
  add(path_569155, "labName", newJString(labName))
  result = call_569154.call(path_569155, query_569156, nil, nil, nil)

var secretsGet* = Call_SecretsGet_569143(name: "secretsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
                                      validator: validate_SecretsGet_569144,
                                      base: "", url: url_SecretsGet_569145,
                                      schemes: {Scheme.Https})
type
  Call_SecretsUpdate_569185 = ref object of OpenApiRestCall_567666
proc url_SecretsUpdate_569187(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsUpdate_569186(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of secrets. All other properties will be ignored.
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
  var valid_569188 = path.getOrDefault("resourceGroupName")
  valid_569188 = validateParameter(valid_569188, JString, required = true,
                                 default = nil)
  if valid_569188 != nil:
    section.add "resourceGroupName", valid_569188
  var valid_569189 = path.getOrDefault("name")
  valid_569189 = validateParameter(valid_569189, JString, required = true,
                                 default = nil)
  if valid_569189 != nil:
    section.add "name", valid_569189
  var valid_569190 = path.getOrDefault("subscriptionId")
  valid_569190 = validateParameter(valid_569190, JString, required = true,
                                 default = nil)
  if valid_569190 != nil:
    section.add "subscriptionId", valid_569190
  var valid_569191 = path.getOrDefault("userName")
  valid_569191 = validateParameter(valid_569191, JString, required = true,
                                 default = nil)
  if valid_569191 != nil:
    section.add "userName", valid_569191
  var valid_569192 = path.getOrDefault("labName")
  valid_569192 = validateParameter(valid_569192, JString, required = true,
                                 default = nil)
  if valid_569192 != nil:
    section.add "labName", valid_569192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569193 = query.getOrDefault("api-version")
  valid_569193 = validateParameter(valid_569193, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569193 != nil:
    section.add "api-version", valid_569193
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

proc call*(call_569195: Call_SecretsUpdate_569185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of secrets. All other properties will be ignored.
  ## 
  let valid = call_569195.validator(path, query, header, formData, body)
  let scheme = call_569195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569195.url(scheme.get, call_569195.host, call_569195.base,
                         call_569195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569195, url, valid)

proc call*(call_569196: Call_SecretsUpdate_569185; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          secret: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## secretsUpdate
  ## Allows modifying tags of secrets. All other properties will be ignored.
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
  var path_569197 = newJObject()
  var query_569198 = newJObject()
  var body_569199 = newJObject()
  add(path_569197, "resourceGroupName", newJString(resourceGroupName))
  add(query_569198, "api-version", newJString(apiVersion))
  add(path_569197, "name", newJString(name))
  add(path_569197, "subscriptionId", newJString(subscriptionId))
  add(path_569197, "userName", newJString(userName))
  add(path_569197, "labName", newJString(labName))
  if secret != nil:
    body_569199 = secret
  result = call_569196.call(path_569197, query_569198, nil, nil, body_569199)

var secretsUpdate* = Call_SecretsUpdate_569185(name: "secretsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsUpdate_569186, base: "", url: url_SecretsUpdate_569187,
    schemes: {Scheme.Https})
type
  Call_SecretsDelete_569172 = ref object of OpenApiRestCall_567666
proc url_SecretsDelete_569174(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsDelete_569173(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569175 = path.getOrDefault("resourceGroupName")
  valid_569175 = validateParameter(valid_569175, JString, required = true,
                                 default = nil)
  if valid_569175 != nil:
    section.add "resourceGroupName", valid_569175
  var valid_569176 = path.getOrDefault("name")
  valid_569176 = validateParameter(valid_569176, JString, required = true,
                                 default = nil)
  if valid_569176 != nil:
    section.add "name", valid_569176
  var valid_569177 = path.getOrDefault("subscriptionId")
  valid_569177 = validateParameter(valid_569177, JString, required = true,
                                 default = nil)
  if valid_569177 != nil:
    section.add "subscriptionId", valid_569177
  var valid_569178 = path.getOrDefault("userName")
  valid_569178 = validateParameter(valid_569178, JString, required = true,
                                 default = nil)
  if valid_569178 != nil:
    section.add "userName", valid_569178
  var valid_569179 = path.getOrDefault("labName")
  valid_569179 = validateParameter(valid_569179, JString, required = true,
                                 default = nil)
  if valid_569179 != nil:
    section.add "labName", valid_569179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569180 = query.getOrDefault("api-version")
  valid_569180 = validateParameter(valid_569180, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569180 != nil:
    section.add "api-version", valid_569180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569181: Call_SecretsDelete_569172; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete secret.
  ## 
  let valid = call_569181.validator(path, query, header, formData, body)
  let scheme = call_569181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569181.url(scheme.get, call_569181.host, call_569181.base,
                         call_569181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569181, url, valid)

proc call*(call_569182: Call_SecretsDelete_569172; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569183 = newJObject()
  var query_569184 = newJObject()
  add(path_569183, "resourceGroupName", newJString(resourceGroupName))
  add(query_569184, "api-version", newJString(apiVersion))
  add(path_569183, "name", newJString(name))
  add(path_569183, "subscriptionId", newJString(subscriptionId))
  add(path_569183, "userName", newJString(userName))
  add(path_569183, "labName", newJString(labName))
  result = call_569182.call(path_569183, query_569184, nil, nil, nil)

var secretsDelete* = Call_SecretsDelete_569172(name: "secretsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsDelete_569173, base: "", url: url_SecretsDelete_569174,
    schemes: {Scheme.Https})
type
  Call_ServiceFabricsList_569200 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricsList_569202(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/servicefabrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsList_569201(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List service fabrics in a given user profile.
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
  var valid_569203 = path.getOrDefault("resourceGroupName")
  valid_569203 = validateParameter(valid_569203, JString, required = true,
                                 default = nil)
  if valid_569203 != nil:
    section.add "resourceGroupName", valid_569203
  var valid_569204 = path.getOrDefault("subscriptionId")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "subscriptionId", valid_569204
  var valid_569205 = path.getOrDefault("userName")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "userName", valid_569205
  var valid_569206 = path.getOrDefault("labName")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "labName", valid_569206
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_569207 = query.getOrDefault("$orderby")
  valid_569207 = validateParameter(valid_569207, JString, required = false,
                                 default = nil)
  if valid_569207 != nil:
    section.add "$orderby", valid_569207
  var valid_569208 = query.getOrDefault("$expand")
  valid_569208 = validateParameter(valid_569208, JString, required = false,
                                 default = nil)
  if valid_569208 != nil:
    section.add "$expand", valid_569208
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569209 = query.getOrDefault("api-version")
  valid_569209 = validateParameter(valid_569209, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569209 != nil:
    section.add "api-version", valid_569209
  var valid_569210 = query.getOrDefault("$top")
  valid_569210 = validateParameter(valid_569210, JInt, required = false, default = nil)
  if valid_569210 != nil:
    section.add "$top", valid_569210
  var valid_569211 = query.getOrDefault("$filter")
  valid_569211 = validateParameter(valid_569211, JString, required = false,
                                 default = nil)
  if valid_569211 != nil:
    section.add "$filter", valid_569211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569212: Call_ServiceFabricsList_569200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List service fabrics in a given user profile.
  ## 
  let valid = call_569212.validator(path, query, header, formData, body)
  let scheme = call_569212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569212.url(scheme.get, call_569212.host, call_569212.base,
                         call_569212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569212, url, valid)

proc call*(call_569213: Call_ServiceFabricsList_569200; resourceGroupName: string;
          subscriptionId: string; userName: string; labName: string;
          Orderby: string = ""; Expand: string = ""; apiVersion: string = "2018-09-15";
          Top: int = 0; Filter: string = ""): Recallable =
  ## serviceFabricsList
  ## List service fabrics in a given user profile.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_569214 = newJObject()
  var query_569215 = newJObject()
  add(query_569215, "$orderby", newJString(Orderby))
  add(path_569214, "resourceGroupName", newJString(resourceGroupName))
  add(query_569215, "$expand", newJString(Expand))
  add(query_569215, "api-version", newJString(apiVersion))
  add(path_569214, "subscriptionId", newJString(subscriptionId))
  add(query_569215, "$top", newJInt(Top))
  add(path_569214, "userName", newJString(userName))
  add(path_569214, "labName", newJString(labName))
  add(query_569215, "$filter", newJString(Filter))
  result = call_569213.call(path_569214, query_569215, nil, nil, nil)

var serviceFabricsList* = Call_ServiceFabricsList_569200(
    name: "serviceFabricsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics",
    validator: validate_ServiceFabricsList_569201, base: "",
    url: url_ServiceFabricsList_569202, schemes: {Scheme.Https})
type
  Call_ServiceFabricsCreateOrUpdate_569230 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricsCreateOrUpdate_569232(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsCreateOrUpdate_569231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing service fabric. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569233 = path.getOrDefault("resourceGroupName")
  valid_569233 = validateParameter(valid_569233, JString, required = true,
                                 default = nil)
  if valid_569233 != nil:
    section.add "resourceGroupName", valid_569233
  var valid_569234 = path.getOrDefault("name")
  valid_569234 = validateParameter(valid_569234, JString, required = true,
                                 default = nil)
  if valid_569234 != nil:
    section.add "name", valid_569234
  var valid_569235 = path.getOrDefault("subscriptionId")
  valid_569235 = validateParameter(valid_569235, JString, required = true,
                                 default = nil)
  if valid_569235 != nil:
    section.add "subscriptionId", valid_569235
  var valid_569236 = path.getOrDefault("userName")
  valid_569236 = validateParameter(valid_569236, JString, required = true,
                                 default = nil)
  if valid_569236 != nil:
    section.add "userName", valid_569236
  var valid_569237 = path.getOrDefault("labName")
  valid_569237 = validateParameter(valid_569237, JString, required = true,
                                 default = nil)
  if valid_569237 != nil:
    section.add "labName", valid_569237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569238 = query.getOrDefault("api-version")
  valid_569238 = validateParameter(valid_569238, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569238 != nil:
    section.add "api-version", valid_569238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569240: Call_ServiceFabricsCreateOrUpdate_569230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing service fabric. This operation can take a while to complete.
  ## 
  let valid = call_569240.validator(path, query, header, formData, body)
  let scheme = call_569240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569240.url(scheme.get, call_569240.host, call_569240.base,
                         call_569240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569240, url, valid)

proc call*(call_569241: Call_ServiceFabricsCreateOrUpdate_569230;
          serviceFabric: JsonNode; resourceGroupName: string; name: string;
          subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsCreateOrUpdate
  ## Create or replace an existing service fabric. This operation can take a while to complete.
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569242 = newJObject()
  var query_569243 = newJObject()
  var body_569244 = newJObject()
  if serviceFabric != nil:
    body_569244 = serviceFabric
  add(path_569242, "resourceGroupName", newJString(resourceGroupName))
  add(query_569243, "api-version", newJString(apiVersion))
  add(path_569242, "name", newJString(name))
  add(path_569242, "subscriptionId", newJString(subscriptionId))
  add(path_569242, "userName", newJString(userName))
  add(path_569242, "labName", newJString(labName))
  result = call_569241.call(path_569242, query_569243, nil, nil, body_569244)

var serviceFabricsCreateOrUpdate* = Call_ServiceFabricsCreateOrUpdate_569230(
    name: "serviceFabricsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsCreateOrUpdate_569231, base: "",
    url: url_ServiceFabricsCreateOrUpdate_569232, schemes: {Scheme.Https})
type
  Call_ServiceFabricsGet_569216 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricsGet_569218(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsGet_569217(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get service fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569219 = path.getOrDefault("resourceGroupName")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "resourceGroupName", valid_569219
  var valid_569220 = path.getOrDefault("name")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "name", valid_569220
  var valid_569221 = path.getOrDefault("subscriptionId")
  valid_569221 = validateParameter(valid_569221, JString, required = true,
                                 default = nil)
  if valid_569221 != nil:
    section.add "subscriptionId", valid_569221
  var valid_569222 = path.getOrDefault("userName")
  valid_569222 = validateParameter(valid_569222, JString, required = true,
                                 default = nil)
  if valid_569222 != nil:
    section.add "userName", valid_569222
  var valid_569223 = path.getOrDefault("labName")
  valid_569223 = validateParameter(valid_569223, JString, required = true,
                                 default = nil)
  if valid_569223 != nil:
    section.add "labName", valid_569223
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569224 = query.getOrDefault("$expand")
  valid_569224 = validateParameter(valid_569224, JString, required = false,
                                 default = nil)
  if valid_569224 != nil:
    section.add "$expand", valid_569224
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569225 = query.getOrDefault("api-version")
  valid_569225 = validateParameter(valid_569225, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569225 != nil:
    section.add "api-version", valid_569225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569226: Call_ServiceFabricsGet_569216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service fabric.
  ## 
  let valid = call_569226.validator(path, query, header, formData, body)
  let scheme = call_569226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569226.url(scheme.get, call_569226.host, call_569226.base,
                         call_569226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569226, url, valid)

proc call*(call_569227: Call_ServiceFabricsGet_569216; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsGet
  ## Get service fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569228 = newJObject()
  var query_569229 = newJObject()
  add(path_569228, "resourceGroupName", newJString(resourceGroupName))
  add(query_569229, "$expand", newJString(Expand))
  add(path_569228, "name", newJString(name))
  add(query_569229, "api-version", newJString(apiVersion))
  add(path_569228, "subscriptionId", newJString(subscriptionId))
  add(path_569228, "userName", newJString(userName))
  add(path_569228, "labName", newJString(labName))
  result = call_569227.call(path_569228, query_569229, nil, nil, nil)

var serviceFabricsGet* = Call_ServiceFabricsGet_569216(name: "serviceFabricsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsGet_569217, base: "",
    url: url_ServiceFabricsGet_569218, schemes: {Scheme.Https})
type
  Call_ServiceFabricsUpdate_569258 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricsUpdate_569260(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsUpdate_569259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of service fabrics. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569261 = path.getOrDefault("resourceGroupName")
  valid_569261 = validateParameter(valid_569261, JString, required = true,
                                 default = nil)
  if valid_569261 != nil:
    section.add "resourceGroupName", valid_569261
  var valid_569262 = path.getOrDefault("name")
  valid_569262 = validateParameter(valid_569262, JString, required = true,
                                 default = nil)
  if valid_569262 != nil:
    section.add "name", valid_569262
  var valid_569263 = path.getOrDefault("subscriptionId")
  valid_569263 = validateParameter(valid_569263, JString, required = true,
                                 default = nil)
  if valid_569263 != nil:
    section.add "subscriptionId", valid_569263
  var valid_569264 = path.getOrDefault("userName")
  valid_569264 = validateParameter(valid_569264, JString, required = true,
                                 default = nil)
  if valid_569264 != nil:
    section.add "userName", valid_569264
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
                                 default = newJString("2018-09-15"))
  if valid_569266 != nil:
    section.add "api-version", valid_569266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569268: Call_ServiceFabricsUpdate_569258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of service fabrics. All other properties will be ignored.
  ## 
  let valid = call_569268.validator(path, query, header, formData, body)
  let scheme = call_569268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569268.url(scheme.get, call_569268.host, call_569268.base,
                         call_569268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569268, url, valid)

proc call*(call_569269: Call_ServiceFabricsUpdate_569258; serviceFabric: JsonNode;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsUpdate
  ## Allows modifying tags of service fabrics. All other properties will be ignored.
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569270 = newJObject()
  var query_569271 = newJObject()
  var body_569272 = newJObject()
  if serviceFabric != nil:
    body_569272 = serviceFabric
  add(path_569270, "resourceGroupName", newJString(resourceGroupName))
  add(query_569271, "api-version", newJString(apiVersion))
  add(path_569270, "name", newJString(name))
  add(path_569270, "subscriptionId", newJString(subscriptionId))
  add(path_569270, "userName", newJString(userName))
  add(path_569270, "labName", newJString(labName))
  result = call_569269.call(path_569270, query_569271, nil, nil, body_569272)

var serviceFabricsUpdate* = Call_ServiceFabricsUpdate_569258(
    name: "serviceFabricsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsUpdate_569259, base: "",
    url: url_ServiceFabricsUpdate_569260, schemes: {Scheme.Https})
type
  Call_ServiceFabricsDelete_569245 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricsDelete_569247(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsDelete_569246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete service fabric. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569248 = path.getOrDefault("resourceGroupName")
  valid_569248 = validateParameter(valid_569248, JString, required = true,
                                 default = nil)
  if valid_569248 != nil:
    section.add "resourceGroupName", valid_569248
  var valid_569249 = path.getOrDefault("name")
  valid_569249 = validateParameter(valid_569249, JString, required = true,
                                 default = nil)
  if valid_569249 != nil:
    section.add "name", valid_569249
  var valid_569250 = path.getOrDefault("subscriptionId")
  valid_569250 = validateParameter(valid_569250, JString, required = true,
                                 default = nil)
  if valid_569250 != nil:
    section.add "subscriptionId", valid_569250
  var valid_569251 = path.getOrDefault("userName")
  valid_569251 = validateParameter(valid_569251, JString, required = true,
                                 default = nil)
  if valid_569251 != nil:
    section.add "userName", valid_569251
  var valid_569252 = path.getOrDefault("labName")
  valid_569252 = validateParameter(valid_569252, JString, required = true,
                                 default = nil)
  if valid_569252 != nil:
    section.add "labName", valid_569252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569253 = query.getOrDefault("api-version")
  valid_569253 = validateParameter(valid_569253, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569253 != nil:
    section.add "api-version", valid_569253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569254: Call_ServiceFabricsDelete_569245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete service fabric. This operation can take a while to complete.
  ## 
  let valid = call_569254.validator(path, query, header, formData, body)
  let scheme = call_569254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569254.url(scheme.get, call_569254.host, call_569254.base,
                         call_569254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569254, url, valid)

proc call*(call_569255: Call_ServiceFabricsDelete_569245;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsDelete
  ## Delete service fabric. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569256 = newJObject()
  var query_569257 = newJObject()
  add(path_569256, "resourceGroupName", newJString(resourceGroupName))
  add(query_569257, "api-version", newJString(apiVersion))
  add(path_569256, "name", newJString(name))
  add(path_569256, "subscriptionId", newJString(subscriptionId))
  add(path_569256, "userName", newJString(userName))
  add(path_569256, "labName", newJString(labName))
  result = call_569255.call(path_569256, query_569257, nil, nil, nil)

var serviceFabricsDelete* = Call_ServiceFabricsDelete_569245(
    name: "serviceFabricsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsDelete_569246, base: "",
    url: url_ServiceFabricsDelete_569247, schemes: {Scheme.Https})
type
  Call_ServiceFabricsListApplicableSchedules_569273 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricsListApplicableSchedules_569275(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listApplicableSchedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsListApplicableSchedules_569274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569276 = path.getOrDefault("resourceGroupName")
  valid_569276 = validateParameter(valid_569276, JString, required = true,
                                 default = nil)
  if valid_569276 != nil:
    section.add "resourceGroupName", valid_569276
  var valid_569277 = path.getOrDefault("name")
  valid_569277 = validateParameter(valid_569277, JString, required = true,
                                 default = nil)
  if valid_569277 != nil:
    section.add "name", valid_569277
  var valid_569278 = path.getOrDefault("subscriptionId")
  valid_569278 = validateParameter(valid_569278, JString, required = true,
                                 default = nil)
  if valid_569278 != nil:
    section.add "subscriptionId", valid_569278
  var valid_569279 = path.getOrDefault("userName")
  valid_569279 = validateParameter(valid_569279, JString, required = true,
                                 default = nil)
  if valid_569279 != nil:
    section.add "userName", valid_569279
  var valid_569280 = path.getOrDefault("labName")
  valid_569280 = validateParameter(valid_569280, JString, required = true,
                                 default = nil)
  if valid_569280 != nil:
    section.add "labName", valid_569280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569281 = query.getOrDefault("api-version")
  valid_569281 = validateParameter(valid_569281, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569281 != nil:
    section.add "api-version", valid_569281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569282: Call_ServiceFabricsListApplicableSchedules_569273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  let valid = call_569282.validator(path, query, header, formData, body)
  let scheme = call_569282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569282.url(scheme.get, call_569282.host, call_569282.base,
                         call_569282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569282, url, valid)

proc call*(call_569283: Call_ServiceFabricsListApplicableSchedules_569273;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsListApplicableSchedules
  ## Lists the applicable start/stop schedules, if any.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569284 = newJObject()
  var query_569285 = newJObject()
  add(path_569284, "resourceGroupName", newJString(resourceGroupName))
  add(query_569285, "api-version", newJString(apiVersion))
  add(path_569284, "name", newJString(name))
  add(path_569284, "subscriptionId", newJString(subscriptionId))
  add(path_569284, "userName", newJString(userName))
  add(path_569284, "labName", newJString(labName))
  result = call_569283.call(path_569284, query_569285, nil, nil, nil)

var serviceFabricsListApplicableSchedules* = Call_ServiceFabricsListApplicableSchedules_569273(
    name: "serviceFabricsListApplicableSchedules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}/listApplicableSchedules",
    validator: validate_ServiceFabricsListApplicableSchedules_569274, base: "",
    url: url_ServiceFabricsListApplicableSchedules_569275, schemes: {Scheme.Https})
type
  Call_ServiceFabricsStart_569286 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricsStart_569288(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsStart_569287(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Start a service fabric. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569289 = path.getOrDefault("resourceGroupName")
  valid_569289 = validateParameter(valid_569289, JString, required = true,
                                 default = nil)
  if valid_569289 != nil:
    section.add "resourceGroupName", valid_569289
  var valid_569290 = path.getOrDefault("name")
  valid_569290 = validateParameter(valid_569290, JString, required = true,
                                 default = nil)
  if valid_569290 != nil:
    section.add "name", valid_569290
  var valid_569291 = path.getOrDefault("subscriptionId")
  valid_569291 = validateParameter(valid_569291, JString, required = true,
                                 default = nil)
  if valid_569291 != nil:
    section.add "subscriptionId", valid_569291
  var valid_569292 = path.getOrDefault("userName")
  valid_569292 = validateParameter(valid_569292, JString, required = true,
                                 default = nil)
  if valid_569292 != nil:
    section.add "userName", valid_569292
  var valid_569293 = path.getOrDefault("labName")
  valid_569293 = validateParameter(valid_569293, JString, required = true,
                                 default = nil)
  if valid_569293 != nil:
    section.add "labName", valid_569293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569294 = query.getOrDefault("api-version")
  valid_569294 = validateParameter(valid_569294, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569294 != nil:
    section.add "api-version", valid_569294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569295: Call_ServiceFabricsStart_569286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a service fabric. This operation can take a while to complete.
  ## 
  let valid = call_569295.validator(path, query, header, formData, body)
  let scheme = call_569295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569295.url(scheme.get, call_569295.host, call_569295.base,
                         call_569295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569295, url, valid)

proc call*(call_569296: Call_ServiceFabricsStart_569286; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsStart
  ## Start a service fabric. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569297 = newJObject()
  var query_569298 = newJObject()
  add(path_569297, "resourceGroupName", newJString(resourceGroupName))
  add(query_569298, "api-version", newJString(apiVersion))
  add(path_569297, "name", newJString(name))
  add(path_569297, "subscriptionId", newJString(subscriptionId))
  add(path_569297, "userName", newJString(userName))
  add(path_569297, "labName", newJString(labName))
  result = call_569296.call(path_569297, query_569298, nil, nil, nil)

var serviceFabricsStart* = Call_ServiceFabricsStart_569286(
    name: "serviceFabricsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}/start",
    validator: validate_ServiceFabricsStart_569287, base: "",
    url: url_ServiceFabricsStart_569288, schemes: {Scheme.Https})
type
  Call_ServiceFabricsStop_569299 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricsStop_569301(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricsStop_569300(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Stop a service fabric This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   userName: JString (required)
  ##           : The name of the user profile.
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
  var valid_569303 = path.getOrDefault("name")
  valid_569303 = validateParameter(valid_569303, JString, required = true,
                                 default = nil)
  if valid_569303 != nil:
    section.add "name", valid_569303
  var valid_569304 = path.getOrDefault("subscriptionId")
  valid_569304 = validateParameter(valid_569304, JString, required = true,
                                 default = nil)
  if valid_569304 != nil:
    section.add "subscriptionId", valid_569304
  var valid_569305 = path.getOrDefault("userName")
  valid_569305 = validateParameter(valid_569305, JString, required = true,
                                 default = nil)
  if valid_569305 != nil:
    section.add "userName", valid_569305
  var valid_569306 = path.getOrDefault("labName")
  valid_569306 = validateParameter(valid_569306, JString, required = true,
                                 default = nil)
  if valid_569306 != nil:
    section.add "labName", valid_569306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569307 = query.getOrDefault("api-version")
  valid_569307 = validateParameter(valid_569307, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569307 != nil:
    section.add "api-version", valid_569307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569308: Call_ServiceFabricsStop_569299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a service fabric This operation can take a while to complete.
  ## 
  let valid = call_569308.validator(path, query, header, formData, body)
  let scheme = call_569308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569308.url(scheme.get, call_569308.host, call_569308.base,
                         call_569308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569308, url, valid)

proc call*(call_569309: Call_ServiceFabricsStop_569299; resourceGroupName: string;
          name: string; subscriptionId: string; userName: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsStop
  ## Stop a service fabric This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569310 = newJObject()
  var query_569311 = newJObject()
  add(path_569310, "resourceGroupName", newJString(resourceGroupName))
  add(query_569311, "api-version", newJString(apiVersion))
  add(path_569310, "name", newJString(name))
  add(path_569310, "subscriptionId", newJString(subscriptionId))
  add(path_569310, "userName", newJString(userName))
  add(path_569310, "labName", newJString(labName))
  result = call_569309.call(path_569310, query_569311, nil, nil, nil)

var serviceFabricsStop* = Call_ServiceFabricsStop_569299(
    name: "serviceFabricsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}/stop",
    validator: validate_ServiceFabricsStop_569300, base: "",
    url: url_ServiceFabricsStop_569301, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesList_569312 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricSchedulesList_569314(protocol: Scheme; host: string;
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
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevTestLab/labs/"),
               (kind: VariableSegment, value: "labName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userName"),
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesList_569313(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a given service fabric.
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
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569315 = path.getOrDefault("resourceGroupName")
  valid_569315 = validateParameter(valid_569315, JString, required = true,
                                 default = nil)
  if valid_569315 != nil:
    section.add "resourceGroupName", valid_569315
  var valid_569316 = path.getOrDefault("subscriptionId")
  valid_569316 = validateParameter(valid_569316, JString, required = true,
                                 default = nil)
  if valid_569316 != nil:
    section.add "subscriptionId", valid_569316
  var valid_569317 = path.getOrDefault("userName")
  valid_569317 = validateParameter(valid_569317, JString, required = true,
                                 default = nil)
  if valid_569317 != nil:
    section.add "userName", valid_569317
  var valid_569318 = path.getOrDefault("labName")
  valid_569318 = validateParameter(valid_569318, JString, required = true,
                                 default = nil)
  if valid_569318 != nil:
    section.add "labName", valid_569318
  var valid_569319 = path.getOrDefault("serviceFabricName")
  valid_569319 = validateParameter(valid_569319, JString, required = true,
                                 default = nil)
  if valid_569319 != nil:
    section.add "serviceFabricName", valid_569319
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_569320 = query.getOrDefault("$orderby")
  valid_569320 = validateParameter(valid_569320, JString, required = false,
                                 default = nil)
  if valid_569320 != nil:
    section.add "$orderby", valid_569320
  var valid_569321 = query.getOrDefault("$expand")
  valid_569321 = validateParameter(valid_569321, JString, required = false,
                                 default = nil)
  if valid_569321 != nil:
    section.add "$expand", valid_569321
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569322 = query.getOrDefault("api-version")
  valid_569322 = validateParameter(valid_569322, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569322 != nil:
    section.add "api-version", valid_569322
  var valid_569323 = query.getOrDefault("$top")
  valid_569323 = validateParameter(valid_569323, JInt, required = false, default = nil)
  if valid_569323 != nil:
    section.add "$top", valid_569323
  var valid_569324 = query.getOrDefault("$filter")
  valid_569324 = validateParameter(valid_569324, JString, required = false,
                                 default = nil)
  if valid_569324 != nil:
    section.add "$filter", valid_569324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569325: Call_ServiceFabricSchedulesList_569312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given service fabric.
  ## 
  let valid = call_569325.validator(path, query, header, formData, body)
  let scheme = call_569325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569325.url(scheme.get, call_569325.host, call_569325.base,
                         call_569325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569325, url, valid)

proc call*(call_569326: Call_ServiceFabricSchedulesList_569312;
          resourceGroupName: string; subscriptionId: string; userName: string;
          labName: string; serviceFabricName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## serviceFabricSchedulesList
  ## List schedules in a given service fabric.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_569327 = newJObject()
  var query_569328 = newJObject()
  add(query_569328, "$orderby", newJString(Orderby))
  add(path_569327, "resourceGroupName", newJString(resourceGroupName))
  add(query_569328, "$expand", newJString(Expand))
  add(query_569328, "api-version", newJString(apiVersion))
  add(path_569327, "subscriptionId", newJString(subscriptionId))
  add(query_569328, "$top", newJInt(Top))
  add(path_569327, "userName", newJString(userName))
  add(path_569327, "labName", newJString(labName))
  add(path_569327, "serviceFabricName", newJString(serviceFabricName))
  add(query_569328, "$filter", newJString(Filter))
  result = call_569326.call(path_569327, query_569328, nil, nil, nil)

var serviceFabricSchedulesList* = Call_ServiceFabricSchedulesList_569312(
    name: "serviceFabricSchedulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules",
    validator: validate_ServiceFabricSchedulesList_569313, base: "",
    url: url_ServiceFabricSchedulesList_569314, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesCreateOrUpdate_569344 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricSchedulesCreateOrUpdate_569346(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "labName" in path, "`labName` is a required path parameter"
  assert "userName" in path, "`userName` is a required path parameter"
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesCreateOrUpdate_569345(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569347 = path.getOrDefault("resourceGroupName")
  valid_569347 = validateParameter(valid_569347, JString, required = true,
                                 default = nil)
  if valid_569347 != nil:
    section.add "resourceGroupName", valid_569347
  var valid_569348 = path.getOrDefault("name")
  valid_569348 = validateParameter(valid_569348, JString, required = true,
                                 default = nil)
  if valid_569348 != nil:
    section.add "name", valid_569348
  var valid_569349 = path.getOrDefault("subscriptionId")
  valid_569349 = validateParameter(valid_569349, JString, required = true,
                                 default = nil)
  if valid_569349 != nil:
    section.add "subscriptionId", valid_569349
  var valid_569350 = path.getOrDefault("userName")
  valid_569350 = validateParameter(valid_569350, JString, required = true,
                                 default = nil)
  if valid_569350 != nil:
    section.add "userName", valid_569350
  var valid_569351 = path.getOrDefault("labName")
  valid_569351 = validateParameter(valid_569351, JString, required = true,
                                 default = nil)
  if valid_569351 != nil:
    section.add "labName", valid_569351
  var valid_569352 = path.getOrDefault("serviceFabricName")
  valid_569352 = validateParameter(valid_569352, JString, required = true,
                                 default = nil)
  if valid_569352 != nil:
    section.add "serviceFabricName", valid_569352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569353 = query.getOrDefault("api-version")
  valid_569353 = validateParameter(valid_569353, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569353 != nil:
    section.add "api-version", valid_569353
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

proc call*(call_569355: Call_ServiceFabricSchedulesCreateOrUpdate_569344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_569355.validator(path, query, header, formData, body)
  let scheme = call_569355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569355.url(scheme.get, call_569355.host, call_569355.base,
                         call_569355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569355, url, valid)

proc call*(call_569356: Call_ServiceFabricSchedulesCreateOrUpdate_569344;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; schedule: JsonNode;
          serviceFabricName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_569357 = newJObject()
  var query_569358 = newJObject()
  var body_569359 = newJObject()
  add(path_569357, "resourceGroupName", newJString(resourceGroupName))
  add(query_569358, "api-version", newJString(apiVersion))
  add(path_569357, "name", newJString(name))
  add(path_569357, "subscriptionId", newJString(subscriptionId))
  add(path_569357, "userName", newJString(userName))
  add(path_569357, "labName", newJString(labName))
  if schedule != nil:
    body_569359 = schedule
  add(path_569357, "serviceFabricName", newJString(serviceFabricName))
  result = call_569356.call(path_569357, query_569358, nil, nil, body_569359)

var serviceFabricSchedulesCreateOrUpdate* = Call_ServiceFabricSchedulesCreateOrUpdate_569344(
    name: "serviceFabricSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesCreateOrUpdate_569345, base: "",
    url: url_ServiceFabricSchedulesCreateOrUpdate_569346, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesGet_569329 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricSchedulesGet_569331(protocol: Scheme; host: string;
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
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesGet_569330(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569332 = path.getOrDefault("resourceGroupName")
  valid_569332 = validateParameter(valid_569332, JString, required = true,
                                 default = nil)
  if valid_569332 != nil:
    section.add "resourceGroupName", valid_569332
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
  var valid_569335 = path.getOrDefault("userName")
  valid_569335 = validateParameter(valid_569335, JString, required = true,
                                 default = nil)
  if valid_569335 != nil:
    section.add "userName", valid_569335
  var valid_569336 = path.getOrDefault("labName")
  valid_569336 = validateParameter(valid_569336, JString, required = true,
                                 default = nil)
  if valid_569336 != nil:
    section.add "labName", valid_569336
  var valid_569337 = path.getOrDefault("serviceFabricName")
  valid_569337 = validateParameter(valid_569337, JString, required = true,
                                 default = nil)
  if valid_569337 != nil:
    section.add "serviceFabricName", valid_569337
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569338 = query.getOrDefault("$expand")
  valid_569338 = validateParameter(valid_569338, JString, required = false,
                                 default = nil)
  if valid_569338 != nil:
    section.add "$expand", valid_569338
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569339 = query.getOrDefault("api-version")
  valid_569339 = validateParameter(valid_569339, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569339 != nil:
    section.add "api-version", valid_569339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569340: Call_ServiceFabricSchedulesGet_569329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_569340.validator(path, query, header, formData, body)
  let scheme = call_569340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569340.url(scheme.get, call_569340.host, call_569340.base,
                         call_569340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569340, url, valid)

proc call*(call_569341: Call_ServiceFabricSchedulesGet_569329;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; serviceFabricName: string;
          Expand: string = ""; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesGet
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
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_569342 = newJObject()
  var query_569343 = newJObject()
  add(path_569342, "resourceGroupName", newJString(resourceGroupName))
  add(query_569343, "$expand", newJString(Expand))
  add(path_569342, "name", newJString(name))
  add(query_569343, "api-version", newJString(apiVersion))
  add(path_569342, "subscriptionId", newJString(subscriptionId))
  add(path_569342, "userName", newJString(userName))
  add(path_569342, "labName", newJString(labName))
  add(path_569342, "serviceFabricName", newJString(serviceFabricName))
  result = call_569341.call(path_569342, query_569343, nil, nil, nil)

var serviceFabricSchedulesGet* = Call_ServiceFabricSchedulesGet_569329(
    name: "serviceFabricSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesGet_569330, base: "",
    url: url_ServiceFabricSchedulesGet_569331, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesUpdate_569374 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricSchedulesUpdate_569376(protocol: Scheme; host: string;
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
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesUpdate_569375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569377 = path.getOrDefault("resourceGroupName")
  valid_569377 = validateParameter(valid_569377, JString, required = true,
                                 default = nil)
  if valid_569377 != nil:
    section.add "resourceGroupName", valid_569377
  var valid_569378 = path.getOrDefault("name")
  valid_569378 = validateParameter(valid_569378, JString, required = true,
                                 default = nil)
  if valid_569378 != nil:
    section.add "name", valid_569378
  var valid_569379 = path.getOrDefault("subscriptionId")
  valid_569379 = validateParameter(valid_569379, JString, required = true,
                                 default = nil)
  if valid_569379 != nil:
    section.add "subscriptionId", valid_569379
  var valid_569380 = path.getOrDefault("userName")
  valid_569380 = validateParameter(valid_569380, JString, required = true,
                                 default = nil)
  if valid_569380 != nil:
    section.add "userName", valid_569380
  var valid_569381 = path.getOrDefault("labName")
  valid_569381 = validateParameter(valid_569381, JString, required = true,
                                 default = nil)
  if valid_569381 != nil:
    section.add "labName", valid_569381
  var valid_569382 = path.getOrDefault("serviceFabricName")
  valid_569382 = validateParameter(valid_569382, JString, required = true,
                                 default = nil)
  if valid_569382 != nil:
    section.add "serviceFabricName", valid_569382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569383 = query.getOrDefault("api-version")
  valid_569383 = validateParameter(valid_569383, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569383 != nil:
    section.add "api-version", valid_569383
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

proc call*(call_569385: Call_ServiceFabricSchedulesUpdate_569374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_569385.validator(path, query, header, formData, body)
  let scheme = call_569385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569385.url(scheme.get, call_569385.host, call_569385.base,
                         call_569385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569385, url, valid)

proc call*(call_569386: Call_ServiceFabricSchedulesUpdate_569374;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; schedule: JsonNode;
          serviceFabricName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   schedule: JObject (required)
  ##           : A schedule.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_569387 = newJObject()
  var query_569388 = newJObject()
  var body_569389 = newJObject()
  add(path_569387, "resourceGroupName", newJString(resourceGroupName))
  add(query_569388, "api-version", newJString(apiVersion))
  add(path_569387, "name", newJString(name))
  add(path_569387, "subscriptionId", newJString(subscriptionId))
  add(path_569387, "userName", newJString(userName))
  add(path_569387, "labName", newJString(labName))
  if schedule != nil:
    body_569389 = schedule
  add(path_569387, "serviceFabricName", newJString(serviceFabricName))
  result = call_569386.call(path_569387, query_569388, nil, nil, body_569389)

var serviceFabricSchedulesUpdate* = Call_ServiceFabricSchedulesUpdate_569374(
    name: "serviceFabricSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesUpdate_569375, base: "",
    url: url_ServiceFabricSchedulesUpdate_569376, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesDelete_569360 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricSchedulesDelete_569362(protocol: Scheme; host: string;
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
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesDelete_569361(path: JsonNode; query: JsonNode;
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
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569363 = path.getOrDefault("resourceGroupName")
  valid_569363 = validateParameter(valid_569363, JString, required = true,
                                 default = nil)
  if valid_569363 != nil:
    section.add "resourceGroupName", valid_569363
  var valid_569364 = path.getOrDefault("name")
  valid_569364 = validateParameter(valid_569364, JString, required = true,
                                 default = nil)
  if valid_569364 != nil:
    section.add "name", valid_569364
  var valid_569365 = path.getOrDefault("subscriptionId")
  valid_569365 = validateParameter(valid_569365, JString, required = true,
                                 default = nil)
  if valid_569365 != nil:
    section.add "subscriptionId", valid_569365
  var valid_569366 = path.getOrDefault("userName")
  valid_569366 = validateParameter(valid_569366, JString, required = true,
                                 default = nil)
  if valid_569366 != nil:
    section.add "userName", valid_569366
  var valid_569367 = path.getOrDefault("labName")
  valid_569367 = validateParameter(valid_569367, JString, required = true,
                                 default = nil)
  if valid_569367 != nil:
    section.add "labName", valid_569367
  var valid_569368 = path.getOrDefault("serviceFabricName")
  valid_569368 = validateParameter(valid_569368, JString, required = true,
                                 default = nil)
  if valid_569368 != nil:
    section.add "serviceFabricName", valid_569368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569369 = query.getOrDefault("api-version")
  valid_569369 = validateParameter(valid_569369, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569369 != nil:
    section.add "api-version", valid_569369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569370: Call_ServiceFabricSchedulesDelete_569360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_569370.validator(path, query, header, formData, body)
  let scheme = call_569370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569370.url(scheme.get, call_569370.host, call_569370.base,
                         call_569370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569370, url, valid)

proc call*(call_569371: Call_ServiceFabricSchedulesDelete_569360;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; serviceFabricName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesDelete
  ## Delete schedule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_569372 = newJObject()
  var query_569373 = newJObject()
  add(path_569372, "resourceGroupName", newJString(resourceGroupName))
  add(query_569373, "api-version", newJString(apiVersion))
  add(path_569372, "name", newJString(name))
  add(path_569372, "subscriptionId", newJString(subscriptionId))
  add(path_569372, "userName", newJString(userName))
  add(path_569372, "labName", newJString(labName))
  add(path_569372, "serviceFabricName", newJString(serviceFabricName))
  result = call_569371.call(path_569372, query_569373, nil, nil, nil)

var serviceFabricSchedulesDelete* = Call_ServiceFabricSchedulesDelete_569360(
    name: "serviceFabricSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesDelete_569361, base: "",
    url: url_ServiceFabricSchedulesDelete_569362, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesExecute_569390 = ref object of OpenApiRestCall_567666
proc url_ServiceFabricSchedulesExecute_569392(protocol: Scheme; host: string;
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
  assert "serviceFabricName" in path,
        "`serviceFabricName` is a required path parameter"
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
               (kind: ConstantSegment, value: "/servicefabrics/"),
               (kind: VariableSegment, value: "serviceFabricName"),
               (kind: ConstantSegment, value: "/schedules/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/execute")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFabricSchedulesExecute_569391(path: JsonNode; query: JsonNode;
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
  ##   userName: JString (required)
  ##           : The name of the user profile.
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569393 = path.getOrDefault("resourceGroupName")
  valid_569393 = validateParameter(valid_569393, JString, required = true,
                                 default = nil)
  if valid_569393 != nil:
    section.add "resourceGroupName", valid_569393
  var valid_569394 = path.getOrDefault("name")
  valid_569394 = validateParameter(valid_569394, JString, required = true,
                                 default = nil)
  if valid_569394 != nil:
    section.add "name", valid_569394
  var valid_569395 = path.getOrDefault("subscriptionId")
  valid_569395 = validateParameter(valid_569395, JString, required = true,
                                 default = nil)
  if valid_569395 != nil:
    section.add "subscriptionId", valid_569395
  var valid_569396 = path.getOrDefault("userName")
  valid_569396 = validateParameter(valid_569396, JString, required = true,
                                 default = nil)
  if valid_569396 != nil:
    section.add "userName", valid_569396
  var valid_569397 = path.getOrDefault("labName")
  valid_569397 = validateParameter(valid_569397, JString, required = true,
                                 default = nil)
  if valid_569397 != nil:
    section.add "labName", valid_569397
  var valid_569398 = path.getOrDefault("serviceFabricName")
  valid_569398 = validateParameter(valid_569398, JString, required = true,
                                 default = nil)
  if valid_569398 != nil:
    section.add "serviceFabricName", valid_569398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569399 = query.getOrDefault("api-version")
  valid_569399 = validateParameter(valid_569399, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569399 != nil:
    section.add "api-version", valid_569399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569400: Call_ServiceFabricSchedulesExecute_569390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_569400.validator(path, query, header, formData, body)
  let scheme = call_569400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569400.url(scheme.get, call_569400.host, call_569400.base,
                         call_569400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569400, url, valid)

proc call*(call_569401: Call_ServiceFabricSchedulesExecute_569390;
          resourceGroupName: string; name: string; subscriptionId: string;
          userName: string; labName: string; serviceFabricName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  var path_569402 = newJObject()
  var query_569403 = newJObject()
  add(path_569402, "resourceGroupName", newJString(resourceGroupName))
  add(query_569403, "api-version", newJString(apiVersion))
  add(path_569402, "name", newJString(name))
  add(path_569402, "subscriptionId", newJString(subscriptionId))
  add(path_569402, "userName", newJString(userName))
  add(path_569402, "labName", newJString(labName))
  add(path_569402, "serviceFabricName", newJString(serviceFabricName))
  result = call_569401.call(path_569402, query_569403, nil, nil, nil)

var serviceFabricSchedulesExecute* = Call_ServiceFabricSchedulesExecute_569390(
    name: "serviceFabricSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}/execute",
    validator: validate_ServiceFabricSchedulesExecute_569391, base: "",
    url: url_ServiceFabricSchedulesExecute_569392, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_569404 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesList_569406(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesList_569405(path: JsonNode; query: JsonNode;
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
  var valid_569407 = path.getOrDefault("resourceGroupName")
  valid_569407 = validateParameter(valid_569407, JString, required = true,
                                 default = nil)
  if valid_569407 != nil:
    section.add "resourceGroupName", valid_569407
  var valid_569408 = path.getOrDefault("subscriptionId")
  valid_569408 = validateParameter(valid_569408, JString, required = true,
                                 default = nil)
  if valid_569408 != nil:
    section.add "subscriptionId", valid_569408
  var valid_569409 = path.getOrDefault("labName")
  valid_569409 = validateParameter(valid_569409, JString, required = true,
                                 default = nil)
  if valid_569409 != nil:
    section.add "labName", valid_569409
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_569410 = query.getOrDefault("$orderby")
  valid_569410 = validateParameter(valid_569410, JString, required = false,
                                 default = nil)
  if valid_569410 != nil:
    section.add "$orderby", valid_569410
  var valid_569411 = query.getOrDefault("$expand")
  valid_569411 = validateParameter(valid_569411, JString, required = false,
                                 default = nil)
  if valid_569411 != nil:
    section.add "$expand", valid_569411
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569412 = query.getOrDefault("api-version")
  valid_569412 = validateParameter(valid_569412, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569412 != nil:
    section.add "api-version", valid_569412
  var valid_569413 = query.getOrDefault("$top")
  valid_569413 = validateParameter(valid_569413, JInt, required = false, default = nil)
  if valid_569413 != nil:
    section.add "$top", valid_569413
  var valid_569414 = query.getOrDefault("$filter")
  valid_569414 = validateParameter(valid_569414, JString, required = false,
                                 default = nil)
  if valid_569414 != nil:
    section.add "$filter", valid_569414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569415: Call_VirtualMachinesList_569404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual machines in a given lab.
  ## 
  let valid = call_569415.validator(path, query, header, formData, body)
  let scheme = call_569415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569415.url(scheme.get, call_569415.host, call_569415.base,
                         call_569415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569415, url, valid)

proc call*(call_569416: Call_VirtualMachinesList_569404; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachinesList
  ## List virtual machines in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_569417 = newJObject()
  var query_569418 = newJObject()
  add(query_569418, "$orderby", newJString(Orderby))
  add(path_569417, "resourceGroupName", newJString(resourceGroupName))
  add(query_569418, "$expand", newJString(Expand))
  add(query_569418, "api-version", newJString(apiVersion))
  add(path_569417, "subscriptionId", newJString(subscriptionId))
  add(query_569418, "$top", newJInt(Top))
  add(path_569417, "labName", newJString(labName))
  add(query_569418, "$filter", newJString(Filter))
  result = call_569416.call(path_569417, query_569418, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_569404(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines",
    validator: validate_VirtualMachinesList_569405, base: "",
    url: url_VirtualMachinesList_569406, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_569432 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesCreateOrUpdate_569434(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesCreateOrUpdate_569433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing virtual machine. This operation can take a while to complete.
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
  var valid_569435 = path.getOrDefault("resourceGroupName")
  valid_569435 = validateParameter(valid_569435, JString, required = true,
                                 default = nil)
  if valid_569435 != nil:
    section.add "resourceGroupName", valid_569435
  var valid_569436 = path.getOrDefault("name")
  valid_569436 = validateParameter(valid_569436, JString, required = true,
                                 default = nil)
  if valid_569436 != nil:
    section.add "name", valid_569436
  var valid_569437 = path.getOrDefault("subscriptionId")
  valid_569437 = validateParameter(valid_569437, JString, required = true,
                                 default = nil)
  if valid_569437 != nil:
    section.add "subscriptionId", valid_569437
  var valid_569438 = path.getOrDefault("labName")
  valid_569438 = validateParameter(valid_569438, JString, required = true,
                                 default = nil)
  if valid_569438 != nil:
    section.add "labName", valid_569438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569439 = query.getOrDefault("api-version")
  valid_569439 = validateParameter(valid_569439, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569439 != nil:
    section.add "api-version", valid_569439
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

proc call*(call_569441: Call_VirtualMachinesCreateOrUpdate_569432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569441.validator(path, query, header, formData, body)
  let scheme = call_569441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569441.url(scheme.get, call_569441.host, call_569441.base,
                         call_569441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569441, url, valid)

proc call*(call_569442: Call_VirtualMachinesCreateOrUpdate_569432;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesCreateOrUpdate
  ## Create or replace an existing virtual machine. This operation can take a while to complete.
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
  var path_569443 = newJObject()
  var query_569444 = newJObject()
  var body_569445 = newJObject()
  add(path_569443, "resourceGroupName", newJString(resourceGroupName))
  add(query_569444, "api-version", newJString(apiVersion))
  add(path_569443, "name", newJString(name))
  add(path_569443, "subscriptionId", newJString(subscriptionId))
  add(path_569443, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_569445 = labVirtualMachine
  result = call_569442.call(path_569443, query_569444, nil, nil, body_569445)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_569432(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesCreateOrUpdate_569433, base: "",
    url: url_VirtualMachinesCreateOrUpdate_569434, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_569419 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesGet_569421(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesGet_569420(path: JsonNode; query: JsonNode;
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
  var valid_569422 = path.getOrDefault("resourceGroupName")
  valid_569422 = validateParameter(valid_569422, JString, required = true,
                                 default = nil)
  if valid_569422 != nil:
    section.add "resourceGroupName", valid_569422
  var valid_569423 = path.getOrDefault("name")
  valid_569423 = validateParameter(valid_569423, JString, required = true,
                                 default = nil)
  if valid_569423 != nil:
    section.add "name", valid_569423
  var valid_569424 = path.getOrDefault("subscriptionId")
  valid_569424 = validateParameter(valid_569424, JString, required = true,
                                 default = nil)
  if valid_569424 != nil:
    section.add "subscriptionId", valid_569424
  var valid_569425 = path.getOrDefault("labName")
  valid_569425 = validateParameter(valid_569425, JString, required = true,
                                 default = nil)
  if valid_569425 != nil:
    section.add "labName", valid_569425
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569426 = query.getOrDefault("$expand")
  valid_569426 = validateParameter(valid_569426, JString, required = false,
                                 default = nil)
  if valid_569426 != nil:
    section.add "$expand", valid_569426
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569427 = query.getOrDefault("api-version")
  valid_569427 = validateParameter(valid_569427, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569427 != nil:
    section.add "api-version", valid_569427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569428: Call_VirtualMachinesGet_569419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine.
  ## 
  let valid = call_569428.validator(path, query, header, formData, body)
  let scheme = call_569428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569428.url(scheme.get, call_569428.host, call_569428.base,
                         call_569428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569428, url, valid)

proc call*(call_569429: Call_VirtualMachinesGet_569419; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569430 = newJObject()
  var query_569431 = newJObject()
  add(path_569430, "resourceGroupName", newJString(resourceGroupName))
  add(query_569431, "$expand", newJString(Expand))
  add(path_569430, "name", newJString(name))
  add(query_569431, "api-version", newJString(apiVersion))
  add(path_569430, "subscriptionId", newJString(subscriptionId))
  add(path_569430, "labName", newJString(labName))
  result = call_569429.call(path_569430, query_569431, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_569419(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesGet_569420, base: "",
    url: url_VirtualMachinesGet_569421, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_569458 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesUpdate_569460(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUpdate_569459(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of virtual machines. All other properties will be ignored.
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
  var valid_569461 = path.getOrDefault("resourceGroupName")
  valid_569461 = validateParameter(valid_569461, JString, required = true,
                                 default = nil)
  if valid_569461 != nil:
    section.add "resourceGroupName", valid_569461
  var valid_569462 = path.getOrDefault("name")
  valid_569462 = validateParameter(valid_569462, JString, required = true,
                                 default = nil)
  if valid_569462 != nil:
    section.add "name", valid_569462
  var valid_569463 = path.getOrDefault("subscriptionId")
  valid_569463 = validateParameter(valid_569463, JString, required = true,
                                 default = nil)
  if valid_569463 != nil:
    section.add "subscriptionId", valid_569463
  var valid_569464 = path.getOrDefault("labName")
  valid_569464 = validateParameter(valid_569464, JString, required = true,
                                 default = nil)
  if valid_569464 != nil:
    section.add "labName", valid_569464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569465 = query.getOrDefault("api-version")
  valid_569465 = validateParameter(valid_569465, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569465 != nil:
    section.add "api-version", valid_569465
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

proc call*(call_569467: Call_VirtualMachinesUpdate_569458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of virtual machines. All other properties will be ignored.
  ## 
  let valid = call_569467.validator(path, query, header, formData, body)
  let scheme = call_569467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569467.url(scheme.get, call_569467.host, call_569467.base,
                         call_569467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569467, url, valid)

proc call*(call_569468: Call_VirtualMachinesUpdate_569458;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; labVirtualMachine: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesUpdate
  ## Allows modifying tags of virtual machines. All other properties will be ignored.
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
  var path_569469 = newJObject()
  var query_569470 = newJObject()
  var body_569471 = newJObject()
  add(path_569469, "resourceGroupName", newJString(resourceGroupName))
  add(query_569470, "api-version", newJString(apiVersion))
  add(path_569469, "name", newJString(name))
  add(path_569469, "subscriptionId", newJString(subscriptionId))
  add(path_569469, "labName", newJString(labName))
  if labVirtualMachine != nil:
    body_569471 = labVirtualMachine
  result = call_569468.call(path_569469, query_569470, nil, nil, body_569471)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_569458(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesUpdate_569459, base: "",
    url: url_VirtualMachinesUpdate_569460, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_569446 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesDelete_569448(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesDelete_569447(path: JsonNode; query: JsonNode;
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
  var valid_569449 = path.getOrDefault("resourceGroupName")
  valid_569449 = validateParameter(valid_569449, JString, required = true,
                                 default = nil)
  if valid_569449 != nil:
    section.add "resourceGroupName", valid_569449
  var valid_569450 = path.getOrDefault("name")
  valid_569450 = validateParameter(valid_569450, JString, required = true,
                                 default = nil)
  if valid_569450 != nil:
    section.add "name", valid_569450
  var valid_569451 = path.getOrDefault("subscriptionId")
  valid_569451 = validateParameter(valid_569451, JString, required = true,
                                 default = nil)
  if valid_569451 != nil:
    section.add "subscriptionId", valid_569451
  var valid_569452 = path.getOrDefault("labName")
  valid_569452 = validateParameter(valid_569452, JString, required = true,
                                 default = nil)
  if valid_569452 != nil:
    section.add "labName", valid_569452
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569453 = query.getOrDefault("api-version")
  valid_569453 = validateParameter(valid_569453, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569453 != nil:
    section.add "api-version", valid_569453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569454: Call_VirtualMachinesDelete_569446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569454.validator(path, query, header, formData, body)
  let scheme = call_569454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569454.url(scheme.get, call_569454.host, call_569454.base,
                         call_569454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569454, url, valid)

proc call*(call_569455: Call_VirtualMachinesDelete_569446;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569456 = newJObject()
  var query_569457 = newJObject()
  add(path_569456, "resourceGroupName", newJString(resourceGroupName))
  add(query_569457, "api-version", newJString(apiVersion))
  add(path_569456, "name", newJString(name))
  add(path_569456, "subscriptionId", newJString(subscriptionId))
  add(path_569456, "labName", newJString(labName))
  result = call_569455.call(path_569456, query_569457, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_569446(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesDelete_569447, base: "",
    url: url_VirtualMachinesDelete_569448, schemes: {Scheme.Https})
type
  Call_VirtualMachinesAddDataDisk_569472 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesAddDataDisk_569474(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesAddDataDisk_569473(path: JsonNode; query: JsonNode;
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
  var valid_569475 = path.getOrDefault("resourceGroupName")
  valid_569475 = validateParameter(valid_569475, JString, required = true,
                                 default = nil)
  if valid_569475 != nil:
    section.add "resourceGroupName", valid_569475
  var valid_569476 = path.getOrDefault("name")
  valid_569476 = validateParameter(valid_569476, JString, required = true,
                                 default = nil)
  if valid_569476 != nil:
    section.add "name", valid_569476
  var valid_569477 = path.getOrDefault("subscriptionId")
  valid_569477 = validateParameter(valid_569477, JString, required = true,
                                 default = nil)
  if valid_569477 != nil:
    section.add "subscriptionId", valid_569477
  var valid_569478 = path.getOrDefault("labName")
  valid_569478 = validateParameter(valid_569478, JString, required = true,
                                 default = nil)
  if valid_569478 != nil:
    section.add "labName", valid_569478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569479 = query.getOrDefault("api-version")
  valid_569479 = validateParameter(valid_569479, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569479 != nil:
    section.add "api-version", valid_569479
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

proc call*(call_569481: Call_VirtualMachinesAddDataDisk_569472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569481.validator(path, query, header, formData, body)
  let scheme = call_569481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569481.url(scheme.get, call_569481.host, call_569481.base,
                         call_569481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569481, url, valid)

proc call*(call_569482: Call_VirtualMachinesAddDataDisk_569472;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; dataDiskProperties: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569483 = newJObject()
  var query_569484 = newJObject()
  var body_569485 = newJObject()
  add(path_569483, "resourceGroupName", newJString(resourceGroupName))
  add(query_569484, "api-version", newJString(apiVersion))
  add(path_569483, "name", newJString(name))
  add(path_569483, "subscriptionId", newJString(subscriptionId))
  add(path_569483, "labName", newJString(labName))
  if dataDiskProperties != nil:
    body_569485 = dataDiskProperties
  result = call_569482.call(path_569483, query_569484, nil, nil, body_569485)

var virtualMachinesAddDataDisk* = Call_VirtualMachinesAddDataDisk_569472(
    name: "virtualMachinesAddDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/addDataDisk",
    validator: validate_VirtualMachinesAddDataDisk_569473, base: "",
    url: url_VirtualMachinesAddDataDisk_569474, schemes: {Scheme.Https})
type
  Call_VirtualMachinesApplyArtifacts_569486 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesApplyArtifacts_569488(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesApplyArtifacts_569487(path: JsonNode; query: JsonNode;
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
  var valid_569492 = path.getOrDefault("labName")
  valid_569492 = validateParameter(valid_569492, JString, required = true,
                                 default = nil)
  if valid_569492 != nil:
    section.add "labName", valid_569492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569493 = query.getOrDefault("api-version")
  valid_569493 = validateParameter(valid_569493, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569493 != nil:
    section.add "api-version", valid_569493
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

proc call*(call_569495: Call_VirtualMachinesApplyArtifacts_569486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569495.validator(path, query, header, formData, body)
  let scheme = call_569495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569495.url(scheme.get, call_569495.host, call_569495.base,
                         call_569495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569495, url, valid)

proc call*(call_569496: Call_VirtualMachinesApplyArtifacts_569486;
          resourceGroupName: string; name: string; subscriptionId: string;
          applyArtifactsRequest: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569497 = newJObject()
  var query_569498 = newJObject()
  var body_569499 = newJObject()
  add(path_569497, "resourceGroupName", newJString(resourceGroupName))
  add(query_569498, "api-version", newJString(apiVersion))
  add(path_569497, "name", newJString(name))
  add(path_569497, "subscriptionId", newJString(subscriptionId))
  if applyArtifactsRequest != nil:
    body_569499 = applyArtifactsRequest
  add(path_569497, "labName", newJString(labName))
  result = call_569496.call(path_569497, query_569498, nil, nil, body_569499)

var virtualMachinesApplyArtifacts* = Call_VirtualMachinesApplyArtifacts_569486(
    name: "virtualMachinesApplyArtifacts", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/applyArtifacts",
    validator: validate_VirtualMachinesApplyArtifacts_569487, base: "",
    url: url_VirtualMachinesApplyArtifacts_569488, schemes: {Scheme.Https})
type
  Call_VirtualMachinesClaim_569500 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesClaim_569502(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesClaim_569501(path: JsonNode; query: JsonNode;
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
  var valid_569503 = path.getOrDefault("resourceGroupName")
  valid_569503 = validateParameter(valid_569503, JString, required = true,
                                 default = nil)
  if valid_569503 != nil:
    section.add "resourceGroupName", valid_569503
  var valid_569504 = path.getOrDefault("name")
  valid_569504 = validateParameter(valid_569504, JString, required = true,
                                 default = nil)
  if valid_569504 != nil:
    section.add "name", valid_569504
  var valid_569505 = path.getOrDefault("subscriptionId")
  valid_569505 = validateParameter(valid_569505, JString, required = true,
                                 default = nil)
  if valid_569505 != nil:
    section.add "subscriptionId", valid_569505
  var valid_569506 = path.getOrDefault("labName")
  valid_569506 = validateParameter(valid_569506, JString, required = true,
                                 default = nil)
  if valid_569506 != nil:
    section.add "labName", valid_569506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569507 = query.getOrDefault("api-version")
  valid_569507 = validateParameter(valid_569507, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569507 != nil:
    section.add "api-version", valid_569507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569508: Call_VirtualMachinesClaim_569500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  let valid = call_569508.validator(path, query, header, formData, body)
  let scheme = call_569508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569508.url(scheme.get, call_569508.host, call_569508.base,
                         call_569508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569508, url, valid)

proc call*(call_569509: Call_VirtualMachinesClaim_569500;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569510 = newJObject()
  var query_569511 = newJObject()
  add(path_569510, "resourceGroupName", newJString(resourceGroupName))
  add(query_569511, "api-version", newJString(apiVersion))
  add(path_569510, "name", newJString(name))
  add(path_569510, "subscriptionId", newJString(subscriptionId))
  add(path_569510, "labName", newJString(labName))
  result = call_569509.call(path_569510, query_569511, nil, nil, nil)

var virtualMachinesClaim* = Call_VirtualMachinesClaim_569500(
    name: "virtualMachinesClaim", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/claim",
    validator: validate_VirtualMachinesClaim_569501, base: "",
    url: url_VirtualMachinesClaim_569502, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDetachDataDisk_569512 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesDetachDataDisk_569514(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesDetachDataDisk_569513(path: JsonNode; query: JsonNode;
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
  var valid_569515 = path.getOrDefault("resourceGroupName")
  valid_569515 = validateParameter(valid_569515, JString, required = true,
                                 default = nil)
  if valid_569515 != nil:
    section.add "resourceGroupName", valid_569515
  var valid_569516 = path.getOrDefault("name")
  valid_569516 = validateParameter(valid_569516, JString, required = true,
                                 default = nil)
  if valid_569516 != nil:
    section.add "name", valid_569516
  var valid_569517 = path.getOrDefault("subscriptionId")
  valid_569517 = validateParameter(valid_569517, JString, required = true,
                                 default = nil)
  if valid_569517 != nil:
    section.add "subscriptionId", valid_569517
  var valid_569518 = path.getOrDefault("labName")
  valid_569518 = validateParameter(valid_569518, JString, required = true,
                                 default = nil)
  if valid_569518 != nil:
    section.add "labName", valid_569518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569519 = query.getOrDefault("api-version")
  valid_569519 = validateParameter(valid_569519, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569519 != nil:
    section.add "api-version", valid_569519
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

proc call*(call_569521: Call_VirtualMachinesDetachDataDisk_569512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569521.validator(path, query, header, formData, body)
  let scheme = call_569521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569521.url(scheme.get, call_569521.host, call_569521.base,
                         call_569521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569521, url, valid)

proc call*(call_569522: Call_VirtualMachinesDetachDataDisk_569512;
          resourceGroupName: string; name: string; subscriptionId: string;
          detachDataDiskProperties: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569523 = newJObject()
  var query_569524 = newJObject()
  var body_569525 = newJObject()
  add(path_569523, "resourceGroupName", newJString(resourceGroupName))
  add(query_569524, "api-version", newJString(apiVersion))
  add(path_569523, "name", newJString(name))
  add(path_569523, "subscriptionId", newJString(subscriptionId))
  if detachDataDiskProperties != nil:
    body_569525 = detachDataDiskProperties
  add(path_569523, "labName", newJString(labName))
  result = call_569522.call(path_569523, query_569524, nil, nil, body_569525)

var virtualMachinesDetachDataDisk* = Call_VirtualMachinesDetachDataDisk_569512(
    name: "virtualMachinesDetachDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/detachDataDisk",
    validator: validate_VirtualMachinesDetachDataDisk_569513, base: "",
    url: url_VirtualMachinesDetachDataDisk_569514, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGetRdpFileContents_569526 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesGetRdpFileContents_569528(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/getRdpFileContents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesGetRdpFileContents_569527(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a string that represents the contents of the RDP file for the virtual machine
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
  var valid_569529 = path.getOrDefault("resourceGroupName")
  valid_569529 = validateParameter(valid_569529, JString, required = true,
                                 default = nil)
  if valid_569529 != nil:
    section.add "resourceGroupName", valid_569529
  var valid_569530 = path.getOrDefault("name")
  valid_569530 = validateParameter(valid_569530, JString, required = true,
                                 default = nil)
  if valid_569530 != nil:
    section.add "name", valid_569530
  var valid_569531 = path.getOrDefault("subscriptionId")
  valid_569531 = validateParameter(valid_569531, JString, required = true,
                                 default = nil)
  if valid_569531 != nil:
    section.add "subscriptionId", valid_569531
  var valid_569532 = path.getOrDefault("labName")
  valid_569532 = validateParameter(valid_569532, JString, required = true,
                                 default = nil)
  if valid_569532 != nil:
    section.add "labName", valid_569532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569533 = query.getOrDefault("api-version")
  valid_569533 = validateParameter(valid_569533, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569533 != nil:
    section.add "api-version", valid_569533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569534: Call_VirtualMachinesGetRdpFileContents_569526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a string that represents the contents of the RDP file for the virtual machine
  ## 
  let valid = call_569534.validator(path, query, header, formData, body)
  let scheme = call_569534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569534.url(scheme.get, call_569534.host, call_569534.base,
                         call_569534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569534, url, valid)

proc call*(call_569535: Call_VirtualMachinesGetRdpFileContents_569526;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesGetRdpFileContents
  ## Gets a string that represents the contents of the RDP file for the virtual machine
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
  var path_569536 = newJObject()
  var query_569537 = newJObject()
  add(path_569536, "resourceGroupName", newJString(resourceGroupName))
  add(query_569537, "api-version", newJString(apiVersion))
  add(path_569536, "name", newJString(name))
  add(path_569536, "subscriptionId", newJString(subscriptionId))
  add(path_569536, "labName", newJString(labName))
  result = call_569535.call(path_569536, query_569537, nil, nil, nil)

var virtualMachinesGetRdpFileContents* = Call_VirtualMachinesGetRdpFileContents_569526(
    name: "virtualMachinesGetRdpFileContents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/getRdpFileContents",
    validator: validate_VirtualMachinesGetRdpFileContents_569527, base: "",
    url: url_VirtualMachinesGetRdpFileContents_569528, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListApplicableSchedules_569538 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesListApplicableSchedules_569540(protocol: Scheme;
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

proc validate_VirtualMachinesListApplicableSchedules_569539(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the applicable start/stop schedules, if any.
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
  var valid_569541 = path.getOrDefault("resourceGroupName")
  valid_569541 = validateParameter(valid_569541, JString, required = true,
                                 default = nil)
  if valid_569541 != nil:
    section.add "resourceGroupName", valid_569541
  var valid_569542 = path.getOrDefault("name")
  valid_569542 = validateParameter(valid_569542, JString, required = true,
                                 default = nil)
  if valid_569542 != nil:
    section.add "name", valid_569542
  var valid_569543 = path.getOrDefault("subscriptionId")
  valid_569543 = validateParameter(valid_569543, JString, required = true,
                                 default = nil)
  if valid_569543 != nil:
    section.add "subscriptionId", valid_569543
  var valid_569544 = path.getOrDefault("labName")
  valid_569544 = validateParameter(valid_569544, JString, required = true,
                                 default = nil)
  if valid_569544 != nil:
    section.add "labName", valid_569544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569545 = query.getOrDefault("api-version")
  valid_569545 = validateParameter(valid_569545, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569545 != nil:
    section.add "api-version", valid_569545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569546: Call_VirtualMachinesListApplicableSchedules_569538;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  let valid = call_569546.validator(path, query, header, formData, body)
  let scheme = call_569546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569546.url(scheme.get, call_569546.host, call_569546.base,
                         call_569546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569546, url, valid)

proc call*(call_569547: Call_VirtualMachinesListApplicableSchedules_569538;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesListApplicableSchedules
  ## Lists the applicable start/stop schedules, if any.
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
  var path_569548 = newJObject()
  var query_569549 = newJObject()
  add(path_569548, "resourceGroupName", newJString(resourceGroupName))
  add(query_569549, "api-version", newJString(apiVersion))
  add(path_569548, "name", newJString(name))
  add(path_569548, "subscriptionId", newJString(subscriptionId))
  add(path_569548, "labName", newJString(labName))
  result = call_569547.call(path_569548, query_569549, nil, nil, nil)

var virtualMachinesListApplicableSchedules* = Call_VirtualMachinesListApplicableSchedules_569538(
    name: "virtualMachinesListApplicableSchedules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/listApplicableSchedules",
    validator: validate_VirtualMachinesListApplicableSchedules_569539, base: "",
    url: url_VirtualMachinesListApplicableSchedules_569540,
    schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_569550 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesRedeploy_569552(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/redeploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesRedeploy_569551(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redeploy a virtual machine This operation can take a while to complete.
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
  var valid_569553 = path.getOrDefault("resourceGroupName")
  valid_569553 = validateParameter(valid_569553, JString, required = true,
                                 default = nil)
  if valid_569553 != nil:
    section.add "resourceGroupName", valid_569553
  var valid_569554 = path.getOrDefault("name")
  valid_569554 = validateParameter(valid_569554, JString, required = true,
                                 default = nil)
  if valid_569554 != nil:
    section.add "name", valid_569554
  var valid_569555 = path.getOrDefault("subscriptionId")
  valid_569555 = validateParameter(valid_569555, JString, required = true,
                                 default = nil)
  if valid_569555 != nil:
    section.add "subscriptionId", valid_569555
  var valid_569556 = path.getOrDefault("labName")
  valid_569556 = validateParameter(valid_569556, JString, required = true,
                                 default = nil)
  if valid_569556 != nil:
    section.add "labName", valid_569556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569557 = query.getOrDefault("api-version")
  valid_569557 = validateParameter(valid_569557, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569557 != nil:
    section.add "api-version", valid_569557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569558: Call_VirtualMachinesRedeploy_569550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redeploy a virtual machine This operation can take a while to complete.
  ## 
  let valid = call_569558.validator(path, query, header, formData, body)
  let scheme = call_569558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569558.url(scheme.get, call_569558.host, call_569558.base,
                         call_569558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569558, url, valid)

proc call*(call_569559: Call_VirtualMachinesRedeploy_569550;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesRedeploy
  ## Redeploy a virtual machine This operation can take a while to complete.
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
  var path_569560 = newJObject()
  var query_569561 = newJObject()
  add(path_569560, "resourceGroupName", newJString(resourceGroupName))
  add(query_569561, "api-version", newJString(apiVersion))
  add(path_569560, "name", newJString(name))
  add(path_569560, "subscriptionId", newJString(subscriptionId))
  add(path_569560, "labName", newJString(labName))
  result = call_569559.call(path_569560, query_569561, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_569550(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/redeploy",
    validator: validate_VirtualMachinesRedeploy_569551, base: "",
    url: url_VirtualMachinesRedeploy_569552, schemes: {Scheme.Https})
type
  Call_VirtualMachinesResize_569562 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesResize_569564(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesResize_569563(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resize Virtual Machine. This operation can take a while to complete.
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
  var valid_569565 = path.getOrDefault("resourceGroupName")
  valid_569565 = validateParameter(valid_569565, JString, required = true,
                                 default = nil)
  if valid_569565 != nil:
    section.add "resourceGroupName", valid_569565
  var valid_569566 = path.getOrDefault("name")
  valid_569566 = validateParameter(valid_569566, JString, required = true,
                                 default = nil)
  if valid_569566 != nil:
    section.add "name", valid_569566
  var valid_569567 = path.getOrDefault("subscriptionId")
  valid_569567 = validateParameter(valid_569567, JString, required = true,
                                 default = nil)
  if valid_569567 != nil:
    section.add "subscriptionId", valid_569567
  var valid_569568 = path.getOrDefault("labName")
  valid_569568 = validateParameter(valid_569568, JString, required = true,
                                 default = nil)
  if valid_569568 != nil:
    section.add "labName", valid_569568
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569569 = query.getOrDefault("api-version")
  valid_569569 = validateParameter(valid_569569, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569569 != nil:
    section.add "api-version", valid_569569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resizeLabVirtualMachineProperties: JObject (required)
  ##                                    : Request body for resizing a virtual machine.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569571: Call_VirtualMachinesResize_569562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resize Virtual Machine. This operation can take a while to complete.
  ## 
  let valid = call_569571.validator(path, query, header, formData, body)
  let scheme = call_569571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569571.url(scheme.get, call_569571.host, call_569571.base,
                         call_569571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569571, url, valid)

proc call*(call_569572: Call_VirtualMachinesResize_569562;
          resourceGroupName: string; name: string; subscriptionId: string;
          resizeLabVirtualMachineProperties: JsonNode; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesResize
  ## Resize Virtual Machine. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resizeLabVirtualMachineProperties: JObject (required)
  ##                                    : Request body for resizing a virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  var path_569573 = newJObject()
  var query_569574 = newJObject()
  var body_569575 = newJObject()
  add(path_569573, "resourceGroupName", newJString(resourceGroupName))
  add(query_569574, "api-version", newJString(apiVersion))
  add(path_569573, "name", newJString(name))
  add(path_569573, "subscriptionId", newJString(subscriptionId))
  if resizeLabVirtualMachineProperties != nil:
    body_569575 = resizeLabVirtualMachineProperties
  add(path_569573, "labName", newJString(labName))
  result = call_569572.call(path_569573, query_569574, nil, nil, body_569575)

var virtualMachinesResize* = Call_VirtualMachinesResize_569562(
    name: "virtualMachinesResize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/resize",
    validator: validate_VirtualMachinesResize_569563, base: "",
    url: url_VirtualMachinesResize_569564, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_569576 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesRestart_569578(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesRestart_569577(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restart a virtual machine. This operation can take a while to complete.
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
  var valid_569579 = path.getOrDefault("resourceGroupName")
  valid_569579 = validateParameter(valid_569579, JString, required = true,
                                 default = nil)
  if valid_569579 != nil:
    section.add "resourceGroupName", valid_569579
  var valid_569580 = path.getOrDefault("name")
  valid_569580 = validateParameter(valid_569580, JString, required = true,
                                 default = nil)
  if valid_569580 != nil:
    section.add "name", valid_569580
  var valid_569581 = path.getOrDefault("subscriptionId")
  valid_569581 = validateParameter(valid_569581, JString, required = true,
                                 default = nil)
  if valid_569581 != nil:
    section.add "subscriptionId", valid_569581
  var valid_569582 = path.getOrDefault("labName")
  valid_569582 = validateParameter(valid_569582, JString, required = true,
                                 default = nil)
  if valid_569582 != nil:
    section.add "labName", valid_569582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569583 = query.getOrDefault("api-version")
  valid_569583 = validateParameter(valid_569583, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569583 != nil:
    section.add "api-version", valid_569583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569584: Call_VirtualMachinesRestart_569576; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restart a virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569584.validator(path, query, header, formData, body)
  let scheme = call_569584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569584.url(scheme.get, call_569584.host, call_569584.base,
                         call_569584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569584, url, valid)

proc call*(call_569585: Call_VirtualMachinesRestart_569576;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesRestart
  ## Restart a virtual machine. This operation can take a while to complete.
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
  var path_569586 = newJObject()
  var query_569587 = newJObject()
  add(path_569586, "resourceGroupName", newJString(resourceGroupName))
  add(query_569587, "api-version", newJString(apiVersion))
  add(path_569586, "name", newJString(name))
  add(path_569586, "subscriptionId", newJString(subscriptionId))
  add(path_569586, "labName", newJString(labName))
  result = call_569585.call(path_569586, query_569587, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_569576(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/restart",
    validator: validate_VirtualMachinesRestart_569577, base: "",
    url: url_VirtualMachinesRestart_569578, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_569588 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesStart_569590(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStart_569589(path: JsonNode; query: JsonNode;
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
  var valid_569591 = path.getOrDefault("resourceGroupName")
  valid_569591 = validateParameter(valid_569591, JString, required = true,
                                 default = nil)
  if valid_569591 != nil:
    section.add "resourceGroupName", valid_569591
  var valid_569592 = path.getOrDefault("name")
  valid_569592 = validateParameter(valid_569592, JString, required = true,
                                 default = nil)
  if valid_569592 != nil:
    section.add "name", valid_569592
  var valid_569593 = path.getOrDefault("subscriptionId")
  valid_569593 = validateParameter(valid_569593, JString, required = true,
                                 default = nil)
  if valid_569593 != nil:
    section.add "subscriptionId", valid_569593
  var valid_569594 = path.getOrDefault("labName")
  valid_569594 = validateParameter(valid_569594, JString, required = true,
                                 default = nil)
  if valid_569594 != nil:
    section.add "labName", valid_569594
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569595 = query.getOrDefault("api-version")
  valid_569595 = validateParameter(valid_569595, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569595 != nil:
    section.add "api-version", valid_569595
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569596: Call_VirtualMachinesStart_569588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_569596.validator(path, query, header, formData, body)
  let scheme = call_569596.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569596.url(scheme.get, call_569596.host, call_569596.base,
                         call_569596.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569596, url, valid)

proc call*(call_569597: Call_VirtualMachinesStart_569588;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569598 = newJObject()
  var query_569599 = newJObject()
  add(path_569598, "resourceGroupName", newJString(resourceGroupName))
  add(query_569599, "api-version", newJString(apiVersion))
  add(path_569598, "name", newJString(name))
  add(path_569598, "subscriptionId", newJString(subscriptionId))
  add(path_569598, "labName", newJString(labName))
  result = call_569597.call(path_569598, query_569599, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_569588(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/start",
    validator: validate_VirtualMachinesStart_569589, base: "",
    url: url_VirtualMachinesStart_569590, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStop_569600 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesStop_569602(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStop_569601(path: JsonNode; query: JsonNode;
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
  var valid_569603 = path.getOrDefault("resourceGroupName")
  valid_569603 = validateParameter(valid_569603, JString, required = true,
                                 default = nil)
  if valid_569603 != nil:
    section.add "resourceGroupName", valid_569603
  var valid_569604 = path.getOrDefault("name")
  valid_569604 = validateParameter(valid_569604, JString, required = true,
                                 default = nil)
  if valid_569604 != nil:
    section.add "name", valid_569604
  var valid_569605 = path.getOrDefault("subscriptionId")
  valid_569605 = validateParameter(valid_569605, JString, required = true,
                                 default = nil)
  if valid_569605 != nil:
    section.add "subscriptionId", valid_569605
  var valid_569606 = path.getOrDefault("labName")
  valid_569606 = validateParameter(valid_569606, JString, required = true,
                                 default = nil)
  if valid_569606 != nil:
    section.add "labName", valid_569606
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569607 = query.getOrDefault("api-version")
  valid_569607 = validateParameter(valid_569607, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569607 != nil:
    section.add "api-version", valid_569607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569608: Call_VirtualMachinesStop_569600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a virtual machine This operation can take a while to complete.
  ## 
  let valid = call_569608.validator(path, query, header, formData, body)
  let scheme = call_569608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569608.url(scheme.get, call_569608.host, call_569608.base,
                         call_569608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569608, url, valid)

proc call*(call_569609: Call_VirtualMachinesStop_569600; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569610 = newJObject()
  var query_569611 = newJObject()
  add(path_569610, "resourceGroupName", newJString(resourceGroupName))
  add(query_569611, "api-version", newJString(apiVersion))
  add(path_569610, "name", newJString(name))
  add(path_569610, "subscriptionId", newJString(subscriptionId))
  add(path_569610, "labName", newJString(labName))
  result = call_569609.call(path_569610, query_569611, nil, nil, nil)

var virtualMachinesStop* = Call_VirtualMachinesStop_569600(
    name: "virtualMachinesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/stop",
    validator: validate_VirtualMachinesStop_569601, base: "",
    url: url_VirtualMachinesStop_569602, schemes: {Scheme.Https})
type
  Call_VirtualMachinesTransferDisks_569612 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesTransferDisks_569614(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/transferDisks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesTransferDisks_569613(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Transfers all data disks attached to the virtual machine to be owned by the current user. This operation can take a while to complete.
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
  var valid_569615 = path.getOrDefault("resourceGroupName")
  valid_569615 = validateParameter(valid_569615, JString, required = true,
                                 default = nil)
  if valid_569615 != nil:
    section.add "resourceGroupName", valid_569615
  var valid_569616 = path.getOrDefault("name")
  valid_569616 = validateParameter(valid_569616, JString, required = true,
                                 default = nil)
  if valid_569616 != nil:
    section.add "name", valid_569616
  var valid_569617 = path.getOrDefault("subscriptionId")
  valid_569617 = validateParameter(valid_569617, JString, required = true,
                                 default = nil)
  if valid_569617 != nil:
    section.add "subscriptionId", valid_569617
  var valid_569618 = path.getOrDefault("labName")
  valid_569618 = validateParameter(valid_569618, JString, required = true,
                                 default = nil)
  if valid_569618 != nil:
    section.add "labName", valid_569618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569619 = query.getOrDefault("api-version")
  valid_569619 = validateParameter(valid_569619, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569619 != nil:
    section.add "api-version", valid_569619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569620: Call_VirtualMachinesTransferDisks_569612; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Transfers all data disks attached to the virtual machine to be owned by the current user. This operation can take a while to complete.
  ## 
  let valid = call_569620.validator(path, query, header, formData, body)
  let scheme = call_569620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569620.url(scheme.get, call_569620.host, call_569620.base,
                         call_569620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569620, url, valid)

proc call*(call_569621: Call_VirtualMachinesTransferDisks_569612;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesTransferDisks
  ## Transfers all data disks attached to the virtual machine to be owned by the current user. This operation can take a while to complete.
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
  var path_569622 = newJObject()
  var query_569623 = newJObject()
  add(path_569622, "resourceGroupName", newJString(resourceGroupName))
  add(query_569623, "api-version", newJString(apiVersion))
  add(path_569622, "name", newJString(name))
  add(path_569622, "subscriptionId", newJString(subscriptionId))
  add(path_569622, "labName", newJString(labName))
  result = call_569621.call(path_569622, query_569623, nil, nil, nil)

var virtualMachinesTransferDisks* = Call_VirtualMachinesTransferDisks_569612(
    name: "virtualMachinesTransferDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/transferDisks",
    validator: validate_VirtualMachinesTransferDisks_569613, base: "",
    url: url_VirtualMachinesTransferDisks_569614, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUnClaim_569624 = ref object of OpenApiRestCall_567666
proc url_VirtualMachinesUnClaim_569626(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/unClaim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesUnClaim_569625(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Release ownership of an existing virtual machine This operation can take a while to complete.
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
  var valid_569627 = path.getOrDefault("resourceGroupName")
  valid_569627 = validateParameter(valid_569627, JString, required = true,
                                 default = nil)
  if valid_569627 != nil:
    section.add "resourceGroupName", valid_569627
  var valid_569628 = path.getOrDefault("name")
  valid_569628 = validateParameter(valid_569628, JString, required = true,
                                 default = nil)
  if valid_569628 != nil:
    section.add "name", valid_569628
  var valid_569629 = path.getOrDefault("subscriptionId")
  valid_569629 = validateParameter(valid_569629, JString, required = true,
                                 default = nil)
  if valid_569629 != nil:
    section.add "subscriptionId", valid_569629
  var valid_569630 = path.getOrDefault("labName")
  valid_569630 = validateParameter(valid_569630, JString, required = true,
                                 default = nil)
  if valid_569630 != nil:
    section.add "labName", valid_569630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569631 = query.getOrDefault("api-version")
  valid_569631 = validateParameter(valid_569631, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569631 != nil:
    section.add "api-version", valid_569631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569632: Call_VirtualMachinesUnClaim_569624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Release ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  let valid = call_569632.validator(path, query, header, formData, body)
  let scheme = call_569632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569632.url(scheme.get, call_569632.host, call_569632.base,
                         call_569632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569632, url, valid)

proc call*(call_569633: Call_VirtualMachinesUnClaim_569624;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesUnClaim
  ## Release ownership of an existing virtual machine This operation can take a while to complete.
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
  var path_569634 = newJObject()
  var query_569635 = newJObject()
  add(path_569634, "resourceGroupName", newJString(resourceGroupName))
  add(query_569635, "api-version", newJString(apiVersion))
  add(path_569634, "name", newJString(name))
  add(path_569634, "subscriptionId", newJString(subscriptionId))
  add(path_569634, "labName", newJString(labName))
  result = call_569633.call(path_569634, query_569635, nil, nil, nil)

var virtualMachinesUnClaim* = Call_VirtualMachinesUnClaim_569624(
    name: "virtualMachinesUnClaim", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/unClaim",
    validator: validate_VirtualMachinesUnClaim_569625, base: "",
    url: url_VirtualMachinesUnClaim_569626, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesList_569636 = ref object of OpenApiRestCall_567666
proc url_VirtualMachineSchedulesList_569638(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesList_569637(path: JsonNode; query: JsonNode;
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
  var valid_569639 = path.getOrDefault("resourceGroupName")
  valid_569639 = validateParameter(valid_569639, JString, required = true,
                                 default = nil)
  if valid_569639 != nil:
    section.add "resourceGroupName", valid_569639
  var valid_569640 = path.getOrDefault("virtualMachineName")
  valid_569640 = validateParameter(valid_569640, JString, required = true,
                                 default = nil)
  if valid_569640 != nil:
    section.add "virtualMachineName", valid_569640
  var valid_569641 = path.getOrDefault("subscriptionId")
  valid_569641 = validateParameter(valid_569641, JString, required = true,
                                 default = nil)
  if valid_569641 != nil:
    section.add "subscriptionId", valid_569641
  var valid_569642 = path.getOrDefault("labName")
  valid_569642 = validateParameter(valid_569642, JString, required = true,
                                 default = nil)
  if valid_569642 != nil:
    section.add "labName", valid_569642
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_569643 = query.getOrDefault("$orderby")
  valid_569643 = validateParameter(valid_569643, JString, required = false,
                                 default = nil)
  if valid_569643 != nil:
    section.add "$orderby", valid_569643
  var valid_569644 = query.getOrDefault("$expand")
  valid_569644 = validateParameter(valid_569644, JString, required = false,
                                 default = nil)
  if valid_569644 != nil:
    section.add "$expand", valid_569644
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569645 = query.getOrDefault("api-version")
  valid_569645 = validateParameter(valid_569645, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569645 != nil:
    section.add "api-version", valid_569645
  var valid_569646 = query.getOrDefault("$top")
  valid_569646 = validateParameter(valid_569646, JInt, required = false, default = nil)
  if valid_569646 != nil:
    section.add "$top", valid_569646
  var valid_569647 = query.getOrDefault("$filter")
  valid_569647 = validateParameter(valid_569647, JString, required = false,
                                 default = nil)
  if valid_569647 != nil:
    section.add "$filter", valid_569647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569648: Call_VirtualMachineSchedulesList_569636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given virtual machine.
  ## 
  let valid = call_569648.validator(path, query, header, formData, body)
  let scheme = call_569648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569648.url(scheme.get, call_569648.host, call_569648.base,
                         call_569648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569648, url, valid)

proc call*(call_569649: Call_VirtualMachineSchedulesList_569636;
          resourceGroupName: string; virtualMachineName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachineSchedulesList
  ## List schedules in a given virtual machine.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
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
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_569650 = newJObject()
  var query_569651 = newJObject()
  add(query_569651, "$orderby", newJString(Orderby))
  add(path_569650, "resourceGroupName", newJString(resourceGroupName))
  add(query_569651, "$expand", newJString(Expand))
  add(path_569650, "virtualMachineName", newJString(virtualMachineName))
  add(query_569651, "api-version", newJString(apiVersion))
  add(path_569650, "subscriptionId", newJString(subscriptionId))
  add(query_569651, "$top", newJInt(Top))
  add(path_569650, "labName", newJString(labName))
  add(query_569651, "$filter", newJString(Filter))
  result = call_569649.call(path_569650, query_569651, nil, nil, nil)

var virtualMachineSchedulesList* = Call_VirtualMachineSchedulesList_569636(
    name: "virtualMachineSchedulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules",
    validator: validate_VirtualMachineSchedulesList_569637, base: "",
    url: url_VirtualMachineSchedulesList_569638, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesCreateOrUpdate_569666 = ref object of OpenApiRestCall_567666
proc url_VirtualMachineSchedulesCreateOrUpdate_569668(protocol: Scheme;
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

proc validate_VirtualMachineSchedulesCreateOrUpdate_569667(path: JsonNode;
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
  var valid_569669 = path.getOrDefault("resourceGroupName")
  valid_569669 = validateParameter(valid_569669, JString, required = true,
                                 default = nil)
  if valid_569669 != nil:
    section.add "resourceGroupName", valid_569669
  var valid_569670 = path.getOrDefault("virtualMachineName")
  valid_569670 = validateParameter(valid_569670, JString, required = true,
                                 default = nil)
  if valid_569670 != nil:
    section.add "virtualMachineName", valid_569670
  var valid_569671 = path.getOrDefault("name")
  valid_569671 = validateParameter(valid_569671, JString, required = true,
                                 default = nil)
  if valid_569671 != nil:
    section.add "name", valid_569671
  var valid_569672 = path.getOrDefault("subscriptionId")
  valid_569672 = validateParameter(valid_569672, JString, required = true,
                                 default = nil)
  if valid_569672 != nil:
    section.add "subscriptionId", valid_569672
  var valid_569673 = path.getOrDefault("labName")
  valid_569673 = validateParameter(valid_569673, JString, required = true,
                                 default = nil)
  if valid_569673 != nil:
    section.add "labName", valid_569673
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569674 = query.getOrDefault("api-version")
  valid_569674 = validateParameter(valid_569674, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569674 != nil:
    section.add "api-version", valid_569674
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

proc call*(call_569676: Call_VirtualMachineSchedulesCreateOrUpdate_569666;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_569676.validator(path, query, header, formData, body)
  let scheme = call_569676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569676.url(scheme.get, call_569676.host, call_569676.base,
                         call_569676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569676, url, valid)

proc call*(call_569677: Call_VirtualMachineSchedulesCreateOrUpdate_569666;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569678 = newJObject()
  var query_569679 = newJObject()
  var body_569680 = newJObject()
  add(path_569678, "resourceGroupName", newJString(resourceGroupName))
  add(query_569679, "api-version", newJString(apiVersion))
  add(path_569678, "virtualMachineName", newJString(virtualMachineName))
  add(path_569678, "name", newJString(name))
  add(path_569678, "subscriptionId", newJString(subscriptionId))
  add(path_569678, "labName", newJString(labName))
  if schedule != nil:
    body_569680 = schedule
  result = call_569677.call(path_569678, query_569679, nil, nil, body_569680)

var virtualMachineSchedulesCreateOrUpdate* = Call_VirtualMachineSchedulesCreateOrUpdate_569666(
    name: "virtualMachineSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesCreateOrUpdate_569667, base: "",
    url: url_VirtualMachineSchedulesCreateOrUpdate_569668, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesGet_569652 = ref object of OpenApiRestCall_567666
proc url_VirtualMachineSchedulesGet_569654(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesGet_569653(path: JsonNode; query: JsonNode;
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
  var valid_569655 = path.getOrDefault("resourceGroupName")
  valid_569655 = validateParameter(valid_569655, JString, required = true,
                                 default = nil)
  if valid_569655 != nil:
    section.add "resourceGroupName", valid_569655
  var valid_569656 = path.getOrDefault("virtualMachineName")
  valid_569656 = validateParameter(valid_569656, JString, required = true,
                                 default = nil)
  if valid_569656 != nil:
    section.add "virtualMachineName", valid_569656
  var valid_569657 = path.getOrDefault("name")
  valid_569657 = validateParameter(valid_569657, JString, required = true,
                                 default = nil)
  if valid_569657 != nil:
    section.add "name", valid_569657
  var valid_569658 = path.getOrDefault("subscriptionId")
  valid_569658 = validateParameter(valid_569658, JString, required = true,
                                 default = nil)
  if valid_569658 != nil:
    section.add "subscriptionId", valid_569658
  var valid_569659 = path.getOrDefault("labName")
  valid_569659 = validateParameter(valid_569659, JString, required = true,
                                 default = nil)
  if valid_569659 != nil:
    section.add "labName", valid_569659
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569660 = query.getOrDefault("$expand")
  valid_569660 = validateParameter(valid_569660, JString, required = false,
                                 default = nil)
  if valid_569660 != nil:
    section.add "$expand", valid_569660
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569661 = query.getOrDefault("api-version")
  valid_569661 = validateParameter(valid_569661, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569661 != nil:
    section.add "api-version", valid_569661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569662: Call_VirtualMachineSchedulesGet_569652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_569662.validator(path, query, header, formData, body)
  let scheme = call_569662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569662.url(scheme.get, call_569662.host, call_569662.base,
                         call_569662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569662, url, valid)

proc call*(call_569663: Call_VirtualMachineSchedulesGet_569652;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569664 = newJObject()
  var query_569665 = newJObject()
  add(path_569664, "resourceGroupName", newJString(resourceGroupName))
  add(query_569665, "$expand", newJString(Expand))
  add(path_569664, "virtualMachineName", newJString(virtualMachineName))
  add(path_569664, "name", newJString(name))
  add(query_569665, "api-version", newJString(apiVersion))
  add(path_569664, "subscriptionId", newJString(subscriptionId))
  add(path_569664, "labName", newJString(labName))
  result = call_569663.call(path_569664, query_569665, nil, nil, nil)

var virtualMachineSchedulesGet* = Call_VirtualMachineSchedulesGet_569652(
    name: "virtualMachineSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesGet_569653, base: "",
    url: url_VirtualMachineSchedulesGet_569654, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesUpdate_569694 = ref object of OpenApiRestCall_567666
proc url_VirtualMachineSchedulesUpdate_569696(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesUpdate_569695(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var valid_569697 = path.getOrDefault("resourceGroupName")
  valid_569697 = validateParameter(valid_569697, JString, required = true,
                                 default = nil)
  if valid_569697 != nil:
    section.add "resourceGroupName", valid_569697
  var valid_569698 = path.getOrDefault("virtualMachineName")
  valid_569698 = validateParameter(valid_569698, JString, required = true,
                                 default = nil)
  if valid_569698 != nil:
    section.add "virtualMachineName", valid_569698
  var valid_569699 = path.getOrDefault("name")
  valid_569699 = validateParameter(valid_569699, JString, required = true,
                                 default = nil)
  if valid_569699 != nil:
    section.add "name", valid_569699
  var valid_569700 = path.getOrDefault("subscriptionId")
  valid_569700 = validateParameter(valid_569700, JString, required = true,
                                 default = nil)
  if valid_569700 != nil:
    section.add "subscriptionId", valid_569700
  var valid_569701 = path.getOrDefault("labName")
  valid_569701 = validateParameter(valid_569701, JString, required = true,
                                 default = nil)
  if valid_569701 != nil:
    section.add "labName", valid_569701
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569702 = query.getOrDefault("api-version")
  valid_569702 = validateParameter(valid_569702, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569702 != nil:
    section.add "api-version", valid_569702
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

proc call*(call_569704: Call_VirtualMachineSchedulesUpdate_569694; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_569704.validator(path, query, header, formData, body)
  let scheme = call_569704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569704.url(scheme.get, call_569704.host, call_569704.base,
                         call_569704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569704, url, valid)

proc call*(call_569705: Call_VirtualMachineSchedulesUpdate_569694;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachineSchedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var path_569706 = newJObject()
  var query_569707 = newJObject()
  var body_569708 = newJObject()
  add(path_569706, "resourceGroupName", newJString(resourceGroupName))
  add(query_569707, "api-version", newJString(apiVersion))
  add(path_569706, "virtualMachineName", newJString(virtualMachineName))
  add(path_569706, "name", newJString(name))
  add(path_569706, "subscriptionId", newJString(subscriptionId))
  add(path_569706, "labName", newJString(labName))
  if schedule != nil:
    body_569708 = schedule
  result = call_569705.call(path_569706, query_569707, nil, nil, body_569708)

var virtualMachineSchedulesUpdate* = Call_VirtualMachineSchedulesUpdate_569694(
    name: "virtualMachineSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesUpdate_569695, base: "",
    url: url_VirtualMachineSchedulesUpdate_569696, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesDelete_569681 = ref object of OpenApiRestCall_567666
proc url_VirtualMachineSchedulesDelete_569683(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesDelete_569682(path: JsonNode; query: JsonNode;
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
  var valid_569684 = path.getOrDefault("resourceGroupName")
  valid_569684 = validateParameter(valid_569684, JString, required = true,
                                 default = nil)
  if valid_569684 != nil:
    section.add "resourceGroupName", valid_569684
  var valid_569685 = path.getOrDefault("virtualMachineName")
  valid_569685 = validateParameter(valid_569685, JString, required = true,
                                 default = nil)
  if valid_569685 != nil:
    section.add "virtualMachineName", valid_569685
  var valid_569686 = path.getOrDefault("name")
  valid_569686 = validateParameter(valid_569686, JString, required = true,
                                 default = nil)
  if valid_569686 != nil:
    section.add "name", valid_569686
  var valid_569687 = path.getOrDefault("subscriptionId")
  valid_569687 = validateParameter(valid_569687, JString, required = true,
                                 default = nil)
  if valid_569687 != nil:
    section.add "subscriptionId", valid_569687
  var valid_569688 = path.getOrDefault("labName")
  valid_569688 = validateParameter(valid_569688, JString, required = true,
                                 default = nil)
  if valid_569688 != nil:
    section.add "labName", valid_569688
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569689 = query.getOrDefault("api-version")
  valid_569689 = validateParameter(valid_569689, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569689 != nil:
    section.add "api-version", valid_569689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569690: Call_VirtualMachineSchedulesDelete_569681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_569690.validator(path, query, header, formData, body)
  let scheme = call_569690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569690.url(scheme.get, call_569690.host, call_569690.base,
                         call_569690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569690, url, valid)

proc call*(call_569691: Call_VirtualMachineSchedulesDelete_569681;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569692 = newJObject()
  var query_569693 = newJObject()
  add(path_569692, "resourceGroupName", newJString(resourceGroupName))
  add(query_569693, "api-version", newJString(apiVersion))
  add(path_569692, "virtualMachineName", newJString(virtualMachineName))
  add(path_569692, "name", newJString(name))
  add(path_569692, "subscriptionId", newJString(subscriptionId))
  add(path_569692, "labName", newJString(labName))
  result = call_569691.call(path_569692, query_569693, nil, nil, nil)

var virtualMachineSchedulesDelete* = Call_VirtualMachineSchedulesDelete_569681(
    name: "virtualMachineSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesDelete_569682, base: "",
    url: url_VirtualMachineSchedulesDelete_569683, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesExecute_569709 = ref object of OpenApiRestCall_567666
proc url_VirtualMachineSchedulesExecute_569711(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesExecute_569710(path: JsonNode;
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
  var valid_569712 = path.getOrDefault("resourceGroupName")
  valid_569712 = validateParameter(valid_569712, JString, required = true,
                                 default = nil)
  if valid_569712 != nil:
    section.add "resourceGroupName", valid_569712
  var valid_569713 = path.getOrDefault("virtualMachineName")
  valid_569713 = validateParameter(valid_569713, JString, required = true,
                                 default = nil)
  if valid_569713 != nil:
    section.add "virtualMachineName", valid_569713
  var valid_569714 = path.getOrDefault("name")
  valid_569714 = validateParameter(valid_569714, JString, required = true,
                                 default = nil)
  if valid_569714 != nil:
    section.add "name", valid_569714
  var valid_569715 = path.getOrDefault("subscriptionId")
  valid_569715 = validateParameter(valid_569715, JString, required = true,
                                 default = nil)
  if valid_569715 != nil:
    section.add "subscriptionId", valid_569715
  var valid_569716 = path.getOrDefault("labName")
  valid_569716 = validateParameter(valid_569716, JString, required = true,
                                 default = nil)
  if valid_569716 != nil:
    section.add "labName", valid_569716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569717 = query.getOrDefault("api-version")
  valid_569717 = validateParameter(valid_569717, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569717 != nil:
    section.add "api-version", valid_569717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569718: Call_VirtualMachineSchedulesExecute_569709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_569718.validator(path, query, header, formData, body)
  let scheme = call_569718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569718.url(scheme.get, call_569718.host, call_569718.base,
                         call_569718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569718, url, valid)

proc call*(call_569719: Call_VirtualMachineSchedulesExecute_569709;
          resourceGroupName: string; virtualMachineName: string; name: string;
          subscriptionId: string; labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569720 = newJObject()
  var query_569721 = newJObject()
  add(path_569720, "resourceGroupName", newJString(resourceGroupName))
  add(query_569721, "api-version", newJString(apiVersion))
  add(path_569720, "virtualMachineName", newJString(virtualMachineName))
  add(path_569720, "name", newJString(name))
  add(path_569720, "subscriptionId", newJString(subscriptionId))
  add(path_569720, "labName", newJString(labName))
  result = call_569719.call(path_569720, query_569721, nil, nil, nil)

var virtualMachineSchedulesExecute* = Call_VirtualMachineSchedulesExecute_569709(
    name: "virtualMachineSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}/execute",
    validator: validate_VirtualMachineSchedulesExecute_569710, base: "",
    url: url_VirtualMachineSchedulesExecute_569711, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_569722 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworksList_569724(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_569723(path: JsonNode; query: JsonNode;
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
  var valid_569725 = path.getOrDefault("resourceGroupName")
  valid_569725 = validateParameter(valid_569725, JString, required = true,
                                 default = nil)
  if valid_569725 != nil:
    section.add "resourceGroupName", valid_569725
  var valid_569726 = path.getOrDefault("subscriptionId")
  valid_569726 = validateParameter(valid_569726, JString, required = true,
                                 default = nil)
  if valid_569726 != nil:
    section.add "subscriptionId", valid_569726
  var valid_569727 = path.getOrDefault("labName")
  valid_569727 = validateParameter(valid_569727, JString, required = true,
                                 default = nil)
  if valid_569727 != nil:
    section.add "labName", valid_569727
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_569728 = query.getOrDefault("$orderby")
  valid_569728 = validateParameter(valid_569728, JString, required = false,
                                 default = nil)
  if valid_569728 != nil:
    section.add "$orderby", valid_569728
  var valid_569729 = query.getOrDefault("$expand")
  valid_569729 = validateParameter(valid_569729, JString, required = false,
                                 default = nil)
  if valid_569729 != nil:
    section.add "$expand", valid_569729
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569730 = query.getOrDefault("api-version")
  valid_569730 = validateParameter(valid_569730, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569730 != nil:
    section.add "api-version", valid_569730
  var valid_569731 = query.getOrDefault("$top")
  valid_569731 = validateParameter(valid_569731, JInt, required = false, default = nil)
  if valid_569731 != nil:
    section.add "$top", valid_569731
  var valid_569732 = query.getOrDefault("$filter")
  valid_569732 = validateParameter(valid_569732, JString, required = false,
                                 default = nil)
  if valid_569732 != nil:
    section.add "$filter", valid_569732
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569733: Call_VirtualNetworksList_569722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual networks in a given lab.
  ## 
  let valid = call_569733.validator(path, query, header, formData, body)
  let scheme = call_569733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569733.url(scheme.get, call_569733.host, call_569733.base,
                         call_569733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569733, url, valid)

proc call*(call_569734: Call_VirtualNetworksList_569722; resourceGroupName: string;
          subscriptionId: string; labName: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualNetworksList
  ## List virtual networks in a given lab.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_569735 = newJObject()
  var query_569736 = newJObject()
  add(query_569736, "$orderby", newJString(Orderby))
  add(path_569735, "resourceGroupName", newJString(resourceGroupName))
  add(query_569736, "$expand", newJString(Expand))
  add(query_569736, "api-version", newJString(apiVersion))
  add(path_569735, "subscriptionId", newJString(subscriptionId))
  add(query_569736, "$top", newJInt(Top))
  add(path_569735, "labName", newJString(labName))
  add(query_569736, "$filter", newJString(Filter))
  result = call_569734.call(path_569735, query_569736, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_569722(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks",
    validator: validate_VirtualNetworksList_569723, base: "",
    url: url_VirtualNetworksList_569724, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_569750 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworksCreateOrUpdate_569752(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_569751(path: JsonNode; query: JsonNode;
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
  var valid_569753 = path.getOrDefault("resourceGroupName")
  valid_569753 = validateParameter(valid_569753, JString, required = true,
                                 default = nil)
  if valid_569753 != nil:
    section.add "resourceGroupName", valid_569753
  var valid_569754 = path.getOrDefault("name")
  valid_569754 = validateParameter(valid_569754, JString, required = true,
                                 default = nil)
  if valid_569754 != nil:
    section.add "name", valid_569754
  var valid_569755 = path.getOrDefault("subscriptionId")
  valid_569755 = validateParameter(valid_569755, JString, required = true,
                                 default = nil)
  if valid_569755 != nil:
    section.add "subscriptionId", valid_569755
  var valid_569756 = path.getOrDefault("labName")
  valid_569756 = validateParameter(valid_569756, JString, required = true,
                                 default = nil)
  if valid_569756 != nil:
    section.add "labName", valid_569756
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569757 = query.getOrDefault("api-version")
  valid_569757 = validateParameter(valid_569757, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569757 != nil:
    section.add "api-version", valid_569757
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

proc call*(call_569759: Call_VirtualNetworksCreateOrUpdate_569750; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  let valid = call_569759.validator(path, query, header, formData, body)
  let scheme = call_569759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569759.url(scheme.get, call_569759.host, call_569759.base,
                         call_569759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569759, url, valid)

proc call*(call_569760: Call_VirtualNetworksCreateOrUpdate_569750;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569761 = newJObject()
  var query_569762 = newJObject()
  var body_569763 = newJObject()
  add(path_569761, "resourceGroupName", newJString(resourceGroupName))
  add(query_569762, "api-version", newJString(apiVersion))
  add(path_569761, "name", newJString(name))
  add(path_569761, "subscriptionId", newJString(subscriptionId))
  add(path_569761, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_569763 = virtualNetwork
  result = call_569760.call(path_569761, query_569762, nil, nil, body_569763)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_569750(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksCreateOrUpdate_569751, base: "",
    url: url_VirtualNetworksCreateOrUpdate_569752, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_569737 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworksGet_569739(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_569738(path: JsonNode; query: JsonNode;
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
  var valid_569740 = path.getOrDefault("resourceGroupName")
  valid_569740 = validateParameter(valid_569740, JString, required = true,
                                 default = nil)
  if valid_569740 != nil:
    section.add "resourceGroupName", valid_569740
  var valid_569741 = path.getOrDefault("name")
  valid_569741 = validateParameter(valid_569741, JString, required = true,
                                 default = nil)
  if valid_569741 != nil:
    section.add "name", valid_569741
  var valid_569742 = path.getOrDefault("subscriptionId")
  valid_569742 = validateParameter(valid_569742, JString, required = true,
                                 default = nil)
  if valid_569742 != nil:
    section.add "subscriptionId", valid_569742
  var valid_569743 = path.getOrDefault("labName")
  valid_569743 = validateParameter(valid_569743, JString, required = true,
                                 default = nil)
  if valid_569743 != nil:
    section.add "labName", valid_569743
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569744 = query.getOrDefault("$expand")
  valid_569744 = validateParameter(valid_569744, JString, required = false,
                                 default = nil)
  if valid_569744 != nil:
    section.add "$expand", valid_569744
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569745 = query.getOrDefault("api-version")
  valid_569745 = validateParameter(valid_569745, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569745 != nil:
    section.add "api-version", valid_569745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569746: Call_VirtualNetworksGet_569737; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual network.
  ## 
  let valid = call_569746.validator(path, query, header, formData, body)
  let scheme = call_569746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569746.url(scheme.get, call_569746.host, call_569746.base,
                         call_569746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569746, url, valid)

proc call*(call_569747: Call_VirtualNetworksGet_569737; resourceGroupName: string;
          name: string; subscriptionId: string; labName: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569748 = newJObject()
  var query_569749 = newJObject()
  add(path_569748, "resourceGroupName", newJString(resourceGroupName))
  add(query_569749, "$expand", newJString(Expand))
  add(path_569748, "name", newJString(name))
  add(query_569749, "api-version", newJString(apiVersion))
  add(path_569748, "subscriptionId", newJString(subscriptionId))
  add(path_569748, "labName", newJString(labName))
  result = call_569747.call(path_569748, query_569749, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_569737(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksGet_569738, base: "",
    url: url_VirtualNetworksGet_569739, schemes: {Scheme.Https})
type
  Call_VirtualNetworksUpdate_569776 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworksUpdate_569778(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksUpdate_569777(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of virtual networks. All other properties will be ignored.
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
  var valid_569779 = path.getOrDefault("resourceGroupName")
  valid_569779 = validateParameter(valid_569779, JString, required = true,
                                 default = nil)
  if valid_569779 != nil:
    section.add "resourceGroupName", valid_569779
  var valid_569780 = path.getOrDefault("name")
  valid_569780 = validateParameter(valid_569780, JString, required = true,
                                 default = nil)
  if valid_569780 != nil:
    section.add "name", valid_569780
  var valid_569781 = path.getOrDefault("subscriptionId")
  valid_569781 = validateParameter(valid_569781, JString, required = true,
                                 default = nil)
  if valid_569781 != nil:
    section.add "subscriptionId", valid_569781
  var valid_569782 = path.getOrDefault("labName")
  valid_569782 = validateParameter(valid_569782, JString, required = true,
                                 default = nil)
  if valid_569782 != nil:
    section.add "labName", valid_569782
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569783 = query.getOrDefault("api-version")
  valid_569783 = validateParameter(valid_569783, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569783 != nil:
    section.add "api-version", valid_569783
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

proc call*(call_569785: Call_VirtualNetworksUpdate_569776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of virtual networks. All other properties will be ignored.
  ## 
  let valid = call_569785.validator(path, query, header, formData, body)
  let scheme = call_569785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569785.url(scheme.get, call_569785.host, call_569785.base,
                         call_569785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569785, url, valid)

proc call*(call_569786: Call_VirtualNetworksUpdate_569776;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; virtualNetwork: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualNetworksUpdate
  ## Allows modifying tags of virtual networks. All other properties will be ignored.
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
  var path_569787 = newJObject()
  var query_569788 = newJObject()
  var body_569789 = newJObject()
  add(path_569787, "resourceGroupName", newJString(resourceGroupName))
  add(query_569788, "api-version", newJString(apiVersion))
  add(path_569787, "name", newJString(name))
  add(path_569787, "subscriptionId", newJString(subscriptionId))
  add(path_569787, "labName", newJString(labName))
  if virtualNetwork != nil:
    body_569789 = virtualNetwork
  result = call_569786.call(path_569787, query_569788, nil, nil, body_569789)

var virtualNetworksUpdate* = Call_VirtualNetworksUpdate_569776(
    name: "virtualNetworksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksUpdate_569777, base: "",
    url: url_VirtualNetworksUpdate_569778, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_569764 = ref object of OpenApiRestCall_567666
proc url_VirtualNetworksDelete_569766(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_569765(path: JsonNode; query: JsonNode;
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
  var valid_569767 = path.getOrDefault("resourceGroupName")
  valid_569767 = validateParameter(valid_569767, JString, required = true,
                                 default = nil)
  if valid_569767 != nil:
    section.add "resourceGroupName", valid_569767
  var valid_569768 = path.getOrDefault("name")
  valid_569768 = validateParameter(valid_569768, JString, required = true,
                                 default = nil)
  if valid_569768 != nil:
    section.add "name", valid_569768
  var valid_569769 = path.getOrDefault("subscriptionId")
  valid_569769 = validateParameter(valid_569769, JString, required = true,
                                 default = nil)
  if valid_569769 != nil:
    section.add "subscriptionId", valid_569769
  var valid_569770 = path.getOrDefault("labName")
  valid_569770 = validateParameter(valid_569770, JString, required = true,
                                 default = nil)
  if valid_569770 != nil:
    section.add "labName", valid_569770
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569771 = query.getOrDefault("api-version")
  valid_569771 = validateParameter(valid_569771, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569771 != nil:
    section.add "api-version", valid_569771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569772: Call_VirtualNetworksDelete_569764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  let valid = call_569772.validator(path, query, header, formData, body)
  let scheme = call_569772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569772.url(scheme.get, call_569772.host, call_569772.base,
                         call_569772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569772, url, valid)

proc call*(call_569773: Call_VirtualNetworksDelete_569764;
          resourceGroupName: string; name: string; subscriptionId: string;
          labName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569774 = newJObject()
  var query_569775 = newJObject()
  add(path_569774, "resourceGroupName", newJString(resourceGroupName))
  add(query_569775, "api-version", newJString(apiVersion))
  add(path_569774, "name", newJString(name))
  add(path_569774, "subscriptionId", newJString(subscriptionId))
  add(path_569774, "labName", newJString(labName))
  result = call_569773.call(path_569774, query_569775, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_569764(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksDelete_569765, base: "",
    url: url_VirtualNetworksDelete_569766, schemes: {Scheme.Https})
type
  Call_LabsCreateOrUpdate_569802 = ref object of OpenApiRestCall_567666
proc url_LabsCreateOrUpdate_569804(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateOrUpdate_569803(path: JsonNode; query: JsonNode;
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
  var valid_569805 = path.getOrDefault("resourceGroupName")
  valid_569805 = validateParameter(valid_569805, JString, required = true,
                                 default = nil)
  if valid_569805 != nil:
    section.add "resourceGroupName", valid_569805
  var valid_569806 = path.getOrDefault("name")
  valid_569806 = validateParameter(valid_569806, JString, required = true,
                                 default = nil)
  if valid_569806 != nil:
    section.add "name", valid_569806
  var valid_569807 = path.getOrDefault("subscriptionId")
  valid_569807 = validateParameter(valid_569807, JString, required = true,
                                 default = nil)
  if valid_569807 != nil:
    section.add "subscriptionId", valid_569807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569808 = query.getOrDefault("api-version")
  valid_569808 = validateParameter(valid_569808, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569808 != nil:
    section.add "api-version", valid_569808
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

proc call*(call_569810: Call_LabsCreateOrUpdate_569802; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing lab. This operation can take a while to complete.
  ## 
  let valid = call_569810.validator(path, query, header, formData, body)
  let scheme = call_569810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569810.url(scheme.get, call_569810.host, call_569810.base,
                         call_569810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569810, url, valid)

proc call*(call_569811: Call_LabsCreateOrUpdate_569802; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569812 = newJObject()
  var query_569813 = newJObject()
  var body_569814 = newJObject()
  add(path_569812, "resourceGroupName", newJString(resourceGroupName))
  add(query_569813, "api-version", newJString(apiVersion))
  add(path_569812, "name", newJString(name))
  add(path_569812, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_569814 = lab
  result = call_569811.call(path_569812, query_569813, nil, nil, body_569814)

var labsCreateOrUpdate* = Call_LabsCreateOrUpdate_569802(
    name: "labsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabsCreateOrUpdate_569803, base: "",
    url: url_LabsCreateOrUpdate_569804, schemes: {Scheme.Https})
type
  Call_LabsGet_569790 = ref object of OpenApiRestCall_567666
proc url_LabsGet_569792(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsGet_569791(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569793 = path.getOrDefault("resourceGroupName")
  valid_569793 = validateParameter(valid_569793, JString, required = true,
                                 default = nil)
  if valid_569793 != nil:
    section.add "resourceGroupName", valid_569793
  var valid_569794 = path.getOrDefault("name")
  valid_569794 = validateParameter(valid_569794, JString, required = true,
                                 default = nil)
  if valid_569794 != nil:
    section.add "name", valid_569794
  var valid_569795 = path.getOrDefault("subscriptionId")
  valid_569795 = validateParameter(valid_569795, JString, required = true,
                                 default = nil)
  if valid_569795 != nil:
    section.add "subscriptionId", valid_569795
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569796 = query.getOrDefault("$expand")
  valid_569796 = validateParameter(valid_569796, JString, required = false,
                                 default = nil)
  if valid_569796 != nil:
    section.add "$expand", valid_569796
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569797 = query.getOrDefault("api-version")
  valid_569797 = validateParameter(valid_569797, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569797 != nil:
    section.add "api-version", valid_569797
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569798: Call_LabsGet_569790; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab.
  ## 
  let valid = call_569798.validator(path, query, header, formData, body)
  let scheme = call_569798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569798.url(scheme.get, call_569798.host, call_569798.base,
                         call_569798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569798, url, valid)

proc call*(call_569799: Call_LabsGet_569790; resourceGroupName: string; name: string;
          subscriptionId: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569800 = newJObject()
  var query_569801 = newJObject()
  add(path_569800, "resourceGroupName", newJString(resourceGroupName))
  add(query_569801, "$expand", newJString(Expand))
  add(path_569800, "name", newJString(name))
  add(query_569801, "api-version", newJString(apiVersion))
  add(path_569800, "subscriptionId", newJString(subscriptionId))
  result = call_569799.call(path_569800, query_569801, nil, nil, nil)

var labsGet* = Call_LabsGet_569790(name: "labsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                validator: validate_LabsGet_569791, base: "",
                                url: url_LabsGet_569792, schemes: {Scheme.Https})
type
  Call_LabsUpdate_569826 = ref object of OpenApiRestCall_567666
proc url_LabsUpdate_569828(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsUpdate_569827(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of labs. All other properties will be ignored.
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
  var valid_569829 = path.getOrDefault("resourceGroupName")
  valid_569829 = validateParameter(valid_569829, JString, required = true,
                                 default = nil)
  if valid_569829 != nil:
    section.add "resourceGroupName", valid_569829
  var valid_569830 = path.getOrDefault("name")
  valid_569830 = validateParameter(valid_569830, JString, required = true,
                                 default = nil)
  if valid_569830 != nil:
    section.add "name", valid_569830
  var valid_569831 = path.getOrDefault("subscriptionId")
  valid_569831 = validateParameter(valid_569831, JString, required = true,
                                 default = nil)
  if valid_569831 != nil:
    section.add "subscriptionId", valid_569831
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569832 = query.getOrDefault("api-version")
  valid_569832 = validateParameter(valid_569832, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569832 != nil:
    section.add "api-version", valid_569832
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

proc call*(call_569834: Call_LabsUpdate_569826; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of labs. All other properties will be ignored.
  ## 
  let valid = call_569834.validator(path, query, header, formData, body)
  let scheme = call_569834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569834.url(scheme.get, call_569834.host, call_569834.base,
                         call_569834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569834, url, valid)

proc call*(call_569835: Call_LabsUpdate_569826; resourceGroupName: string;
          name: string; subscriptionId: string; lab: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsUpdate
  ## Allows modifying tags of labs. All other properties will be ignored.
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
  var path_569836 = newJObject()
  var query_569837 = newJObject()
  var body_569838 = newJObject()
  add(path_569836, "resourceGroupName", newJString(resourceGroupName))
  add(query_569837, "api-version", newJString(apiVersion))
  add(path_569836, "name", newJString(name))
  add(path_569836, "subscriptionId", newJString(subscriptionId))
  if lab != nil:
    body_569838 = lab
  result = call_569835.call(path_569836, query_569837, nil, nil, body_569838)

var labsUpdate* = Call_LabsUpdate_569826(name: "labsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsUpdate_569827,
                                      base: "", url: url_LabsUpdate_569828,
                                      schemes: {Scheme.Https})
type
  Call_LabsDelete_569815 = ref object of OpenApiRestCall_567666
proc url_LabsDelete_569817(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsDelete_569816(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569818 = path.getOrDefault("resourceGroupName")
  valid_569818 = validateParameter(valid_569818, JString, required = true,
                                 default = nil)
  if valid_569818 != nil:
    section.add "resourceGroupName", valid_569818
  var valid_569819 = path.getOrDefault("name")
  valid_569819 = validateParameter(valid_569819, JString, required = true,
                                 default = nil)
  if valid_569819 != nil:
    section.add "name", valid_569819
  var valid_569820 = path.getOrDefault("subscriptionId")
  valid_569820 = validateParameter(valid_569820, JString, required = true,
                                 default = nil)
  if valid_569820 != nil:
    section.add "subscriptionId", valid_569820
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569821 = query.getOrDefault("api-version")
  valid_569821 = validateParameter(valid_569821, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569821 != nil:
    section.add "api-version", valid_569821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569822: Call_LabsDelete_569815; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete.
  ## 
  let valid = call_569822.validator(path, query, header, formData, body)
  let scheme = call_569822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569822.url(scheme.get, call_569822.host, call_569822.base,
                         call_569822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569822, url, valid)

proc call*(call_569823: Call_LabsDelete_569815; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569824 = newJObject()
  var query_569825 = newJObject()
  add(path_569824, "resourceGroupName", newJString(resourceGroupName))
  add(query_569825, "api-version", newJString(apiVersion))
  add(path_569824, "name", newJString(name))
  add(path_569824, "subscriptionId", newJString(subscriptionId))
  result = call_569823.call(path_569824, query_569825, nil, nil, nil)

var labsDelete* = Call_LabsDelete_569815(name: "labsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsDelete_569816,
                                      base: "", url: url_LabsDelete_569817,
                                      schemes: {Scheme.Https})
type
  Call_LabsClaimAnyVm_569839 = ref object of OpenApiRestCall_567666
proc url_LabsClaimAnyVm_569841(protocol: Scheme; host: string; base: string;
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

proc validate_LabsClaimAnyVm_569840(path: JsonNode; query: JsonNode;
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
  var valid_569842 = path.getOrDefault("resourceGroupName")
  valid_569842 = validateParameter(valid_569842, JString, required = true,
                                 default = nil)
  if valid_569842 != nil:
    section.add "resourceGroupName", valid_569842
  var valid_569843 = path.getOrDefault("name")
  valid_569843 = validateParameter(valid_569843, JString, required = true,
                                 default = nil)
  if valid_569843 != nil:
    section.add "name", valid_569843
  var valid_569844 = path.getOrDefault("subscriptionId")
  valid_569844 = validateParameter(valid_569844, JString, required = true,
                                 default = nil)
  if valid_569844 != nil:
    section.add "subscriptionId", valid_569844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569845 = query.getOrDefault("api-version")
  valid_569845 = validateParameter(valid_569845, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569845 != nil:
    section.add "api-version", valid_569845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569846: Call_LabsClaimAnyVm_569839; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ## 
  let valid = call_569846.validator(path, query, header, formData, body)
  let scheme = call_569846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569846.url(scheme.get, call_569846.host, call_569846.base,
                         call_569846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569846, url, valid)

proc call*(call_569847: Call_LabsClaimAnyVm_569839; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569848 = newJObject()
  var query_569849 = newJObject()
  add(path_569848, "resourceGroupName", newJString(resourceGroupName))
  add(query_569849, "api-version", newJString(apiVersion))
  add(path_569848, "name", newJString(name))
  add(path_569848, "subscriptionId", newJString(subscriptionId))
  result = call_569847.call(path_569848, query_569849, nil, nil, nil)

var labsClaimAnyVm* = Call_LabsClaimAnyVm_569839(name: "labsClaimAnyVm",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/claimAnyVm",
    validator: validate_LabsClaimAnyVm_569840, base: "", url: url_LabsClaimAnyVm_569841,
    schemes: {Scheme.Https})
type
  Call_LabsCreateEnvironment_569850 = ref object of OpenApiRestCall_567666
proc url_LabsCreateEnvironment_569852(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateEnvironment_569851(path: JsonNode; query: JsonNode;
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
  var valid_569853 = path.getOrDefault("resourceGroupName")
  valid_569853 = validateParameter(valid_569853, JString, required = true,
                                 default = nil)
  if valid_569853 != nil:
    section.add "resourceGroupName", valid_569853
  var valid_569854 = path.getOrDefault("name")
  valid_569854 = validateParameter(valid_569854, JString, required = true,
                                 default = nil)
  if valid_569854 != nil:
    section.add "name", valid_569854
  var valid_569855 = path.getOrDefault("subscriptionId")
  valid_569855 = validateParameter(valid_569855, JString, required = true,
                                 default = nil)
  if valid_569855 != nil:
    section.add "subscriptionId", valid_569855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569856 = query.getOrDefault("api-version")
  valid_569856 = validateParameter(valid_569856, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569856 != nil:
    section.add "api-version", valid_569856
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

proc call*(call_569858: Call_LabsCreateEnvironment_569850; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ## 
  let valid = call_569858.validator(path, query, header, formData, body)
  let scheme = call_569858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569858.url(scheme.get, call_569858.host, call_569858.base,
                         call_569858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569858, url, valid)

proc call*(call_569859: Call_LabsCreateEnvironment_569850;
          resourceGroupName: string; name: string;
          labVirtualMachineCreationParameter: JsonNode; subscriptionId: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569860 = newJObject()
  var query_569861 = newJObject()
  var body_569862 = newJObject()
  add(path_569860, "resourceGroupName", newJString(resourceGroupName))
  add(query_569861, "api-version", newJString(apiVersion))
  add(path_569860, "name", newJString(name))
  if labVirtualMachineCreationParameter != nil:
    body_569862 = labVirtualMachineCreationParameter
  add(path_569860, "subscriptionId", newJString(subscriptionId))
  result = call_569859.call(path_569860, query_569861, nil, nil, body_569862)

var labsCreateEnvironment* = Call_LabsCreateEnvironment_569850(
    name: "labsCreateEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment",
    validator: validate_LabsCreateEnvironment_569851, base: "",
    url: url_LabsCreateEnvironment_569852, schemes: {Scheme.Https})
type
  Call_LabsExportResourceUsage_569863 = ref object of OpenApiRestCall_567666
proc url_LabsExportResourceUsage_569865(protocol: Scheme; host: string; base: string;
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

proc validate_LabsExportResourceUsage_569864(path: JsonNode; query: JsonNode;
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
  var valid_569866 = path.getOrDefault("resourceGroupName")
  valid_569866 = validateParameter(valid_569866, JString, required = true,
                                 default = nil)
  if valid_569866 != nil:
    section.add "resourceGroupName", valid_569866
  var valid_569867 = path.getOrDefault("name")
  valid_569867 = validateParameter(valid_569867, JString, required = true,
                                 default = nil)
  if valid_569867 != nil:
    section.add "name", valid_569867
  var valid_569868 = path.getOrDefault("subscriptionId")
  valid_569868 = validateParameter(valid_569868, JString, required = true,
                                 default = nil)
  if valid_569868 != nil:
    section.add "subscriptionId", valid_569868
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569869 = query.getOrDefault("api-version")
  valid_569869 = validateParameter(valid_569869, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569869 != nil:
    section.add "api-version", valid_569869
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

proc call*(call_569871: Call_LabsExportResourceUsage_569863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ## 
  let valid = call_569871.validator(path, query, header, formData, body)
  let scheme = call_569871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569871.url(scheme.get, call_569871.host, call_569871.base,
                         call_569871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569871, url, valid)

proc call*(call_569872: Call_LabsExportResourceUsage_569863;
          resourceGroupName: string; name: string; subscriptionId: string;
          exportResourceUsageParameters: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569873 = newJObject()
  var query_569874 = newJObject()
  var body_569875 = newJObject()
  add(path_569873, "resourceGroupName", newJString(resourceGroupName))
  add(query_569874, "api-version", newJString(apiVersion))
  add(path_569873, "name", newJString(name))
  add(path_569873, "subscriptionId", newJString(subscriptionId))
  if exportResourceUsageParameters != nil:
    body_569875 = exportResourceUsageParameters
  result = call_569872.call(path_569873, query_569874, nil, nil, body_569875)

var labsExportResourceUsage* = Call_LabsExportResourceUsage_569863(
    name: "labsExportResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/exportResourceUsage",
    validator: validate_LabsExportResourceUsage_569864, base: "",
    url: url_LabsExportResourceUsage_569865, schemes: {Scheme.Https})
type
  Call_LabsGenerateUploadUri_569876 = ref object of OpenApiRestCall_567666
proc url_LabsGenerateUploadUri_569878(protocol: Scheme; host: string; base: string;
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

proc validate_LabsGenerateUploadUri_569877(path: JsonNode; query: JsonNode;
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
  var valid_569879 = path.getOrDefault("resourceGroupName")
  valid_569879 = validateParameter(valid_569879, JString, required = true,
                                 default = nil)
  if valid_569879 != nil:
    section.add "resourceGroupName", valid_569879
  var valid_569880 = path.getOrDefault("name")
  valid_569880 = validateParameter(valid_569880, JString, required = true,
                                 default = nil)
  if valid_569880 != nil:
    section.add "name", valid_569880
  var valid_569881 = path.getOrDefault("subscriptionId")
  valid_569881 = validateParameter(valid_569881, JString, required = true,
                                 default = nil)
  if valid_569881 != nil:
    section.add "subscriptionId", valid_569881
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569882 = query.getOrDefault("api-version")
  valid_569882 = validateParameter(valid_569882, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569882 != nil:
    section.add "api-version", valid_569882
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

proc call*(call_569884: Call_LabsGenerateUploadUri_569876; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  let valid = call_569884.validator(path, query, header, formData, body)
  let scheme = call_569884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569884.url(scheme.get, call_569884.host, call_569884.base,
                         call_569884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569884, url, valid)

proc call*(call_569885: Call_LabsGenerateUploadUri_569876;
          resourceGroupName: string; name: string; subscriptionId: string;
          generateUploadUriParameter: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569886 = newJObject()
  var query_569887 = newJObject()
  var body_569888 = newJObject()
  add(path_569886, "resourceGroupName", newJString(resourceGroupName))
  add(query_569887, "api-version", newJString(apiVersion))
  add(path_569886, "name", newJString(name))
  add(path_569886, "subscriptionId", newJString(subscriptionId))
  if generateUploadUriParameter != nil:
    body_569888 = generateUploadUriParameter
  result = call_569885.call(path_569886, query_569887, nil, nil, body_569888)

var labsGenerateUploadUri* = Call_LabsGenerateUploadUri_569876(
    name: "labsGenerateUploadUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri",
    validator: validate_LabsGenerateUploadUri_569877, base: "",
    url: url_LabsGenerateUploadUri_569878, schemes: {Scheme.Https})
type
  Call_LabsImportVirtualMachine_569889 = ref object of OpenApiRestCall_567666
proc url_LabsImportVirtualMachine_569891(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
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
               (kind: ConstantSegment, value: "/importVirtualMachine")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LabsImportVirtualMachine_569890(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Import a virtual machine into a different lab. This operation can take a while to complete.
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
  var valid_569892 = path.getOrDefault("resourceGroupName")
  valid_569892 = validateParameter(valid_569892, JString, required = true,
                                 default = nil)
  if valid_569892 != nil:
    section.add "resourceGroupName", valid_569892
  var valid_569893 = path.getOrDefault("name")
  valid_569893 = validateParameter(valid_569893, JString, required = true,
                                 default = nil)
  if valid_569893 != nil:
    section.add "name", valid_569893
  var valid_569894 = path.getOrDefault("subscriptionId")
  valid_569894 = validateParameter(valid_569894, JString, required = true,
                                 default = nil)
  if valid_569894 != nil:
    section.add "subscriptionId", valid_569894
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569895 = query.getOrDefault("api-version")
  valid_569895 = validateParameter(valid_569895, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569895 != nil:
    section.add "api-version", valid_569895
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   importLabVirtualMachineRequest: JObject (required)
  ##                                 : This represents the payload required to import a virtual machine from a different lab into the current one
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569897: Call_LabsImportVirtualMachine_569889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Import a virtual machine into a different lab. This operation can take a while to complete.
  ## 
  let valid = call_569897.validator(path, query, header, formData, body)
  let scheme = call_569897.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569897.url(scheme.get, call_569897.host, call_569897.base,
                         call_569897.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569897, url, valid)

proc call*(call_569898: Call_LabsImportVirtualMachine_569889;
          resourceGroupName: string; name: string; subscriptionId: string;
          importLabVirtualMachineRequest: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsImportVirtualMachine
  ## Import a virtual machine into a different lab. This operation can take a while to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   importLabVirtualMachineRequest: JObject (required)
  ##                                 : This represents the payload required to import a virtual machine from a different lab into the current one
  var path_569899 = newJObject()
  var query_569900 = newJObject()
  var body_569901 = newJObject()
  add(path_569899, "resourceGroupName", newJString(resourceGroupName))
  add(query_569900, "api-version", newJString(apiVersion))
  add(path_569899, "name", newJString(name))
  add(path_569899, "subscriptionId", newJString(subscriptionId))
  if importLabVirtualMachineRequest != nil:
    body_569901 = importLabVirtualMachineRequest
  result = call_569898.call(path_569899, query_569900, nil, nil, body_569901)

var labsImportVirtualMachine* = Call_LabsImportVirtualMachine_569889(
    name: "labsImportVirtualMachine", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/importVirtualMachine",
    validator: validate_LabsImportVirtualMachine_569890, base: "",
    url: url_LabsImportVirtualMachine_569891, schemes: {Scheme.Https})
type
  Call_LabsListVhds_569902 = ref object of OpenApiRestCall_567666
proc url_LabsListVhds_569904(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListVhds_569903(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569905 = path.getOrDefault("resourceGroupName")
  valid_569905 = validateParameter(valid_569905, JString, required = true,
                                 default = nil)
  if valid_569905 != nil:
    section.add "resourceGroupName", valid_569905
  var valid_569906 = path.getOrDefault("name")
  valid_569906 = validateParameter(valid_569906, JString, required = true,
                                 default = nil)
  if valid_569906 != nil:
    section.add "name", valid_569906
  var valid_569907 = path.getOrDefault("subscriptionId")
  valid_569907 = validateParameter(valid_569907, JString, required = true,
                                 default = nil)
  if valid_569907 != nil:
    section.add "subscriptionId", valid_569907
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569908 = query.getOrDefault("api-version")
  valid_569908 = validateParameter(valid_569908, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569908 != nil:
    section.add "api-version", valid_569908
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569909: Call_LabsListVhds_569902; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disk images available for custom image creation.
  ## 
  let valid = call_569909.validator(path, query, header, formData, body)
  let scheme = call_569909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569909.url(scheme.get, call_569909.host, call_569909.base,
                         call_569909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569909, url, valid)

proc call*(call_569910: Call_LabsListVhds_569902; resourceGroupName: string;
          name: string; subscriptionId: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569911 = newJObject()
  var query_569912 = newJObject()
  add(path_569911, "resourceGroupName", newJString(resourceGroupName))
  add(query_569912, "api-version", newJString(apiVersion))
  add(path_569911, "name", newJString(name))
  add(path_569911, "subscriptionId", newJString(subscriptionId))
  result = call_569910.call(path_569911, query_569912, nil, nil, nil)

var labsListVhds* = Call_LabsListVhds_569902(name: "labsListVhds",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds",
    validator: validate_LabsListVhds_569903, base: "", url: url_LabsListVhds_569904,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListByResourceGroup_569913 = ref object of OpenApiRestCall_567666
proc url_GlobalSchedulesListByResourceGroup_569915(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesListByResourceGroup_569914(path: JsonNode;
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
  var valid_569916 = path.getOrDefault("resourceGroupName")
  valid_569916 = validateParameter(valid_569916, JString, required = true,
                                 default = nil)
  if valid_569916 != nil:
    section.add "resourceGroupName", valid_569916
  var valid_569917 = path.getOrDefault("subscriptionId")
  valid_569917 = validateParameter(valid_569917, JString, required = true,
                                 default = nil)
  if valid_569917 != nil:
    section.add "subscriptionId", valid_569917
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_569918 = query.getOrDefault("$orderby")
  valid_569918 = validateParameter(valid_569918, JString, required = false,
                                 default = nil)
  if valid_569918 != nil:
    section.add "$orderby", valid_569918
  var valid_569919 = query.getOrDefault("$expand")
  valid_569919 = validateParameter(valid_569919, JString, required = false,
                                 default = nil)
  if valid_569919 != nil:
    section.add "$expand", valid_569919
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569920 = query.getOrDefault("api-version")
  valid_569920 = validateParameter(valid_569920, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569920 != nil:
    section.add "api-version", valid_569920
  var valid_569921 = query.getOrDefault("$top")
  valid_569921 = validateParameter(valid_569921, JInt, required = false, default = nil)
  if valid_569921 != nil:
    section.add "$top", valid_569921
  var valid_569922 = query.getOrDefault("$filter")
  valid_569922 = validateParameter(valid_569922, JString, required = false,
                                 default = nil)
  if valid_569922 != nil:
    section.add "$filter", valid_569922
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569923: Call_GlobalSchedulesListByResourceGroup_569913;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a resource group.
  ## 
  let valid = call_569923.validator(path, query, header, formData, body)
  let scheme = call_569923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569923.url(scheme.get, call_569923.host, call_569923.base,
                         call_569923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569923, url, valid)

proc call*(call_569924: Call_GlobalSchedulesListByResourceGroup_569913;
          resourceGroupName: string; subscriptionId: string; Orderby: string = "";
          Expand: string = ""; apiVersion: string = "2018-09-15"; Top: int = 0;
          Filter: string = ""): Recallable =
  ## globalSchedulesListByResourceGroup
  ## List schedules in a resource group.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_569925 = newJObject()
  var query_569926 = newJObject()
  add(query_569926, "$orderby", newJString(Orderby))
  add(path_569925, "resourceGroupName", newJString(resourceGroupName))
  add(query_569926, "$expand", newJString(Expand))
  add(query_569926, "api-version", newJString(apiVersion))
  add(path_569925, "subscriptionId", newJString(subscriptionId))
  add(query_569926, "$top", newJInt(Top))
  add(query_569926, "$filter", newJString(Filter))
  result = call_569924.call(path_569925, query_569926, nil, nil, nil)

var globalSchedulesListByResourceGroup* = Call_GlobalSchedulesListByResourceGroup_569913(
    name: "globalSchedulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListByResourceGroup_569914, base: "",
    url: url_GlobalSchedulesListByResourceGroup_569915, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesCreateOrUpdate_569939 = ref object of OpenApiRestCall_567666
proc url_GlobalSchedulesCreateOrUpdate_569941(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesCreateOrUpdate_569940(path: JsonNode; query: JsonNode;
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
  var valid_569942 = path.getOrDefault("resourceGroupName")
  valid_569942 = validateParameter(valid_569942, JString, required = true,
                                 default = nil)
  if valid_569942 != nil:
    section.add "resourceGroupName", valid_569942
  var valid_569943 = path.getOrDefault("name")
  valid_569943 = validateParameter(valid_569943, JString, required = true,
                                 default = nil)
  if valid_569943 != nil:
    section.add "name", valid_569943
  var valid_569944 = path.getOrDefault("subscriptionId")
  valid_569944 = validateParameter(valid_569944, JString, required = true,
                                 default = nil)
  if valid_569944 != nil:
    section.add "subscriptionId", valid_569944
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569945 = query.getOrDefault("api-version")
  valid_569945 = validateParameter(valid_569945, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569945 != nil:
    section.add "api-version", valid_569945
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

proc call*(call_569947: Call_GlobalSchedulesCreateOrUpdate_569939; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_569947.validator(path, query, header, formData, body)
  let scheme = call_569947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569947.url(scheme.get, call_569947.host, call_569947.base,
                         call_569947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569947, url, valid)

proc call*(call_569948: Call_GlobalSchedulesCreateOrUpdate_569939;
          resourceGroupName: string; name: string; subscriptionId: string;
          schedule: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569949 = newJObject()
  var query_569950 = newJObject()
  var body_569951 = newJObject()
  add(path_569949, "resourceGroupName", newJString(resourceGroupName))
  add(query_569950, "api-version", newJString(apiVersion))
  add(path_569949, "name", newJString(name))
  add(path_569949, "subscriptionId", newJString(subscriptionId))
  if schedule != nil:
    body_569951 = schedule
  result = call_569948.call(path_569949, query_569950, nil, nil, body_569951)

var globalSchedulesCreateOrUpdate* = Call_GlobalSchedulesCreateOrUpdate_569939(
    name: "globalSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesCreateOrUpdate_569940, base: "",
    url: url_GlobalSchedulesCreateOrUpdate_569941, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesGet_569927 = ref object of OpenApiRestCall_567666
proc url_GlobalSchedulesGet_569929(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesGet_569928(path: JsonNode; query: JsonNode;
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
  var valid_569930 = path.getOrDefault("resourceGroupName")
  valid_569930 = validateParameter(valid_569930, JString, required = true,
                                 default = nil)
  if valid_569930 != nil:
    section.add "resourceGroupName", valid_569930
  var valid_569931 = path.getOrDefault("name")
  valid_569931 = validateParameter(valid_569931, JString, required = true,
                                 default = nil)
  if valid_569931 != nil:
    section.add "name", valid_569931
  var valid_569932 = path.getOrDefault("subscriptionId")
  valid_569932 = validateParameter(valid_569932, JString, required = true,
                                 default = nil)
  if valid_569932 != nil:
    section.add "subscriptionId", valid_569932
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  var valid_569933 = query.getOrDefault("$expand")
  valid_569933 = validateParameter(valid_569933, JString, required = false,
                                 default = nil)
  if valid_569933 != nil:
    section.add "$expand", valid_569933
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569934 = query.getOrDefault("api-version")
  valid_569934 = validateParameter(valid_569934, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569934 != nil:
    section.add "api-version", valid_569934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569935: Call_GlobalSchedulesGet_569927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_569935.validator(path, query, header, formData, body)
  let scheme = call_569935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569935.url(scheme.get, call_569935.host, call_569935.base,
                         call_569935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569935, url, valid)

proc call*(call_569936: Call_GlobalSchedulesGet_569927; resourceGroupName: string;
          name: string; subscriptionId: string; Expand: string = "";
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569937 = newJObject()
  var query_569938 = newJObject()
  add(path_569937, "resourceGroupName", newJString(resourceGroupName))
  add(query_569938, "$expand", newJString(Expand))
  add(path_569937, "name", newJString(name))
  add(query_569938, "api-version", newJString(apiVersion))
  add(path_569937, "subscriptionId", newJString(subscriptionId))
  result = call_569936.call(path_569937, query_569938, nil, nil, nil)

var globalSchedulesGet* = Call_GlobalSchedulesGet_569927(
    name: "globalSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesGet_569928, base: "",
    url: url_GlobalSchedulesGet_569929, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesUpdate_569963 = ref object of OpenApiRestCall_567666
proc url_GlobalSchedulesUpdate_569965(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesUpdate_569964(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var valid_569966 = path.getOrDefault("resourceGroupName")
  valid_569966 = validateParameter(valid_569966, JString, required = true,
                                 default = nil)
  if valid_569966 != nil:
    section.add "resourceGroupName", valid_569966
  var valid_569967 = path.getOrDefault("name")
  valid_569967 = validateParameter(valid_569967, JString, required = true,
                                 default = nil)
  if valid_569967 != nil:
    section.add "name", valid_569967
  var valid_569968 = path.getOrDefault("subscriptionId")
  valid_569968 = validateParameter(valid_569968, JString, required = true,
                                 default = nil)
  if valid_569968 != nil:
    section.add "subscriptionId", valid_569968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569969 = query.getOrDefault("api-version")
  valid_569969 = validateParameter(valid_569969, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569969 != nil:
    section.add "api-version", valid_569969
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

proc call*(call_569971: Call_GlobalSchedulesUpdate_569963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_569971.validator(path, query, header, formData, body)
  let scheme = call_569971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569971.url(scheme.get, call_569971.host, call_569971.base,
                         call_569971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569971, url, valid)

proc call*(call_569972: Call_GlobalSchedulesUpdate_569963;
          resourceGroupName: string; name: string; subscriptionId: string;
          schedule: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## globalSchedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var path_569973 = newJObject()
  var query_569974 = newJObject()
  var body_569975 = newJObject()
  add(path_569973, "resourceGroupName", newJString(resourceGroupName))
  add(query_569974, "api-version", newJString(apiVersion))
  add(path_569973, "name", newJString(name))
  add(path_569973, "subscriptionId", newJString(subscriptionId))
  if schedule != nil:
    body_569975 = schedule
  result = call_569972.call(path_569973, query_569974, nil, nil, body_569975)

var globalSchedulesUpdate* = Call_GlobalSchedulesUpdate_569963(
    name: "globalSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesUpdate_569964, base: "",
    url: url_GlobalSchedulesUpdate_569965, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesDelete_569952 = ref object of OpenApiRestCall_567666
proc url_GlobalSchedulesDelete_569954(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesDelete_569953(path: JsonNode; query: JsonNode;
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
  var valid_569955 = path.getOrDefault("resourceGroupName")
  valid_569955 = validateParameter(valid_569955, JString, required = true,
                                 default = nil)
  if valid_569955 != nil:
    section.add "resourceGroupName", valid_569955
  var valid_569956 = path.getOrDefault("name")
  valid_569956 = validateParameter(valid_569956, JString, required = true,
                                 default = nil)
  if valid_569956 != nil:
    section.add "name", valid_569956
  var valid_569957 = path.getOrDefault("subscriptionId")
  valid_569957 = validateParameter(valid_569957, JString, required = true,
                                 default = nil)
  if valid_569957 != nil:
    section.add "subscriptionId", valid_569957
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569958 = query.getOrDefault("api-version")
  valid_569958 = validateParameter(valid_569958, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569958 != nil:
    section.add "api-version", valid_569958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569959: Call_GlobalSchedulesDelete_569952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_569959.validator(path, query, header, formData, body)
  let scheme = call_569959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569959.url(scheme.get, call_569959.host, call_569959.base,
                         call_569959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569959, url, valid)

proc call*(call_569960: Call_GlobalSchedulesDelete_569952;
          resourceGroupName: string; name: string; subscriptionId: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569961 = newJObject()
  var query_569962 = newJObject()
  add(path_569961, "resourceGroupName", newJString(resourceGroupName))
  add(query_569962, "api-version", newJString(apiVersion))
  add(path_569961, "name", newJString(name))
  add(path_569961, "subscriptionId", newJString(subscriptionId))
  result = call_569960.call(path_569961, query_569962, nil, nil, nil)

var globalSchedulesDelete* = Call_GlobalSchedulesDelete_569952(
    name: "globalSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesDelete_569953, base: "",
    url: url_GlobalSchedulesDelete_569954, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesExecute_569976 = ref object of OpenApiRestCall_567666
proc url_GlobalSchedulesExecute_569978(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesExecute_569977(path: JsonNode; query: JsonNode;
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
  var valid_569979 = path.getOrDefault("resourceGroupName")
  valid_569979 = validateParameter(valid_569979, JString, required = true,
                                 default = nil)
  if valid_569979 != nil:
    section.add "resourceGroupName", valid_569979
  var valid_569980 = path.getOrDefault("name")
  valid_569980 = validateParameter(valid_569980, JString, required = true,
                                 default = nil)
  if valid_569980 != nil:
    section.add "name", valid_569980
  var valid_569981 = path.getOrDefault("subscriptionId")
  valid_569981 = validateParameter(valid_569981, JString, required = true,
                                 default = nil)
  if valid_569981 != nil:
    section.add "subscriptionId", valid_569981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569982 = query.getOrDefault("api-version")
  valid_569982 = validateParameter(valid_569982, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569982 != nil:
    section.add "api-version", valid_569982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569983: Call_GlobalSchedulesExecute_569976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_569983.validator(path, query, header, formData, body)
  let scheme = call_569983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569983.url(scheme.get, call_569983.host, call_569983.base,
                         call_569983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569983, url, valid)

proc call*(call_569984: Call_GlobalSchedulesExecute_569976;
          resourceGroupName: string; name: string; subscriptionId: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569985 = newJObject()
  var query_569986 = newJObject()
  add(path_569985, "resourceGroupName", newJString(resourceGroupName))
  add(query_569986, "api-version", newJString(apiVersion))
  add(path_569985, "name", newJString(name))
  add(path_569985, "subscriptionId", newJString(subscriptionId))
  result = call_569984.call(path_569985, query_569986, nil, nil, nil)

var globalSchedulesExecute* = Call_GlobalSchedulesExecute_569976(
    name: "globalSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/execute",
    validator: validate_GlobalSchedulesExecute_569977, base: "",
    url: url_GlobalSchedulesExecute_569978, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesRetarget_569987 = ref object of OpenApiRestCall_567666
proc url_GlobalSchedulesRetarget_569989(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesRetarget_569988(path: JsonNode; query: JsonNode;
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
  var valid_569990 = path.getOrDefault("resourceGroupName")
  valid_569990 = validateParameter(valid_569990, JString, required = true,
                                 default = nil)
  if valid_569990 != nil:
    section.add "resourceGroupName", valid_569990
  var valid_569991 = path.getOrDefault("name")
  valid_569991 = validateParameter(valid_569991, JString, required = true,
                                 default = nil)
  if valid_569991 != nil:
    section.add "name", valid_569991
  var valid_569992 = path.getOrDefault("subscriptionId")
  valid_569992 = validateParameter(valid_569992, JString, required = true,
                                 default = nil)
  if valid_569992 != nil:
    section.add "subscriptionId", valid_569992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569993 = query.getOrDefault("api-version")
  valid_569993 = validateParameter(valid_569993, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_569993 != nil:
    section.add "api-version", valid_569993
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

proc call*(call_569995: Call_GlobalSchedulesRetarget_569987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ## 
  let valid = call_569995.validator(path, query, header, formData, body)
  let scheme = call_569995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569995.url(scheme.get, call_569995.host, call_569995.base,
                         call_569995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569995, url, valid)

proc call*(call_569996: Call_GlobalSchedulesRetarget_569987;
          resourceGroupName: string; name: string; subscriptionId: string;
          retargetScheduleProperties: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_569997 = newJObject()
  var query_569998 = newJObject()
  var body_569999 = newJObject()
  add(path_569997, "resourceGroupName", newJString(resourceGroupName))
  add(query_569998, "api-version", newJString(apiVersion))
  add(path_569997, "name", newJString(name))
  add(path_569997, "subscriptionId", newJString(subscriptionId))
  if retargetScheduleProperties != nil:
    body_569999 = retargetScheduleProperties
  result = call_569996.call(path_569997, query_569998, nil, nil, body_569999)

var globalSchedulesRetarget* = Call_GlobalSchedulesRetarget_569987(
    name: "globalSchedulesRetarget", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/retarget",
    validator: validate_GlobalSchedulesRetarget_569988, base: "",
    url: url_GlobalSchedulesRetarget_569989, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
