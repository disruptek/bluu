
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563548 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563548](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563548): Option[Scheme] {.used.} =
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
  macServiceName = "devtestlabs-DTL"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderOperationsList_563770 = ref object of OpenApiRestCall_563548
proc url_ProviderOperationsList_563772(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsList_563771(path: JsonNode; query: JsonNode;
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
  var valid_563946 = query.getOrDefault("api-version")
  valid_563946 = validateParameter(valid_563946, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_563946 != nil:
    section.add "api-version", valid_563946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563969: Call_ProviderOperationsList_563770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Result of the request to list REST API operations
  ## 
  let valid = call_563969.validator(path, query, header, formData, body)
  let scheme = call_563969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563969.url(scheme.get, call_563969.host, call_563969.base,
                         call_563969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563969, url, valid)

proc call*(call_564040: Call_ProviderOperationsList_563770;
          apiVersion: string = "2016-05-15"): Recallable =
  ## providerOperationsList
  ## Result of the request to list REST API operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564041 = newJObject()
  add(query_564041, "api-version", newJString(apiVersion))
  result = call_564040.call(nil, query_564041, nil, nil, nil)

var providerOperationsList* = Call_ProviderOperationsList_563770(
    name: "providerOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DevTestLab/operations",
    validator: validate_ProviderOperationsList_563771, base: "",
    url: url_ProviderOperationsList_563772, schemes: {Scheme.Https})
type
  Call_LabsListBySubscription_564081 = ref object of OpenApiRestCall_563548
proc url_LabsListBySubscription_564083(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListBySubscription_564082(path: JsonNode; query: JsonNode;
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
  var valid_564099 = path.getOrDefault("subscriptionId")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "subscriptionId", valid_564099
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564100 = query.getOrDefault("$top")
  valid_564100 = validateParameter(valid_564100, JInt, required = false, default = nil)
  if valid_564100 != nil:
    section.add "$top", valid_564100
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564101 = query.getOrDefault("api-version")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564101 != nil:
    section.add "api-version", valid_564101
  var valid_564102 = query.getOrDefault("$expand")
  valid_564102 = validateParameter(valid_564102, JString, required = false,
                                 default = nil)
  if valid_564102 != nil:
    section.add "$expand", valid_564102
  var valid_564103 = query.getOrDefault("$orderby")
  valid_564103 = validateParameter(valid_564103, JString, required = false,
                                 default = nil)
  if valid_564103 != nil:
    section.add "$orderby", valid_564103
  var valid_564104 = query.getOrDefault("$filter")
  valid_564104 = validateParameter(valid_564104, JString, required = false,
                                 default = nil)
  if valid_564104 != nil:
    section.add "$filter", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_LabsListBySubscription_564081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a subscription.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_LabsListBySubscription_564081; subscriptionId: string;
          Top: int = 0; apiVersion: string = "2016-05-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## labsListBySubscription
  ## List labs in a subscription.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "$top", newJInt(Top))
  add(query_564108, "api-version", newJString(apiVersion))
  add(query_564108, "$expand", newJString(Expand))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  add(query_564108, "$orderby", newJString(Orderby))
  add(query_564108, "$filter", newJString(Filter))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var labsListBySubscription* = Call_LabsListBySubscription_564081(
    name: "labsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListBySubscription_564082, base: "",
    url: url_LabsListBySubscription_564083, schemes: {Scheme.Https})
type
  Call_OperationsGet_564109 = ref object of OpenApiRestCall_563548
proc url_OperationsGet_564111(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsGet_564110(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The name of the location.
  ##   name: JString (required)
  ##       : The name of the operation.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564112 = path.getOrDefault("locationName")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "locationName", valid_564112
  var valid_564113 = path.getOrDefault("name")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "name", valid_564113
  var valid_564114 = path.getOrDefault("subscriptionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "subscriptionId", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_OperationsGet_564109; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get operation.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_OperationsGet_564109; locationName: string;
          name: string; subscriptionId: string; apiVersion: string = "2016-05-15"): Recallable =
  ## operationsGet
  ## Get operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   locationName: string (required)
  ##               : The name of the location.
  ##   name: string (required)
  ##       : The name of the operation.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "locationName", newJString(locationName))
  add(path_564118, "name", newJString(name))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var operationsGet* = Call_OperationsGet_564109(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/locations/{locationName}/operations/{name}",
    validator: validate_OperationsGet_564110, base: "", url: url_OperationsGet_564111,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListBySubscription_564120 = ref object of OpenApiRestCall_563548
proc url_GlobalSchedulesListBySubscription_564122(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesListBySubscription_564121(path: JsonNode;
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
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564124 = query.getOrDefault("$top")
  valid_564124 = validateParameter(valid_564124, JInt, required = false, default = nil)
  if valid_564124 != nil:
    section.add "$top", valid_564124
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  var valid_564126 = query.getOrDefault("$expand")
  valid_564126 = validateParameter(valid_564126, JString, required = false,
                                 default = nil)
  if valid_564126 != nil:
    section.add "$expand", valid_564126
  var valid_564127 = query.getOrDefault("$orderby")
  valid_564127 = validateParameter(valid_564127, JString, required = false,
                                 default = nil)
  if valid_564127 != nil:
    section.add "$orderby", valid_564127
  var valid_564128 = query.getOrDefault("$filter")
  valid_564128 = validateParameter(valid_564128, JString, required = false,
                                 default = nil)
  if valid_564128 != nil:
    section.add "$filter", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_GlobalSchedulesListBySubscription_564120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a subscription.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_GlobalSchedulesListBySubscription_564120;
          subscriptionId: string; Top: int = 0; apiVersion: string = "2016-05-15";
          Expand: string = ""; Orderby: string = ""; Filter: string = ""): Recallable =
  ## globalSchedulesListBySubscription
  ## List schedules in a subscription.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(query_564132, "$top", newJInt(Top))
  add(query_564132, "api-version", newJString(apiVersion))
  add(query_564132, "$expand", newJString(Expand))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(query_564132, "$orderby", newJString(Orderby))
  add(query_564132, "$filter", newJString(Filter))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var globalSchedulesListBySubscription* = Call_GlobalSchedulesListBySubscription_564120(
    name: "globalSchedulesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListBySubscription_564121, base: "",
    url: url_GlobalSchedulesListBySubscription_564122, schemes: {Scheme.Https})
type
  Call_LabsListByResourceGroup_564133 = ref object of OpenApiRestCall_563548
proc url_LabsListByResourceGroup_564135(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListByResourceGroup_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List labs in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564138 = query.getOrDefault("$top")
  valid_564138 = validateParameter(valid_564138, JInt, required = false, default = nil)
  if valid_564138 != nil:
    section.add "$top", valid_564138
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  var valid_564140 = query.getOrDefault("$expand")
  valid_564140 = validateParameter(valid_564140, JString, required = false,
                                 default = nil)
  if valid_564140 != nil:
    section.add "$expand", valid_564140
  var valid_564141 = query.getOrDefault("$orderby")
  valid_564141 = validateParameter(valid_564141, JString, required = false,
                                 default = nil)
  if valid_564141 != nil:
    section.add "$orderby", valid_564141
  var valid_564142 = query.getOrDefault("$filter")
  valid_564142 = validateParameter(valid_564142, JString, required = false,
                                 default = nil)
  if valid_564142 != nil:
    section.add "$filter", valid_564142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564143: Call_LabsListByResourceGroup_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a resource group.
  ## 
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_LabsListByResourceGroup_564133;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## labsListByResourceGroup
  ## List labs in a resource group.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564145 = newJObject()
  var query_564146 = newJObject()
  add(query_564146, "$top", newJInt(Top))
  add(query_564146, "api-version", newJString(apiVersion))
  add(query_564146, "$expand", newJString(Expand))
  add(path_564145, "subscriptionId", newJString(subscriptionId))
  add(query_564146, "$orderby", newJString(Orderby))
  add(path_564145, "resourceGroupName", newJString(resourceGroupName))
  add(query_564146, "$filter", newJString(Filter))
  result = call_564144.call(path_564145, query_564146, nil, nil, nil)

var labsListByResourceGroup* = Call_LabsListByResourceGroup_564133(
    name: "labsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListByResourceGroup_564134, base: "",
    url: url_LabsListByResourceGroup_564135, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesList_564147 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourcesList_564149(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesList_564148(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List artifact sources in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564150 = path.getOrDefault("labName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "labName", valid_564150
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564153 = query.getOrDefault("$top")
  valid_564153 = validateParameter(valid_564153, JInt, required = false, default = nil)
  if valid_564153 != nil:
    section.add "$top", valid_564153
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  var valid_564155 = query.getOrDefault("$expand")
  valid_564155 = validateParameter(valid_564155, JString, required = false,
                                 default = nil)
  if valid_564155 != nil:
    section.add "$expand", valid_564155
  var valid_564156 = query.getOrDefault("$orderby")
  valid_564156 = validateParameter(valid_564156, JString, required = false,
                                 default = nil)
  if valid_564156 != nil:
    section.add "$orderby", valid_564156
  var valid_564157 = query.getOrDefault("$filter")
  valid_564157 = validateParameter(valid_564157, JString, required = false,
                                 default = nil)
  if valid_564157 != nil:
    section.add "$filter", valid_564157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564158: Call_ArtifactSourcesList_564147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifact sources in a given lab.
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_ArtifactSourcesList_564147; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## artifactSourcesList
  ## List artifact sources in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  add(path_564160, "labName", newJString(labName))
  add(query_564161, "$top", newJInt(Top))
  add(query_564161, "api-version", newJString(apiVersion))
  add(query_564161, "$expand", newJString(Expand))
  add(path_564160, "subscriptionId", newJString(subscriptionId))
  add(query_564161, "$orderby", newJString(Orderby))
  add(path_564160, "resourceGroupName", newJString(resourceGroupName))
  add(query_564161, "$filter", newJString(Filter))
  result = call_564159.call(path_564160, query_564161, nil, nil, nil)

var artifactSourcesList* = Call_ArtifactSourcesList_564147(
    name: "artifactSourcesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources",
    validator: validate_ArtifactSourcesList_564148, base: "",
    url: url_ArtifactSourcesList_564149, schemes: {Scheme.Https})
type
  Call_ArmTemplatesList_564162 = ref object of OpenApiRestCall_563548
proc url_ArmTemplatesList_564164(protocol: Scheme; host: string; base: string;
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

proc validate_ArmTemplatesList_564163(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List azure resource manager templates in a given artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564165 = path.getOrDefault("labName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "labName", valid_564165
  var valid_564166 = path.getOrDefault("subscriptionId")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "subscriptionId", valid_564166
  var valid_564167 = path.getOrDefault("resourceGroupName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "resourceGroupName", valid_564167
  var valid_564168 = path.getOrDefault("artifactSourceName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "artifactSourceName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564169 = query.getOrDefault("$top")
  valid_564169 = validateParameter(valid_564169, JInt, required = false, default = nil)
  if valid_564169 != nil:
    section.add "$top", valid_564169
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564170 != nil:
    section.add "api-version", valid_564170
  var valid_564171 = query.getOrDefault("$expand")
  valid_564171 = validateParameter(valid_564171, JString, required = false,
                                 default = nil)
  if valid_564171 != nil:
    section.add "$expand", valid_564171
  var valid_564172 = query.getOrDefault("$orderby")
  valid_564172 = validateParameter(valid_564172, JString, required = false,
                                 default = nil)
  if valid_564172 != nil:
    section.add "$orderby", valid_564172
  var valid_564173 = query.getOrDefault("$filter")
  valid_564173 = validateParameter(valid_564173, JString, required = false,
                                 default = nil)
  if valid_564173 != nil:
    section.add "$filter", valid_564173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_ArmTemplatesList_564162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List azure resource manager templates in a given artifact source.
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_ArmTemplatesList_564162; labName: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; Top: int = 0; apiVersion: string = "2016-05-15";
          Expand: string = ""; Orderby: string = ""; Filter: string = ""): Recallable =
  ## armTemplatesList
  ## List azure resource manager templates in a given artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  add(path_564176, "labName", newJString(labName))
  add(query_564177, "$top", newJInt(Top))
  add(query_564177, "api-version", newJString(apiVersion))
  add(query_564177, "$expand", newJString(Expand))
  add(path_564176, "subscriptionId", newJString(subscriptionId))
  add(query_564177, "$orderby", newJString(Orderby))
  add(path_564176, "resourceGroupName", newJString(resourceGroupName))
  add(query_564177, "$filter", newJString(Filter))
  add(path_564176, "artifactSourceName", newJString(artifactSourceName))
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var armTemplatesList* = Call_ArmTemplatesList_564162(name: "armTemplatesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates",
    validator: validate_ArmTemplatesList_564163, base: "",
    url: url_ArmTemplatesList_564164, schemes: {Scheme.Https})
type
  Call_ArmTemplatesGet_564178 = ref object of OpenApiRestCall_563548
proc url_ArmTemplatesGet_564180(protocol: Scheme; host: string; base: string;
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

proc validate_ArmTemplatesGet_564179(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get azure resource manager template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the azure Resource Manager template.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564181 = path.getOrDefault("labName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "labName", valid_564181
  var valid_564182 = path.getOrDefault("name")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "name", valid_564182
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  var valid_564184 = path.getOrDefault("resourceGroupName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "resourceGroupName", valid_564184
  var valid_564185 = path.getOrDefault("artifactSourceName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "artifactSourceName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  var valid_564187 = query.getOrDefault("$expand")
  valid_564187 = validateParameter(valid_564187, JString, required = false,
                                 default = nil)
  if valid_564187 != nil:
    section.add "$expand", valid_564187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564188: Call_ArmTemplatesGet_564178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get azure resource manager template.
  ## 
  let valid = call_564188.validator(path, query, header, formData, body)
  let scheme = call_564188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564188.url(scheme.get, call_564188.host, call_564188.base,
                         call_564188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564188, url, valid)

proc call*(call_564189: Call_ArmTemplatesGet_564178; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; apiVersion: string = "2016-05-15";
          Expand: string = ""): Recallable =
  ## armTemplatesGet
  ## Get azure resource manager template.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   name: string (required)
  ##       : The name of the azure Resource Manager template.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564190 = newJObject()
  var query_564191 = newJObject()
  add(path_564190, "labName", newJString(labName))
  add(query_564191, "api-version", newJString(apiVersion))
  add(query_564191, "$expand", newJString(Expand))
  add(path_564190, "name", newJString(name))
  add(path_564190, "subscriptionId", newJString(subscriptionId))
  add(path_564190, "resourceGroupName", newJString(resourceGroupName))
  add(path_564190, "artifactSourceName", newJString(artifactSourceName))
  result = call_564189.call(path_564190, query_564191, nil, nil, nil)

var armTemplatesGet* = Call_ArmTemplatesGet_564178(name: "armTemplatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates/{name}",
    validator: validate_ArmTemplatesGet_564179, base: "", url: url_ArmTemplatesGet_564180,
    schemes: {Scheme.Https})
type
  Call_ArtifactsList_564192 = ref object of OpenApiRestCall_563548
proc url_ArtifactsList_564194(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsList_564193(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts in a given artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564195 = path.getOrDefault("labName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "labName", valid_564195
  var valid_564196 = path.getOrDefault("subscriptionId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "subscriptionId", valid_564196
  var valid_564197 = path.getOrDefault("resourceGroupName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceGroupName", valid_564197
  var valid_564198 = path.getOrDefault("artifactSourceName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "artifactSourceName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564199 = query.getOrDefault("$top")
  valid_564199 = validateParameter(valid_564199, JInt, required = false, default = nil)
  if valid_564199 != nil:
    section.add "$top", valid_564199
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  var valid_564201 = query.getOrDefault("$expand")
  valid_564201 = validateParameter(valid_564201, JString, required = false,
                                 default = nil)
  if valid_564201 != nil:
    section.add "$expand", valid_564201
  var valid_564202 = query.getOrDefault("$orderby")
  valid_564202 = validateParameter(valid_564202, JString, required = false,
                                 default = nil)
  if valid_564202 != nil:
    section.add "$orderby", valid_564202
  var valid_564203 = query.getOrDefault("$filter")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "$filter", valid_564203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_ArtifactsList_564192; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts in a given artifact source.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_ArtifactsList_564192; labName: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; Top: int = 0; apiVersion: string = "2016-05-15";
          Expand: string = ""; Orderby: string = ""; Filter: string = ""): Recallable =
  ## artifactsList
  ## List artifacts in a given artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=title)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(path_564206, "labName", newJString(labName))
  add(query_564207, "$top", newJInt(Top))
  add(query_564207, "api-version", newJString(apiVersion))
  add(query_564207, "$expand", newJString(Expand))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(query_564207, "$orderby", newJString(Orderby))
  add(path_564206, "resourceGroupName", newJString(resourceGroupName))
  add(query_564207, "$filter", newJString(Filter))
  add(path_564206, "artifactSourceName", newJString(artifactSourceName))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_564192(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts",
    validator: validate_ArtifactsList_564193, base: "", url: url_ArtifactsList_564194,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGet_564208 = ref object of OpenApiRestCall_563548
proc url_ArtifactsGet_564210(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsGet_564209(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564211 = path.getOrDefault("labName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "labName", valid_564211
  var valid_564212 = path.getOrDefault("name")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "name", valid_564212
  var valid_564213 = path.getOrDefault("subscriptionId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "subscriptionId", valid_564213
  var valid_564214 = path.getOrDefault("resourceGroupName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "resourceGroupName", valid_564214
  var valid_564215 = path.getOrDefault("artifactSourceName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "artifactSourceName", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564216 != nil:
    section.add "api-version", valid_564216
  var valid_564217 = query.getOrDefault("$expand")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "$expand", valid_564217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_ArtifactsGet_564208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_ArtifactsGet_564208; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; apiVersion: string = "2016-05-15";
          Expand: string = ""): Recallable =
  ## artifactsGet
  ## Get artifact.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=title)'
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  add(path_564220, "labName", newJString(labName))
  add(query_564221, "api-version", newJString(apiVersion))
  add(query_564221, "$expand", newJString(Expand))
  add(path_564220, "name", newJString(name))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  add(path_564220, "artifactSourceName", newJString(artifactSourceName))
  result = call_564219.call(path_564220, query_564221, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_564208(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}",
    validator: validate_ArtifactsGet_564209, base: "", url: url_ArtifactsGet_564210,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGenerateArmTemplate_564222 = ref object of OpenApiRestCall_563548
proc url_ArtifactsGenerateArmTemplate_564224(protocol: Scheme; host: string;
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

proc validate_ArtifactsGenerateArmTemplate_564223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564225 = path.getOrDefault("labName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "labName", valid_564225
  var valid_564226 = path.getOrDefault("name")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "name", valid_564226
  var valid_564227 = path.getOrDefault("subscriptionId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "subscriptionId", valid_564227
  var valid_564228 = path.getOrDefault("resourceGroupName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "resourceGroupName", valid_564228
  var valid_564229 = path.getOrDefault("artifactSourceName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "artifactSourceName", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564230 = query.getOrDefault("api-version")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564230 != nil:
    section.add "api-version", valid_564230
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

proc call*(call_564232: Call_ArtifactsGenerateArmTemplate_564222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_ArtifactsGenerateArmTemplate_564222; labName: string;
          generateArmTemplateRequest: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## artifactsGenerateArmTemplate
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   generateArmTemplateRequest: JObject (required)
  ##                             : Parameters for generating an ARM template for deploying artifacts.
  ##   name: string (required)
  ##       : The name of the artifact.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  var body_564236 = newJObject()
  add(path_564234, "labName", newJString(labName))
  add(query_564235, "api-version", newJString(apiVersion))
  if generateArmTemplateRequest != nil:
    body_564236 = generateArmTemplateRequest
  add(path_564234, "name", newJString(name))
  add(path_564234, "subscriptionId", newJString(subscriptionId))
  add(path_564234, "resourceGroupName", newJString(resourceGroupName))
  add(path_564234, "artifactSourceName", newJString(artifactSourceName))
  result = call_564233.call(path_564234, query_564235, nil, nil, body_564236)

var artifactsGenerateArmTemplate* = Call_ArtifactsGenerateArmTemplate_564222(
    name: "artifactsGenerateArmTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}/generateArmTemplate",
    validator: validate_ArtifactsGenerateArmTemplate_564223, base: "",
    url: url_ArtifactsGenerateArmTemplate_564224, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesCreateOrUpdate_564250 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourcesCreateOrUpdate_564252(protocol: Scheme; host: string;
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

proc validate_ArtifactSourcesCreateOrUpdate_564251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564253 = path.getOrDefault("labName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "labName", valid_564253
  var valid_564254 = path.getOrDefault("name")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "name", valid_564254
  var valid_564255 = path.getOrDefault("subscriptionId")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "subscriptionId", valid_564255
  var valid_564256 = path.getOrDefault("resourceGroupName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "resourceGroupName", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564257 != nil:
    section.add "api-version", valid_564257
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

proc call*(call_564259: Call_ArtifactSourcesCreateOrUpdate_564250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing artifact source.
  ## 
  let valid = call_564259.validator(path, query, header, formData, body)
  let scheme = call_564259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564259.url(scheme.get, call_564259.host, call_564259.base,
                         call_564259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564259, url, valid)

proc call*(call_564260: Call_ArtifactSourcesCreateOrUpdate_564250; labName: string;
          name: string; subscriptionId: string; artifactSource: JsonNode;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## artifactSourcesCreateOrUpdate
  ## Create or replace an existing artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564261 = newJObject()
  var query_564262 = newJObject()
  var body_564263 = newJObject()
  add(path_564261, "labName", newJString(labName))
  add(query_564262, "api-version", newJString(apiVersion))
  add(path_564261, "name", newJString(name))
  add(path_564261, "subscriptionId", newJString(subscriptionId))
  if artifactSource != nil:
    body_564263 = artifactSource
  add(path_564261, "resourceGroupName", newJString(resourceGroupName))
  result = call_564260.call(path_564261, query_564262, nil, nil, body_564263)

var artifactSourcesCreateOrUpdate* = Call_ArtifactSourcesCreateOrUpdate_564250(
    name: "artifactSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesCreateOrUpdate_564251, base: "",
    url: url_ArtifactSourcesCreateOrUpdate_564252, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesGet_564237 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourcesGet_564239(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesGet_564238(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564240 = path.getOrDefault("labName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "labName", valid_564240
  var valid_564241 = path.getOrDefault("name")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "name", valid_564241
  var valid_564242 = path.getOrDefault("subscriptionId")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "subscriptionId", valid_564242
  var valid_564243 = path.getOrDefault("resourceGroupName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "resourceGroupName", valid_564243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564244 = query.getOrDefault("api-version")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564244 != nil:
    section.add "api-version", valid_564244
  var valid_564245 = query.getOrDefault("$expand")
  valid_564245 = validateParameter(valid_564245, JString, required = false,
                                 default = nil)
  if valid_564245 != nil:
    section.add "$expand", valid_564245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564246: Call_ArtifactSourcesGet_564237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact source.
  ## 
  let valid = call_564246.validator(path, query, header, formData, body)
  let scheme = call_564246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564246.url(scheme.get, call_564246.host, call_564246.base,
                         call_564246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564246, url, valid)

proc call*(call_564247: Call_ArtifactSourcesGet_564237; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## artifactSourcesGet
  ## Get artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564248 = newJObject()
  var query_564249 = newJObject()
  add(path_564248, "labName", newJString(labName))
  add(query_564249, "api-version", newJString(apiVersion))
  add(query_564249, "$expand", newJString(Expand))
  add(path_564248, "name", newJString(name))
  add(path_564248, "subscriptionId", newJString(subscriptionId))
  add(path_564248, "resourceGroupName", newJString(resourceGroupName))
  result = call_564247.call(path_564248, query_564249, nil, nil, nil)

var artifactSourcesGet* = Call_ArtifactSourcesGet_564237(
    name: "artifactSourcesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesGet_564238, base: "",
    url: url_ArtifactSourcesGet_564239, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesUpdate_564276 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourcesUpdate_564278(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesUpdate_564277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of artifact sources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564279 = path.getOrDefault("labName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "labName", valid_564279
  var valid_564280 = path.getOrDefault("name")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "name", valid_564280
  var valid_564281 = path.getOrDefault("subscriptionId")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "subscriptionId", valid_564281
  var valid_564282 = path.getOrDefault("resourceGroupName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "resourceGroupName", valid_564282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564283 = query.getOrDefault("api-version")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564283 != nil:
    section.add "api-version", valid_564283
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

proc call*(call_564285: Call_ArtifactSourcesUpdate_564276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of artifact sources.
  ## 
  let valid = call_564285.validator(path, query, header, formData, body)
  let scheme = call_564285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564285.url(scheme.get, call_564285.host, call_564285.base,
                         call_564285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564285, url, valid)

proc call*(call_564286: Call_ArtifactSourcesUpdate_564276; labName: string;
          name: string; subscriptionId: string; artifactSource: JsonNode;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## artifactSourcesUpdate
  ## Modify properties of artifact sources.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   artifactSource: JObject (required)
  ##                 : Properties of an artifact source.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564287 = newJObject()
  var query_564288 = newJObject()
  var body_564289 = newJObject()
  add(path_564287, "labName", newJString(labName))
  add(query_564288, "api-version", newJString(apiVersion))
  add(path_564287, "name", newJString(name))
  add(path_564287, "subscriptionId", newJString(subscriptionId))
  if artifactSource != nil:
    body_564289 = artifactSource
  add(path_564287, "resourceGroupName", newJString(resourceGroupName))
  result = call_564286.call(path_564287, query_564288, nil, nil, body_564289)

var artifactSourcesUpdate* = Call_ArtifactSourcesUpdate_564276(
    name: "artifactSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesUpdate_564277, base: "",
    url: url_ArtifactSourcesUpdate_564278, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesDelete_564264 = ref object of OpenApiRestCall_563548
proc url_ArtifactSourcesDelete_564266(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesDelete_564265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete artifact source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564267 = path.getOrDefault("labName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "labName", valid_564267
  var valid_564268 = path.getOrDefault("name")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "name", valid_564268
  var valid_564269 = path.getOrDefault("subscriptionId")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "subscriptionId", valid_564269
  var valid_564270 = path.getOrDefault("resourceGroupName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "resourceGroupName", valid_564270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564271 = query.getOrDefault("api-version")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564271 != nil:
    section.add "api-version", valid_564271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564272: Call_ArtifactSourcesDelete_564264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete artifact source.
  ## 
  let valid = call_564272.validator(path, query, header, formData, body)
  let scheme = call_564272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564272.url(scheme.get, call_564272.host, call_564272.base,
                         call_564272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564272, url, valid)

proc call*(call_564273: Call_ArtifactSourcesDelete_564264; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## artifactSourcesDelete
  ## Delete artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the artifact source.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564274 = newJObject()
  var query_564275 = newJObject()
  add(path_564274, "labName", newJString(labName))
  add(query_564275, "api-version", newJString(apiVersion))
  add(path_564274, "name", newJString(name))
  add(path_564274, "subscriptionId", newJString(subscriptionId))
  add(path_564274, "resourceGroupName", newJString(resourceGroupName))
  result = call_564273.call(path_564274, query_564275, nil, nil, nil)

var artifactSourcesDelete* = Call_ArtifactSourcesDelete_564264(
    name: "artifactSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesDelete_564265, base: "",
    url: url_ArtifactSourcesDelete_564266, schemes: {Scheme.Https})
type
  Call_CostsCreateOrUpdate_564303 = ref object of OpenApiRestCall_563548
proc url_CostsCreateOrUpdate_564305(protocol: Scheme; host: string; base: string;
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

proc validate_CostsCreateOrUpdate_564304(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing cost.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564306 = path.getOrDefault("labName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "labName", valid_564306
  var valid_564307 = path.getOrDefault("name")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "name", valid_564307
  var valid_564308 = path.getOrDefault("subscriptionId")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "subscriptionId", valid_564308
  var valid_564309 = path.getOrDefault("resourceGroupName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "resourceGroupName", valid_564309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564310 = query.getOrDefault("api-version")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564310 != nil:
    section.add "api-version", valid_564310
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

proc call*(call_564312: Call_CostsCreateOrUpdate_564303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing cost.
  ## 
  let valid = call_564312.validator(path, query, header, formData, body)
  let scheme = call_564312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564312.url(scheme.get, call_564312.host, call_564312.base,
                         call_564312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564312, url, valid)

proc call*(call_564313: Call_CostsCreateOrUpdate_564303; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          labCost: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## costsCreateOrUpdate
  ## Create or replace an existing cost.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   labCost: JObject (required)
  ##          : A cost item.
  var path_564314 = newJObject()
  var query_564315 = newJObject()
  var body_564316 = newJObject()
  add(path_564314, "labName", newJString(labName))
  add(query_564315, "api-version", newJString(apiVersion))
  add(path_564314, "name", newJString(name))
  add(path_564314, "subscriptionId", newJString(subscriptionId))
  add(path_564314, "resourceGroupName", newJString(resourceGroupName))
  if labCost != nil:
    body_564316 = labCost
  result = call_564313.call(path_564314, query_564315, nil, nil, body_564316)

var costsCreateOrUpdate* = Call_CostsCreateOrUpdate_564303(
    name: "costsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
    validator: validate_CostsCreateOrUpdate_564304, base: "",
    url: url_CostsCreateOrUpdate_564305, schemes: {Scheme.Https})
type
  Call_CostsGet_564290 = ref object of OpenApiRestCall_563548
proc url_CostsGet_564292(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CostsGet_564291(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cost.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the cost.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564293 = path.getOrDefault("labName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "labName", valid_564293
  var valid_564294 = path.getOrDefault("name")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "name", valid_564294
  var valid_564295 = path.getOrDefault("subscriptionId")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "subscriptionId", valid_564295
  var valid_564296 = path.getOrDefault("resourceGroupName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "resourceGroupName", valid_564296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=labCostDetails)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564297 = query.getOrDefault("api-version")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564297 != nil:
    section.add "api-version", valid_564297
  var valid_564298 = query.getOrDefault("$expand")
  valid_564298 = validateParameter(valid_564298, JString, required = false,
                                 default = nil)
  if valid_564298 != nil:
    section.add "$expand", valid_564298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564299: Call_CostsGet_564290; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost.
  ## 
  let valid = call_564299.validator(path, query, header, formData, body)
  let scheme = call_564299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564299.url(scheme.get, call_564299.host, call_564299.base,
                         call_564299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564299, url, valid)

proc call*(call_564300: Call_CostsGet_564290; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## costsGet
  ## Get cost.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=labCostDetails)'
  ##   name: string (required)
  ##       : The name of the cost.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564301 = newJObject()
  var query_564302 = newJObject()
  add(path_564301, "labName", newJString(labName))
  add(query_564302, "api-version", newJString(apiVersion))
  add(query_564302, "$expand", newJString(Expand))
  add(path_564301, "name", newJString(name))
  add(path_564301, "subscriptionId", newJString(subscriptionId))
  add(path_564301, "resourceGroupName", newJString(resourceGroupName))
  result = call_564300.call(path_564301, query_564302, nil, nil, nil)

var costsGet* = Call_CostsGet_564290(name: "costsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
                                  validator: validate_CostsGet_564291, base: "",
                                  url: url_CostsGet_564292,
                                  schemes: {Scheme.Https})
type
  Call_CustomImagesList_564317 = ref object of OpenApiRestCall_563548
proc url_CustomImagesList_564319(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesList_564318(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List custom images in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564320 = path.getOrDefault("labName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "labName", valid_564320
  var valid_564321 = path.getOrDefault("subscriptionId")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "subscriptionId", valid_564321
  var valid_564322 = path.getOrDefault("resourceGroupName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "resourceGroupName", valid_564322
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564323 = query.getOrDefault("$top")
  valid_564323 = validateParameter(valid_564323, JInt, required = false, default = nil)
  if valid_564323 != nil:
    section.add "$top", valid_564323
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  var valid_564325 = query.getOrDefault("$expand")
  valid_564325 = validateParameter(valid_564325, JString, required = false,
                                 default = nil)
  if valid_564325 != nil:
    section.add "$expand", valid_564325
  var valid_564326 = query.getOrDefault("$orderby")
  valid_564326 = validateParameter(valid_564326, JString, required = false,
                                 default = nil)
  if valid_564326 != nil:
    section.add "$orderby", valid_564326
  var valid_564327 = query.getOrDefault("$filter")
  valid_564327 = validateParameter(valid_564327, JString, required = false,
                                 default = nil)
  if valid_564327 != nil:
    section.add "$filter", valid_564327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564328: Call_CustomImagesList_564317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List custom images in a given lab.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_CustomImagesList_564317; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## customImagesList
  ## List custom images in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=vm)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  add(path_564330, "labName", newJString(labName))
  add(query_564331, "$top", newJInt(Top))
  add(query_564331, "api-version", newJString(apiVersion))
  add(query_564331, "$expand", newJString(Expand))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(query_564331, "$orderby", newJString(Orderby))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  add(query_564331, "$filter", newJString(Filter))
  result = call_564329.call(path_564330, query_564331, nil, nil, nil)

var customImagesList* = Call_CustomImagesList_564317(name: "customImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages",
    validator: validate_CustomImagesList_564318, base: "",
    url: url_CustomImagesList_564319, schemes: {Scheme.Https})
type
  Call_CustomImagesCreateOrUpdate_564345 = ref object of OpenApiRestCall_563548
proc url_CustomImagesCreateOrUpdate_564347(protocol: Scheme; host: string;
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

proc validate_CustomImagesCreateOrUpdate_564346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564348 = path.getOrDefault("labName")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "labName", valid_564348
  var valid_564349 = path.getOrDefault("name")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "name", valid_564349
  var valid_564350 = path.getOrDefault("subscriptionId")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "subscriptionId", valid_564350
  var valid_564351 = path.getOrDefault("resourceGroupName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "resourceGroupName", valid_564351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564352 = query.getOrDefault("api-version")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564352 != nil:
    section.add "api-version", valid_564352
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

proc call*(call_564354: Call_CustomImagesCreateOrUpdate_564345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  let valid = call_564354.validator(path, query, header, formData, body)
  let scheme = call_564354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564354.url(scheme.get, call_564354.host, call_564354.base,
                         call_564354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564354, url, valid)

proc call*(call_564355: Call_CustomImagesCreateOrUpdate_564345; labName: string;
          customImage: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## customImagesCreateOrUpdate
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   customImage: JObject (required)
  ##              : A custom image.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564356 = newJObject()
  var query_564357 = newJObject()
  var body_564358 = newJObject()
  add(path_564356, "labName", newJString(labName))
  if customImage != nil:
    body_564358 = customImage
  add(query_564357, "api-version", newJString(apiVersion))
  add(path_564356, "name", newJString(name))
  add(path_564356, "subscriptionId", newJString(subscriptionId))
  add(path_564356, "resourceGroupName", newJString(resourceGroupName))
  result = call_564355.call(path_564356, query_564357, nil, nil, body_564358)

var customImagesCreateOrUpdate* = Call_CustomImagesCreateOrUpdate_564345(
    name: "customImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesCreateOrUpdate_564346, base: "",
    url: url_CustomImagesCreateOrUpdate_564347, schemes: {Scheme.Https})
type
  Call_CustomImagesGet_564332 = ref object of OpenApiRestCall_563548
proc url_CustomImagesGet_564334(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesGet_564333(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get custom image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564335 = path.getOrDefault("labName")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "labName", valid_564335
  var valid_564336 = path.getOrDefault("name")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "name", valid_564336
  var valid_564337 = path.getOrDefault("subscriptionId")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "subscriptionId", valid_564337
  var valid_564338 = path.getOrDefault("resourceGroupName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "resourceGroupName", valid_564338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564339 = query.getOrDefault("api-version")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564339 != nil:
    section.add "api-version", valid_564339
  var valid_564340 = query.getOrDefault("$expand")
  valid_564340 = validateParameter(valid_564340, JString, required = false,
                                 default = nil)
  if valid_564340 != nil:
    section.add "$expand", valid_564340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564341: Call_CustomImagesGet_564332; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get custom image.
  ## 
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_CustomImagesGet_564332; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## customImagesGet
  ## Get custom image.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=vm)'
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  add(path_564343, "labName", newJString(labName))
  add(query_564344, "api-version", newJString(apiVersion))
  add(query_564344, "$expand", newJString(Expand))
  add(path_564343, "name", newJString(name))
  add(path_564343, "subscriptionId", newJString(subscriptionId))
  add(path_564343, "resourceGroupName", newJString(resourceGroupName))
  result = call_564342.call(path_564343, query_564344, nil, nil, nil)

var customImagesGet* = Call_CustomImagesGet_564332(name: "customImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesGet_564333, base: "", url: url_CustomImagesGet_564334,
    schemes: {Scheme.Https})
type
  Call_CustomImagesDelete_564359 = ref object of OpenApiRestCall_563548
proc url_CustomImagesDelete_564361(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesDelete_564360(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the custom image.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564362 = path.getOrDefault("labName")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "labName", valid_564362
  var valid_564363 = path.getOrDefault("name")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "name", valid_564363
  var valid_564364 = path.getOrDefault("subscriptionId")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "subscriptionId", valid_564364
  var valid_564365 = path.getOrDefault("resourceGroupName")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "resourceGroupName", valid_564365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564366 = query.getOrDefault("api-version")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564366 != nil:
    section.add "api-version", valid_564366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564367: Call_CustomImagesDelete_564359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  let valid = call_564367.validator(path, query, header, formData, body)
  let scheme = call_564367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564367.url(scheme.get, call_564367.host, call_564367.base,
                         call_564367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564367, url, valid)

proc call*(call_564368: Call_CustomImagesDelete_564359; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## customImagesDelete
  ## Delete custom image. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the custom image.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564369 = newJObject()
  var query_564370 = newJObject()
  add(path_564369, "labName", newJString(labName))
  add(query_564370, "api-version", newJString(apiVersion))
  add(path_564369, "name", newJString(name))
  add(path_564369, "subscriptionId", newJString(subscriptionId))
  add(path_564369, "resourceGroupName", newJString(resourceGroupName))
  result = call_564368.call(path_564369, query_564370, nil, nil, nil)

var customImagesDelete* = Call_CustomImagesDelete_564359(
    name: "customImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesDelete_564360, base: "",
    url: url_CustomImagesDelete_564361, schemes: {Scheme.Https})
type
  Call_FormulasList_564371 = ref object of OpenApiRestCall_563548
proc url_FormulasList_564373(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasList_564372(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List formulas in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564374 = path.getOrDefault("labName")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "labName", valid_564374
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
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564377 = query.getOrDefault("$top")
  valid_564377 = validateParameter(valid_564377, JInt, required = false, default = nil)
  if valid_564377 != nil:
    section.add "$top", valid_564377
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564378 = query.getOrDefault("api-version")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564378 != nil:
    section.add "api-version", valid_564378
  var valid_564379 = query.getOrDefault("$expand")
  valid_564379 = validateParameter(valid_564379, JString, required = false,
                                 default = nil)
  if valid_564379 != nil:
    section.add "$expand", valid_564379
  var valid_564380 = query.getOrDefault("$orderby")
  valid_564380 = validateParameter(valid_564380, JString, required = false,
                                 default = nil)
  if valid_564380 != nil:
    section.add "$orderby", valid_564380
  var valid_564381 = query.getOrDefault("$filter")
  valid_564381 = validateParameter(valid_564381, JString, required = false,
                                 default = nil)
  if valid_564381 != nil:
    section.add "$filter", valid_564381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564382: Call_FormulasList_564371; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List formulas in a given lab.
  ## 
  let valid = call_564382.validator(path, query, header, formData, body)
  let scheme = call_564382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564382.url(scheme.get, call_564382.host, call_564382.base,
                         call_564382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564382, url, valid)

proc call*(call_564383: Call_FormulasList_564371; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## formulasList
  ## List formulas in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564384 = newJObject()
  var query_564385 = newJObject()
  add(path_564384, "labName", newJString(labName))
  add(query_564385, "$top", newJInt(Top))
  add(query_564385, "api-version", newJString(apiVersion))
  add(query_564385, "$expand", newJString(Expand))
  add(path_564384, "subscriptionId", newJString(subscriptionId))
  add(query_564385, "$orderby", newJString(Orderby))
  add(path_564384, "resourceGroupName", newJString(resourceGroupName))
  add(query_564385, "$filter", newJString(Filter))
  result = call_564383.call(path_564384, query_564385, nil, nil, nil)

var formulasList* = Call_FormulasList_564371(name: "formulasList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas",
    validator: validate_FormulasList_564372, base: "", url: url_FormulasList_564373,
    schemes: {Scheme.Https})
type
  Call_FormulasCreateOrUpdate_564399 = ref object of OpenApiRestCall_563548
proc url_FormulasCreateOrUpdate_564401(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasCreateOrUpdate_564400(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564402 = path.getOrDefault("labName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "labName", valid_564402
  var valid_564403 = path.getOrDefault("name")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "name", valid_564403
  var valid_564404 = path.getOrDefault("subscriptionId")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "subscriptionId", valid_564404
  var valid_564405 = path.getOrDefault("resourceGroupName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "resourceGroupName", valid_564405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564406 = query.getOrDefault("api-version")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564406 != nil:
    section.add "api-version", valid_564406
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

proc call*(call_564408: Call_FormulasCreateOrUpdate_564399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ## 
  let valid = call_564408.validator(path, query, header, formData, body)
  let scheme = call_564408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564408.url(scheme.get, call_564408.host, call_564408.base,
                         call_564408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564408, url, valid)

proc call*(call_564409: Call_FormulasCreateOrUpdate_564399; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          formula: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## formulasCreateOrUpdate
  ## Create or replace an existing Formula. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   formula: JObject (required)
  ##          : A formula for creating a VM, specifying an image base and other parameters
  var path_564410 = newJObject()
  var query_564411 = newJObject()
  var body_564412 = newJObject()
  add(path_564410, "labName", newJString(labName))
  add(query_564411, "api-version", newJString(apiVersion))
  add(path_564410, "name", newJString(name))
  add(path_564410, "subscriptionId", newJString(subscriptionId))
  add(path_564410, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_564412 = formula
  result = call_564409.call(path_564410, query_564411, nil, nil, body_564412)

var formulasCreateOrUpdate* = Call_FormulasCreateOrUpdate_564399(
    name: "formulasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasCreateOrUpdate_564400, base: "",
    url: url_FormulasCreateOrUpdate_564401, schemes: {Scheme.Https})
type
  Call_FormulasGet_564386 = ref object of OpenApiRestCall_563548
proc url_FormulasGet_564388(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasGet_564387(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564389 = path.getOrDefault("labName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "labName", valid_564389
  var valid_564390 = path.getOrDefault("name")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "name", valid_564390
  var valid_564391 = path.getOrDefault("subscriptionId")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "subscriptionId", valid_564391
  var valid_564392 = path.getOrDefault("resourceGroupName")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "resourceGroupName", valid_564392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564393 = query.getOrDefault("api-version")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564393 != nil:
    section.add "api-version", valid_564393
  var valid_564394 = query.getOrDefault("$expand")
  valid_564394 = validateParameter(valid_564394, JString, required = false,
                                 default = nil)
  if valid_564394 != nil:
    section.add "$expand", valid_564394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564395: Call_FormulasGet_564386; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get formula.
  ## 
  let valid = call_564395.validator(path, query, header, formData, body)
  let scheme = call_564395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564395.url(scheme.get, call_564395.host, call_564395.base,
                         call_564395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564395, url, valid)

proc call*(call_564396: Call_FormulasGet_564386; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## formulasGet
  ## Get formula.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564397 = newJObject()
  var query_564398 = newJObject()
  add(path_564397, "labName", newJString(labName))
  add(query_564398, "api-version", newJString(apiVersion))
  add(query_564398, "$expand", newJString(Expand))
  add(path_564397, "name", newJString(name))
  add(path_564397, "subscriptionId", newJString(subscriptionId))
  add(path_564397, "resourceGroupName", newJString(resourceGroupName))
  result = call_564396.call(path_564397, query_564398, nil, nil, nil)

var formulasGet* = Call_FormulasGet_564386(name: "formulasGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
                                        validator: validate_FormulasGet_564387,
                                        base: "", url: url_FormulasGet_564388,
                                        schemes: {Scheme.Https})
type
  Call_FormulasDelete_564413 = ref object of OpenApiRestCall_563548
proc url_FormulasDelete_564415(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasDelete_564414(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete formula.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the formula.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564416 = path.getOrDefault("labName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "labName", valid_564416
  var valid_564417 = path.getOrDefault("name")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "name", valid_564417
  var valid_564418 = path.getOrDefault("subscriptionId")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "subscriptionId", valid_564418
  var valid_564419 = path.getOrDefault("resourceGroupName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "resourceGroupName", valid_564419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564420 = query.getOrDefault("api-version")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564420 != nil:
    section.add "api-version", valid_564420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564421: Call_FormulasDelete_564413; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete formula.
  ## 
  let valid = call_564421.validator(path, query, header, formData, body)
  let scheme = call_564421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564421.url(scheme.get, call_564421.host, call_564421.base,
                         call_564421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564421, url, valid)

proc call*(call_564422: Call_FormulasDelete_564413; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## formulasDelete
  ## Delete formula.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the formula.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564423 = newJObject()
  var query_564424 = newJObject()
  add(path_564423, "labName", newJString(labName))
  add(query_564424, "api-version", newJString(apiVersion))
  add(path_564423, "name", newJString(name))
  add(path_564423, "subscriptionId", newJString(subscriptionId))
  add(path_564423, "resourceGroupName", newJString(resourceGroupName))
  result = call_564422.call(path_564423, query_564424, nil, nil, nil)

var formulasDelete* = Call_FormulasDelete_564413(name: "formulasDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasDelete_564414, base: "", url: url_FormulasDelete_564415,
    schemes: {Scheme.Https})
type
  Call_GalleryImagesList_564425 = ref object of OpenApiRestCall_563548
proc url_GalleryImagesList_564427(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesList_564426(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List gallery images in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564428 = path.getOrDefault("labName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "labName", valid_564428
  var valid_564429 = path.getOrDefault("subscriptionId")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "subscriptionId", valid_564429
  var valid_564430 = path.getOrDefault("resourceGroupName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "resourceGroupName", valid_564430
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564431 = query.getOrDefault("$top")
  valid_564431 = validateParameter(valid_564431, JInt, required = false, default = nil)
  if valid_564431 != nil:
    section.add "$top", valid_564431
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564432 = query.getOrDefault("api-version")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564432 != nil:
    section.add "api-version", valid_564432
  var valid_564433 = query.getOrDefault("$expand")
  valid_564433 = validateParameter(valid_564433, JString, required = false,
                                 default = nil)
  if valid_564433 != nil:
    section.add "$expand", valid_564433
  var valid_564434 = query.getOrDefault("$orderby")
  valid_564434 = validateParameter(valid_564434, JString, required = false,
                                 default = nil)
  if valid_564434 != nil:
    section.add "$orderby", valid_564434
  var valid_564435 = query.getOrDefault("$filter")
  valid_564435 = validateParameter(valid_564435, JString, required = false,
                                 default = nil)
  if valid_564435 != nil:
    section.add "$filter", valid_564435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564436: Call_GalleryImagesList_564425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images in a given lab.
  ## 
  let valid = call_564436.validator(path, query, header, formData, body)
  let scheme = call_564436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564436.url(scheme.get, call_564436.host, call_564436.base,
                         call_564436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564436, url, valid)

proc call*(call_564437: Call_GalleryImagesList_564425; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## galleryImagesList
  ## List gallery images in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564438 = newJObject()
  var query_564439 = newJObject()
  add(path_564438, "labName", newJString(labName))
  add(query_564439, "$top", newJInt(Top))
  add(query_564439, "api-version", newJString(apiVersion))
  add(query_564439, "$expand", newJString(Expand))
  add(path_564438, "subscriptionId", newJString(subscriptionId))
  add(query_564439, "$orderby", newJString(Orderby))
  add(path_564438, "resourceGroupName", newJString(resourceGroupName))
  add(query_564439, "$filter", newJString(Filter))
  result = call_564437.call(path_564438, query_564439, nil, nil, nil)

var galleryImagesList* = Call_GalleryImagesList_564425(name: "galleryImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/galleryimages",
    validator: validate_GalleryImagesList_564426, base: "",
    url: url_GalleryImagesList_564427, schemes: {Scheme.Https})
type
  Call_NotificationChannelsList_564440 = ref object of OpenApiRestCall_563548
proc url_NotificationChannelsList_564442(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsList_564441(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List notification channels in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564443 = path.getOrDefault("labName")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "labName", valid_564443
  var valid_564444 = path.getOrDefault("subscriptionId")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "subscriptionId", valid_564444
  var valid_564445 = path.getOrDefault("resourceGroupName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "resourceGroupName", valid_564445
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564446 = query.getOrDefault("$top")
  valid_564446 = validateParameter(valid_564446, JInt, required = false, default = nil)
  if valid_564446 != nil:
    section.add "$top", valid_564446
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564447 = query.getOrDefault("api-version")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564447 != nil:
    section.add "api-version", valid_564447
  var valid_564448 = query.getOrDefault("$expand")
  valid_564448 = validateParameter(valid_564448, JString, required = false,
                                 default = nil)
  if valid_564448 != nil:
    section.add "$expand", valid_564448
  var valid_564449 = query.getOrDefault("$orderby")
  valid_564449 = validateParameter(valid_564449, JString, required = false,
                                 default = nil)
  if valid_564449 != nil:
    section.add "$orderby", valid_564449
  var valid_564450 = query.getOrDefault("$filter")
  valid_564450 = validateParameter(valid_564450, JString, required = false,
                                 default = nil)
  if valid_564450 != nil:
    section.add "$filter", valid_564450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564451: Call_NotificationChannelsList_564440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List notification channels in a given lab.
  ## 
  let valid = call_564451.validator(path, query, header, formData, body)
  let scheme = call_564451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564451.url(scheme.get, call_564451.host, call_564451.base,
                         call_564451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564451, url, valid)

proc call*(call_564452: Call_NotificationChannelsList_564440; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## notificationChannelsList
  ## List notification channels in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564453 = newJObject()
  var query_564454 = newJObject()
  add(path_564453, "labName", newJString(labName))
  add(query_564454, "$top", newJInt(Top))
  add(query_564454, "api-version", newJString(apiVersion))
  add(query_564454, "$expand", newJString(Expand))
  add(path_564453, "subscriptionId", newJString(subscriptionId))
  add(query_564454, "$orderby", newJString(Orderby))
  add(path_564453, "resourceGroupName", newJString(resourceGroupName))
  add(query_564454, "$filter", newJString(Filter))
  result = call_564452.call(path_564453, query_564454, nil, nil, nil)

var notificationChannelsList* = Call_NotificationChannelsList_564440(
    name: "notificationChannelsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels",
    validator: validate_NotificationChannelsList_564441, base: "",
    url: url_NotificationChannelsList_564442, schemes: {Scheme.Https})
type
  Call_NotificationChannelsCreateOrUpdate_564468 = ref object of OpenApiRestCall_563548
proc url_NotificationChannelsCreateOrUpdate_564470(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsCreateOrUpdate_564469(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing notificationChannel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564471 = path.getOrDefault("labName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "labName", valid_564471
  var valid_564472 = path.getOrDefault("name")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "name", valid_564472
  var valid_564473 = path.getOrDefault("subscriptionId")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "subscriptionId", valid_564473
  var valid_564474 = path.getOrDefault("resourceGroupName")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "resourceGroupName", valid_564474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564475 = query.getOrDefault("api-version")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564475 != nil:
    section.add "api-version", valid_564475
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

proc call*(call_564477: Call_NotificationChannelsCreateOrUpdate_564468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing notificationChannel.
  ## 
  let valid = call_564477.validator(path, query, header, formData, body)
  let scheme = call_564477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564477.url(scheme.get, call_564477.host, call_564477.base,
                         call_564477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564477, url, valid)

proc call*(call_564478: Call_NotificationChannelsCreateOrUpdate_564468;
          labName: string; notificationChannel: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsCreateOrUpdate
  ## Create or replace an existing notificationChannel.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564479 = newJObject()
  var query_564480 = newJObject()
  var body_564481 = newJObject()
  add(path_564479, "labName", newJString(labName))
  add(query_564480, "api-version", newJString(apiVersion))
  if notificationChannel != nil:
    body_564481 = notificationChannel
  add(path_564479, "name", newJString(name))
  add(path_564479, "subscriptionId", newJString(subscriptionId))
  add(path_564479, "resourceGroupName", newJString(resourceGroupName))
  result = call_564478.call(path_564479, query_564480, nil, nil, body_564481)

var notificationChannelsCreateOrUpdate* = Call_NotificationChannelsCreateOrUpdate_564468(
    name: "notificationChannelsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsCreateOrUpdate_564469, base: "",
    url: url_NotificationChannelsCreateOrUpdate_564470, schemes: {Scheme.Https})
type
  Call_NotificationChannelsGet_564455 = ref object of OpenApiRestCall_563548
proc url_NotificationChannelsGet_564457(protocol: Scheme; host: string; base: string;
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

proc validate_NotificationChannelsGet_564456(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get notification channels.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564458 = path.getOrDefault("labName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "labName", valid_564458
  var valid_564459 = path.getOrDefault("name")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "name", valid_564459
  var valid_564460 = path.getOrDefault("subscriptionId")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "subscriptionId", valid_564460
  var valid_564461 = path.getOrDefault("resourceGroupName")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "resourceGroupName", valid_564461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564462 = query.getOrDefault("api-version")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564462 != nil:
    section.add "api-version", valid_564462
  var valid_564463 = query.getOrDefault("$expand")
  valid_564463 = validateParameter(valid_564463, JString, required = false,
                                 default = nil)
  if valid_564463 != nil:
    section.add "$expand", valid_564463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564464: Call_NotificationChannelsGet_564455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get notification channels.
  ## 
  let valid = call_564464.validator(path, query, header, formData, body)
  let scheme = call_564464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564464.url(scheme.get, call_564464.host, call_564464.base,
                         call_564464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564464, url, valid)

proc call*(call_564465: Call_NotificationChannelsGet_564455; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## notificationChannelsGet
  ## Get notification channels.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564466 = newJObject()
  var query_564467 = newJObject()
  add(path_564466, "labName", newJString(labName))
  add(query_564467, "api-version", newJString(apiVersion))
  add(query_564467, "$expand", newJString(Expand))
  add(path_564466, "name", newJString(name))
  add(path_564466, "subscriptionId", newJString(subscriptionId))
  add(path_564466, "resourceGroupName", newJString(resourceGroupName))
  result = call_564465.call(path_564466, query_564467, nil, nil, nil)

var notificationChannelsGet* = Call_NotificationChannelsGet_564455(
    name: "notificationChannelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsGet_564456, base: "",
    url: url_NotificationChannelsGet_564457, schemes: {Scheme.Https})
type
  Call_NotificationChannelsUpdate_564494 = ref object of OpenApiRestCall_563548
proc url_NotificationChannelsUpdate_564496(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsUpdate_564495(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of notification channels.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564497 = path.getOrDefault("labName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "labName", valid_564497
  var valid_564498 = path.getOrDefault("name")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "name", valid_564498
  var valid_564499 = path.getOrDefault("subscriptionId")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "subscriptionId", valid_564499
  var valid_564500 = path.getOrDefault("resourceGroupName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "resourceGroupName", valid_564500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564501 = query.getOrDefault("api-version")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564501 != nil:
    section.add "api-version", valid_564501
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

proc call*(call_564503: Call_NotificationChannelsUpdate_564494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of notification channels.
  ## 
  let valid = call_564503.validator(path, query, header, formData, body)
  let scheme = call_564503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564503.url(scheme.get, call_564503.host, call_564503.base,
                         call_564503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564503, url, valid)

proc call*(call_564504: Call_NotificationChannelsUpdate_564494; labName: string;
          notificationChannel: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsUpdate
  ## Modify properties of notification channels.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564505 = newJObject()
  var query_564506 = newJObject()
  var body_564507 = newJObject()
  add(path_564505, "labName", newJString(labName))
  add(query_564506, "api-version", newJString(apiVersion))
  if notificationChannel != nil:
    body_564507 = notificationChannel
  add(path_564505, "name", newJString(name))
  add(path_564505, "subscriptionId", newJString(subscriptionId))
  add(path_564505, "resourceGroupName", newJString(resourceGroupName))
  result = call_564504.call(path_564505, query_564506, nil, nil, body_564507)

var notificationChannelsUpdate* = Call_NotificationChannelsUpdate_564494(
    name: "notificationChannelsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsUpdate_564495, base: "",
    url: url_NotificationChannelsUpdate_564496, schemes: {Scheme.Https})
type
  Call_NotificationChannelsDelete_564482 = ref object of OpenApiRestCall_563548
proc url_NotificationChannelsDelete_564484(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsDelete_564483(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564485 = path.getOrDefault("labName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "labName", valid_564485
  var valid_564486 = path.getOrDefault("name")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "name", valid_564486
  var valid_564487 = path.getOrDefault("subscriptionId")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "subscriptionId", valid_564487
  var valid_564488 = path.getOrDefault("resourceGroupName")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "resourceGroupName", valid_564488
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564489 = query.getOrDefault("api-version")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564489 != nil:
    section.add "api-version", valid_564489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564490: Call_NotificationChannelsDelete_564482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete notification channel.
  ## 
  let valid = call_564490.validator(path, query, header, formData, body)
  let scheme = call_564490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564490.url(scheme.get, call_564490.host, call_564490.base,
                         call_564490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564490, url, valid)

proc call*(call_564491: Call_NotificationChannelsDelete_564482; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsDelete
  ## Delete notification channel.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564492 = newJObject()
  var query_564493 = newJObject()
  add(path_564492, "labName", newJString(labName))
  add(query_564493, "api-version", newJString(apiVersion))
  add(path_564492, "name", newJString(name))
  add(path_564492, "subscriptionId", newJString(subscriptionId))
  add(path_564492, "resourceGroupName", newJString(resourceGroupName))
  result = call_564491.call(path_564492, query_564493, nil, nil, nil)

var notificationChannelsDelete* = Call_NotificationChannelsDelete_564482(
    name: "notificationChannelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsDelete_564483, base: "",
    url: url_NotificationChannelsDelete_564484, schemes: {Scheme.Https})
type
  Call_NotificationChannelsNotify_564508 = ref object of OpenApiRestCall_563548
proc url_NotificationChannelsNotify_564510(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsNotify_564509(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send notification to provided channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564511 = path.getOrDefault("labName")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "labName", valid_564511
  var valid_564512 = path.getOrDefault("name")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "name", valid_564512
  var valid_564513 = path.getOrDefault("subscriptionId")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "subscriptionId", valid_564513
  var valid_564514 = path.getOrDefault("resourceGroupName")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "resourceGroupName", valid_564514
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564515 = query.getOrDefault("api-version")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564515 != nil:
    section.add "api-version", valid_564515
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

proc call*(call_564517: Call_NotificationChannelsNotify_564508; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send notification to provided channel.
  ## 
  let valid = call_564517.validator(path, query, header, formData, body)
  let scheme = call_564517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564517.url(scheme.get, call_564517.host, call_564517.base,
                         call_564517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564517, url, valid)

proc call*(call_564518: Call_NotificationChannelsNotify_564508; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          notifyParameters: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## notificationChannelsNotify
  ## Send notification to provided channel.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notificationChannel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   notifyParameters: JObject (required)
  ##                   : Properties for generating a Notification.
  var path_564519 = newJObject()
  var query_564520 = newJObject()
  var body_564521 = newJObject()
  add(path_564519, "labName", newJString(labName))
  add(query_564520, "api-version", newJString(apiVersion))
  add(path_564519, "name", newJString(name))
  add(path_564519, "subscriptionId", newJString(subscriptionId))
  add(path_564519, "resourceGroupName", newJString(resourceGroupName))
  if notifyParameters != nil:
    body_564521 = notifyParameters
  result = call_564518.call(path_564519, query_564520, nil, nil, body_564521)

var notificationChannelsNotify* = Call_NotificationChannelsNotify_564508(
    name: "notificationChannelsNotify", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}/notify",
    validator: validate_NotificationChannelsNotify_564509, base: "",
    url: url_NotificationChannelsNotify_564510, schemes: {Scheme.Https})
type
  Call_PolicySetsEvaluatePolicies_564522 = ref object of OpenApiRestCall_563548
proc url_PolicySetsEvaluatePolicies_564524(protocol: Scheme; host: string;
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

proc validate_PolicySetsEvaluatePolicies_564523(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Evaluates lab policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564525 = path.getOrDefault("labName")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "labName", valid_564525
  var valid_564526 = path.getOrDefault("name")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "name", valid_564526
  var valid_564527 = path.getOrDefault("subscriptionId")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "subscriptionId", valid_564527
  var valid_564528 = path.getOrDefault("resourceGroupName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "resourceGroupName", valid_564528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564529 = query.getOrDefault("api-version")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564529 != nil:
    section.add "api-version", valid_564529
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

proc call*(call_564531: Call_PolicySetsEvaluatePolicies_564522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Evaluates lab policy.
  ## 
  let valid = call_564531.validator(path, query, header, formData, body)
  let scheme = call_564531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564531.url(scheme.get, call_564531.host, call_564531.base,
                         call_564531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564531, url, valid)

proc call*(call_564532: Call_PolicySetsEvaluatePolicies_564522; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          evaluatePoliciesRequest: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## policySetsEvaluatePolicies
  ## Evaluates lab policy.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   evaluatePoliciesRequest: JObject (required)
  ##                          : Request body for evaluating a policy set.
  var path_564533 = newJObject()
  var query_564534 = newJObject()
  var body_564535 = newJObject()
  add(path_564533, "labName", newJString(labName))
  add(query_564534, "api-version", newJString(apiVersion))
  add(path_564533, "name", newJString(name))
  add(path_564533, "subscriptionId", newJString(subscriptionId))
  add(path_564533, "resourceGroupName", newJString(resourceGroupName))
  if evaluatePoliciesRequest != nil:
    body_564535 = evaluatePoliciesRequest
  result = call_564532.call(path_564533, query_564534, nil, nil, body_564535)

var policySetsEvaluatePolicies* = Call_PolicySetsEvaluatePolicies_564522(
    name: "policySetsEvaluatePolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{name}/evaluatePolicies",
    validator: validate_PolicySetsEvaluatePolicies_564523, base: "",
    url: url_PolicySetsEvaluatePolicies_564524, schemes: {Scheme.Https})
type
  Call_PoliciesList_564536 = ref object of OpenApiRestCall_563548
proc url_PoliciesList_564538(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesList_564537(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List policies in a given policy set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564539 = path.getOrDefault("labName")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "labName", valid_564539
  var valid_564540 = path.getOrDefault("policySetName")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "policySetName", valid_564540
  var valid_564541 = path.getOrDefault("subscriptionId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "subscriptionId", valid_564541
  var valid_564542 = path.getOrDefault("resourceGroupName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "resourceGroupName", valid_564542
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564543 = query.getOrDefault("$top")
  valid_564543 = validateParameter(valid_564543, JInt, required = false, default = nil)
  if valid_564543 != nil:
    section.add "$top", valid_564543
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564544 = query.getOrDefault("api-version")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564544 != nil:
    section.add "api-version", valid_564544
  var valid_564545 = query.getOrDefault("$expand")
  valid_564545 = validateParameter(valid_564545, JString, required = false,
                                 default = nil)
  if valid_564545 != nil:
    section.add "$expand", valid_564545
  var valid_564546 = query.getOrDefault("$orderby")
  valid_564546 = validateParameter(valid_564546, JString, required = false,
                                 default = nil)
  if valid_564546 != nil:
    section.add "$orderby", valid_564546
  var valid_564547 = query.getOrDefault("$filter")
  valid_564547 = validateParameter(valid_564547, JString, required = false,
                                 default = nil)
  if valid_564547 != nil:
    section.add "$filter", valid_564547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564548: Call_PoliciesList_564536; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List policies in a given policy set.
  ## 
  let valid = call_564548.validator(path, query, header, formData, body)
  let scheme = call_564548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564548.url(scheme.get, call_564548.host, call_564548.base,
                         call_564548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564548, url, valid)

proc call*(call_564549: Call_PoliciesList_564536; labName: string;
          policySetName: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; apiVersion: string = "2016-05-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## policiesList
  ## List policies in a given policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564550 = newJObject()
  var query_564551 = newJObject()
  add(path_564550, "labName", newJString(labName))
  add(query_564551, "$top", newJInt(Top))
  add(query_564551, "api-version", newJString(apiVersion))
  add(query_564551, "$expand", newJString(Expand))
  add(path_564550, "policySetName", newJString(policySetName))
  add(path_564550, "subscriptionId", newJString(subscriptionId))
  add(query_564551, "$orderby", newJString(Orderby))
  add(path_564550, "resourceGroupName", newJString(resourceGroupName))
  add(query_564551, "$filter", newJString(Filter))
  result = call_564549.call(path_564550, query_564551, nil, nil, nil)

var policiesList* = Call_PoliciesList_564536(name: "policiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies",
    validator: validate_PoliciesList_564537, base: "", url: url_PoliciesList_564538,
    schemes: {Scheme.Https})
type
  Call_PoliciesCreateOrUpdate_564566 = ref object of OpenApiRestCall_563548
proc url_PoliciesCreateOrUpdate_564568(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesCreateOrUpdate_564567(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564569 = path.getOrDefault("labName")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "labName", valid_564569
  var valid_564570 = path.getOrDefault("name")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "name", valid_564570
  var valid_564571 = path.getOrDefault("policySetName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "policySetName", valid_564571
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564574 = query.getOrDefault("api-version")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564574 != nil:
    section.add "api-version", valid_564574
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

proc call*(call_564576: Call_PoliciesCreateOrUpdate_564566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing policy.
  ## 
  let valid = call_564576.validator(path, query, header, formData, body)
  let scheme = call_564576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564576.url(scheme.get, call_564576.host, call_564576.base,
                         call_564576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564576, url, valid)

proc call*(call_564577: Call_PoliciesCreateOrUpdate_564566; labName: string;
          policy: JsonNode; name: string; policySetName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## policiesCreateOrUpdate
  ## Create or replace an existing policy.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   policy: JObject (required)
  ##         : A Policy.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564578 = newJObject()
  var query_564579 = newJObject()
  var body_564580 = newJObject()
  add(path_564578, "labName", newJString(labName))
  add(query_564579, "api-version", newJString(apiVersion))
  if policy != nil:
    body_564580 = policy
  add(path_564578, "name", newJString(name))
  add(path_564578, "policySetName", newJString(policySetName))
  add(path_564578, "subscriptionId", newJString(subscriptionId))
  add(path_564578, "resourceGroupName", newJString(resourceGroupName))
  result = call_564577.call(path_564578, query_564579, nil, nil, body_564580)

var policiesCreateOrUpdate* = Call_PoliciesCreateOrUpdate_564566(
    name: "policiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesCreateOrUpdate_564567, base: "",
    url: url_PoliciesCreateOrUpdate_564568, schemes: {Scheme.Https})
type
  Call_PoliciesGet_564552 = ref object of OpenApiRestCall_563548
proc url_PoliciesGet_564554(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesGet_564553(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564555 = path.getOrDefault("labName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "labName", valid_564555
  var valid_564556 = path.getOrDefault("name")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "name", valid_564556
  var valid_564557 = path.getOrDefault("policySetName")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "policySetName", valid_564557
  var valid_564558 = path.getOrDefault("subscriptionId")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "subscriptionId", valid_564558
  var valid_564559 = path.getOrDefault("resourceGroupName")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "resourceGroupName", valid_564559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564560 = query.getOrDefault("api-version")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564560 != nil:
    section.add "api-version", valid_564560
  var valid_564561 = query.getOrDefault("$expand")
  valid_564561 = validateParameter(valid_564561, JString, required = false,
                                 default = nil)
  if valid_564561 != nil:
    section.add "$expand", valid_564561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564562: Call_PoliciesGet_564552; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get policy.
  ## 
  let valid = call_564562.validator(path, query, header, formData, body)
  let scheme = call_564562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564562.url(scheme.get, call_564562.host, call_564562.base,
                         call_564562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564562, url, valid)

proc call*(call_564563: Call_PoliciesGet_564552; labName: string; name: string;
          policySetName: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## policiesGet
  ## Get policy.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   name: string (required)
  ##       : The name of the policy.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564564 = newJObject()
  var query_564565 = newJObject()
  add(path_564564, "labName", newJString(labName))
  add(query_564565, "api-version", newJString(apiVersion))
  add(query_564565, "$expand", newJString(Expand))
  add(path_564564, "name", newJString(name))
  add(path_564564, "policySetName", newJString(policySetName))
  add(path_564564, "subscriptionId", newJString(subscriptionId))
  add(path_564564, "resourceGroupName", newJString(resourceGroupName))
  result = call_564563.call(path_564564, query_564565, nil, nil, nil)

var policiesGet* = Call_PoliciesGet_564552(name: "policiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
                                        validator: validate_PoliciesGet_564553,
                                        base: "", url: url_PoliciesGet_564554,
                                        schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_564594 = ref object of OpenApiRestCall_563548
proc url_PoliciesUpdate_564596(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesUpdate_564595(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Modify properties of policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564597 = path.getOrDefault("labName")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "labName", valid_564597
  var valid_564598 = path.getOrDefault("name")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "name", valid_564598
  var valid_564599 = path.getOrDefault("policySetName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "policySetName", valid_564599
  var valid_564600 = path.getOrDefault("subscriptionId")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "subscriptionId", valid_564600
  var valid_564601 = path.getOrDefault("resourceGroupName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "resourceGroupName", valid_564601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564602 = query.getOrDefault("api-version")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564602 != nil:
    section.add "api-version", valid_564602
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

proc call*(call_564604: Call_PoliciesUpdate_564594; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of policies.
  ## 
  let valid = call_564604.validator(path, query, header, formData, body)
  let scheme = call_564604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564604.url(scheme.get, call_564604.host, call_564604.base,
                         call_564604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564604, url, valid)

proc call*(call_564605: Call_PoliciesUpdate_564594; labName: string;
          policy: JsonNode; name: string; policySetName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## policiesUpdate
  ## Modify properties of policies.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   policy: JObject (required)
  ##         : A Policy.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564606 = newJObject()
  var query_564607 = newJObject()
  var body_564608 = newJObject()
  add(path_564606, "labName", newJString(labName))
  add(query_564607, "api-version", newJString(apiVersion))
  if policy != nil:
    body_564608 = policy
  add(path_564606, "name", newJString(name))
  add(path_564606, "policySetName", newJString(policySetName))
  add(path_564606, "subscriptionId", newJString(subscriptionId))
  add(path_564606, "resourceGroupName", newJString(resourceGroupName))
  result = call_564605.call(path_564606, query_564607, nil, nil, body_564608)

var policiesUpdate* = Call_PoliciesUpdate_564594(name: "policiesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesUpdate_564595, base: "", url: url_PoliciesUpdate_564596,
    schemes: {Scheme.Https})
type
  Call_PoliciesDelete_564581 = ref object of OpenApiRestCall_563548
proc url_PoliciesDelete_564583(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesDelete_564582(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the policy.
  ##   policySetName: JString (required)
  ##                : The name of the policy set.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564584 = path.getOrDefault("labName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "labName", valid_564584
  var valid_564585 = path.getOrDefault("name")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "name", valid_564585
  var valid_564586 = path.getOrDefault("policySetName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "policySetName", valid_564586
  var valid_564587 = path.getOrDefault("subscriptionId")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "subscriptionId", valid_564587
  var valid_564588 = path.getOrDefault("resourceGroupName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "resourceGroupName", valid_564588
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564589 = query.getOrDefault("api-version")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564589 != nil:
    section.add "api-version", valid_564589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564590: Call_PoliciesDelete_564581; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy.
  ## 
  let valid = call_564590.validator(path, query, header, formData, body)
  let scheme = call_564590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564590.url(scheme.get, call_564590.host, call_564590.base,
                         call_564590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564590, url, valid)

proc call*(call_564591: Call_PoliciesDelete_564581; labName: string; name: string;
          policySetName: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## policiesDelete
  ## Delete policy.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the policy.
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564592 = newJObject()
  var query_564593 = newJObject()
  add(path_564592, "labName", newJString(labName))
  add(query_564593, "api-version", newJString(apiVersion))
  add(path_564592, "name", newJString(name))
  add(path_564592, "policySetName", newJString(policySetName))
  add(path_564592, "subscriptionId", newJString(subscriptionId))
  add(path_564592, "resourceGroupName", newJString(resourceGroupName))
  result = call_564591.call(path_564592, query_564593, nil, nil, nil)

var policiesDelete* = Call_PoliciesDelete_564581(name: "policiesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesDelete_564582, base: "", url: url_PoliciesDelete_564583,
    schemes: {Scheme.Https})
type
  Call_SchedulesList_564609 = ref object of OpenApiRestCall_563548
proc url_SchedulesList_564611(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesList_564610(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564612 = path.getOrDefault("labName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "labName", valid_564612
  var valid_564613 = path.getOrDefault("subscriptionId")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "subscriptionId", valid_564613
  var valid_564614 = path.getOrDefault("resourceGroupName")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "resourceGroupName", valid_564614
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564615 = query.getOrDefault("$top")
  valid_564615 = validateParameter(valid_564615, JInt, required = false, default = nil)
  if valid_564615 != nil:
    section.add "$top", valid_564615
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564616 = query.getOrDefault("api-version")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564616 != nil:
    section.add "api-version", valid_564616
  var valid_564617 = query.getOrDefault("$expand")
  valid_564617 = validateParameter(valid_564617, JString, required = false,
                                 default = nil)
  if valid_564617 != nil:
    section.add "$expand", valid_564617
  var valid_564618 = query.getOrDefault("$orderby")
  valid_564618 = validateParameter(valid_564618, JString, required = false,
                                 default = nil)
  if valid_564618 != nil:
    section.add "$orderby", valid_564618
  var valid_564619 = query.getOrDefault("$filter")
  valid_564619 = validateParameter(valid_564619, JString, required = false,
                                 default = nil)
  if valid_564619 != nil:
    section.add "$filter", valid_564619
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564620: Call_SchedulesList_564609; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given lab.
  ## 
  let valid = call_564620.validator(path, query, header, formData, body)
  let scheme = call_564620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564620.url(scheme.get, call_564620.host, call_564620.base,
                         call_564620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564620, url, valid)

proc call*(call_564621: Call_SchedulesList_564609; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## schedulesList
  ## List schedules in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564622 = newJObject()
  var query_564623 = newJObject()
  add(path_564622, "labName", newJString(labName))
  add(query_564623, "$top", newJInt(Top))
  add(query_564623, "api-version", newJString(apiVersion))
  add(query_564623, "$expand", newJString(Expand))
  add(path_564622, "subscriptionId", newJString(subscriptionId))
  add(query_564623, "$orderby", newJString(Orderby))
  add(path_564622, "resourceGroupName", newJString(resourceGroupName))
  add(query_564623, "$filter", newJString(Filter))
  result = call_564621.call(path_564622, query_564623, nil, nil, nil)

var schedulesList* = Call_SchedulesList_564609(name: "schedulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules",
    validator: validate_SchedulesList_564610, base: "", url: url_SchedulesList_564611,
    schemes: {Scheme.Https})
type
  Call_SchedulesCreateOrUpdate_564637 = ref object of OpenApiRestCall_563548
proc url_SchedulesCreateOrUpdate_564639(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesCreateOrUpdate_564638(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564640 = path.getOrDefault("labName")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "labName", valid_564640
  var valid_564641 = path.getOrDefault("name")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "name", valid_564641
  var valid_564642 = path.getOrDefault("subscriptionId")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "subscriptionId", valid_564642
  var valid_564643 = path.getOrDefault("resourceGroupName")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "resourceGroupName", valid_564643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564644 = query.getOrDefault("api-version")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564644 != nil:
    section.add "api-version", valid_564644
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

proc call*(call_564646: Call_SchedulesCreateOrUpdate_564637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_564646.validator(path, query, header, formData, body)
  let scheme = call_564646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564646.url(scheme.get, call_564646.host, call_564646.base,
                         call_564646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564646, url, valid)

proc call*(call_564647: Call_SchedulesCreateOrUpdate_564637; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          schedule: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_564648 = newJObject()
  var query_564649 = newJObject()
  var body_564650 = newJObject()
  add(path_564648, "labName", newJString(labName))
  add(query_564649, "api-version", newJString(apiVersion))
  add(path_564648, "name", newJString(name))
  add(path_564648, "subscriptionId", newJString(subscriptionId))
  add(path_564648, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_564650 = schedule
  result = call_564647.call(path_564648, query_564649, nil, nil, body_564650)

var schedulesCreateOrUpdate* = Call_SchedulesCreateOrUpdate_564637(
    name: "schedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesCreateOrUpdate_564638, base: "",
    url: url_SchedulesCreateOrUpdate_564639, schemes: {Scheme.Https})
type
  Call_SchedulesGet_564624 = ref object of OpenApiRestCall_563548
proc url_SchedulesGet_564626(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesGet_564625(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564627 = path.getOrDefault("labName")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "labName", valid_564627
  var valid_564628 = path.getOrDefault("name")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "name", valid_564628
  var valid_564629 = path.getOrDefault("subscriptionId")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "subscriptionId", valid_564629
  var valid_564630 = path.getOrDefault("resourceGroupName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "resourceGroupName", valid_564630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564631 = query.getOrDefault("api-version")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564631 != nil:
    section.add "api-version", valid_564631
  var valid_564632 = query.getOrDefault("$expand")
  valid_564632 = validateParameter(valid_564632, JString, required = false,
                                 default = nil)
  if valid_564632 != nil:
    section.add "$expand", valid_564632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564633: Call_SchedulesGet_564624; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_564633.validator(path, query, header, formData, body)
  let scheme = call_564633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564633.url(scheme.get, call_564633.host, call_564633.base,
                         call_564633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564633, url, valid)

proc call*(call_564634: Call_SchedulesGet_564624; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## schedulesGet
  ## Get schedule.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564635 = newJObject()
  var query_564636 = newJObject()
  add(path_564635, "labName", newJString(labName))
  add(query_564636, "api-version", newJString(apiVersion))
  add(query_564636, "$expand", newJString(Expand))
  add(path_564635, "name", newJString(name))
  add(path_564635, "subscriptionId", newJString(subscriptionId))
  add(path_564635, "resourceGroupName", newJString(resourceGroupName))
  result = call_564634.call(path_564635, query_564636, nil, nil, nil)

var schedulesGet* = Call_SchedulesGet_564624(name: "schedulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesGet_564625, base: "", url: url_SchedulesGet_564626,
    schemes: {Scheme.Https})
type
  Call_SchedulesUpdate_564663 = ref object of OpenApiRestCall_563548
proc url_SchedulesUpdate_564665(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesUpdate_564664(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Modify properties of schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564666 = path.getOrDefault("labName")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "labName", valid_564666
  var valid_564667 = path.getOrDefault("name")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "name", valid_564667
  var valid_564668 = path.getOrDefault("subscriptionId")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "subscriptionId", valid_564668
  var valid_564669 = path.getOrDefault("resourceGroupName")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "resourceGroupName", valid_564669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564670 = query.getOrDefault("api-version")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564670 != nil:
    section.add "api-version", valid_564670
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

proc call*(call_564672: Call_SchedulesUpdate_564663; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_564672.validator(path, query, header, formData, body)
  let scheme = call_564672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564672.url(scheme.get, call_564672.host, call_564672.base,
                         call_564672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564672, url, valid)

proc call*(call_564673: Call_SchedulesUpdate_564663; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesUpdate
  ## Modify properties of schedules.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_564674 = newJObject()
  var query_564675 = newJObject()
  var body_564676 = newJObject()
  add(path_564674, "labName", newJString(labName))
  add(query_564675, "api-version", newJString(apiVersion))
  add(path_564674, "name", newJString(name))
  add(path_564674, "subscriptionId", newJString(subscriptionId))
  add(path_564674, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_564676 = schedule
  result = call_564673.call(path_564674, query_564675, nil, nil, body_564676)

var schedulesUpdate* = Call_SchedulesUpdate_564663(name: "schedulesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesUpdate_564664, base: "", url: url_SchedulesUpdate_564665,
    schemes: {Scheme.Https})
type
  Call_SchedulesDelete_564651 = ref object of OpenApiRestCall_563548
proc url_SchedulesDelete_564653(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesDelete_564652(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564654 = path.getOrDefault("labName")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "labName", valid_564654
  var valid_564655 = path.getOrDefault("name")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "name", valid_564655
  var valid_564656 = path.getOrDefault("subscriptionId")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "subscriptionId", valid_564656
  var valid_564657 = path.getOrDefault("resourceGroupName")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "resourceGroupName", valid_564657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564658 = query.getOrDefault("api-version")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564658 != nil:
    section.add "api-version", valid_564658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564659: Call_SchedulesDelete_564651; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_564659.validator(path, query, header, formData, body)
  let scheme = call_564659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564659.url(scheme.get, call_564659.host, call_564659.base,
                         call_564659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564659, url, valid)

proc call*(call_564660: Call_SchedulesDelete_564651; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesDelete
  ## Delete schedule.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564661 = newJObject()
  var query_564662 = newJObject()
  add(path_564661, "labName", newJString(labName))
  add(query_564662, "api-version", newJString(apiVersion))
  add(path_564661, "name", newJString(name))
  add(path_564661, "subscriptionId", newJString(subscriptionId))
  add(path_564661, "resourceGroupName", newJString(resourceGroupName))
  result = call_564660.call(path_564661, query_564662, nil, nil, nil)

var schedulesDelete* = Call_SchedulesDelete_564651(name: "schedulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesDelete_564652, base: "", url: url_SchedulesDelete_564653,
    schemes: {Scheme.Https})
type
  Call_SchedulesExecute_564677 = ref object of OpenApiRestCall_563548
proc url_SchedulesExecute_564679(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesExecute_564678(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564680 = path.getOrDefault("labName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "labName", valid_564680
  var valid_564681 = path.getOrDefault("name")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "name", valid_564681
  var valid_564682 = path.getOrDefault("subscriptionId")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "subscriptionId", valid_564682
  var valid_564683 = path.getOrDefault("resourceGroupName")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "resourceGroupName", valid_564683
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564684 = query.getOrDefault("api-version")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564684 != nil:
    section.add "api-version", valid_564684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564685: Call_SchedulesExecute_564677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_564685.validator(path, query, header, formData, body)
  let scheme = call_564685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564685.url(scheme.get, call_564685.host, call_564685.base,
                         call_564685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564685, url, valid)

proc call*(call_564686: Call_SchedulesExecute_564677; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564687 = newJObject()
  var query_564688 = newJObject()
  add(path_564687, "labName", newJString(labName))
  add(query_564688, "api-version", newJString(apiVersion))
  add(path_564687, "name", newJString(name))
  add(path_564687, "subscriptionId", newJString(subscriptionId))
  add(path_564687, "resourceGroupName", newJString(resourceGroupName))
  result = call_564686.call(path_564687, query_564688, nil, nil, nil)

var schedulesExecute* = Call_SchedulesExecute_564677(name: "schedulesExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/execute",
    validator: validate_SchedulesExecute_564678, base: "",
    url: url_SchedulesExecute_564679, schemes: {Scheme.Https})
type
  Call_SchedulesListApplicable_564689 = ref object of OpenApiRestCall_563548
proc url_SchedulesListApplicable_564691(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesListApplicable_564690(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all applicable schedules
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564692 = path.getOrDefault("labName")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "labName", valid_564692
  var valid_564693 = path.getOrDefault("name")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "name", valid_564693
  var valid_564694 = path.getOrDefault("subscriptionId")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "subscriptionId", valid_564694
  var valid_564695 = path.getOrDefault("resourceGroupName")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "resourceGroupName", valid_564695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564696 = query.getOrDefault("api-version")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564696 != nil:
    section.add "api-version", valid_564696
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564697: Call_SchedulesListApplicable_564689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all applicable schedules
  ## 
  let valid = call_564697.validator(path, query, header, formData, body)
  let scheme = call_564697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564697.url(scheme.get, call_564697.host, call_564697.base,
                         call_564697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564697, url, valid)

proc call*(call_564698: Call_SchedulesListApplicable_564689; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## schedulesListApplicable
  ## Lists all applicable schedules
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564699 = newJObject()
  var query_564700 = newJObject()
  add(path_564699, "labName", newJString(labName))
  add(query_564700, "api-version", newJString(apiVersion))
  add(path_564699, "name", newJString(name))
  add(path_564699, "subscriptionId", newJString(subscriptionId))
  add(path_564699, "resourceGroupName", newJString(resourceGroupName))
  result = call_564698.call(path_564699, query_564700, nil, nil, nil)

var schedulesListApplicable* = Call_SchedulesListApplicable_564689(
    name: "schedulesListApplicable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/listApplicable",
    validator: validate_SchedulesListApplicable_564690, base: "",
    url: url_SchedulesListApplicable_564691, schemes: {Scheme.Https})
type
  Call_ServiceRunnersList_564701 = ref object of OpenApiRestCall_563548
proc url_ServiceRunnersList_564703(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceRunnersList_564702(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List service runners in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564704 = path.getOrDefault("labName")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "labName", valid_564704
  var valid_564705 = path.getOrDefault("subscriptionId")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = nil)
  if valid_564705 != nil:
    section.add "subscriptionId", valid_564705
  var valid_564706 = path.getOrDefault("resourceGroupName")
  valid_564706 = validateParameter(valid_564706, JString, required = true,
                                 default = nil)
  if valid_564706 != nil:
    section.add "resourceGroupName", valid_564706
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564707 = query.getOrDefault("$top")
  valid_564707 = validateParameter(valid_564707, JInt, required = false, default = nil)
  if valid_564707 != nil:
    section.add "$top", valid_564707
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564708 = query.getOrDefault("api-version")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564708 != nil:
    section.add "api-version", valid_564708
  var valid_564709 = query.getOrDefault("$orderby")
  valid_564709 = validateParameter(valid_564709, JString, required = false,
                                 default = nil)
  if valid_564709 != nil:
    section.add "$orderby", valid_564709
  var valid_564710 = query.getOrDefault("$filter")
  valid_564710 = validateParameter(valid_564710, JString, required = false,
                                 default = nil)
  if valid_564710 != nil:
    section.add "$filter", valid_564710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564711: Call_ServiceRunnersList_564701; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List service runners in a given lab.
  ## 
  let valid = call_564711.validator(path, query, header, formData, body)
  let scheme = call_564711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564711.url(scheme.get, call_564711.host, call_564711.base,
                         call_564711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564711, url, valid)

proc call*(call_564712: Call_ServiceRunnersList_564701; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Orderby: string = ""; Filter: string = ""): Recallable =
  ## serviceRunnersList
  ## List service runners in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564713 = newJObject()
  var query_564714 = newJObject()
  add(path_564713, "labName", newJString(labName))
  add(query_564714, "$top", newJInt(Top))
  add(query_564714, "api-version", newJString(apiVersion))
  add(path_564713, "subscriptionId", newJString(subscriptionId))
  add(query_564714, "$orderby", newJString(Orderby))
  add(path_564713, "resourceGroupName", newJString(resourceGroupName))
  add(query_564714, "$filter", newJString(Filter))
  result = call_564712.call(path_564713, query_564714, nil, nil, nil)

var serviceRunnersList* = Call_ServiceRunnersList_564701(
    name: "serviceRunnersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners",
    validator: validate_ServiceRunnersList_564702, base: "",
    url: url_ServiceRunnersList_564703, schemes: {Scheme.Https})
type
  Call_ServiceRunnersCreateOrUpdate_564727 = ref object of OpenApiRestCall_563548
proc url_ServiceRunnersCreateOrUpdate_564729(protocol: Scheme; host: string;
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

proc validate_ServiceRunnersCreateOrUpdate_564728(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Service runner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service runner.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564730 = path.getOrDefault("labName")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "labName", valid_564730
  var valid_564731 = path.getOrDefault("name")
  valid_564731 = validateParameter(valid_564731, JString, required = true,
                                 default = nil)
  if valid_564731 != nil:
    section.add "name", valid_564731
  var valid_564732 = path.getOrDefault("subscriptionId")
  valid_564732 = validateParameter(valid_564732, JString, required = true,
                                 default = nil)
  if valid_564732 != nil:
    section.add "subscriptionId", valid_564732
  var valid_564733 = path.getOrDefault("resourceGroupName")
  valid_564733 = validateParameter(valid_564733, JString, required = true,
                                 default = nil)
  if valid_564733 != nil:
    section.add "resourceGroupName", valid_564733
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564734 = query.getOrDefault("api-version")
  valid_564734 = validateParameter(valid_564734, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564734 != nil:
    section.add "api-version", valid_564734
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

proc call*(call_564736: Call_ServiceRunnersCreateOrUpdate_564727; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Service runner.
  ## 
  let valid = call_564736.validator(path, query, header, formData, body)
  let scheme = call_564736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564736.url(scheme.get, call_564736.host, call_564736.base,
                         call_564736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564736, url, valid)

proc call*(call_564737: Call_ServiceRunnersCreateOrUpdate_564727;
          serviceRunner: JsonNode; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## serviceRunnersCreateOrUpdate
  ## Create or replace an existing Service runner.
  ##   serviceRunner: JObject (required)
  ##                : A container for a managed identity to execute DevTest lab services.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service runner.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564738 = newJObject()
  var query_564739 = newJObject()
  var body_564740 = newJObject()
  if serviceRunner != nil:
    body_564740 = serviceRunner
  add(path_564738, "labName", newJString(labName))
  add(query_564739, "api-version", newJString(apiVersion))
  add(path_564738, "name", newJString(name))
  add(path_564738, "subscriptionId", newJString(subscriptionId))
  add(path_564738, "resourceGroupName", newJString(resourceGroupName))
  result = call_564737.call(path_564738, query_564739, nil, nil, body_564740)

var serviceRunnersCreateOrUpdate* = Call_ServiceRunnersCreateOrUpdate_564727(
    name: "serviceRunnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersCreateOrUpdate_564728, base: "",
    url: url_ServiceRunnersCreateOrUpdate_564729, schemes: {Scheme.Https})
type
  Call_ServiceRunnersGet_564715 = ref object of OpenApiRestCall_563548
proc url_ServiceRunnersGet_564717(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceRunnersGet_564716(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get service runner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service runner.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564718 = path.getOrDefault("labName")
  valid_564718 = validateParameter(valid_564718, JString, required = true,
                                 default = nil)
  if valid_564718 != nil:
    section.add "labName", valid_564718
  var valid_564719 = path.getOrDefault("name")
  valid_564719 = validateParameter(valid_564719, JString, required = true,
                                 default = nil)
  if valid_564719 != nil:
    section.add "name", valid_564719
  var valid_564720 = path.getOrDefault("subscriptionId")
  valid_564720 = validateParameter(valid_564720, JString, required = true,
                                 default = nil)
  if valid_564720 != nil:
    section.add "subscriptionId", valid_564720
  var valid_564721 = path.getOrDefault("resourceGroupName")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = nil)
  if valid_564721 != nil:
    section.add "resourceGroupName", valid_564721
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564722 = query.getOrDefault("api-version")
  valid_564722 = validateParameter(valid_564722, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564722 != nil:
    section.add "api-version", valid_564722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564723: Call_ServiceRunnersGet_564715; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service runner.
  ## 
  let valid = call_564723.validator(path, query, header, formData, body)
  let scheme = call_564723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564723.url(scheme.get, call_564723.host, call_564723.base,
                         call_564723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564723, url, valid)

proc call*(call_564724: Call_ServiceRunnersGet_564715; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## serviceRunnersGet
  ## Get service runner.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service runner.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564725 = newJObject()
  var query_564726 = newJObject()
  add(path_564725, "labName", newJString(labName))
  add(query_564726, "api-version", newJString(apiVersion))
  add(path_564725, "name", newJString(name))
  add(path_564725, "subscriptionId", newJString(subscriptionId))
  add(path_564725, "resourceGroupName", newJString(resourceGroupName))
  result = call_564724.call(path_564725, query_564726, nil, nil, nil)

var serviceRunnersGet* = Call_ServiceRunnersGet_564715(name: "serviceRunnersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersGet_564716, base: "",
    url: url_ServiceRunnersGet_564717, schemes: {Scheme.Https})
type
  Call_ServiceRunnersDelete_564741 = ref object of OpenApiRestCall_563548
proc url_ServiceRunnersDelete_564743(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceRunnersDelete_564742(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete service runner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service runner.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564744 = path.getOrDefault("labName")
  valid_564744 = validateParameter(valid_564744, JString, required = true,
                                 default = nil)
  if valid_564744 != nil:
    section.add "labName", valid_564744
  var valid_564745 = path.getOrDefault("name")
  valid_564745 = validateParameter(valid_564745, JString, required = true,
                                 default = nil)
  if valid_564745 != nil:
    section.add "name", valid_564745
  var valid_564746 = path.getOrDefault("subscriptionId")
  valid_564746 = validateParameter(valid_564746, JString, required = true,
                                 default = nil)
  if valid_564746 != nil:
    section.add "subscriptionId", valid_564746
  var valid_564747 = path.getOrDefault("resourceGroupName")
  valid_564747 = validateParameter(valid_564747, JString, required = true,
                                 default = nil)
  if valid_564747 != nil:
    section.add "resourceGroupName", valid_564747
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564748 = query.getOrDefault("api-version")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564748 != nil:
    section.add "api-version", valid_564748
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564749: Call_ServiceRunnersDelete_564741; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete service runner.
  ## 
  let valid = call_564749.validator(path, query, header, formData, body)
  let scheme = call_564749.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564749.url(scheme.get, call_564749.host, call_564749.base,
                         call_564749.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564749, url, valid)

proc call*(call_564750: Call_ServiceRunnersDelete_564741; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## serviceRunnersDelete
  ## Delete service runner.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service runner.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564751 = newJObject()
  var query_564752 = newJObject()
  add(path_564751, "labName", newJString(labName))
  add(query_564752, "api-version", newJString(apiVersion))
  add(path_564751, "name", newJString(name))
  add(path_564751, "subscriptionId", newJString(subscriptionId))
  add(path_564751, "resourceGroupName", newJString(resourceGroupName))
  result = call_564750.call(path_564751, query_564752, nil, nil, nil)

var serviceRunnersDelete* = Call_ServiceRunnersDelete_564741(
    name: "serviceRunnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersDelete_564742, base: "",
    url: url_ServiceRunnersDelete_564743, schemes: {Scheme.Https})
type
  Call_UsersList_564753 = ref object of OpenApiRestCall_563548
proc url_UsersList_564755(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersList_564754(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List user profiles in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564756 = path.getOrDefault("labName")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = nil)
  if valid_564756 != nil:
    section.add "labName", valid_564756
  var valid_564757 = path.getOrDefault("subscriptionId")
  valid_564757 = validateParameter(valid_564757, JString, required = true,
                                 default = nil)
  if valid_564757 != nil:
    section.add "subscriptionId", valid_564757
  var valid_564758 = path.getOrDefault("resourceGroupName")
  valid_564758 = validateParameter(valid_564758, JString, required = true,
                                 default = nil)
  if valid_564758 != nil:
    section.add "resourceGroupName", valid_564758
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564759 = query.getOrDefault("$top")
  valid_564759 = validateParameter(valid_564759, JInt, required = false, default = nil)
  if valid_564759 != nil:
    section.add "$top", valid_564759
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564760 = query.getOrDefault("api-version")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564760 != nil:
    section.add "api-version", valid_564760
  var valid_564761 = query.getOrDefault("$expand")
  valid_564761 = validateParameter(valid_564761, JString, required = false,
                                 default = nil)
  if valid_564761 != nil:
    section.add "$expand", valid_564761
  var valid_564762 = query.getOrDefault("$orderby")
  valid_564762 = validateParameter(valid_564762, JString, required = false,
                                 default = nil)
  if valid_564762 != nil:
    section.add "$orderby", valid_564762
  var valid_564763 = query.getOrDefault("$filter")
  valid_564763 = validateParameter(valid_564763, JString, required = false,
                                 default = nil)
  if valid_564763 != nil:
    section.add "$filter", valid_564763
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564764: Call_UsersList_564753; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List user profiles in a given lab.
  ## 
  let valid = call_564764.validator(path, query, header, formData, body)
  let scheme = call_564764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564764.url(scheme.get, call_564764.host, call_564764.base,
                         call_564764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564764, url, valid)

proc call*(call_564765: Call_UsersList_564753; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## usersList
  ## List user profiles in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=identity)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564766 = newJObject()
  var query_564767 = newJObject()
  add(path_564766, "labName", newJString(labName))
  add(query_564767, "$top", newJInt(Top))
  add(query_564767, "api-version", newJString(apiVersion))
  add(query_564767, "$expand", newJString(Expand))
  add(path_564766, "subscriptionId", newJString(subscriptionId))
  add(query_564767, "$orderby", newJString(Orderby))
  add(path_564766, "resourceGroupName", newJString(resourceGroupName))
  add(query_564767, "$filter", newJString(Filter))
  result = call_564765.call(path_564766, query_564767, nil, nil, nil)

var usersList* = Call_UsersList_564753(name: "usersList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users",
                                    validator: validate_UsersList_564754,
                                    base: "", url: url_UsersList_564755,
                                    schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_564781 = ref object of OpenApiRestCall_563548
proc url_UsersCreateOrUpdate_564783(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_564782(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564784 = path.getOrDefault("labName")
  valid_564784 = validateParameter(valid_564784, JString, required = true,
                                 default = nil)
  if valid_564784 != nil:
    section.add "labName", valid_564784
  var valid_564785 = path.getOrDefault("name")
  valid_564785 = validateParameter(valid_564785, JString, required = true,
                                 default = nil)
  if valid_564785 != nil:
    section.add "name", valid_564785
  var valid_564786 = path.getOrDefault("subscriptionId")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "subscriptionId", valid_564786
  var valid_564787 = path.getOrDefault("resourceGroupName")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "resourceGroupName", valid_564787
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564788 = query.getOrDefault("api-version")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564788 != nil:
    section.add "api-version", valid_564788
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

proc call*(call_564790: Call_UsersCreateOrUpdate_564781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing user profile.
  ## 
  let valid = call_564790.validator(path, query, header, formData, body)
  let scheme = call_564790.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564790.url(scheme.get, call_564790.host, call_564790.base,
                         call_564790.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564790, url, valid)

proc call*(call_564791: Call_UsersCreateOrUpdate_564781; labName: string;
          name: string; subscriptionId: string; user: JsonNode;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## usersCreateOrUpdate
  ## Create or replace an existing user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564792 = newJObject()
  var query_564793 = newJObject()
  var body_564794 = newJObject()
  add(path_564792, "labName", newJString(labName))
  add(query_564793, "api-version", newJString(apiVersion))
  add(path_564792, "name", newJString(name))
  add(path_564792, "subscriptionId", newJString(subscriptionId))
  if user != nil:
    body_564794 = user
  add(path_564792, "resourceGroupName", newJString(resourceGroupName))
  result = call_564791.call(path_564792, query_564793, nil, nil, body_564794)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_564781(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_564782, base: "",
    url: url_UsersCreateOrUpdate_564783, schemes: {Scheme.Https})
type
  Call_UsersGet_564768 = ref object of OpenApiRestCall_563548
proc url_UsersGet_564770(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_564769(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564771 = path.getOrDefault("labName")
  valid_564771 = validateParameter(valid_564771, JString, required = true,
                                 default = nil)
  if valid_564771 != nil:
    section.add "labName", valid_564771
  var valid_564772 = path.getOrDefault("name")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "name", valid_564772
  var valid_564773 = path.getOrDefault("subscriptionId")
  valid_564773 = validateParameter(valid_564773, JString, required = true,
                                 default = nil)
  if valid_564773 != nil:
    section.add "subscriptionId", valid_564773
  var valid_564774 = path.getOrDefault("resourceGroupName")
  valid_564774 = validateParameter(valid_564774, JString, required = true,
                                 default = nil)
  if valid_564774 != nil:
    section.add "resourceGroupName", valid_564774
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564775 = query.getOrDefault("api-version")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564775 != nil:
    section.add "api-version", valid_564775
  var valid_564776 = query.getOrDefault("$expand")
  valid_564776 = validateParameter(valid_564776, JString, required = false,
                                 default = nil)
  if valid_564776 != nil:
    section.add "$expand", valid_564776
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564777: Call_UsersGet_564768; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user profile.
  ## 
  let valid = call_564777.validator(path, query, header, formData, body)
  let scheme = call_564777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564777.url(scheme.get, call_564777.host, call_564777.base,
                         call_564777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564777, url, valid)

proc call*(call_564778: Call_UsersGet_564768; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## usersGet
  ## Get user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=identity)'
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564779 = newJObject()
  var query_564780 = newJObject()
  add(path_564779, "labName", newJString(labName))
  add(query_564780, "api-version", newJString(apiVersion))
  add(query_564780, "$expand", newJString(Expand))
  add(path_564779, "name", newJString(name))
  add(path_564779, "subscriptionId", newJString(subscriptionId))
  add(path_564779, "resourceGroupName", newJString(resourceGroupName))
  result = call_564778.call(path_564779, query_564780, nil, nil, nil)

var usersGet* = Call_UsersGet_564768(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                  validator: validate_UsersGet_564769, base: "",
                                  url: url_UsersGet_564770,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_564807 = ref object of OpenApiRestCall_563548
proc url_UsersUpdate_564809(protocol: Scheme; host: string; base: string;
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

proc validate_UsersUpdate_564808(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of user profiles.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564810 = path.getOrDefault("labName")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "labName", valid_564810
  var valid_564811 = path.getOrDefault("name")
  valid_564811 = validateParameter(valid_564811, JString, required = true,
                                 default = nil)
  if valid_564811 != nil:
    section.add "name", valid_564811
  var valid_564812 = path.getOrDefault("subscriptionId")
  valid_564812 = validateParameter(valid_564812, JString, required = true,
                                 default = nil)
  if valid_564812 != nil:
    section.add "subscriptionId", valid_564812
  var valid_564813 = path.getOrDefault("resourceGroupName")
  valid_564813 = validateParameter(valid_564813, JString, required = true,
                                 default = nil)
  if valid_564813 != nil:
    section.add "resourceGroupName", valid_564813
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564814 = query.getOrDefault("api-version")
  valid_564814 = validateParameter(valid_564814, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564814 != nil:
    section.add "api-version", valid_564814
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

proc call*(call_564816: Call_UsersUpdate_564807; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of user profiles.
  ## 
  let valid = call_564816.validator(path, query, header, formData, body)
  let scheme = call_564816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564816.url(scheme.get, call_564816.host, call_564816.base,
                         call_564816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564816, url, valid)

proc call*(call_564817: Call_UsersUpdate_564807; labName: string; name: string;
          subscriptionId: string; user: JsonNode; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## usersUpdate
  ## Modify properties of user profiles.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   user: JObject (required)
  ##       : Profile of a lab user.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564818 = newJObject()
  var query_564819 = newJObject()
  var body_564820 = newJObject()
  add(path_564818, "labName", newJString(labName))
  add(query_564819, "api-version", newJString(apiVersion))
  add(path_564818, "name", newJString(name))
  add(path_564818, "subscriptionId", newJString(subscriptionId))
  if user != nil:
    body_564820 = user
  add(path_564818, "resourceGroupName", newJString(resourceGroupName))
  result = call_564817.call(path_564818, query_564819, nil, nil, body_564820)

var usersUpdate* = Call_UsersUpdate_564807(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersUpdate_564808,
                                        base: "", url: url_UsersUpdate_564809,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_564795 = ref object of OpenApiRestCall_563548
proc url_UsersDelete_564797(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_564796(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete user profile. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the user profile.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564798 = path.getOrDefault("labName")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "labName", valid_564798
  var valid_564799 = path.getOrDefault("name")
  valid_564799 = validateParameter(valid_564799, JString, required = true,
                                 default = nil)
  if valid_564799 != nil:
    section.add "name", valid_564799
  var valid_564800 = path.getOrDefault("subscriptionId")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "subscriptionId", valid_564800
  var valid_564801 = path.getOrDefault("resourceGroupName")
  valid_564801 = validateParameter(valid_564801, JString, required = true,
                                 default = nil)
  if valid_564801 != nil:
    section.add "resourceGroupName", valid_564801
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564802 = query.getOrDefault("api-version")
  valid_564802 = validateParameter(valid_564802, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564802 != nil:
    section.add "api-version", valid_564802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564803: Call_UsersDelete_564795; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user profile. This operation can take a while to complete.
  ## 
  let valid = call_564803.validator(path, query, header, formData, body)
  let scheme = call_564803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564803.url(scheme.get, call_564803.host, call_564803.base,
                         call_564803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564803, url, valid)

proc call*(call_564804: Call_UsersDelete_564795; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## usersDelete
  ## Delete user profile. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the user profile.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564805 = newJObject()
  var query_564806 = newJObject()
  add(path_564805, "labName", newJString(labName))
  add(query_564806, "api-version", newJString(apiVersion))
  add(path_564805, "name", newJString(name))
  add(path_564805, "subscriptionId", newJString(subscriptionId))
  add(path_564805, "resourceGroupName", newJString(resourceGroupName))
  result = call_564804.call(path_564805, query_564806, nil, nil, nil)

var usersDelete* = Call_UsersDelete_564795(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersDelete_564796,
                                        base: "", url: url_UsersDelete_564797,
                                        schemes: {Scheme.Https})
type
  Call_DisksList_564821 = ref object of OpenApiRestCall_563548
proc url_DisksList_564823(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksList_564822(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List disks in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564824 = path.getOrDefault("labName")
  valid_564824 = validateParameter(valid_564824, JString, required = true,
                                 default = nil)
  if valid_564824 != nil:
    section.add "labName", valid_564824
  var valid_564825 = path.getOrDefault("subscriptionId")
  valid_564825 = validateParameter(valid_564825, JString, required = true,
                                 default = nil)
  if valid_564825 != nil:
    section.add "subscriptionId", valid_564825
  var valid_564826 = path.getOrDefault("resourceGroupName")
  valid_564826 = validateParameter(valid_564826, JString, required = true,
                                 default = nil)
  if valid_564826 != nil:
    section.add "resourceGroupName", valid_564826
  var valid_564827 = path.getOrDefault("userName")
  valid_564827 = validateParameter(valid_564827, JString, required = true,
                                 default = nil)
  if valid_564827 != nil:
    section.add "userName", valid_564827
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564828 = query.getOrDefault("$top")
  valid_564828 = validateParameter(valid_564828, JInt, required = false, default = nil)
  if valid_564828 != nil:
    section.add "$top", valid_564828
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564829 = query.getOrDefault("api-version")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564829 != nil:
    section.add "api-version", valid_564829
  var valid_564830 = query.getOrDefault("$expand")
  valid_564830 = validateParameter(valid_564830, JString, required = false,
                                 default = nil)
  if valid_564830 != nil:
    section.add "$expand", valid_564830
  var valid_564831 = query.getOrDefault("$orderby")
  valid_564831 = validateParameter(valid_564831, JString, required = false,
                                 default = nil)
  if valid_564831 != nil:
    section.add "$orderby", valid_564831
  var valid_564832 = query.getOrDefault("$filter")
  valid_564832 = validateParameter(valid_564832, JString, required = false,
                                 default = nil)
  if valid_564832 != nil:
    section.add "$filter", valid_564832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564833: Call_DisksList_564821; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disks in a given user profile.
  ## 
  let valid = call_564833.validator(path, query, header, formData, body)
  let scheme = call_564833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564833.url(scheme.get, call_564833.host, call_564833.base,
                         call_564833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564833, url, valid)

proc call*(call_564834: Call_DisksList_564821; labName: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          Top: int = 0; apiVersion: string = "2016-05-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## disksList
  ## List disks in a given user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564835 = newJObject()
  var query_564836 = newJObject()
  add(path_564835, "labName", newJString(labName))
  add(query_564836, "$top", newJInt(Top))
  add(query_564836, "api-version", newJString(apiVersion))
  add(query_564836, "$expand", newJString(Expand))
  add(path_564835, "subscriptionId", newJString(subscriptionId))
  add(query_564836, "$orderby", newJString(Orderby))
  add(path_564835, "resourceGroupName", newJString(resourceGroupName))
  add(query_564836, "$filter", newJString(Filter))
  add(path_564835, "userName", newJString(userName))
  result = call_564834.call(path_564835, query_564836, nil, nil, nil)

var disksList* = Call_DisksList_564821(name: "disksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks",
                                    validator: validate_DisksList_564822,
                                    base: "", url: url_DisksList_564823,
                                    schemes: {Scheme.Https})
type
  Call_DisksCreateOrUpdate_564851 = ref object of OpenApiRestCall_563548
proc url_DisksCreateOrUpdate_564853(protocol: Scheme; host: string; base: string;
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

proc validate_DisksCreateOrUpdate_564852(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing disk. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564854 = path.getOrDefault("labName")
  valid_564854 = validateParameter(valid_564854, JString, required = true,
                                 default = nil)
  if valid_564854 != nil:
    section.add "labName", valid_564854
  var valid_564855 = path.getOrDefault("name")
  valid_564855 = validateParameter(valid_564855, JString, required = true,
                                 default = nil)
  if valid_564855 != nil:
    section.add "name", valid_564855
  var valid_564856 = path.getOrDefault("subscriptionId")
  valid_564856 = validateParameter(valid_564856, JString, required = true,
                                 default = nil)
  if valid_564856 != nil:
    section.add "subscriptionId", valid_564856
  var valid_564857 = path.getOrDefault("resourceGroupName")
  valid_564857 = validateParameter(valid_564857, JString, required = true,
                                 default = nil)
  if valid_564857 != nil:
    section.add "resourceGroupName", valid_564857
  var valid_564858 = path.getOrDefault("userName")
  valid_564858 = validateParameter(valid_564858, JString, required = true,
                                 default = nil)
  if valid_564858 != nil:
    section.add "userName", valid_564858
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564859 = query.getOrDefault("api-version")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564859 != nil:
    section.add "api-version", valid_564859
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

proc call*(call_564861: Call_DisksCreateOrUpdate_564851; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing disk. This operation can take a while to complete.
  ## 
  let valid = call_564861.validator(path, query, header, formData, body)
  let scheme = call_564861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564861.url(scheme.get, call_564861.host, call_564861.base,
                         call_564861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564861, url, valid)

proc call*(call_564862: Call_DisksCreateOrUpdate_564851; labName: string;
          name: string; disk: JsonNode; subscriptionId: string;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## disksCreateOrUpdate
  ## Create or replace an existing disk. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   disk: JObject (required)
  ##       : A Disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564863 = newJObject()
  var query_564864 = newJObject()
  var body_564865 = newJObject()
  add(path_564863, "labName", newJString(labName))
  add(query_564864, "api-version", newJString(apiVersion))
  add(path_564863, "name", newJString(name))
  if disk != nil:
    body_564865 = disk
  add(path_564863, "subscriptionId", newJString(subscriptionId))
  add(path_564863, "resourceGroupName", newJString(resourceGroupName))
  add(path_564863, "userName", newJString(userName))
  result = call_564862.call(path_564863, query_564864, nil, nil, body_564865)

var disksCreateOrUpdate* = Call_DisksCreateOrUpdate_564851(
    name: "disksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
    validator: validate_DisksCreateOrUpdate_564852, base: "",
    url: url_DisksCreateOrUpdate_564853, schemes: {Scheme.Https})
type
  Call_DisksGet_564837 = ref object of OpenApiRestCall_563548
proc url_DisksGet_564839(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksGet_564838(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get disk.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564840 = path.getOrDefault("labName")
  valid_564840 = validateParameter(valid_564840, JString, required = true,
                                 default = nil)
  if valid_564840 != nil:
    section.add "labName", valid_564840
  var valid_564841 = path.getOrDefault("name")
  valid_564841 = validateParameter(valid_564841, JString, required = true,
                                 default = nil)
  if valid_564841 != nil:
    section.add "name", valid_564841
  var valid_564842 = path.getOrDefault("subscriptionId")
  valid_564842 = validateParameter(valid_564842, JString, required = true,
                                 default = nil)
  if valid_564842 != nil:
    section.add "subscriptionId", valid_564842
  var valid_564843 = path.getOrDefault("resourceGroupName")
  valid_564843 = validateParameter(valid_564843, JString, required = true,
                                 default = nil)
  if valid_564843 != nil:
    section.add "resourceGroupName", valid_564843
  var valid_564844 = path.getOrDefault("userName")
  valid_564844 = validateParameter(valid_564844, JString, required = true,
                                 default = nil)
  if valid_564844 != nil:
    section.add "userName", valid_564844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564845 = query.getOrDefault("api-version")
  valid_564845 = validateParameter(valid_564845, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564845 != nil:
    section.add "api-version", valid_564845
  var valid_564846 = query.getOrDefault("$expand")
  valid_564846 = validateParameter(valid_564846, JString, required = false,
                                 default = nil)
  if valid_564846 != nil:
    section.add "$expand", valid_564846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564847: Call_DisksGet_564837; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get disk.
  ## 
  let valid = call_564847.validator(path, query, header, formData, body)
  let scheme = call_564847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564847.url(scheme.get, call_564847.host, call_564847.base,
                         call_564847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564847, url, valid)

proc call*(call_564848: Call_DisksGet_564837; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## disksGet
  ## Get disk.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564849 = newJObject()
  var query_564850 = newJObject()
  add(path_564849, "labName", newJString(labName))
  add(query_564850, "api-version", newJString(apiVersion))
  add(query_564850, "$expand", newJString(Expand))
  add(path_564849, "name", newJString(name))
  add(path_564849, "subscriptionId", newJString(subscriptionId))
  add(path_564849, "resourceGroupName", newJString(resourceGroupName))
  add(path_564849, "userName", newJString(userName))
  result = call_564848.call(path_564849, query_564850, nil, nil, nil)

var disksGet* = Call_DisksGet_564837(name: "disksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                  validator: validate_DisksGet_564838, base: "",
                                  url: url_DisksGet_564839,
                                  schemes: {Scheme.Https})
type
  Call_DisksDelete_564866 = ref object of OpenApiRestCall_563548
proc url_DisksDelete_564868(protocol: Scheme; host: string; base: string;
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

proc validate_DisksDelete_564867(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete disk. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564869 = path.getOrDefault("labName")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "labName", valid_564869
  var valid_564870 = path.getOrDefault("name")
  valid_564870 = validateParameter(valid_564870, JString, required = true,
                                 default = nil)
  if valid_564870 != nil:
    section.add "name", valid_564870
  var valid_564871 = path.getOrDefault("subscriptionId")
  valid_564871 = validateParameter(valid_564871, JString, required = true,
                                 default = nil)
  if valid_564871 != nil:
    section.add "subscriptionId", valid_564871
  var valid_564872 = path.getOrDefault("resourceGroupName")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "resourceGroupName", valid_564872
  var valid_564873 = path.getOrDefault("userName")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "userName", valid_564873
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564874 = query.getOrDefault("api-version")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564874 != nil:
    section.add "api-version", valid_564874
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564875: Call_DisksDelete_564866; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete disk. This operation can take a while to complete.
  ## 
  let valid = call_564875.validator(path, query, header, formData, body)
  let scheme = call_564875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564875.url(scheme.get, call_564875.host, call_564875.base,
                         call_564875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564875, url, valid)

proc call*(call_564876: Call_DisksDelete_564866; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## disksDelete
  ## Delete disk. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564877 = newJObject()
  var query_564878 = newJObject()
  add(path_564877, "labName", newJString(labName))
  add(query_564878, "api-version", newJString(apiVersion))
  add(path_564877, "name", newJString(name))
  add(path_564877, "subscriptionId", newJString(subscriptionId))
  add(path_564877, "resourceGroupName", newJString(resourceGroupName))
  add(path_564877, "userName", newJString(userName))
  result = call_564876.call(path_564877, query_564878, nil, nil, nil)

var disksDelete* = Call_DisksDelete_564866(name: "disksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                        validator: validate_DisksDelete_564867,
                                        base: "", url: url_DisksDelete_564868,
                                        schemes: {Scheme.Https})
type
  Call_DisksAttach_564879 = ref object of OpenApiRestCall_563548
proc url_DisksAttach_564881(protocol: Scheme; host: string; base: string;
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

proc validate_DisksAttach_564880(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564882 = path.getOrDefault("labName")
  valid_564882 = validateParameter(valid_564882, JString, required = true,
                                 default = nil)
  if valid_564882 != nil:
    section.add "labName", valid_564882
  var valid_564883 = path.getOrDefault("name")
  valid_564883 = validateParameter(valid_564883, JString, required = true,
                                 default = nil)
  if valid_564883 != nil:
    section.add "name", valid_564883
  var valid_564884 = path.getOrDefault("subscriptionId")
  valid_564884 = validateParameter(valid_564884, JString, required = true,
                                 default = nil)
  if valid_564884 != nil:
    section.add "subscriptionId", valid_564884
  var valid_564885 = path.getOrDefault("resourceGroupName")
  valid_564885 = validateParameter(valid_564885, JString, required = true,
                                 default = nil)
  if valid_564885 != nil:
    section.add "resourceGroupName", valid_564885
  var valid_564886 = path.getOrDefault("userName")
  valid_564886 = validateParameter(valid_564886, JString, required = true,
                                 default = nil)
  if valid_564886 != nil:
    section.add "userName", valid_564886
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564887 = query.getOrDefault("api-version")
  valid_564887 = validateParameter(valid_564887, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564887 != nil:
    section.add "api-version", valid_564887
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

proc call*(call_564889: Call_DisksAttach_564879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_564889.validator(path, query, header, formData, body)
  let scheme = call_564889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564889.url(scheme.get, call_564889.host, call_564889.base,
                         call_564889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564889, url, valid)

proc call*(call_564890: Call_DisksAttach_564879; labName: string;
          attachDiskProperties: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## disksAttach
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   attachDiskProperties: JObject (required)
  ##                       : Properties of the disk to attach.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564891 = newJObject()
  var query_564892 = newJObject()
  var body_564893 = newJObject()
  add(path_564891, "labName", newJString(labName))
  if attachDiskProperties != nil:
    body_564893 = attachDiskProperties
  add(query_564892, "api-version", newJString(apiVersion))
  add(path_564891, "name", newJString(name))
  add(path_564891, "subscriptionId", newJString(subscriptionId))
  add(path_564891, "resourceGroupName", newJString(resourceGroupName))
  add(path_564891, "userName", newJString(userName))
  result = call_564890.call(path_564891, query_564892, nil, nil, body_564893)

var disksAttach* = Call_DisksAttach_564879(name: "disksAttach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/attach",
                                        validator: validate_DisksAttach_564880,
                                        base: "", url: url_DisksAttach_564881,
                                        schemes: {Scheme.Https})
type
  Call_DisksDetach_564894 = ref object of OpenApiRestCall_563548
proc url_DisksDetach_564896(protocol: Scheme; host: string; base: string;
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

proc validate_DisksDetach_564895(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the disk.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564897 = path.getOrDefault("labName")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "labName", valid_564897
  var valid_564898 = path.getOrDefault("name")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = nil)
  if valid_564898 != nil:
    section.add "name", valid_564898
  var valid_564899 = path.getOrDefault("subscriptionId")
  valid_564899 = validateParameter(valid_564899, JString, required = true,
                                 default = nil)
  if valid_564899 != nil:
    section.add "subscriptionId", valid_564899
  var valid_564900 = path.getOrDefault("resourceGroupName")
  valid_564900 = validateParameter(valid_564900, JString, required = true,
                                 default = nil)
  if valid_564900 != nil:
    section.add "resourceGroupName", valid_564900
  var valid_564901 = path.getOrDefault("userName")
  valid_564901 = validateParameter(valid_564901, JString, required = true,
                                 default = nil)
  if valid_564901 != nil:
    section.add "userName", valid_564901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564902 = query.getOrDefault("api-version")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564902 != nil:
    section.add "api-version", valid_564902
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

proc call*(call_564904: Call_DisksDetach_564894; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_564904.validator(path, query, header, formData, body)
  let scheme = call_564904.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564904.url(scheme.get, call_564904.host, call_564904.base,
                         call_564904.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564904, url, valid)

proc call*(call_564905: Call_DisksDetach_564894; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          detachDiskProperties: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## disksDetach
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the disk.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   detachDiskProperties: JObject (required)
  ##                       : Properties of the disk to detach.
  var path_564906 = newJObject()
  var query_564907 = newJObject()
  var body_564908 = newJObject()
  add(path_564906, "labName", newJString(labName))
  add(query_564907, "api-version", newJString(apiVersion))
  add(path_564906, "name", newJString(name))
  add(path_564906, "subscriptionId", newJString(subscriptionId))
  add(path_564906, "resourceGroupName", newJString(resourceGroupName))
  add(path_564906, "userName", newJString(userName))
  if detachDiskProperties != nil:
    body_564908 = detachDiskProperties
  result = call_564905.call(path_564906, query_564907, nil, nil, body_564908)

var disksDetach* = Call_DisksDetach_564894(name: "disksDetach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/detach",
                                        validator: validate_DisksDetach_564895,
                                        base: "", url: url_DisksDetach_564896,
                                        schemes: {Scheme.Https})
type
  Call_EnvironmentsList_564909 = ref object of OpenApiRestCall_563548
proc url_EnvironmentsList_564911(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsList_564910(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List environments in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564912 = path.getOrDefault("labName")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "labName", valid_564912
  var valid_564913 = path.getOrDefault("subscriptionId")
  valid_564913 = validateParameter(valid_564913, JString, required = true,
                                 default = nil)
  if valid_564913 != nil:
    section.add "subscriptionId", valid_564913
  var valid_564914 = path.getOrDefault("resourceGroupName")
  valid_564914 = validateParameter(valid_564914, JString, required = true,
                                 default = nil)
  if valid_564914 != nil:
    section.add "resourceGroupName", valid_564914
  var valid_564915 = path.getOrDefault("userName")
  valid_564915 = validateParameter(valid_564915, JString, required = true,
                                 default = nil)
  if valid_564915 != nil:
    section.add "userName", valid_564915
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564916 = query.getOrDefault("$top")
  valid_564916 = validateParameter(valid_564916, JInt, required = false, default = nil)
  if valid_564916 != nil:
    section.add "$top", valid_564916
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564917 = query.getOrDefault("api-version")
  valid_564917 = validateParameter(valid_564917, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564917 != nil:
    section.add "api-version", valid_564917
  var valid_564918 = query.getOrDefault("$expand")
  valid_564918 = validateParameter(valid_564918, JString, required = false,
                                 default = nil)
  if valid_564918 != nil:
    section.add "$expand", valid_564918
  var valid_564919 = query.getOrDefault("$orderby")
  valid_564919 = validateParameter(valid_564919, JString, required = false,
                                 default = nil)
  if valid_564919 != nil:
    section.add "$orderby", valid_564919
  var valid_564920 = query.getOrDefault("$filter")
  valid_564920 = validateParameter(valid_564920, JString, required = false,
                                 default = nil)
  if valid_564920 != nil:
    section.add "$filter", valid_564920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564921: Call_EnvironmentsList_564909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environments in a given user profile.
  ## 
  let valid = call_564921.validator(path, query, header, formData, body)
  let scheme = call_564921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564921.url(scheme.get, call_564921.host, call_564921.base,
                         call_564921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564921, url, valid)

proc call*(call_564922: Call_EnvironmentsList_564909; labName: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          Top: int = 0; apiVersion: string = "2016-05-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## environmentsList
  ## List environments in a given user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564923 = newJObject()
  var query_564924 = newJObject()
  add(path_564923, "labName", newJString(labName))
  add(query_564924, "$top", newJInt(Top))
  add(query_564924, "api-version", newJString(apiVersion))
  add(query_564924, "$expand", newJString(Expand))
  add(path_564923, "subscriptionId", newJString(subscriptionId))
  add(query_564924, "$orderby", newJString(Orderby))
  add(path_564923, "resourceGroupName", newJString(resourceGroupName))
  add(query_564924, "$filter", newJString(Filter))
  add(path_564923, "userName", newJString(userName))
  result = call_564922.call(path_564923, query_564924, nil, nil, nil)

var environmentsList* = Call_EnvironmentsList_564909(name: "environmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments",
    validator: validate_EnvironmentsList_564910, base: "",
    url: url_EnvironmentsList_564911, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_564939 = ref object of OpenApiRestCall_563548
proc url_EnvironmentsCreateOrUpdate_564941(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_564940(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing environment. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564942 = path.getOrDefault("labName")
  valid_564942 = validateParameter(valid_564942, JString, required = true,
                                 default = nil)
  if valid_564942 != nil:
    section.add "labName", valid_564942
  var valid_564943 = path.getOrDefault("name")
  valid_564943 = validateParameter(valid_564943, JString, required = true,
                                 default = nil)
  if valid_564943 != nil:
    section.add "name", valid_564943
  var valid_564944 = path.getOrDefault("subscriptionId")
  valid_564944 = validateParameter(valid_564944, JString, required = true,
                                 default = nil)
  if valid_564944 != nil:
    section.add "subscriptionId", valid_564944
  var valid_564945 = path.getOrDefault("resourceGroupName")
  valid_564945 = validateParameter(valid_564945, JString, required = true,
                                 default = nil)
  if valid_564945 != nil:
    section.add "resourceGroupName", valid_564945
  var valid_564946 = path.getOrDefault("userName")
  valid_564946 = validateParameter(valid_564946, JString, required = true,
                                 default = nil)
  if valid_564946 != nil:
    section.add "userName", valid_564946
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564947 = query.getOrDefault("api-version")
  valid_564947 = validateParameter(valid_564947, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564947 != nil:
    section.add "api-version", valid_564947
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

proc call*(call_564949: Call_EnvironmentsCreateOrUpdate_564939; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing environment. This operation can take a while to complete.
  ## 
  let valid = call_564949.validator(path, query, header, formData, body)
  let scheme = call_564949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564949.url(scheme.get, call_564949.host, call_564949.base,
                         call_564949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564949, url, valid)

proc call*(call_564950: Call_EnvironmentsCreateOrUpdate_564939; labName: string;
          name: string; subscriptionId: string; dtlEnvironment: JsonNode;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## environmentsCreateOrUpdate
  ## Create or replace an existing environment. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   dtlEnvironment: JObject (required)
  ##                 : An environment, which is essentially an ARM template deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564951 = newJObject()
  var query_564952 = newJObject()
  var body_564953 = newJObject()
  add(path_564951, "labName", newJString(labName))
  add(query_564952, "api-version", newJString(apiVersion))
  add(path_564951, "name", newJString(name))
  add(path_564951, "subscriptionId", newJString(subscriptionId))
  if dtlEnvironment != nil:
    body_564953 = dtlEnvironment
  add(path_564951, "resourceGroupName", newJString(resourceGroupName))
  add(path_564951, "userName", newJString(userName))
  result = call_564950.call(path_564951, query_564952, nil, nil, body_564953)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_564939(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsCreateOrUpdate_564940, base: "",
    url: url_EnvironmentsCreateOrUpdate_564941, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_564925 = ref object of OpenApiRestCall_563548
proc url_EnvironmentsGet_564927(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsGet_564926(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564928 = path.getOrDefault("labName")
  valid_564928 = validateParameter(valid_564928, JString, required = true,
                                 default = nil)
  if valid_564928 != nil:
    section.add "labName", valid_564928
  var valid_564929 = path.getOrDefault("name")
  valid_564929 = validateParameter(valid_564929, JString, required = true,
                                 default = nil)
  if valid_564929 != nil:
    section.add "name", valid_564929
  var valid_564930 = path.getOrDefault("subscriptionId")
  valid_564930 = validateParameter(valid_564930, JString, required = true,
                                 default = nil)
  if valid_564930 != nil:
    section.add "subscriptionId", valid_564930
  var valid_564931 = path.getOrDefault("resourceGroupName")
  valid_564931 = validateParameter(valid_564931, JString, required = true,
                                 default = nil)
  if valid_564931 != nil:
    section.add "resourceGroupName", valid_564931
  var valid_564932 = path.getOrDefault("userName")
  valid_564932 = validateParameter(valid_564932, JString, required = true,
                                 default = nil)
  if valid_564932 != nil:
    section.add "userName", valid_564932
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564933 = query.getOrDefault("api-version")
  valid_564933 = validateParameter(valid_564933, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564933 != nil:
    section.add "api-version", valid_564933
  var valid_564934 = query.getOrDefault("$expand")
  valid_564934 = validateParameter(valid_564934, JString, required = false,
                                 default = nil)
  if valid_564934 != nil:
    section.add "$expand", valid_564934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564935: Call_EnvironmentsGet_564925; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment.
  ## 
  let valid = call_564935.validator(path, query, header, formData, body)
  let scheme = call_564935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564935.url(scheme.get, call_564935.host, call_564935.base,
                         call_564935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564935, url, valid)

proc call*(call_564936: Call_EnvironmentsGet_564925; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## environmentsGet
  ## Get environment.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   name: string (required)
  ##       : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564937 = newJObject()
  var query_564938 = newJObject()
  add(path_564937, "labName", newJString(labName))
  add(query_564938, "api-version", newJString(apiVersion))
  add(query_564938, "$expand", newJString(Expand))
  add(path_564937, "name", newJString(name))
  add(path_564937, "subscriptionId", newJString(subscriptionId))
  add(path_564937, "resourceGroupName", newJString(resourceGroupName))
  add(path_564937, "userName", newJString(userName))
  result = call_564936.call(path_564937, query_564938, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_564925(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsGet_564926, base: "", url: url_EnvironmentsGet_564927,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_564954 = ref object of OpenApiRestCall_563548
proc url_EnvironmentsDelete_564956(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_564955(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete environment. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the environment.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564957 = path.getOrDefault("labName")
  valid_564957 = validateParameter(valid_564957, JString, required = true,
                                 default = nil)
  if valid_564957 != nil:
    section.add "labName", valid_564957
  var valid_564958 = path.getOrDefault("name")
  valid_564958 = validateParameter(valid_564958, JString, required = true,
                                 default = nil)
  if valid_564958 != nil:
    section.add "name", valid_564958
  var valid_564959 = path.getOrDefault("subscriptionId")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "subscriptionId", valid_564959
  var valid_564960 = path.getOrDefault("resourceGroupName")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "resourceGroupName", valid_564960
  var valid_564961 = path.getOrDefault("userName")
  valid_564961 = validateParameter(valid_564961, JString, required = true,
                                 default = nil)
  if valid_564961 != nil:
    section.add "userName", valid_564961
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564962 = query.getOrDefault("api-version")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564962 != nil:
    section.add "api-version", valid_564962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564963: Call_EnvironmentsDelete_564954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment. This operation can take a while to complete.
  ## 
  let valid = call_564963.validator(path, query, header, formData, body)
  let scheme = call_564963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564963.url(scheme.get, call_564963.host, call_564963.base,
                         call_564963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564963, url, valid)

proc call*(call_564964: Call_EnvironmentsDelete_564954; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          userName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## environmentsDelete
  ## Delete environment. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the environment.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564965 = newJObject()
  var query_564966 = newJObject()
  add(path_564965, "labName", newJString(labName))
  add(query_564966, "api-version", newJString(apiVersion))
  add(path_564965, "name", newJString(name))
  add(path_564965, "subscriptionId", newJString(subscriptionId))
  add(path_564965, "resourceGroupName", newJString(resourceGroupName))
  add(path_564965, "userName", newJString(userName))
  result = call_564964.call(path_564965, query_564966, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_564954(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsDelete_564955, base: "",
    url: url_EnvironmentsDelete_564956, schemes: {Scheme.Https})
type
  Call_SecretsList_564967 = ref object of OpenApiRestCall_563548
proc url_SecretsList_564969(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsList_564968(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## List secrets in a given user profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564970 = path.getOrDefault("labName")
  valid_564970 = validateParameter(valid_564970, JString, required = true,
                                 default = nil)
  if valid_564970 != nil:
    section.add "labName", valid_564970
  var valid_564971 = path.getOrDefault("subscriptionId")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "subscriptionId", valid_564971
  var valid_564972 = path.getOrDefault("resourceGroupName")
  valid_564972 = validateParameter(valid_564972, JString, required = true,
                                 default = nil)
  if valid_564972 != nil:
    section.add "resourceGroupName", valid_564972
  var valid_564973 = path.getOrDefault("userName")
  valid_564973 = validateParameter(valid_564973, JString, required = true,
                                 default = nil)
  if valid_564973 != nil:
    section.add "userName", valid_564973
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_564974 = query.getOrDefault("$top")
  valid_564974 = validateParameter(valid_564974, JInt, required = false, default = nil)
  if valid_564974 != nil:
    section.add "$top", valid_564974
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564975 = query.getOrDefault("api-version")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564975 != nil:
    section.add "api-version", valid_564975
  var valid_564976 = query.getOrDefault("$expand")
  valid_564976 = validateParameter(valid_564976, JString, required = false,
                                 default = nil)
  if valid_564976 != nil:
    section.add "$expand", valid_564976
  var valid_564977 = query.getOrDefault("$orderby")
  valid_564977 = validateParameter(valid_564977, JString, required = false,
                                 default = nil)
  if valid_564977 != nil:
    section.add "$orderby", valid_564977
  var valid_564978 = query.getOrDefault("$filter")
  valid_564978 = validateParameter(valid_564978, JString, required = false,
                                 default = nil)
  if valid_564978 != nil:
    section.add "$filter", valid_564978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564979: Call_SecretsList_564967; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List secrets in a given user profile.
  ## 
  let valid = call_564979.validator(path, query, header, formData, body)
  let scheme = call_564979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564979.url(scheme.get, call_564979.host, call_564979.base,
                         call_564979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564979, url, valid)

proc call*(call_564980: Call_SecretsList_564967; labName: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          Top: int = 0; apiVersion: string = "2016-05-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## secretsList
  ## List secrets in a given user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=value)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564981 = newJObject()
  var query_564982 = newJObject()
  add(path_564981, "labName", newJString(labName))
  add(query_564982, "$top", newJInt(Top))
  add(query_564982, "api-version", newJString(apiVersion))
  add(query_564982, "$expand", newJString(Expand))
  add(path_564981, "subscriptionId", newJString(subscriptionId))
  add(query_564982, "$orderby", newJString(Orderby))
  add(path_564981, "resourceGroupName", newJString(resourceGroupName))
  add(query_564982, "$filter", newJString(Filter))
  add(path_564981, "userName", newJString(userName))
  result = call_564980.call(path_564981, query_564982, nil, nil, nil)

var secretsList* = Call_SecretsList_564967(name: "secretsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets",
                                        validator: validate_SecretsList_564968,
                                        base: "", url: url_SecretsList_564969,
                                        schemes: {Scheme.Https})
type
  Call_SecretsCreateOrUpdate_564997 = ref object of OpenApiRestCall_563548
proc url_SecretsCreateOrUpdate_564999(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsCreateOrUpdate_564998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565000 = path.getOrDefault("labName")
  valid_565000 = validateParameter(valid_565000, JString, required = true,
                                 default = nil)
  if valid_565000 != nil:
    section.add "labName", valid_565000
  var valid_565001 = path.getOrDefault("name")
  valid_565001 = validateParameter(valid_565001, JString, required = true,
                                 default = nil)
  if valid_565001 != nil:
    section.add "name", valid_565001
  var valid_565002 = path.getOrDefault("subscriptionId")
  valid_565002 = validateParameter(valid_565002, JString, required = true,
                                 default = nil)
  if valid_565002 != nil:
    section.add "subscriptionId", valid_565002
  var valid_565003 = path.getOrDefault("resourceGroupName")
  valid_565003 = validateParameter(valid_565003, JString, required = true,
                                 default = nil)
  if valid_565003 != nil:
    section.add "resourceGroupName", valid_565003
  var valid_565004 = path.getOrDefault("userName")
  valid_565004 = validateParameter(valid_565004, JString, required = true,
                                 default = nil)
  if valid_565004 != nil:
    section.add "userName", valid_565004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565005 = query.getOrDefault("api-version")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565005 != nil:
    section.add "api-version", valid_565005
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

proc call*(call_565007: Call_SecretsCreateOrUpdate_564997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing secret.
  ## 
  let valid = call_565007.validator(path, query, header, formData, body)
  let scheme = call_565007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565007.url(scheme.get, call_565007.host, call_565007.base,
                         call_565007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565007, url, valid)

proc call*(call_565008: Call_SecretsCreateOrUpdate_564997; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          userName: string; secret: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## secretsCreateOrUpdate
  ## Create or replace an existing secret.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the secret.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  ##   secret: JObject (required)
  ##         : A secret.
  var path_565009 = newJObject()
  var query_565010 = newJObject()
  var body_565011 = newJObject()
  add(path_565009, "labName", newJString(labName))
  add(query_565010, "api-version", newJString(apiVersion))
  add(path_565009, "name", newJString(name))
  add(path_565009, "subscriptionId", newJString(subscriptionId))
  add(path_565009, "resourceGroupName", newJString(resourceGroupName))
  add(path_565009, "userName", newJString(userName))
  if secret != nil:
    body_565011 = secret
  result = call_565008.call(path_565009, query_565010, nil, nil, body_565011)

var secretsCreateOrUpdate* = Call_SecretsCreateOrUpdate_564997(
    name: "secretsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsCreateOrUpdate_564998, base: "",
    url: url_SecretsCreateOrUpdate_564999, schemes: {Scheme.Https})
type
  Call_SecretsGet_564983 = ref object of OpenApiRestCall_563548
proc url_SecretsGet_564985(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SecretsGet_564984(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564986 = path.getOrDefault("labName")
  valid_564986 = validateParameter(valid_564986, JString, required = true,
                                 default = nil)
  if valid_564986 != nil:
    section.add "labName", valid_564986
  var valid_564987 = path.getOrDefault("name")
  valid_564987 = validateParameter(valid_564987, JString, required = true,
                                 default = nil)
  if valid_564987 != nil:
    section.add "name", valid_564987
  var valid_564988 = path.getOrDefault("subscriptionId")
  valid_564988 = validateParameter(valid_564988, JString, required = true,
                                 default = nil)
  if valid_564988 != nil:
    section.add "subscriptionId", valid_564988
  var valid_564989 = path.getOrDefault("resourceGroupName")
  valid_564989 = validateParameter(valid_564989, JString, required = true,
                                 default = nil)
  if valid_564989 != nil:
    section.add "resourceGroupName", valid_564989
  var valid_564990 = path.getOrDefault("userName")
  valid_564990 = validateParameter(valid_564990, JString, required = true,
                                 default = nil)
  if valid_564990 != nil:
    section.add "userName", valid_564990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564991 = query.getOrDefault("api-version")
  valid_564991 = validateParameter(valid_564991, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_564991 != nil:
    section.add "api-version", valid_564991
  var valid_564992 = query.getOrDefault("$expand")
  valid_564992 = validateParameter(valid_564992, JString, required = false,
                                 default = nil)
  if valid_564992 != nil:
    section.add "$expand", valid_564992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564993: Call_SecretsGet_564983; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get secret.
  ## 
  let valid = call_564993.validator(path, query, header, formData, body)
  let scheme = call_564993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564993.url(scheme.get, call_564993.host, call_564993.base,
                         call_564993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564993, url, valid)

proc call*(call_564994: Call_SecretsGet_564983; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## secretsGet
  ## Get secret.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=value)'
  ##   name: string (required)
  ##       : The name of the secret.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564995 = newJObject()
  var query_564996 = newJObject()
  add(path_564995, "labName", newJString(labName))
  add(query_564996, "api-version", newJString(apiVersion))
  add(query_564996, "$expand", newJString(Expand))
  add(path_564995, "name", newJString(name))
  add(path_564995, "subscriptionId", newJString(subscriptionId))
  add(path_564995, "resourceGroupName", newJString(resourceGroupName))
  add(path_564995, "userName", newJString(userName))
  result = call_564994.call(path_564995, query_564996, nil, nil, nil)

var secretsGet* = Call_SecretsGet_564983(name: "secretsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
                                      validator: validate_SecretsGet_564984,
                                      base: "", url: url_SecretsGet_564985,
                                      schemes: {Scheme.Https})
type
  Call_SecretsDelete_565012 = ref object of OpenApiRestCall_563548
proc url_SecretsDelete_565014(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsDelete_565013(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the secret.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565015 = path.getOrDefault("labName")
  valid_565015 = validateParameter(valid_565015, JString, required = true,
                                 default = nil)
  if valid_565015 != nil:
    section.add "labName", valid_565015
  var valid_565016 = path.getOrDefault("name")
  valid_565016 = validateParameter(valid_565016, JString, required = true,
                                 default = nil)
  if valid_565016 != nil:
    section.add "name", valid_565016
  var valid_565017 = path.getOrDefault("subscriptionId")
  valid_565017 = validateParameter(valid_565017, JString, required = true,
                                 default = nil)
  if valid_565017 != nil:
    section.add "subscriptionId", valid_565017
  var valid_565018 = path.getOrDefault("resourceGroupName")
  valid_565018 = validateParameter(valid_565018, JString, required = true,
                                 default = nil)
  if valid_565018 != nil:
    section.add "resourceGroupName", valid_565018
  var valid_565019 = path.getOrDefault("userName")
  valid_565019 = validateParameter(valid_565019, JString, required = true,
                                 default = nil)
  if valid_565019 != nil:
    section.add "userName", valid_565019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565020 = query.getOrDefault("api-version")
  valid_565020 = validateParameter(valid_565020, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565020 != nil:
    section.add "api-version", valid_565020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565021: Call_SecretsDelete_565012; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete secret.
  ## 
  let valid = call_565021.validator(path, query, header, formData, body)
  let scheme = call_565021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565021.url(scheme.get, call_565021.host, call_565021.base,
                         call_565021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565021, url, valid)

proc call*(call_565022: Call_SecretsDelete_565012; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## secretsDelete
  ## Delete secret.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the secret.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565023 = newJObject()
  var query_565024 = newJObject()
  add(path_565023, "labName", newJString(labName))
  add(query_565024, "api-version", newJString(apiVersion))
  add(path_565023, "name", newJString(name))
  add(path_565023, "subscriptionId", newJString(subscriptionId))
  add(path_565023, "resourceGroupName", newJString(resourceGroupName))
  add(path_565023, "userName", newJString(userName))
  result = call_565022.call(path_565023, query_565024, nil, nil, nil)

var secretsDelete* = Call_SecretsDelete_565012(name: "secretsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsDelete_565013, base: "", url: url_SecretsDelete_565014,
    schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_565025 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesList_565027(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesList_565026(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List virtual machines in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565028 = path.getOrDefault("labName")
  valid_565028 = validateParameter(valid_565028, JString, required = true,
                                 default = nil)
  if valid_565028 != nil:
    section.add "labName", valid_565028
  var valid_565029 = path.getOrDefault("subscriptionId")
  valid_565029 = validateParameter(valid_565029, JString, required = true,
                                 default = nil)
  if valid_565029 != nil:
    section.add "subscriptionId", valid_565029
  var valid_565030 = path.getOrDefault("resourceGroupName")
  valid_565030 = validateParameter(valid_565030, JString, required = true,
                                 default = nil)
  if valid_565030 != nil:
    section.add "resourceGroupName", valid_565030
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_565031 = query.getOrDefault("$top")
  valid_565031 = validateParameter(valid_565031, JInt, required = false, default = nil)
  if valid_565031 != nil:
    section.add "$top", valid_565031
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565032 = query.getOrDefault("api-version")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565032 != nil:
    section.add "api-version", valid_565032
  var valid_565033 = query.getOrDefault("$expand")
  valid_565033 = validateParameter(valid_565033, JString, required = false,
                                 default = nil)
  if valid_565033 != nil:
    section.add "$expand", valid_565033
  var valid_565034 = query.getOrDefault("$orderby")
  valid_565034 = validateParameter(valid_565034, JString, required = false,
                                 default = nil)
  if valid_565034 != nil:
    section.add "$orderby", valid_565034
  var valid_565035 = query.getOrDefault("$filter")
  valid_565035 = validateParameter(valid_565035, JString, required = false,
                                 default = nil)
  if valid_565035 != nil:
    section.add "$filter", valid_565035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565036: Call_VirtualMachinesList_565025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual machines in a given lab.
  ## 
  let valid = call_565036.validator(path, query, header, formData, body)
  let scheme = call_565036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565036.url(scheme.get, call_565036.host, call_565036.base,
                         call_565036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565036, url, valid)

proc call*(call_565037: Call_VirtualMachinesList_565025; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## virtualMachinesList
  ## List virtual machines in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_565038 = newJObject()
  var query_565039 = newJObject()
  add(path_565038, "labName", newJString(labName))
  add(query_565039, "$top", newJInt(Top))
  add(query_565039, "api-version", newJString(apiVersion))
  add(query_565039, "$expand", newJString(Expand))
  add(path_565038, "subscriptionId", newJString(subscriptionId))
  add(query_565039, "$orderby", newJString(Orderby))
  add(path_565038, "resourceGroupName", newJString(resourceGroupName))
  add(query_565039, "$filter", newJString(Filter))
  result = call_565037.call(path_565038, query_565039, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_565025(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines",
    validator: validate_VirtualMachinesList_565026, base: "",
    url: url_VirtualMachinesList_565027, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_565053 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesCreateOrUpdate_565055(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesCreateOrUpdate_565054(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing Virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565056 = path.getOrDefault("labName")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "labName", valid_565056
  var valid_565057 = path.getOrDefault("name")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = nil)
  if valid_565057 != nil:
    section.add "name", valid_565057
  var valid_565058 = path.getOrDefault("subscriptionId")
  valid_565058 = validateParameter(valid_565058, JString, required = true,
                                 default = nil)
  if valid_565058 != nil:
    section.add "subscriptionId", valid_565058
  var valid_565059 = path.getOrDefault("resourceGroupName")
  valid_565059 = validateParameter(valid_565059, JString, required = true,
                                 default = nil)
  if valid_565059 != nil:
    section.add "resourceGroupName", valid_565059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565060 = query.getOrDefault("api-version")
  valid_565060 = validateParameter(valid_565060, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565060 != nil:
    section.add "api-version", valid_565060
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

proc call*(call_565062: Call_VirtualMachinesCreateOrUpdate_565053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing Virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565062.validator(path, query, header, formData, body)
  let scheme = call_565062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565062.url(scheme.get, call_565062.host, call_565062.base,
                         call_565062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565062, url, valid)

proc call*(call_565063: Call_VirtualMachinesCreateOrUpdate_565053; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          labVirtualMachine: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesCreateOrUpdate
  ## Create or replace an existing Virtual machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  var path_565064 = newJObject()
  var query_565065 = newJObject()
  var body_565066 = newJObject()
  add(path_565064, "labName", newJString(labName))
  add(query_565065, "api-version", newJString(apiVersion))
  add(path_565064, "name", newJString(name))
  add(path_565064, "subscriptionId", newJString(subscriptionId))
  add(path_565064, "resourceGroupName", newJString(resourceGroupName))
  if labVirtualMachine != nil:
    body_565066 = labVirtualMachine
  result = call_565063.call(path_565064, query_565065, nil, nil, body_565066)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_565053(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesCreateOrUpdate_565054, base: "",
    url: url_VirtualMachinesCreateOrUpdate_565055, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_565040 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesGet_565042(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesGet_565041(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565043 = path.getOrDefault("labName")
  valid_565043 = validateParameter(valid_565043, JString, required = true,
                                 default = nil)
  if valid_565043 != nil:
    section.add "labName", valid_565043
  var valid_565044 = path.getOrDefault("name")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "name", valid_565044
  var valid_565045 = path.getOrDefault("subscriptionId")
  valid_565045 = validateParameter(valid_565045, JString, required = true,
                                 default = nil)
  if valid_565045 != nil:
    section.add "subscriptionId", valid_565045
  var valid_565046 = path.getOrDefault("resourceGroupName")
  valid_565046 = validateParameter(valid_565046, JString, required = true,
                                 default = nil)
  if valid_565046 != nil:
    section.add "resourceGroupName", valid_565046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565047 = query.getOrDefault("api-version")
  valid_565047 = validateParameter(valid_565047, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565047 != nil:
    section.add "api-version", valid_565047
  var valid_565048 = query.getOrDefault("$expand")
  valid_565048 = validateParameter(valid_565048, JString, required = false,
                                 default = nil)
  if valid_565048 != nil:
    section.add "$expand", valid_565048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565049: Call_VirtualMachinesGet_565040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine.
  ## 
  let valid = call_565049.validator(path, query, header, formData, body)
  let scheme = call_565049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565049.url(scheme.get, call_565049.host, call_565049.base,
                         call_565049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565049, url, valid)

proc call*(call_565050: Call_VirtualMachinesGet_565040; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## virtualMachinesGet
  ## Get virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565051 = newJObject()
  var query_565052 = newJObject()
  add(path_565051, "labName", newJString(labName))
  add(query_565052, "api-version", newJString(apiVersion))
  add(query_565052, "$expand", newJString(Expand))
  add(path_565051, "name", newJString(name))
  add(path_565051, "subscriptionId", newJString(subscriptionId))
  add(path_565051, "resourceGroupName", newJString(resourceGroupName))
  result = call_565050.call(path_565051, query_565052, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_565040(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesGet_565041, base: "",
    url: url_VirtualMachinesGet_565042, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_565079 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesUpdate_565081(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUpdate_565080(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565082 = path.getOrDefault("labName")
  valid_565082 = validateParameter(valid_565082, JString, required = true,
                                 default = nil)
  if valid_565082 != nil:
    section.add "labName", valid_565082
  var valid_565083 = path.getOrDefault("name")
  valid_565083 = validateParameter(valid_565083, JString, required = true,
                                 default = nil)
  if valid_565083 != nil:
    section.add "name", valid_565083
  var valid_565084 = path.getOrDefault("subscriptionId")
  valid_565084 = validateParameter(valid_565084, JString, required = true,
                                 default = nil)
  if valid_565084 != nil:
    section.add "subscriptionId", valid_565084
  var valid_565085 = path.getOrDefault("resourceGroupName")
  valid_565085 = validateParameter(valid_565085, JString, required = true,
                                 default = nil)
  if valid_565085 != nil:
    section.add "resourceGroupName", valid_565085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565086 = query.getOrDefault("api-version")
  valid_565086 = validateParameter(valid_565086, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565086 != nil:
    section.add "api-version", valid_565086
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

proc call*(call_565088: Call_VirtualMachinesUpdate_565079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual machines.
  ## 
  let valid = call_565088.validator(path, query, header, formData, body)
  let scheme = call_565088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565088.url(scheme.get, call_565088.host, call_565088.base,
                         call_565088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565088, url, valid)

proc call*(call_565089: Call_VirtualMachinesUpdate_565079; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          labVirtualMachine: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesUpdate
  ## Modify properties of virtual machines.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   labVirtualMachine: JObject (required)
  ##                    : A virtual machine.
  var path_565090 = newJObject()
  var query_565091 = newJObject()
  var body_565092 = newJObject()
  add(path_565090, "labName", newJString(labName))
  add(query_565091, "api-version", newJString(apiVersion))
  add(path_565090, "name", newJString(name))
  add(path_565090, "subscriptionId", newJString(subscriptionId))
  add(path_565090, "resourceGroupName", newJString(resourceGroupName))
  if labVirtualMachine != nil:
    body_565092 = labVirtualMachine
  result = call_565089.call(path_565090, query_565091, nil, nil, body_565092)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_565079(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesUpdate_565080, base: "",
    url: url_VirtualMachinesUpdate_565081, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_565067 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesDelete_565069(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesDelete_565068(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565070 = path.getOrDefault("labName")
  valid_565070 = validateParameter(valid_565070, JString, required = true,
                                 default = nil)
  if valid_565070 != nil:
    section.add "labName", valid_565070
  var valid_565071 = path.getOrDefault("name")
  valid_565071 = validateParameter(valid_565071, JString, required = true,
                                 default = nil)
  if valid_565071 != nil:
    section.add "name", valid_565071
  var valid_565072 = path.getOrDefault("subscriptionId")
  valid_565072 = validateParameter(valid_565072, JString, required = true,
                                 default = nil)
  if valid_565072 != nil:
    section.add "subscriptionId", valid_565072
  var valid_565073 = path.getOrDefault("resourceGroupName")
  valid_565073 = validateParameter(valid_565073, JString, required = true,
                                 default = nil)
  if valid_565073 != nil:
    section.add "resourceGroupName", valid_565073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565074 = query.getOrDefault("api-version")
  valid_565074 = validateParameter(valid_565074, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565074 != nil:
    section.add "api-version", valid_565074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565075: Call_VirtualMachinesDelete_565067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565075.validator(path, query, header, formData, body)
  let scheme = call_565075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565075.url(scheme.get, call_565075.host, call_565075.base,
                         call_565075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565075, url, valid)

proc call*(call_565076: Call_VirtualMachinesDelete_565067; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesDelete
  ## Delete virtual machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565077 = newJObject()
  var query_565078 = newJObject()
  add(path_565077, "labName", newJString(labName))
  add(query_565078, "api-version", newJString(apiVersion))
  add(path_565077, "name", newJString(name))
  add(path_565077, "subscriptionId", newJString(subscriptionId))
  add(path_565077, "resourceGroupName", newJString(resourceGroupName))
  result = call_565076.call(path_565077, query_565078, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_565067(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesDelete_565068, base: "",
    url: url_VirtualMachinesDelete_565069, schemes: {Scheme.Https})
type
  Call_VirtualMachinesAddDataDisk_565093 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesAddDataDisk_565095(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesAddDataDisk_565094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565096 = path.getOrDefault("labName")
  valid_565096 = validateParameter(valid_565096, JString, required = true,
                                 default = nil)
  if valid_565096 != nil:
    section.add "labName", valid_565096
  var valid_565097 = path.getOrDefault("name")
  valid_565097 = validateParameter(valid_565097, JString, required = true,
                                 default = nil)
  if valid_565097 != nil:
    section.add "name", valid_565097
  var valid_565098 = path.getOrDefault("subscriptionId")
  valid_565098 = validateParameter(valid_565098, JString, required = true,
                                 default = nil)
  if valid_565098 != nil:
    section.add "subscriptionId", valid_565098
  var valid_565099 = path.getOrDefault("resourceGroupName")
  valid_565099 = validateParameter(valid_565099, JString, required = true,
                                 default = nil)
  if valid_565099 != nil:
    section.add "resourceGroupName", valid_565099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565100 = query.getOrDefault("api-version")
  valid_565100 = validateParameter(valid_565100, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565100 != nil:
    section.add "api-version", valid_565100
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

proc call*(call_565102: Call_VirtualMachinesAddDataDisk_565093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565102.validator(path, query, header, formData, body)
  let scheme = call_565102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565102.url(scheme.get, call_565102.host, call_565102.base,
                         call_565102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565102, url, valid)

proc call*(call_565103: Call_VirtualMachinesAddDataDisk_565093; labName: string;
          dataDiskProperties: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesAddDataDisk
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   dataDiskProperties: JObject (required)
  ##                     : Request body for adding a new or existing data disk to a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565104 = newJObject()
  var query_565105 = newJObject()
  var body_565106 = newJObject()
  add(path_565104, "labName", newJString(labName))
  if dataDiskProperties != nil:
    body_565106 = dataDiskProperties
  add(query_565105, "api-version", newJString(apiVersion))
  add(path_565104, "name", newJString(name))
  add(path_565104, "subscriptionId", newJString(subscriptionId))
  add(path_565104, "resourceGroupName", newJString(resourceGroupName))
  result = call_565103.call(path_565104, query_565105, nil, nil, body_565106)

var virtualMachinesAddDataDisk* = Call_VirtualMachinesAddDataDisk_565093(
    name: "virtualMachinesAddDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/addDataDisk",
    validator: validate_VirtualMachinesAddDataDisk_565094, base: "",
    url: url_VirtualMachinesAddDataDisk_565095, schemes: {Scheme.Https})
type
  Call_VirtualMachinesApplyArtifacts_565107 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesApplyArtifacts_565109(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesApplyArtifacts_565108(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565110 = path.getOrDefault("labName")
  valid_565110 = validateParameter(valid_565110, JString, required = true,
                                 default = nil)
  if valid_565110 != nil:
    section.add "labName", valid_565110
  var valid_565111 = path.getOrDefault("name")
  valid_565111 = validateParameter(valid_565111, JString, required = true,
                                 default = nil)
  if valid_565111 != nil:
    section.add "name", valid_565111
  var valid_565112 = path.getOrDefault("subscriptionId")
  valid_565112 = validateParameter(valid_565112, JString, required = true,
                                 default = nil)
  if valid_565112 != nil:
    section.add "subscriptionId", valid_565112
  var valid_565113 = path.getOrDefault("resourceGroupName")
  valid_565113 = validateParameter(valid_565113, JString, required = true,
                                 default = nil)
  if valid_565113 != nil:
    section.add "resourceGroupName", valid_565113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565114 = query.getOrDefault("api-version")
  valid_565114 = validateParameter(valid_565114, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565114 != nil:
    section.add "api-version", valid_565114
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

proc call*(call_565116: Call_VirtualMachinesApplyArtifacts_565107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565116.validator(path, query, header, formData, body)
  let scheme = call_565116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565116.url(scheme.get, call_565116.host, call_565116.base,
                         call_565116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565116, url, valid)

proc call*(call_565117: Call_VirtualMachinesApplyArtifacts_565107; labName: string;
          applyArtifactsRequest: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesApplyArtifacts
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   applyArtifactsRequest: JObject (required)
  ##                        : Request body for applying artifacts to a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565118 = newJObject()
  var query_565119 = newJObject()
  var body_565120 = newJObject()
  add(path_565118, "labName", newJString(labName))
  if applyArtifactsRequest != nil:
    body_565120 = applyArtifactsRequest
  add(query_565119, "api-version", newJString(apiVersion))
  add(path_565118, "name", newJString(name))
  add(path_565118, "subscriptionId", newJString(subscriptionId))
  add(path_565118, "resourceGroupName", newJString(resourceGroupName))
  result = call_565117.call(path_565118, query_565119, nil, nil, body_565120)

var virtualMachinesApplyArtifacts* = Call_VirtualMachinesApplyArtifacts_565107(
    name: "virtualMachinesApplyArtifacts", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/applyArtifacts",
    validator: validate_VirtualMachinesApplyArtifacts_565108, base: "",
    url: url_VirtualMachinesApplyArtifacts_565109, schemes: {Scheme.Https})
type
  Call_VirtualMachinesClaim_565121 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesClaim_565123(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesClaim_565122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565124 = path.getOrDefault("labName")
  valid_565124 = validateParameter(valid_565124, JString, required = true,
                                 default = nil)
  if valid_565124 != nil:
    section.add "labName", valid_565124
  var valid_565125 = path.getOrDefault("name")
  valid_565125 = validateParameter(valid_565125, JString, required = true,
                                 default = nil)
  if valid_565125 != nil:
    section.add "name", valid_565125
  var valid_565126 = path.getOrDefault("subscriptionId")
  valid_565126 = validateParameter(valid_565126, JString, required = true,
                                 default = nil)
  if valid_565126 != nil:
    section.add "subscriptionId", valid_565126
  var valid_565127 = path.getOrDefault("resourceGroupName")
  valid_565127 = validateParameter(valid_565127, JString, required = true,
                                 default = nil)
  if valid_565127 != nil:
    section.add "resourceGroupName", valid_565127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565128 = query.getOrDefault("api-version")
  valid_565128 = validateParameter(valid_565128, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565128 != nil:
    section.add "api-version", valid_565128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565129: Call_VirtualMachinesClaim_565121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  let valid = call_565129.validator(path, query, header, formData, body)
  let scheme = call_565129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565129.url(scheme.get, call_565129.host, call_565129.base,
                         call_565129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565129, url, valid)

proc call*(call_565130: Call_VirtualMachinesClaim_565121; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesClaim
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565131 = newJObject()
  var query_565132 = newJObject()
  add(path_565131, "labName", newJString(labName))
  add(query_565132, "api-version", newJString(apiVersion))
  add(path_565131, "name", newJString(name))
  add(path_565131, "subscriptionId", newJString(subscriptionId))
  add(path_565131, "resourceGroupName", newJString(resourceGroupName))
  result = call_565130.call(path_565131, query_565132, nil, nil, nil)

var virtualMachinesClaim* = Call_VirtualMachinesClaim_565121(
    name: "virtualMachinesClaim", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/claim",
    validator: validate_VirtualMachinesClaim_565122, base: "",
    url: url_VirtualMachinesClaim_565123, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDetachDataDisk_565133 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesDetachDataDisk_565135(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesDetachDataDisk_565134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565136 = path.getOrDefault("labName")
  valid_565136 = validateParameter(valid_565136, JString, required = true,
                                 default = nil)
  if valid_565136 != nil:
    section.add "labName", valid_565136
  var valid_565137 = path.getOrDefault("name")
  valid_565137 = validateParameter(valid_565137, JString, required = true,
                                 default = nil)
  if valid_565137 != nil:
    section.add "name", valid_565137
  var valid_565138 = path.getOrDefault("subscriptionId")
  valid_565138 = validateParameter(valid_565138, JString, required = true,
                                 default = nil)
  if valid_565138 != nil:
    section.add "subscriptionId", valid_565138
  var valid_565139 = path.getOrDefault("resourceGroupName")
  valid_565139 = validateParameter(valid_565139, JString, required = true,
                                 default = nil)
  if valid_565139 != nil:
    section.add "resourceGroupName", valid_565139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565140 = query.getOrDefault("api-version")
  valid_565140 = validateParameter(valid_565140, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565140 != nil:
    section.add "api-version", valid_565140
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

proc call*(call_565142: Call_VirtualMachinesDetachDataDisk_565133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565142.validator(path, query, header, formData, body)
  let scheme = call_565142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565142.url(scheme.get, call_565142.host, call_565142.base,
                         call_565142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565142, url, valid)

proc call*(call_565143: Call_VirtualMachinesDetachDataDisk_565133; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          detachDataDiskProperties: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesDetachDataDisk
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   detachDataDiskProperties: JObject (required)
  ##                           : Request body for detaching data disk from a virtual machine.
  var path_565144 = newJObject()
  var query_565145 = newJObject()
  var body_565146 = newJObject()
  add(path_565144, "labName", newJString(labName))
  add(query_565145, "api-version", newJString(apiVersion))
  add(path_565144, "name", newJString(name))
  add(path_565144, "subscriptionId", newJString(subscriptionId))
  add(path_565144, "resourceGroupName", newJString(resourceGroupName))
  if detachDataDiskProperties != nil:
    body_565146 = detachDataDiskProperties
  result = call_565143.call(path_565144, query_565145, nil, nil, body_565146)

var virtualMachinesDetachDataDisk* = Call_VirtualMachinesDetachDataDisk_565133(
    name: "virtualMachinesDetachDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/detachDataDisk",
    validator: validate_VirtualMachinesDetachDataDisk_565134, base: "",
    url: url_VirtualMachinesDetachDataDisk_565135, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListApplicableSchedules_565147 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesListApplicableSchedules_565149(protocol: Scheme;
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

proc validate_VirtualMachinesListApplicableSchedules_565148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all applicable schedules
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565150 = path.getOrDefault("labName")
  valid_565150 = validateParameter(valid_565150, JString, required = true,
                                 default = nil)
  if valid_565150 != nil:
    section.add "labName", valid_565150
  var valid_565151 = path.getOrDefault("name")
  valid_565151 = validateParameter(valid_565151, JString, required = true,
                                 default = nil)
  if valid_565151 != nil:
    section.add "name", valid_565151
  var valid_565152 = path.getOrDefault("subscriptionId")
  valid_565152 = validateParameter(valid_565152, JString, required = true,
                                 default = nil)
  if valid_565152 != nil:
    section.add "subscriptionId", valid_565152
  var valid_565153 = path.getOrDefault("resourceGroupName")
  valid_565153 = validateParameter(valid_565153, JString, required = true,
                                 default = nil)
  if valid_565153 != nil:
    section.add "resourceGroupName", valid_565153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565154 = query.getOrDefault("api-version")
  valid_565154 = validateParameter(valid_565154, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565154 != nil:
    section.add "api-version", valid_565154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565155: Call_VirtualMachinesListApplicableSchedules_565147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all applicable schedules
  ## 
  let valid = call_565155.validator(path, query, header, formData, body)
  let scheme = call_565155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565155.url(scheme.get, call_565155.host, call_565155.base,
                         call_565155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565155, url, valid)

proc call*(call_565156: Call_VirtualMachinesListApplicableSchedules_565147;
          labName: string; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesListApplicableSchedules
  ## Lists all applicable schedules
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565157 = newJObject()
  var query_565158 = newJObject()
  add(path_565157, "labName", newJString(labName))
  add(query_565158, "api-version", newJString(apiVersion))
  add(path_565157, "name", newJString(name))
  add(path_565157, "subscriptionId", newJString(subscriptionId))
  add(path_565157, "resourceGroupName", newJString(resourceGroupName))
  result = call_565156.call(path_565157, query_565158, nil, nil, nil)

var virtualMachinesListApplicableSchedules* = Call_VirtualMachinesListApplicableSchedules_565147(
    name: "virtualMachinesListApplicableSchedules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/listApplicableSchedules",
    validator: validate_VirtualMachinesListApplicableSchedules_565148, base: "",
    url: url_VirtualMachinesListApplicableSchedules_565149,
    schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_565159 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesStart_565161(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStart_565160(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start a virtual machine. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565162 = path.getOrDefault("labName")
  valid_565162 = validateParameter(valid_565162, JString, required = true,
                                 default = nil)
  if valid_565162 != nil:
    section.add "labName", valid_565162
  var valid_565163 = path.getOrDefault("name")
  valid_565163 = validateParameter(valid_565163, JString, required = true,
                                 default = nil)
  if valid_565163 != nil:
    section.add "name", valid_565163
  var valid_565164 = path.getOrDefault("subscriptionId")
  valid_565164 = validateParameter(valid_565164, JString, required = true,
                                 default = nil)
  if valid_565164 != nil:
    section.add "subscriptionId", valid_565164
  var valid_565165 = path.getOrDefault("resourceGroupName")
  valid_565165 = validateParameter(valid_565165, JString, required = true,
                                 default = nil)
  if valid_565165 != nil:
    section.add "resourceGroupName", valid_565165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565166 = query.getOrDefault("api-version")
  valid_565166 = validateParameter(valid_565166, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565166 != nil:
    section.add "api-version", valid_565166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565167: Call_VirtualMachinesStart_565159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565167.validator(path, query, header, formData, body)
  let scheme = call_565167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565167.url(scheme.get, call_565167.host, call_565167.base,
                         call_565167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565167, url, valid)

proc call*(call_565168: Call_VirtualMachinesStart_565159; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesStart
  ## Start a virtual machine. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565169 = newJObject()
  var query_565170 = newJObject()
  add(path_565169, "labName", newJString(labName))
  add(query_565170, "api-version", newJString(apiVersion))
  add(path_565169, "name", newJString(name))
  add(path_565169, "subscriptionId", newJString(subscriptionId))
  add(path_565169, "resourceGroupName", newJString(resourceGroupName))
  result = call_565168.call(path_565169, query_565170, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_565159(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/start",
    validator: validate_VirtualMachinesStart_565160, base: "",
    url: url_VirtualMachinesStart_565161, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStop_565171 = ref object of OpenApiRestCall_563548
proc url_VirtualMachinesStop_565173(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStop_565172(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Stop a virtual machine This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565174 = path.getOrDefault("labName")
  valid_565174 = validateParameter(valid_565174, JString, required = true,
                                 default = nil)
  if valid_565174 != nil:
    section.add "labName", valid_565174
  var valid_565175 = path.getOrDefault("name")
  valid_565175 = validateParameter(valid_565175, JString, required = true,
                                 default = nil)
  if valid_565175 != nil:
    section.add "name", valid_565175
  var valid_565176 = path.getOrDefault("subscriptionId")
  valid_565176 = validateParameter(valid_565176, JString, required = true,
                                 default = nil)
  if valid_565176 != nil:
    section.add "subscriptionId", valid_565176
  var valid_565177 = path.getOrDefault("resourceGroupName")
  valid_565177 = validateParameter(valid_565177, JString, required = true,
                                 default = nil)
  if valid_565177 != nil:
    section.add "resourceGroupName", valid_565177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565178 = query.getOrDefault("api-version")
  valid_565178 = validateParameter(valid_565178, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565178 != nil:
    section.add "api-version", valid_565178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565179: Call_VirtualMachinesStop_565171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a virtual machine This operation can take a while to complete.
  ## 
  let valid = call_565179.validator(path, query, header, formData, body)
  let scheme = call_565179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565179.url(scheme.get, call_565179.host, call_565179.base,
                         call_565179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565179, url, valid)

proc call*(call_565180: Call_VirtualMachinesStop_565171; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachinesStop
  ## Stop a virtual machine This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565181 = newJObject()
  var query_565182 = newJObject()
  add(path_565181, "labName", newJString(labName))
  add(query_565182, "api-version", newJString(apiVersion))
  add(path_565181, "name", newJString(name))
  add(path_565181, "subscriptionId", newJString(subscriptionId))
  add(path_565181, "resourceGroupName", newJString(resourceGroupName))
  result = call_565180.call(path_565181, query_565182, nil, nil, nil)

var virtualMachinesStop* = Call_VirtualMachinesStop_565171(
    name: "virtualMachinesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/stop",
    validator: validate_VirtualMachinesStop_565172, base: "",
    url: url_VirtualMachinesStop_565173, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesList_565183 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineSchedulesList_565185(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesList_565184(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a given virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565186 = path.getOrDefault("labName")
  valid_565186 = validateParameter(valid_565186, JString, required = true,
                                 default = nil)
  if valid_565186 != nil:
    section.add "labName", valid_565186
  var valid_565187 = path.getOrDefault("virtualMachineName")
  valid_565187 = validateParameter(valid_565187, JString, required = true,
                                 default = nil)
  if valid_565187 != nil:
    section.add "virtualMachineName", valid_565187
  var valid_565188 = path.getOrDefault("subscriptionId")
  valid_565188 = validateParameter(valid_565188, JString, required = true,
                                 default = nil)
  if valid_565188 != nil:
    section.add "subscriptionId", valid_565188
  var valid_565189 = path.getOrDefault("resourceGroupName")
  valid_565189 = validateParameter(valid_565189, JString, required = true,
                                 default = nil)
  if valid_565189 != nil:
    section.add "resourceGroupName", valid_565189
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_565190 = query.getOrDefault("$top")
  valid_565190 = validateParameter(valid_565190, JInt, required = false, default = nil)
  if valid_565190 != nil:
    section.add "$top", valid_565190
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565191 = query.getOrDefault("api-version")
  valid_565191 = validateParameter(valid_565191, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565191 != nil:
    section.add "api-version", valid_565191
  var valid_565192 = query.getOrDefault("$expand")
  valid_565192 = validateParameter(valid_565192, JString, required = false,
                                 default = nil)
  if valid_565192 != nil:
    section.add "$expand", valid_565192
  var valid_565193 = query.getOrDefault("$orderby")
  valid_565193 = validateParameter(valid_565193, JString, required = false,
                                 default = nil)
  if valid_565193 != nil:
    section.add "$orderby", valid_565193
  var valid_565194 = query.getOrDefault("$filter")
  valid_565194 = validateParameter(valid_565194, JString, required = false,
                                 default = nil)
  if valid_565194 != nil:
    section.add "$filter", valid_565194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565195: Call_VirtualMachineSchedulesList_565183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given virtual machine.
  ## 
  let valid = call_565195.validator(path, query, header, formData, body)
  let scheme = call_565195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565195.url(scheme.get, call_565195.host, call_565195.base,
                         call_565195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565195, url, valid)

proc call*(call_565196: Call_VirtualMachineSchedulesList_565183; labName: string;
          virtualMachineName: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; apiVersion: string = "2016-05-15";
          Expand: string = ""; Orderby: string = ""; Filter: string = ""): Recallable =
  ## virtualMachineSchedulesList
  ## List schedules in a given virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_565197 = newJObject()
  var query_565198 = newJObject()
  add(path_565197, "labName", newJString(labName))
  add(query_565198, "$top", newJInt(Top))
  add(query_565198, "api-version", newJString(apiVersion))
  add(query_565198, "$expand", newJString(Expand))
  add(path_565197, "virtualMachineName", newJString(virtualMachineName))
  add(path_565197, "subscriptionId", newJString(subscriptionId))
  add(query_565198, "$orderby", newJString(Orderby))
  add(path_565197, "resourceGroupName", newJString(resourceGroupName))
  add(query_565198, "$filter", newJString(Filter))
  result = call_565196.call(path_565197, query_565198, nil, nil, nil)

var virtualMachineSchedulesList* = Call_VirtualMachineSchedulesList_565183(
    name: "virtualMachineSchedulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules",
    validator: validate_VirtualMachineSchedulesList_565184, base: "",
    url: url_VirtualMachineSchedulesList_565185, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesCreateOrUpdate_565213 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineSchedulesCreateOrUpdate_565215(protocol: Scheme;
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

proc validate_VirtualMachineSchedulesCreateOrUpdate_565214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565216 = path.getOrDefault("labName")
  valid_565216 = validateParameter(valid_565216, JString, required = true,
                                 default = nil)
  if valid_565216 != nil:
    section.add "labName", valid_565216
  var valid_565217 = path.getOrDefault("virtualMachineName")
  valid_565217 = validateParameter(valid_565217, JString, required = true,
                                 default = nil)
  if valid_565217 != nil:
    section.add "virtualMachineName", valid_565217
  var valid_565218 = path.getOrDefault("name")
  valid_565218 = validateParameter(valid_565218, JString, required = true,
                                 default = nil)
  if valid_565218 != nil:
    section.add "name", valid_565218
  var valid_565219 = path.getOrDefault("subscriptionId")
  valid_565219 = validateParameter(valid_565219, JString, required = true,
                                 default = nil)
  if valid_565219 != nil:
    section.add "subscriptionId", valid_565219
  var valid_565220 = path.getOrDefault("resourceGroupName")
  valid_565220 = validateParameter(valid_565220, JString, required = true,
                                 default = nil)
  if valid_565220 != nil:
    section.add "resourceGroupName", valid_565220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565221 = query.getOrDefault("api-version")
  valid_565221 = validateParameter(valid_565221, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565221 != nil:
    section.add "api-version", valid_565221
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

proc call*(call_565223: Call_VirtualMachineSchedulesCreateOrUpdate_565213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_565223.validator(path, query, header, formData, body)
  let scheme = call_565223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565223.url(scheme.get, call_565223.host, call_565223.base,
                         call_565223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565223, url, valid)

proc call*(call_565224: Call_VirtualMachineSchedulesCreateOrUpdate_565213;
          labName: string; virtualMachineName: string; name: string;
          subscriptionId: string; resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_565225 = newJObject()
  var query_565226 = newJObject()
  var body_565227 = newJObject()
  add(path_565225, "labName", newJString(labName))
  add(query_565226, "api-version", newJString(apiVersion))
  add(path_565225, "virtualMachineName", newJString(virtualMachineName))
  add(path_565225, "name", newJString(name))
  add(path_565225, "subscriptionId", newJString(subscriptionId))
  add(path_565225, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565227 = schedule
  result = call_565224.call(path_565225, query_565226, nil, nil, body_565227)

var virtualMachineSchedulesCreateOrUpdate* = Call_VirtualMachineSchedulesCreateOrUpdate_565213(
    name: "virtualMachineSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesCreateOrUpdate_565214, base: "",
    url: url_VirtualMachineSchedulesCreateOrUpdate_565215, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesGet_565199 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineSchedulesGet_565201(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesGet_565200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565202 = path.getOrDefault("labName")
  valid_565202 = validateParameter(valid_565202, JString, required = true,
                                 default = nil)
  if valid_565202 != nil:
    section.add "labName", valid_565202
  var valid_565203 = path.getOrDefault("virtualMachineName")
  valid_565203 = validateParameter(valid_565203, JString, required = true,
                                 default = nil)
  if valid_565203 != nil:
    section.add "virtualMachineName", valid_565203
  var valid_565204 = path.getOrDefault("name")
  valid_565204 = validateParameter(valid_565204, JString, required = true,
                                 default = nil)
  if valid_565204 != nil:
    section.add "name", valid_565204
  var valid_565205 = path.getOrDefault("subscriptionId")
  valid_565205 = validateParameter(valid_565205, JString, required = true,
                                 default = nil)
  if valid_565205 != nil:
    section.add "subscriptionId", valid_565205
  var valid_565206 = path.getOrDefault("resourceGroupName")
  valid_565206 = validateParameter(valid_565206, JString, required = true,
                                 default = nil)
  if valid_565206 != nil:
    section.add "resourceGroupName", valid_565206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565207 = query.getOrDefault("api-version")
  valid_565207 = validateParameter(valid_565207, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565207 != nil:
    section.add "api-version", valid_565207
  var valid_565208 = query.getOrDefault("$expand")
  valid_565208 = validateParameter(valid_565208, JString, required = false,
                                 default = nil)
  if valid_565208 != nil:
    section.add "$expand", valid_565208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565209: Call_VirtualMachineSchedulesGet_565199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_565209.validator(path, query, header, formData, body)
  let scheme = call_565209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565209.url(scheme.get, call_565209.host, call_565209.base,
                         call_565209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565209, url, valid)

proc call*(call_565210: Call_VirtualMachineSchedulesGet_565199; labName: string;
          virtualMachineName: string; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2016-05-15";
          Expand: string = ""): Recallable =
  ## virtualMachineSchedulesGet
  ## Get schedule.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565211 = newJObject()
  var query_565212 = newJObject()
  add(path_565211, "labName", newJString(labName))
  add(query_565212, "api-version", newJString(apiVersion))
  add(query_565212, "$expand", newJString(Expand))
  add(path_565211, "virtualMachineName", newJString(virtualMachineName))
  add(path_565211, "name", newJString(name))
  add(path_565211, "subscriptionId", newJString(subscriptionId))
  add(path_565211, "resourceGroupName", newJString(resourceGroupName))
  result = call_565210.call(path_565211, query_565212, nil, nil, nil)

var virtualMachineSchedulesGet* = Call_VirtualMachineSchedulesGet_565199(
    name: "virtualMachineSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesGet_565200, base: "",
    url: url_VirtualMachineSchedulesGet_565201, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesUpdate_565241 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineSchedulesUpdate_565243(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesUpdate_565242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565244 = path.getOrDefault("labName")
  valid_565244 = validateParameter(valid_565244, JString, required = true,
                                 default = nil)
  if valid_565244 != nil:
    section.add "labName", valid_565244
  var valid_565245 = path.getOrDefault("virtualMachineName")
  valid_565245 = validateParameter(valid_565245, JString, required = true,
                                 default = nil)
  if valid_565245 != nil:
    section.add "virtualMachineName", valid_565245
  var valid_565246 = path.getOrDefault("name")
  valid_565246 = validateParameter(valid_565246, JString, required = true,
                                 default = nil)
  if valid_565246 != nil:
    section.add "name", valid_565246
  var valid_565247 = path.getOrDefault("subscriptionId")
  valid_565247 = validateParameter(valid_565247, JString, required = true,
                                 default = nil)
  if valid_565247 != nil:
    section.add "subscriptionId", valid_565247
  var valid_565248 = path.getOrDefault("resourceGroupName")
  valid_565248 = validateParameter(valid_565248, JString, required = true,
                                 default = nil)
  if valid_565248 != nil:
    section.add "resourceGroupName", valid_565248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565249 = query.getOrDefault("api-version")
  valid_565249 = validateParameter(valid_565249, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565249 != nil:
    section.add "api-version", valid_565249
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

proc call*(call_565251: Call_VirtualMachineSchedulesUpdate_565241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_565251.validator(path, query, header, formData, body)
  let scheme = call_565251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565251.url(scheme.get, call_565251.host, call_565251.base,
                         call_565251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565251, url, valid)

proc call*(call_565252: Call_VirtualMachineSchedulesUpdate_565241; labName: string;
          virtualMachineName: string; name: string; subscriptionId: string;
          resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesUpdate
  ## Modify properties of schedules.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_565253 = newJObject()
  var query_565254 = newJObject()
  var body_565255 = newJObject()
  add(path_565253, "labName", newJString(labName))
  add(query_565254, "api-version", newJString(apiVersion))
  add(path_565253, "virtualMachineName", newJString(virtualMachineName))
  add(path_565253, "name", newJString(name))
  add(path_565253, "subscriptionId", newJString(subscriptionId))
  add(path_565253, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565255 = schedule
  result = call_565252.call(path_565253, query_565254, nil, nil, body_565255)

var virtualMachineSchedulesUpdate* = Call_VirtualMachineSchedulesUpdate_565241(
    name: "virtualMachineSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesUpdate_565242, base: "",
    url: url_VirtualMachineSchedulesUpdate_565243, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesDelete_565228 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineSchedulesDelete_565230(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesDelete_565229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565231 = path.getOrDefault("labName")
  valid_565231 = validateParameter(valid_565231, JString, required = true,
                                 default = nil)
  if valid_565231 != nil:
    section.add "labName", valid_565231
  var valid_565232 = path.getOrDefault("virtualMachineName")
  valid_565232 = validateParameter(valid_565232, JString, required = true,
                                 default = nil)
  if valid_565232 != nil:
    section.add "virtualMachineName", valid_565232
  var valid_565233 = path.getOrDefault("name")
  valid_565233 = validateParameter(valid_565233, JString, required = true,
                                 default = nil)
  if valid_565233 != nil:
    section.add "name", valid_565233
  var valid_565234 = path.getOrDefault("subscriptionId")
  valid_565234 = validateParameter(valid_565234, JString, required = true,
                                 default = nil)
  if valid_565234 != nil:
    section.add "subscriptionId", valid_565234
  var valid_565235 = path.getOrDefault("resourceGroupName")
  valid_565235 = validateParameter(valid_565235, JString, required = true,
                                 default = nil)
  if valid_565235 != nil:
    section.add "resourceGroupName", valid_565235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565236 = query.getOrDefault("api-version")
  valid_565236 = validateParameter(valid_565236, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565236 != nil:
    section.add "api-version", valid_565236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565237: Call_VirtualMachineSchedulesDelete_565228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_565237.validator(path, query, header, formData, body)
  let scheme = call_565237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565237.url(scheme.get, call_565237.host, call_565237.base,
                         call_565237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565237, url, valid)

proc call*(call_565238: Call_VirtualMachineSchedulesDelete_565228; labName: string;
          virtualMachineName: string; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesDelete
  ## Delete schedule.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565239 = newJObject()
  var query_565240 = newJObject()
  add(path_565239, "labName", newJString(labName))
  add(query_565240, "api-version", newJString(apiVersion))
  add(path_565239, "virtualMachineName", newJString(virtualMachineName))
  add(path_565239, "name", newJString(name))
  add(path_565239, "subscriptionId", newJString(subscriptionId))
  add(path_565239, "resourceGroupName", newJString(resourceGroupName))
  result = call_565238.call(path_565239, query_565240, nil, nil, nil)

var virtualMachineSchedulesDelete* = Call_VirtualMachineSchedulesDelete_565228(
    name: "virtualMachineSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesDelete_565229, base: "",
    url: url_VirtualMachineSchedulesDelete_565230, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesExecute_565256 = ref object of OpenApiRestCall_563548
proc url_VirtualMachineSchedulesExecute_565258(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesExecute_565257(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   virtualMachineName: JString (required)
  ##                     : The name of the virtual machine.
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565259 = path.getOrDefault("labName")
  valid_565259 = validateParameter(valid_565259, JString, required = true,
                                 default = nil)
  if valid_565259 != nil:
    section.add "labName", valid_565259
  var valid_565260 = path.getOrDefault("virtualMachineName")
  valid_565260 = validateParameter(valid_565260, JString, required = true,
                                 default = nil)
  if valid_565260 != nil:
    section.add "virtualMachineName", valid_565260
  var valid_565261 = path.getOrDefault("name")
  valid_565261 = validateParameter(valid_565261, JString, required = true,
                                 default = nil)
  if valid_565261 != nil:
    section.add "name", valid_565261
  var valid_565262 = path.getOrDefault("subscriptionId")
  valid_565262 = validateParameter(valid_565262, JString, required = true,
                                 default = nil)
  if valid_565262 != nil:
    section.add "subscriptionId", valid_565262
  var valid_565263 = path.getOrDefault("resourceGroupName")
  valid_565263 = validateParameter(valid_565263, JString, required = true,
                                 default = nil)
  if valid_565263 != nil:
    section.add "resourceGroupName", valid_565263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565264 = query.getOrDefault("api-version")
  valid_565264 = validateParameter(valid_565264, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565264 != nil:
    section.add "api-version", valid_565264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565265: Call_VirtualMachineSchedulesExecute_565256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_565265.validator(path, query, header, formData, body)
  let scheme = call_565265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565265.url(scheme.get, call_565265.host, call_565265.base,
                         call_565265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565265, url, valid)

proc call*(call_565266: Call_VirtualMachineSchedulesExecute_565256;
          labName: string; virtualMachineName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualMachineSchedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565267 = newJObject()
  var query_565268 = newJObject()
  add(path_565267, "labName", newJString(labName))
  add(query_565268, "api-version", newJString(apiVersion))
  add(path_565267, "virtualMachineName", newJString(virtualMachineName))
  add(path_565267, "name", newJString(name))
  add(path_565267, "subscriptionId", newJString(subscriptionId))
  add(path_565267, "resourceGroupName", newJString(resourceGroupName))
  result = call_565266.call(path_565267, query_565268, nil, nil, nil)

var virtualMachineSchedulesExecute* = Call_VirtualMachineSchedulesExecute_565256(
    name: "virtualMachineSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}/execute",
    validator: validate_VirtualMachineSchedulesExecute_565257, base: "",
    url: url_VirtualMachineSchedulesExecute_565258, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_565269 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworksList_565271(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_565270(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List virtual networks in a given lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565272 = path.getOrDefault("labName")
  valid_565272 = validateParameter(valid_565272, JString, required = true,
                                 default = nil)
  if valid_565272 != nil:
    section.add "labName", valid_565272
  var valid_565273 = path.getOrDefault("subscriptionId")
  valid_565273 = validateParameter(valid_565273, JString, required = true,
                                 default = nil)
  if valid_565273 != nil:
    section.add "subscriptionId", valid_565273
  var valid_565274 = path.getOrDefault("resourceGroupName")
  valid_565274 = validateParameter(valid_565274, JString, required = true,
                                 default = nil)
  if valid_565274 != nil:
    section.add "resourceGroupName", valid_565274
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_565275 = query.getOrDefault("$top")
  valid_565275 = validateParameter(valid_565275, JInt, required = false, default = nil)
  if valid_565275 != nil:
    section.add "$top", valid_565275
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565276 = query.getOrDefault("api-version")
  valid_565276 = validateParameter(valid_565276, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565276 != nil:
    section.add "api-version", valid_565276
  var valid_565277 = query.getOrDefault("$expand")
  valid_565277 = validateParameter(valid_565277, JString, required = false,
                                 default = nil)
  if valid_565277 != nil:
    section.add "$expand", valid_565277
  var valid_565278 = query.getOrDefault("$orderby")
  valid_565278 = validateParameter(valid_565278, JString, required = false,
                                 default = nil)
  if valid_565278 != nil:
    section.add "$orderby", valid_565278
  var valid_565279 = query.getOrDefault("$filter")
  valid_565279 = validateParameter(valid_565279, JString, required = false,
                                 default = nil)
  if valid_565279 != nil:
    section.add "$filter", valid_565279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565280: Call_VirtualNetworksList_565269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual networks in a given lab.
  ## 
  let valid = call_565280.validator(path, query, header, formData, body)
  let scheme = call_565280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565280.url(scheme.get, call_565280.host, call_565280.base,
                         call_565280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565280, url, valid)

proc call*(call_565281: Call_VirtualNetworksList_565269; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## virtualNetworksList
  ## List virtual networks in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_565282 = newJObject()
  var query_565283 = newJObject()
  add(path_565282, "labName", newJString(labName))
  add(query_565283, "$top", newJInt(Top))
  add(query_565283, "api-version", newJString(apiVersion))
  add(query_565283, "$expand", newJString(Expand))
  add(path_565282, "subscriptionId", newJString(subscriptionId))
  add(query_565283, "$orderby", newJString(Orderby))
  add(path_565282, "resourceGroupName", newJString(resourceGroupName))
  add(query_565283, "$filter", newJString(Filter))
  result = call_565281.call(path_565282, query_565283, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_565269(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks",
    validator: validate_VirtualNetworksList_565270, base: "",
    url: url_VirtualNetworksList_565271, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_565297 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworksCreateOrUpdate_565299(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_565298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565300 = path.getOrDefault("labName")
  valid_565300 = validateParameter(valid_565300, JString, required = true,
                                 default = nil)
  if valid_565300 != nil:
    section.add "labName", valid_565300
  var valid_565301 = path.getOrDefault("name")
  valid_565301 = validateParameter(valid_565301, JString, required = true,
                                 default = nil)
  if valid_565301 != nil:
    section.add "name", valid_565301
  var valid_565302 = path.getOrDefault("subscriptionId")
  valid_565302 = validateParameter(valid_565302, JString, required = true,
                                 default = nil)
  if valid_565302 != nil:
    section.add "subscriptionId", valid_565302
  var valid_565303 = path.getOrDefault("resourceGroupName")
  valid_565303 = validateParameter(valid_565303, JString, required = true,
                                 default = nil)
  if valid_565303 != nil:
    section.add "resourceGroupName", valid_565303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565304 = query.getOrDefault("api-version")
  valid_565304 = validateParameter(valid_565304, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565304 != nil:
    section.add "api-version", valid_565304
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

proc call*(call_565306: Call_VirtualNetworksCreateOrUpdate_565297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  let valid = call_565306.validator(path, query, header, formData, body)
  let scheme = call_565306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565306.url(scheme.get, call_565306.host, call_565306.base,
                         call_565306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565306, url, valid)

proc call*(call_565307: Call_VirtualNetworksCreateOrUpdate_565297; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          virtualNetwork: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualNetworksCreateOrUpdate
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  var path_565308 = newJObject()
  var query_565309 = newJObject()
  var body_565310 = newJObject()
  add(path_565308, "labName", newJString(labName))
  add(query_565309, "api-version", newJString(apiVersion))
  add(path_565308, "name", newJString(name))
  add(path_565308, "subscriptionId", newJString(subscriptionId))
  add(path_565308, "resourceGroupName", newJString(resourceGroupName))
  if virtualNetwork != nil:
    body_565310 = virtualNetwork
  result = call_565307.call(path_565308, query_565309, nil, nil, body_565310)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_565297(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksCreateOrUpdate_565298, base: "",
    url: url_VirtualNetworksCreateOrUpdate_565299, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_565284 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworksGet_565286(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_565285(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get virtual network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565287 = path.getOrDefault("labName")
  valid_565287 = validateParameter(valid_565287, JString, required = true,
                                 default = nil)
  if valid_565287 != nil:
    section.add "labName", valid_565287
  var valid_565288 = path.getOrDefault("name")
  valid_565288 = validateParameter(valid_565288, JString, required = true,
                                 default = nil)
  if valid_565288 != nil:
    section.add "name", valid_565288
  var valid_565289 = path.getOrDefault("subscriptionId")
  valid_565289 = validateParameter(valid_565289, JString, required = true,
                                 default = nil)
  if valid_565289 != nil:
    section.add "subscriptionId", valid_565289
  var valid_565290 = path.getOrDefault("resourceGroupName")
  valid_565290 = validateParameter(valid_565290, JString, required = true,
                                 default = nil)
  if valid_565290 != nil:
    section.add "resourceGroupName", valid_565290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565291 = query.getOrDefault("api-version")
  valid_565291 = validateParameter(valid_565291, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565291 != nil:
    section.add "api-version", valid_565291
  var valid_565292 = query.getOrDefault("$expand")
  valid_565292 = validateParameter(valid_565292, JString, required = false,
                                 default = nil)
  if valid_565292 != nil:
    section.add "$expand", valid_565292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565293: Call_VirtualNetworksGet_565284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual network.
  ## 
  let valid = call_565293.validator(path, query, header, formData, body)
  let scheme = call_565293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565293.url(scheme.get, call_565293.host, call_565293.base,
                         call_565293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565293, url, valid)

proc call*(call_565294: Call_VirtualNetworksGet_565284; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## virtualNetworksGet
  ## Get virtual network.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565295 = newJObject()
  var query_565296 = newJObject()
  add(path_565295, "labName", newJString(labName))
  add(query_565296, "api-version", newJString(apiVersion))
  add(query_565296, "$expand", newJString(Expand))
  add(path_565295, "name", newJString(name))
  add(path_565295, "subscriptionId", newJString(subscriptionId))
  add(path_565295, "resourceGroupName", newJString(resourceGroupName))
  result = call_565294.call(path_565295, query_565296, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_565284(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksGet_565285, base: "",
    url: url_VirtualNetworksGet_565286, schemes: {Scheme.Https})
type
  Call_VirtualNetworksUpdate_565323 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworksUpdate_565325(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksUpdate_565324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of virtual networks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565326 = path.getOrDefault("labName")
  valid_565326 = validateParameter(valid_565326, JString, required = true,
                                 default = nil)
  if valid_565326 != nil:
    section.add "labName", valid_565326
  var valid_565327 = path.getOrDefault("name")
  valid_565327 = validateParameter(valid_565327, JString, required = true,
                                 default = nil)
  if valid_565327 != nil:
    section.add "name", valid_565327
  var valid_565328 = path.getOrDefault("subscriptionId")
  valid_565328 = validateParameter(valid_565328, JString, required = true,
                                 default = nil)
  if valid_565328 != nil:
    section.add "subscriptionId", valid_565328
  var valid_565329 = path.getOrDefault("resourceGroupName")
  valid_565329 = validateParameter(valid_565329, JString, required = true,
                                 default = nil)
  if valid_565329 != nil:
    section.add "resourceGroupName", valid_565329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565330 = query.getOrDefault("api-version")
  valid_565330 = validateParameter(valid_565330, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565330 != nil:
    section.add "api-version", valid_565330
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

proc call*(call_565332: Call_VirtualNetworksUpdate_565323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of virtual networks.
  ## 
  let valid = call_565332.validator(path, query, header, formData, body)
  let scheme = call_565332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565332.url(scheme.get, call_565332.host, call_565332.base,
                         call_565332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565332, url, valid)

proc call*(call_565333: Call_VirtualNetworksUpdate_565323; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          virtualNetwork: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## virtualNetworksUpdate
  ## Modify properties of virtual networks.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualNetwork: JObject (required)
  ##                 : A virtual network.
  var path_565334 = newJObject()
  var query_565335 = newJObject()
  var body_565336 = newJObject()
  add(path_565334, "labName", newJString(labName))
  add(query_565335, "api-version", newJString(apiVersion))
  add(path_565334, "name", newJString(name))
  add(path_565334, "subscriptionId", newJString(subscriptionId))
  add(path_565334, "resourceGroupName", newJString(resourceGroupName))
  if virtualNetwork != nil:
    body_565336 = virtualNetwork
  result = call_565333.call(path_565334, query_565335, nil, nil, body_565336)

var virtualNetworksUpdate* = Call_VirtualNetworksUpdate_565323(
    name: "virtualNetworksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksUpdate_565324, base: "",
    url: url_VirtualNetworksUpdate_565325, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_565311 = ref object of OpenApiRestCall_563548
proc url_VirtualNetworksDelete_565313(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_565312(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565314 = path.getOrDefault("labName")
  valid_565314 = validateParameter(valid_565314, JString, required = true,
                                 default = nil)
  if valid_565314 != nil:
    section.add "labName", valid_565314
  var valid_565315 = path.getOrDefault("name")
  valid_565315 = validateParameter(valid_565315, JString, required = true,
                                 default = nil)
  if valid_565315 != nil:
    section.add "name", valid_565315
  var valid_565316 = path.getOrDefault("subscriptionId")
  valid_565316 = validateParameter(valid_565316, JString, required = true,
                                 default = nil)
  if valid_565316 != nil:
    section.add "subscriptionId", valid_565316
  var valid_565317 = path.getOrDefault("resourceGroupName")
  valid_565317 = validateParameter(valid_565317, JString, required = true,
                                 default = nil)
  if valid_565317 != nil:
    section.add "resourceGroupName", valid_565317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565318 = query.getOrDefault("api-version")
  valid_565318 = validateParameter(valid_565318, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565318 != nil:
    section.add "api-version", valid_565318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565319: Call_VirtualNetworksDelete_565311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  let valid = call_565319.validator(path, query, header, formData, body)
  let scheme = call_565319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565319.url(scheme.get, call_565319.host, call_565319.base,
                         call_565319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565319, url, valid)

proc call*(call_565320: Call_VirtualNetworksDelete_565311; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## virtualNetworksDelete
  ## Delete virtual network. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the virtual network.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565321 = newJObject()
  var query_565322 = newJObject()
  add(path_565321, "labName", newJString(labName))
  add(query_565322, "api-version", newJString(apiVersion))
  add(path_565321, "name", newJString(name))
  add(path_565321, "subscriptionId", newJString(subscriptionId))
  add(path_565321, "resourceGroupName", newJString(resourceGroupName))
  result = call_565320.call(path_565321, query_565322, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_565311(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksDelete_565312, base: "",
    url: url_VirtualNetworksDelete_565313, schemes: {Scheme.Https})
type
  Call_LabsCreateOrUpdate_565349 = ref object of OpenApiRestCall_563548
proc url_LabsCreateOrUpdate_565351(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateOrUpdate_565350(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create or replace an existing lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565352 = path.getOrDefault("name")
  valid_565352 = validateParameter(valid_565352, JString, required = true,
                                 default = nil)
  if valid_565352 != nil:
    section.add "name", valid_565352
  var valid_565353 = path.getOrDefault("subscriptionId")
  valid_565353 = validateParameter(valid_565353, JString, required = true,
                                 default = nil)
  if valid_565353 != nil:
    section.add "subscriptionId", valid_565353
  var valid_565354 = path.getOrDefault("resourceGroupName")
  valid_565354 = validateParameter(valid_565354, JString, required = true,
                                 default = nil)
  if valid_565354 != nil:
    section.add "resourceGroupName", valid_565354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565355 = query.getOrDefault("api-version")
  valid_565355 = validateParameter(valid_565355, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565355 != nil:
    section.add "api-version", valid_565355
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

proc call*(call_565357: Call_LabsCreateOrUpdate_565349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing lab. This operation can take a while to complete.
  ## 
  let valid = call_565357.validator(path, query, header, formData, body)
  let scheme = call_565357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565357.url(scheme.get, call_565357.host, call_565357.base,
                         call_565357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565357, url, valid)

proc call*(call_565358: Call_LabsCreateOrUpdate_565349; lab: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsCreateOrUpdate
  ## Create or replace an existing lab. This operation can take a while to complete.
  ##   lab: JObject (required)
  ##      : A lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565359 = newJObject()
  var query_565360 = newJObject()
  var body_565361 = newJObject()
  if lab != nil:
    body_565361 = lab
  add(query_565360, "api-version", newJString(apiVersion))
  add(path_565359, "name", newJString(name))
  add(path_565359, "subscriptionId", newJString(subscriptionId))
  add(path_565359, "resourceGroupName", newJString(resourceGroupName))
  result = call_565358.call(path_565359, query_565360, nil, nil, body_565361)

var labsCreateOrUpdate* = Call_LabsCreateOrUpdate_565349(
    name: "labsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabsCreateOrUpdate_565350, base: "",
    url: url_LabsCreateOrUpdate_565351, schemes: {Scheme.Https})
type
  Call_LabsGet_565337 = ref object of OpenApiRestCall_563548
proc url_LabsGet_565339(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsGet_565338(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565340 = path.getOrDefault("name")
  valid_565340 = validateParameter(valid_565340, JString, required = true,
                                 default = nil)
  if valid_565340 != nil:
    section.add "name", valid_565340
  var valid_565341 = path.getOrDefault("subscriptionId")
  valid_565341 = validateParameter(valid_565341, JString, required = true,
                                 default = nil)
  if valid_565341 != nil:
    section.add "subscriptionId", valid_565341
  var valid_565342 = path.getOrDefault("resourceGroupName")
  valid_565342 = validateParameter(valid_565342, JString, required = true,
                                 default = nil)
  if valid_565342 != nil:
    section.add "resourceGroupName", valid_565342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565343 = query.getOrDefault("api-version")
  valid_565343 = validateParameter(valid_565343, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565343 != nil:
    section.add "api-version", valid_565343
  var valid_565344 = query.getOrDefault("$expand")
  valid_565344 = validateParameter(valid_565344, JString, required = false,
                                 default = nil)
  if valid_565344 != nil:
    section.add "$expand", valid_565344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565345: Call_LabsGet_565337; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab.
  ## 
  let valid = call_565345.validator(path, query, header, formData, body)
  let scheme = call_565345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565345.url(scheme.get, call_565345.host, call_565345.base,
                         call_565345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565345, url, valid)

proc call*(call_565346: Call_LabsGet_565337; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2016-05-15";
          Expand: string = ""): Recallable =
  ## labsGet
  ## Get lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565347 = newJObject()
  var query_565348 = newJObject()
  add(query_565348, "api-version", newJString(apiVersion))
  add(query_565348, "$expand", newJString(Expand))
  add(path_565347, "name", newJString(name))
  add(path_565347, "subscriptionId", newJString(subscriptionId))
  add(path_565347, "resourceGroupName", newJString(resourceGroupName))
  result = call_565346.call(path_565347, query_565348, nil, nil, nil)

var labsGet* = Call_LabsGet_565337(name: "labsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                validator: validate_LabsGet_565338, base: "",
                                url: url_LabsGet_565339, schemes: {Scheme.Https})
type
  Call_LabsUpdate_565373 = ref object of OpenApiRestCall_563548
proc url_LabsUpdate_565375(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsUpdate_565374(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of labs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565376 = path.getOrDefault("name")
  valid_565376 = validateParameter(valid_565376, JString, required = true,
                                 default = nil)
  if valid_565376 != nil:
    section.add "name", valid_565376
  var valid_565377 = path.getOrDefault("subscriptionId")
  valid_565377 = validateParameter(valid_565377, JString, required = true,
                                 default = nil)
  if valid_565377 != nil:
    section.add "subscriptionId", valid_565377
  var valid_565378 = path.getOrDefault("resourceGroupName")
  valid_565378 = validateParameter(valid_565378, JString, required = true,
                                 default = nil)
  if valid_565378 != nil:
    section.add "resourceGroupName", valid_565378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565379 = query.getOrDefault("api-version")
  valid_565379 = validateParameter(valid_565379, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565379 != nil:
    section.add "api-version", valid_565379
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

proc call*(call_565381: Call_LabsUpdate_565373; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of labs.
  ## 
  let valid = call_565381.validator(path, query, header, formData, body)
  let scheme = call_565381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565381.url(scheme.get, call_565381.host, call_565381.base,
                         call_565381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565381, url, valid)

proc call*(call_565382: Call_LabsUpdate_565373; lab: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsUpdate
  ## Modify properties of labs.
  ##   lab: JObject (required)
  ##      : A lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565383 = newJObject()
  var query_565384 = newJObject()
  var body_565385 = newJObject()
  if lab != nil:
    body_565385 = lab
  add(query_565384, "api-version", newJString(apiVersion))
  add(path_565383, "name", newJString(name))
  add(path_565383, "subscriptionId", newJString(subscriptionId))
  add(path_565383, "resourceGroupName", newJString(resourceGroupName))
  result = call_565382.call(path_565383, query_565384, nil, nil, body_565385)

var labsUpdate* = Call_LabsUpdate_565373(name: "labsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsUpdate_565374,
                                      base: "", url: url_LabsUpdate_565375,
                                      schemes: {Scheme.Https})
type
  Call_LabsDelete_565362 = ref object of OpenApiRestCall_563548
proc url_LabsDelete_565364(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsDelete_565363(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565365 = path.getOrDefault("name")
  valid_565365 = validateParameter(valid_565365, JString, required = true,
                                 default = nil)
  if valid_565365 != nil:
    section.add "name", valid_565365
  var valid_565366 = path.getOrDefault("subscriptionId")
  valid_565366 = validateParameter(valid_565366, JString, required = true,
                                 default = nil)
  if valid_565366 != nil:
    section.add "subscriptionId", valid_565366
  var valid_565367 = path.getOrDefault("resourceGroupName")
  valid_565367 = validateParameter(valid_565367, JString, required = true,
                                 default = nil)
  if valid_565367 != nil:
    section.add "resourceGroupName", valid_565367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565368 = query.getOrDefault("api-version")
  valid_565368 = validateParameter(valid_565368, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565368 != nil:
    section.add "api-version", valid_565368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565369: Call_LabsDelete_565362; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete.
  ## 
  let valid = call_565369.validator(path, query, header, formData, body)
  let scheme = call_565369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565369.url(scheme.get, call_565369.host, call_565369.base,
                         call_565369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565369, url, valid)

proc call*(call_565370: Call_LabsDelete_565362; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## labsDelete
  ## Delete lab. This operation can take a while to complete.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565371 = newJObject()
  var query_565372 = newJObject()
  add(query_565372, "api-version", newJString(apiVersion))
  add(path_565371, "name", newJString(name))
  add(path_565371, "subscriptionId", newJString(subscriptionId))
  add(path_565371, "resourceGroupName", newJString(resourceGroupName))
  result = call_565370.call(path_565371, query_565372, nil, nil, nil)

var labsDelete* = Call_LabsDelete_565362(name: "labsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsDelete_565363,
                                      base: "", url: url_LabsDelete_565364,
                                      schemes: {Scheme.Https})
type
  Call_LabsClaimAnyVm_565386 = ref object of OpenApiRestCall_563548
proc url_LabsClaimAnyVm_565388(protocol: Scheme; host: string; base: string;
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

proc validate_LabsClaimAnyVm_565387(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565389 = path.getOrDefault("name")
  valid_565389 = validateParameter(valid_565389, JString, required = true,
                                 default = nil)
  if valid_565389 != nil:
    section.add "name", valid_565389
  var valid_565390 = path.getOrDefault("subscriptionId")
  valid_565390 = validateParameter(valid_565390, JString, required = true,
                                 default = nil)
  if valid_565390 != nil:
    section.add "subscriptionId", valid_565390
  var valid_565391 = path.getOrDefault("resourceGroupName")
  valid_565391 = validateParameter(valid_565391, JString, required = true,
                                 default = nil)
  if valid_565391 != nil:
    section.add "resourceGroupName", valid_565391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565392 = query.getOrDefault("api-version")
  valid_565392 = validateParameter(valid_565392, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565392 != nil:
    section.add "api-version", valid_565392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565393: Call_LabsClaimAnyVm_565386; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ## 
  let valid = call_565393.validator(path, query, header, formData, body)
  let scheme = call_565393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565393.url(scheme.get, call_565393.host, call_565393.base,
                         call_565393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565393, url, valid)

proc call*(call_565394: Call_LabsClaimAnyVm_565386; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsClaimAnyVm
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565395 = newJObject()
  var query_565396 = newJObject()
  add(query_565396, "api-version", newJString(apiVersion))
  add(path_565395, "name", newJString(name))
  add(path_565395, "subscriptionId", newJString(subscriptionId))
  add(path_565395, "resourceGroupName", newJString(resourceGroupName))
  result = call_565394.call(path_565395, query_565396, nil, nil, nil)

var labsClaimAnyVm* = Call_LabsClaimAnyVm_565386(name: "labsClaimAnyVm",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/claimAnyVm",
    validator: validate_LabsClaimAnyVm_565387, base: "", url: url_LabsClaimAnyVm_565388,
    schemes: {Scheme.Https})
type
  Call_LabsCreateEnvironment_565397 = ref object of OpenApiRestCall_563548
proc url_LabsCreateEnvironment_565399(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateEnvironment_565398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565400 = path.getOrDefault("name")
  valid_565400 = validateParameter(valid_565400, JString, required = true,
                                 default = nil)
  if valid_565400 != nil:
    section.add "name", valid_565400
  var valid_565401 = path.getOrDefault("subscriptionId")
  valid_565401 = validateParameter(valid_565401, JString, required = true,
                                 default = nil)
  if valid_565401 != nil:
    section.add "subscriptionId", valid_565401
  var valid_565402 = path.getOrDefault("resourceGroupName")
  valid_565402 = validateParameter(valid_565402, JString, required = true,
                                 default = nil)
  if valid_565402 != nil:
    section.add "resourceGroupName", valid_565402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565403 = query.getOrDefault("api-version")
  valid_565403 = validateParameter(valid_565403, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565403 != nil:
    section.add "api-version", valid_565403
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

proc call*(call_565405: Call_LabsCreateEnvironment_565397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ## 
  let valid = call_565405.validator(path, query, header, formData, body)
  let scheme = call_565405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565405.url(scheme.get, call_565405.host, call_565405.base,
                         call_565405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565405, url, valid)

proc call*(call_565406: Call_LabsCreateEnvironment_565397; name: string;
          subscriptionId: string; labVirtualMachineCreationParameter: JsonNode;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## labsCreateEnvironment
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   labVirtualMachineCreationParameter: JObject (required)
  ##                                     : Properties for creating a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565407 = newJObject()
  var query_565408 = newJObject()
  var body_565409 = newJObject()
  add(query_565408, "api-version", newJString(apiVersion))
  add(path_565407, "name", newJString(name))
  add(path_565407, "subscriptionId", newJString(subscriptionId))
  if labVirtualMachineCreationParameter != nil:
    body_565409 = labVirtualMachineCreationParameter
  add(path_565407, "resourceGroupName", newJString(resourceGroupName))
  result = call_565406.call(path_565407, query_565408, nil, nil, body_565409)

var labsCreateEnvironment* = Call_LabsCreateEnvironment_565397(
    name: "labsCreateEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment",
    validator: validate_LabsCreateEnvironment_565398, base: "",
    url: url_LabsCreateEnvironment_565399, schemes: {Scheme.Https})
type
  Call_LabsExportResourceUsage_565410 = ref object of OpenApiRestCall_563548
proc url_LabsExportResourceUsage_565412(protocol: Scheme; host: string; base: string;
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

proc validate_LabsExportResourceUsage_565411(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565413 = path.getOrDefault("name")
  valid_565413 = validateParameter(valid_565413, JString, required = true,
                                 default = nil)
  if valid_565413 != nil:
    section.add "name", valid_565413
  var valid_565414 = path.getOrDefault("subscriptionId")
  valid_565414 = validateParameter(valid_565414, JString, required = true,
                                 default = nil)
  if valid_565414 != nil:
    section.add "subscriptionId", valid_565414
  var valid_565415 = path.getOrDefault("resourceGroupName")
  valid_565415 = validateParameter(valid_565415, JString, required = true,
                                 default = nil)
  if valid_565415 != nil:
    section.add "resourceGroupName", valid_565415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565416 = query.getOrDefault("api-version")
  valid_565416 = validateParameter(valid_565416, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565416 != nil:
    section.add "api-version", valid_565416
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

proc call*(call_565418: Call_LabsExportResourceUsage_565410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ## 
  let valid = call_565418.validator(path, query, header, formData, body)
  let scheme = call_565418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565418.url(scheme.get, call_565418.host, call_565418.base,
                         call_565418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565418, url, valid)

proc call*(call_565419: Call_LabsExportResourceUsage_565410; name: string;
          subscriptionId: string; exportResourceUsageParameters: JsonNode;
          resourceGroupName: string; apiVersion: string = "2016-05-15"): Recallable =
  ## labsExportResourceUsage
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   exportResourceUsageParameters: JObject (required)
  ##                                : The parameters of the export operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565420 = newJObject()
  var query_565421 = newJObject()
  var body_565422 = newJObject()
  add(query_565421, "api-version", newJString(apiVersion))
  add(path_565420, "name", newJString(name))
  add(path_565420, "subscriptionId", newJString(subscriptionId))
  if exportResourceUsageParameters != nil:
    body_565422 = exportResourceUsageParameters
  add(path_565420, "resourceGroupName", newJString(resourceGroupName))
  result = call_565419.call(path_565420, query_565421, nil, nil, body_565422)

var labsExportResourceUsage* = Call_LabsExportResourceUsage_565410(
    name: "labsExportResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/exportResourceUsage",
    validator: validate_LabsExportResourceUsage_565411, base: "",
    url: url_LabsExportResourceUsage_565412, schemes: {Scheme.Https})
type
  Call_LabsGenerateUploadUri_565423 = ref object of OpenApiRestCall_563548
proc url_LabsGenerateUploadUri_565425(protocol: Scheme; host: string; base: string;
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

proc validate_LabsGenerateUploadUri_565424(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565426 = path.getOrDefault("name")
  valid_565426 = validateParameter(valid_565426, JString, required = true,
                                 default = nil)
  if valid_565426 != nil:
    section.add "name", valid_565426
  var valid_565427 = path.getOrDefault("subscriptionId")
  valid_565427 = validateParameter(valid_565427, JString, required = true,
                                 default = nil)
  if valid_565427 != nil:
    section.add "subscriptionId", valid_565427
  var valid_565428 = path.getOrDefault("resourceGroupName")
  valid_565428 = validateParameter(valid_565428, JString, required = true,
                                 default = nil)
  if valid_565428 != nil:
    section.add "resourceGroupName", valid_565428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565429 = query.getOrDefault("api-version")
  valid_565429 = validateParameter(valid_565429, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565429 != nil:
    section.add "api-version", valid_565429
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

proc call*(call_565431: Call_LabsGenerateUploadUri_565423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  let valid = call_565431.validator(path, query, header, formData, body)
  let scheme = call_565431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565431.url(scheme.get, call_565431.host, call_565431.base,
                         call_565431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565431, url, valid)

proc call*(call_565432: Call_LabsGenerateUploadUri_565423; name: string;
          subscriptionId: string; resourceGroupName: string;
          generateUploadUriParameter: JsonNode; apiVersion: string = "2016-05-15"): Recallable =
  ## labsGenerateUploadUri
  ## Generate a URI for uploading custom disk images to a Lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   generateUploadUriParameter: JObject (required)
  ##                             : Properties for generating an upload URI.
  var path_565433 = newJObject()
  var query_565434 = newJObject()
  var body_565435 = newJObject()
  add(query_565434, "api-version", newJString(apiVersion))
  add(path_565433, "name", newJString(name))
  add(path_565433, "subscriptionId", newJString(subscriptionId))
  add(path_565433, "resourceGroupName", newJString(resourceGroupName))
  if generateUploadUriParameter != nil:
    body_565435 = generateUploadUriParameter
  result = call_565432.call(path_565433, query_565434, nil, nil, body_565435)

var labsGenerateUploadUri* = Call_LabsGenerateUploadUri_565423(
    name: "labsGenerateUploadUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri",
    validator: validate_LabsGenerateUploadUri_565424, base: "",
    url: url_LabsGenerateUploadUri_565425, schemes: {Scheme.Https})
type
  Call_LabsListVhds_565436 = ref object of OpenApiRestCall_563548
proc url_LabsListVhds_565438(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListVhds_565437(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List disk images available for custom image creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the lab.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565439 = path.getOrDefault("name")
  valid_565439 = validateParameter(valid_565439, JString, required = true,
                                 default = nil)
  if valid_565439 != nil:
    section.add "name", valid_565439
  var valid_565440 = path.getOrDefault("subscriptionId")
  valid_565440 = validateParameter(valid_565440, JString, required = true,
                                 default = nil)
  if valid_565440 != nil:
    section.add "subscriptionId", valid_565440
  var valid_565441 = path.getOrDefault("resourceGroupName")
  valid_565441 = validateParameter(valid_565441, JString, required = true,
                                 default = nil)
  if valid_565441 != nil:
    section.add "resourceGroupName", valid_565441
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565442 = query.getOrDefault("api-version")
  valid_565442 = validateParameter(valid_565442, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565442 != nil:
    section.add "api-version", valid_565442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565443: Call_LabsListVhds_565436; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disk images available for custom image creation.
  ## 
  let valid = call_565443.validator(path, query, header, formData, body)
  let scheme = call_565443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565443.url(scheme.get, call_565443.host, call_565443.base,
                         call_565443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565443, url, valid)

proc call*(call_565444: Call_LabsListVhds_565436; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## labsListVhds
  ## List disk images available for custom image creation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565445 = newJObject()
  var query_565446 = newJObject()
  add(query_565446, "api-version", newJString(apiVersion))
  add(path_565445, "name", newJString(name))
  add(path_565445, "subscriptionId", newJString(subscriptionId))
  add(path_565445, "resourceGroupName", newJString(resourceGroupName))
  result = call_565444.call(path_565445, query_565446, nil, nil, nil)

var labsListVhds* = Call_LabsListVhds_565436(name: "labsListVhds",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds",
    validator: validate_LabsListVhds_565437, base: "", url: url_LabsListVhds_565438,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListByResourceGroup_565447 = ref object of OpenApiRestCall_563548
proc url_GlobalSchedulesListByResourceGroup_565449(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesListByResourceGroup_565448(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565450 = path.getOrDefault("subscriptionId")
  valid_565450 = validateParameter(valid_565450, JString, required = true,
                                 default = nil)
  if valid_565450 != nil:
    section.add "subscriptionId", valid_565450
  var valid_565451 = path.getOrDefault("resourceGroupName")
  valid_565451 = validateParameter(valid_565451, JString, required = true,
                                 default = nil)
  if valid_565451 != nil:
    section.add "resourceGroupName", valid_565451
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation.
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_565452 = query.getOrDefault("$top")
  valid_565452 = validateParameter(valid_565452, JInt, required = false, default = nil)
  if valid_565452 != nil:
    section.add "$top", valid_565452
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565453 = query.getOrDefault("api-version")
  valid_565453 = validateParameter(valid_565453, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565453 != nil:
    section.add "api-version", valid_565453
  var valid_565454 = query.getOrDefault("$expand")
  valid_565454 = validateParameter(valid_565454, JString, required = false,
                                 default = nil)
  if valid_565454 != nil:
    section.add "$expand", valid_565454
  var valid_565455 = query.getOrDefault("$orderby")
  valid_565455 = validateParameter(valid_565455, JString, required = false,
                                 default = nil)
  if valid_565455 != nil:
    section.add "$orderby", valid_565455
  var valid_565456 = query.getOrDefault("$filter")
  valid_565456 = validateParameter(valid_565456, JString, required = false,
                                 default = nil)
  if valid_565456 != nil:
    section.add "$filter", valid_565456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565457: Call_GlobalSchedulesListByResourceGroup_565447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a resource group.
  ## 
  let valid = call_565457.validator(path, query, header, formData, body)
  let scheme = call_565457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565457.url(scheme.get, call_565457.host, call_565457.base,
                         call_565457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565457, url, valid)

proc call*(call_565458: Call_GlobalSchedulesListByResourceGroup_565447;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2016-05-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## globalSchedulesListByResourceGroup
  ## List schedules in a resource group.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_565459 = newJObject()
  var query_565460 = newJObject()
  add(query_565460, "$top", newJInt(Top))
  add(query_565460, "api-version", newJString(apiVersion))
  add(query_565460, "$expand", newJString(Expand))
  add(path_565459, "subscriptionId", newJString(subscriptionId))
  add(query_565460, "$orderby", newJString(Orderby))
  add(path_565459, "resourceGroupName", newJString(resourceGroupName))
  add(query_565460, "$filter", newJString(Filter))
  result = call_565458.call(path_565459, query_565460, nil, nil, nil)

var globalSchedulesListByResourceGroup* = Call_GlobalSchedulesListByResourceGroup_565447(
    name: "globalSchedulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListByResourceGroup_565448, base: "",
    url: url_GlobalSchedulesListByResourceGroup_565449, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesCreateOrUpdate_565473 = ref object of OpenApiRestCall_563548
proc url_GlobalSchedulesCreateOrUpdate_565475(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesCreateOrUpdate_565474(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565476 = path.getOrDefault("name")
  valid_565476 = validateParameter(valid_565476, JString, required = true,
                                 default = nil)
  if valid_565476 != nil:
    section.add "name", valid_565476
  var valid_565477 = path.getOrDefault("subscriptionId")
  valid_565477 = validateParameter(valid_565477, JString, required = true,
                                 default = nil)
  if valid_565477 != nil:
    section.add "subscriptionId", valid_565477
  var valid_565478 = path.getOrDefault("resourceGroupName")
  valid_565478 = validateParameter(valid_565478, JString, required = true,
                                 default = nil)
  if valid_565478 != nil:
    section.add "resourceGroupName", valid_565478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565479 = query.getOrDefault("api-version")
  valid_565479 = validateParameter(valid_565479, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565479 != nil:
    section.add "api-version", valid_565479
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

proc call*(call_565481: Call_GlobalSchedulesCreateOrUpdate_565473; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_565481.validator(path, query, header, formData, body)
  let scheme = call_565481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565481.url(scheme.get, call_565481.host, call_565481.base,
                         call_565481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565481, url, valid)

proc call*(call_565482: Call_GlobalSchedulesCreateOrUpdate_565473; name: string;
          subscriptionId: string; resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesCreateOrUpdate
  ## Create or replace an existing schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_565483 = newJObject()
  var query_565484 = newJObject()
  var body_565485 = newJObject()
  add(query_565484, "api-version", newJString(apiVersion))
  add(path_565483, "name", newJString(name))
  add(path_565483, "subscriptionId", newJString(subscriptionId))
  add(path_565483, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565485 = schedule
  result = call_565482.call(path_565483, query_565484, nil, nil, body_565485)

var globalSchedulesCreateOrUpdate* = Call_GlobalSchedulesCreateOrUpdate_565473(
    name: "globalSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesCreateOrUpdate_565474, base: "",
    url: url_GlobalSchedulesCreateOrUpdate_565475, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesGet_565461 = ref object of OpenApiRestCall_563548
proc url_GlobalSchedulesGet_565463(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesGet_565462(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565464 = path.getOrDefault("name")
  valid_565464 = validateParameter(valid_565464, JString, required = true,
                                 default = nil)
  if valid_565464 != nil:
    section.add "name", valid_565464
  var valid_565465 = path.getOrDefault("subscriptionId")
  valid_565465 = validateParameter(valid_565465, JString, required = true,
                                 default = nil)
  if valid_565465 != nil:
    section.add "subscriptionId", valid_565465
  var valid_565466 = path.getOrDefault("resourceGroupName")
  valid_565466 = validateParameter(valid_565466, JString, required = true,
                                 default = nil)
  if valid_565466 != nil:
    section.add "resourceGroupName", valid_565466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565467 = query.getOrDefault("api-version")
  valid_565467 = validateParameter(valid_565467, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565467 != nil:
    section.add "api-version", valid_565467
  var valid_565468 = query.getOrDefault("$expand")
  valid_565468 = validateParameter(valid_565468, JString, required = false,
                                 default = nil)
  if valid_565468 != nil:
    section.add "$expand", valid_565468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565469: Call_GlobalSchedulesGet_565461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_565469.validator(path, query, header, formData, body)
  let scheme = call_565469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565469.url(scheme.get, call_565469.host, call_565469.base,
                         call_565469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565469, url, valid)

proc call*(call_565470: Call_GlobalSchedulesGet_565461; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"; Expand: string = ""): Recallable =
  ## globalSchedulesGet
  ## Get schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565471 = newJObject()
  var query_565472 = newJObject()
  add(query_565472, "api-version", newJString(apiVersion))
  add(query_565472, "$expand", newJString(Expand))
  add(path_565471, "name", newJString(name))
  add(path_565471, "subscriptionId", newJString(subscriptionId))
  add(path_565471, "resourceGroupName", newJString(resourceGroupName))
  result = call_565470.call(path_565471, query_565472, nil, nil, nil)

var globalSchedulesGet* = Call_GlobalSchedulesGet_565461(
    name: "globalSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesGet_565462, base: "",
    url: url_GlobalSchedulesGet_565463, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesUpdate_565497 = ref object of OpenApiRestCall_563548
proc url_GlobalSchedulesUpdate_565499(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesUpdate_565498(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify properties of schedules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565500 = path.getOrDefault("name")
  valid_565500 = validateParameter(valid_565500, JString, required = true,
                                 default = nil)
  if valid_565500 != nil:
    section.add "name", valid_565500
  var valid_565501 = path.getOrDefault("subscriptionId")
  valid_565501 = validateParameter(valid_565501, JString, required = true,
                                 default = nil)
  if valid_565501 != nil:
    section.add "subscriptionId", valid_565501
  var valid_565502 = path.getOrDefault("resourceGroupName")
  valid_565502 = validateParameter(valid_565502, JString, required = true,
                                 default = nil)
  if valid_565502 != nil:
    section.add "resourceGroupName", valid_565502
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565503 = query.getOrDefault("api-version")
  valid_565503 = validateParameter(valid_565503, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565503 != nil:
    section.add "api-version", valid_565503
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

proc call*(call_565505: Call_GlobalSchedulesUpdate_565497; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modify properties of schedules.
  ## 
  let valid = call_565505.validator(path, query, header, formData, body)
  let scheme = call_565505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565505.url(scheme.get, call_565505.host, call_565505.base,
                         call_565505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565505, url, valid)

proc call*(call_565506: Call_GlobalSchedulesUpdate_565497; name: string;
          subscriptionId: string; resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesUpdate
  ## Modify properties of schedules.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   schedule: JObject (required)
  ##           : A schedule.
  var path_565507 = newJObject()
  var query_565508 = newJObject()
  var body_565509 = newJObject()
  add(query_565508, "api-version", newJString(apiVersion))
  add(path_565507, "name", newJString(name))
  add(path_565507, "subscriptionId", newJString(subscriptionId))
  add(path_565507, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565509 = schedule
  result = call_565506.call(path_565507, query_565508, nil, nil, body_565509)

var globalSchedulesUpdate* = Call_GlobalSchedulesUpdate_565497(
    name: "globalSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesUpdate_565498, base: "",
    url: url_GlobalSchedulesUpdate_565499, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesDelete_565486 = ref object of OpenApiRestCall_563548
proc url_GlobalSchedulesDelete_565488(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesDelete_565487(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schedule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565489 = path.getOrDefault("name")
  valid_565489 = validateParameter(valid_565489, JString, required = true,
                                 default = nil)
  if valid_565489 != nil:
    section.add "name", valid_565489
  var valid_565490 = path.getOrDefault("subscriptionId")
  valid_565490 = validateParameter(valid_565490, JString, required = true,
                                 default = nil)
  if valid_565490 != nil:
    section.add "subscriptionId", valid_565490
  var valid_565491 = path.getOrDefault("resourceGroupName")
  valid_565491 = validateParameter(valid_565491, JString, required = true,
                                 default = nil)
  if valid_565491 != nil:
    section.add "resourceGroupName", valid_565491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565492 = query.getOrDefault("api-version")
  valid_565492 = validateParameter(valid_565492, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565492 != nil:
    section.add "api-version", valid_565492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565493: Call_GlobalSchedulesDelete_565486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_565493.validator(path, query, header, formData, body)
  let scheme = call_565493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565493.url(scheme.get, call_565493.host, call_565493.base,
                         call_565493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565493, url, valid)

proc call*(call_565494: Call_GlobalSchedulesDelete_565486; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesDelete
  ## Delete schedule.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565495 = newJObject()
  var query_565496 = newJObject()
  add(query_565496, "api-version", newJString(apiVersion))
  add(path_565495, "name", newJString(name))
  add(path_565495, "subscriptionId", newJString(subscriptionId))
  add(path_565495, "resourceGroupName", newJString(resourceGroupName))
  result = call_565494.call(path_565495, query_565496, nil, nil, nil)

var globalSchedulesDelete* = Call_GlobalSchedulesDelete_565486(
    name: "globalSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesDelete_565487, base: "",
    url: url_GlobalSchedulesDelete_565488, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesExecute_565510 = ref object of OpenApiRestCall_563548
proc url_GlobalSchedulesExecute_565512(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesExecute_565511(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565513 = path.getOrDefault("name")
  valid_565513 = validateParameter(valid_565513, JString, required = true,
                                 default = nil)
  if valid_565513 != nil:
    section.add "name", valid_565513
  var valid_565514 = path.getOrDefault("subscriptionId")
  valid_565514 = validateParameter(valid_565514, JString, required = true,
                                 default = nil)
  if valid_565514 != nil:
    section.add "subscriptionId", valid_565514
  var valid_565515 = path.getOrDefault("resourceGroupName")
  valid_565515 = validateParameter(valid_565515, JString, required = true,
                                 default = nil)
  if valid_565515 != nil:
    section.add "resourceGroupName", valid_565515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565516 = query.getOrDefault("api-version")
  valid_565516 = validateParameter(valid_565516, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565516 != nil:
    section.add "api-version", valid_565516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565517: Call_GlobalSchedulesExecute_565510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_565517.validator(path, query, header, formData, body)
  let scheme = call_565517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565517.url(scheme.get, call_565517.host, call_565517.base,
                         call_565517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565517, url, valid)

proc call*(call_565518: Call_GlobalSchedulesExecute_565510; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesExecute
  ## Execute a schedule. This operation can take a while to complete.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565519 = newJObject()
  var query_565520 = newJObject()
  add(query_565520, "api-version", newJString(apiVersion))
  add(path_565519, "name", newJString(name))
  add(path_565519, "subscriptionId", newJString(subscriptionId))
  add(path_565519, "resourceGroupName", newJString(resourceGroupName))
  result = call_565518.call(path_565519, query_565520, nil, nil, nil)

var globalSchedulesExecute* = Call_GlobalSchedulesExecute_565510(
    name: "globalSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/execute",
    validator: validate_GlobalSchedulesExecute_565511, base: "",
    url: url_GlobalSchedulesExecute_565512, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesRetarget_565521 = ref object of OpenApiRestCall_563548
proc url_GlobalSchedulesRetarget_565523(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesRetarget_565522(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the schedule.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_565524 = path.getOrDefault("name")
  valid_565524 = validateParameter(valid_565524, JString, required = true,
                                 default = nil)
  if valid_565524 != nil:
    section.add "name", valid_565524
  var valid_565525 = path.getOrDefault("subscriptionId")
  valid_565525 = validateParameter(valid_565525, JString, required = true,
                                 default = nil)
  if valid_565525 != nil:
    section.add "subscriptionId", valid_565525
  var valid_565526 = path.getOrDefault("resourceGroupName")
  valid_565526 = validateParameter(valid_565526, JString, required = true,
                                 default = nil)
  if valid_565526 != nil:
    section.add "resourceGroupName", valid_565526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565527 = query.getOrDefault("api-version")
  valid_565527 = validateParameter(valid_565527, JString, required = true,
                                 default = newJString("2016-05-15"))
  if valid_565527 != nil:
    section.add "api-version", valid_565527
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

proc call*(call_565529: Call_GlobalSchedulesRetarget_565521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ## 
  let valid = call_565529.validator(path, query, header, formData, body)
  let scheme = call_565529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565529.url(scheme.get, call_565529.host, call_565529.base,
                         call_565529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565529, url, valid)

proc call*(call_565530: Call_GlobalSchedulesRetarget_565521;
          retargetScheduleProperties: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2016-05-15"): Recallable =
  ## globalSchedulesRetarget
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   retargetScheduleProperties: JObject (required)
  ##                             : Properties for retargeting a virtual machine schedule.
  ##   name: string (required)
  ##       : The name of the schedule.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565531 = newJObject()
  var query_565532 = newJObject()
  var body_565533 = newJObject()
  add(query_565532, "api-version", newJString(apiVersion))
  if retargetScheduleProperties != nil:
    body_565533 = retargetScheduleProperties
  add(path_565531, "name", newJString(name))
  add(path_565531, "subscriptionId", newJString(subscriptionId))
  add(path_565531, "resourceGroupName", newJString(resourceGroupName))
  result = call_565530.call(path_565531, query_565532, nil, nil, body_565533)

var globalSchedulesRetarget* = Call_GlobalSchedulesRetarget_565521(
    name: "globalSchedulesRetarget", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/retarget",
    validator: validate_GlobalSchedulesRetarget_565522, base: "",
    url: url_GlobalSchedulesRetarget_565523, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
