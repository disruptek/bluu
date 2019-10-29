
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
  Call_ProviderOperationsList_563786 = ref object of OpenApiRestCall_563564
proc url_ProviderOperationsList_563788(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsList_563787(path: JsonNode; query: JsonNode;
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
  var valid_563962 = query.getOrDefault("api-version")
  valid_563962 = validateParameter(valid_563962, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_563962 != nil:
    section.add "api-version", valid_563962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563985: Call_ProviderOperationsList_563786; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Result of the request to list REST API operations
  ## 
  let valid = call_563985.validator(path, query, header, formData, body)
  let scheme = call_563985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563985.url(scheme.get, call_563985.host, call_563985.base,
                         call_563985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563985, url, valid)

proc call*(call_564056: Call_ProviderOperationsList_563786;
          apiVersion: string = "2018-09-15"): Recallable =
  ## providerOperationsList
  ## Result of the request to list REST API operations
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564057 = newJObject()
  add(query_564057, "api-version", newJString(apiVersion))
  result = call_564056.call(nil, query_564057, nil, nil, nil)

var providerOperationsList* = Call_ProviderOperationsList_563786(
    name: "providerOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.DevTestLab/operations",
    validator: validate_ProviderOperationsList_563787, base: "",
    url: url_ProviderOperationsList_563788, schemes: {Scheme.Https})
type
  Call_LabsListBySubscription_564097 = ref object of OpenApiRestCall_563564
proc url_LabsListBySubscription_564099(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListBySubscription_564098(path: JsonNode; query: JsonNode;
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
  var valid_564115 = path.getOrDefault("subscriptionId")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "subscriptionId", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564116 = query.getOrDefault("$top")
  valid_564116 = validateParameter(valid_564116, JInt, required = false, default = nil)
  if valid_564116 != nil:
    section.add "$top", valid_564116
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  var valid_564118 = query.getOrDefault("$expand")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "$expand", valid_564118
  var valid_564119 = query.getOrDefault("$orderby")
  valid_564119 = validateParameter(valid_564119, JString, required = false,
                                 default = nil)
  if valid_564119 != nil:
    section.add "$orderby", valid_564119
  var valid_564120 = query.getOrDefault("$filter")
  valid_564120 = validateParameter(valid_564120, JString, required = false,
                                 default = nil)
  if valid_564120 != nil:
    section.add "$filter", valid_564120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_LabsListBySubscription_564097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a subscription.
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_LabsListBySubscription_564097; subscriptionId: string;
          Top: int = 0; apiVersion: string = "2018-09-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## labsListBySubscription
  ## List labs in a subscription.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  add(query_564124, "$top", newJInt(Top))
  add(query_564124, "api-version", newJString(apiVersion))
  add(query_564124, "$expand", newJString(Expand))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  add(query_564124, "$orderby", newJString(Orderby))
  add(query_564124, "$filter", newJString(Filter))
  result = call_564122.call(path_564123, query_564124, nil, nil, nil)

var labsListBySubscription* = Call_LabsListBySubscription_564097(
    name: "labsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListBySubscription_564098, base: "",
    url: url_LabsListBySubscription_564099, schemes: {Scheme.Https})
type
  Call_OperationsGet_564125 = ref object of OpenApiRestCall_563564
proc url_OperationsGet_564127(protocol: Scheme; host: string; base: string;
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

proc validate_OperationsGet_564126(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564128 = path.getOrDefault("locationName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "locationName", valid_564128
  var valid_564129 = path.getOrDefault("name")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "name", valid_564129
  var valid_564130 = path.getOrDefault("subscriptionId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "subscriptionId", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_OperationsGet_564125; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get operation.
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_OperationsGet_564125; locationName: string;
          name: string; subscriptionId: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  add(query_564135, "api-version", newJString(apiVersion))
  add(path_564134, "locationName", newJString(locationName))
  add(path_564134, "name", newJString(name))
  add(path_564134, "subscriptionId", newJString(subscriptionId))
  result = call_564133.call(path_564134, query_564135, nil, nil, nil)

var operationsGet* = Call_OperationsGet_564125(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/locations/{locationName}/operations/{name}",
    validator: validate_OperationsGet_564126, base: "", url: url_OperationsGet_564127,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListBySubscription_564136 = ref object of OpenApiRestCall_563564
proc url_GlobalSchedulesListBySubscription_564138(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesListBySubscription_564137(path: JsonNode;
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
  var valid_564139 = path.getOrDefault("subscriptionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "subscriptionId", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564140 = query.getOrDefault("$top")
  valid_564140 = validateParameter(valid_564140, JInt, required = false, default = nil)
  if valid_564140 != nil:
    section.add "$top", valid_564140
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564141 = query.getOrDefault("api-version")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564141 != nil:
    section.add "api-version", valid_564141
  var valid_564142 = query.getOrDefault("$expand")
  valid_564142 = validateParameter(valid_564142, JString, required = false,
                                 default = nil)
  if valid_564142 != nil:
    section.add "$expand", valid_564142
  var valid_564143 = query.getOrDefault("$orderby")
  valid_564143 = validateParameter(valid_564143, JString, required = false,
                                 default = nil)
  if valid_564143 != nil:
    section.add "$orderby", valid_564143
  var valid_564144 = query.getOrDefault("$filter")
  valid_564144 = validateParameter(valid_564144, JString, required = false,
                                 default = nil)
  if valid_564144 != nil:
    section.add "$filter", valid_564144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_GlobalSchedulesListBySubscription_564136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a subscription.
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_GlobalSchedulesListBySubscription_564136;
          subscriptionId: string; Top: int = 0; apiVersion: string = "2018-09-15";
          Expand: string = ""; Orderby: string = ""; Filter: string = ""): Recallable =
  ## globalSchedulesListBySubscription
  ## List schedules in a subscription.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  add(query_564148, "$top", newJInt(Top))
  add(query_564148, "api-version", newJString(apiVersion))
  add(query_564148, "$expand", newJString(Expand))
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  add(query_564148, "$orderby", newJString(Orderby))
  add(query_564148, "$filter", newJString(Filter))
  result = call_564146.call(path_564147, query_564148, nil, nil, nil)

var globalSchedulesListBySubscription* = Call_GlobalSchedulesListBySubscription_564136(
    name: "globalSchedulesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListBySubscription_564137, base: "",
    url: url_GlobalSchedulesListBySubscription_564138, schemes: {Scheme.Https})
type
  Call_LabsListByResourceGroup_564149 = ref object of OpenApiRestCall_563564
proc url_LabsListByResourceGroup_564151(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListByResourceGroup_564150(path: JsonNode; query: JsonNode;
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
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("resourceGroupName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "resourceGroupName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564154 = query.getOrDefault("$top")
  valid_564154 = validateParameter(valid_564154, JInt, required = false, default = nil)
  if valid_564154 != nil:
    section.add "$top", valid_564154
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  var valid_564156 = query.getOrDefault("$expand")
  valid_564156 = validateParameter(valid_564156, JString, required = false,
                                 default = nil)
  if valid_564156 != nil:
    section.add "$expand", valid_564156
  var valid_564157 = query.getOrDefault("$orderby")
  valid_564157 = validateParameter(valid_564157, JString, required = false,
                                 default = nil)
  if valid_564157 != nil:
    section.add "$orderby", valid_564157
  var valid_564158 = query.getOrDefault("$filter")
  valid_564158 = validateParameter(valid_564158, JString, required = false,
                                 default = nil)
  if valid_564158 != nil:
    section.add "$filter", valid_564158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564159: Call_LabsListByResourceGroup_564149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List labs in a resource group.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_LabsListByResourceGroup_564149;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## labsListByResourceGroup
  ## List labs in a resource group.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564161 = newJObject()
  var query_564162 = newJObject()
  add(query_564162, "$top", newJInt(Top))
  add(query_564162, "api-version", newJString(apiVersion))
  add(query_564162, "$expand", newJString(Expand))
  add(path_564161, "subscriptionId", newJString(subscriptionId))
  add(query_564162, "$orderby", newJString(Orderby))
  add(path_564161, "resourceGroupName", newJString(resourceGroupName))
  add(query_564162, "$filter", newJString(Filter))
  result = call_564160.call(path_564161, query_564162, nil, nil, nil)

var labsListByResourceGroup* = Call_LabsListByResourceGroup_564149(
    name: "labsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs",
    validator: validate_LabsListByResourceGroup_564150, base: "",
    url: url_LabsListByResourceGroup_564151, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesList_564163 = ref object of OpenApiRestCall_563564
proc url_ArtifactSourcesList_564165(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesList_564164(path: JsonNode; query: JsonNode;
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
  var valid_564166 = path.getOrDefault("labName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "labName", valid_564166
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("resourceGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceGroupName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564169 = query.getOrDefault("$top")
  valid_564169 = validateParameter(valid_564169, JInt, required = false, default = nil)
  if valid_564169 != nil:
    section.add "$top", valid_564169
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = newJString("2018-09-15"))
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

proc call*(call_564174: Call_ArtifactSourcesList_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifact sources in a given lab.
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_ArtifactSourcesList_564163; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## artifactSourcesList
  ## List artifact sources in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
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
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var artifactSourcesList* = Call_ArtifactSourcesList_564163(
    name: "artifactSourcesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources",
    validator: validate_ArtifactSourcesList_564164, base: "",
    url: url_ArtifactSourcesList_564165, schemes: {Scheme.Https})
type
  Call_ArmTemplatesList_564178 = ref object of OpenApiRestCall_563564
proc url_ArmTemplatesList_564180(protocol: Scheme; host: string; base: string;
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

proc validate_ArmTemplatesList_564179(path: JsonNode; query: JsonNode;
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
  var valid_564181 = path.getOrDefault("labName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "labName", valid_564181
  var valid_564182 = path.getOrDefault("subscriptionId")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "subscriptionId", valid_564182
  var valid_564183 = path.getOrDefault("resourceGroupName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "resourceGroupName", valid_564183
  var valid_564184 = path.getOrDefault("artifactSourceName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "artifactSourceName", valid_564184
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564185 = query.getOrDefault("$top")
  valid_564185 = validateParameter(valid_564185, JInt, required = false, default = nil)
  if valid_564185 != nil:
    section.add "$top", valid_564185
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  var valid_564187 = query.getOrDefault("$expand")
  valid_564187 = validateParameter(valid_564187, JString, required = false,
                                 default = nil)
  if valid_564187 != nil:
    section.add "$expand", valid_564187
  var valid_564188 = query.getOrDefault("$orderby")
  valid_564188 = validateParameter(valid_564188, JString, required = false,
                                 default = nil)
  if valid_564188 != nil:
    section.add "$orderby", valid_564188
  var valid_564189 = query.getOrDefault("$filter")
  valid_564189 = validateParameter(valid_564189, JString, required = false,
                                 default = nil)
  if valid_564189 != nil:
    section.add "$filter", valid_564189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564190: Call_ArmTemplatesList_564178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List azure resource manager templates in a given artifact source.
  ## 
  let valid = call_564190.validator(path, query, header, formData, body)
  let scheme = call_564190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564190.url(scheme.get, call_564190.host, call_564190.base,
                         call_564190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564190, url, valid)

proc call*(call_564191: Call_ArmTemplatesList_564178; labName: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; Top: int = 0; apiVersion: string = "2018-09-15";
          Expand: string = ""; Orderby: string = ""; Filter: string = ""): Recallable =
  ## armTemplatesList
  ## List azure resource manager templates in a given artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=displayName)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564192 = newJObject()
  var query_564193 = newJObject()
  add(path_564192, "labName", newJString(labName))
  add(query_564193, "$top", newJInt(Top))
  add(query_564193, "api-version", newJString(apiVersion))
  add(query_564193, "$expand", newJString(Expand))
  add(path_564192, "subscriptionId", newJString(subscriptionId))
  add(query_564193, "$orderby", newJString(Orderby))
  add(path_564192, "resourceGroupName", newJString(resourceGroupName))
  add(query_564193, "$filter", newJString(Filter))
  add(path_564192, "artifactSourceName", newJString(artifactSourceName))
  result = call_564191.call(path_564192, query_564193, nil, nil, nil)

var armTemplatesList* = Call_ArmTemplatesList_564178(name: "armTemplatesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates",
    validator: validate_ArmTemplatesList_564179, base: "",
    url: url_ArmTemplatesList_564180, schemes: {Scheme.Https})
type
  Call_ArmTemplatesGet_564194 = ref object of OpenApiRestCall_563564
proc url_ArmTemplatesGet_564196(protocol: Scheme; host: string; base: string;
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

proc validate_ArmTemplatesGet_564195(path: JsonNode; query: JsonNode;
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
  ##       : The name of the azure resource manager template.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: JString (required)
  ##                     : The name of the artifact source.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564197 = path.getOrDefault("labName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "labName", valid_564197
  var valid_564198 = path.getOrDefault("name")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "name", valid_564198
  var valid_564199 = path.getOrDefault("subscriptionId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "subscriptionId", valid_564199
  var valid_564200 = path.getOrDefault("resourceGroupName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "resourceGroupName", valid_564200
  var valid_564201 = path.getOrDefault("artifactSourceName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "artifactSourceName", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  var valid_564203 = query.getOrDefault("$expand")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "$expand", valid_564203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_ArmTemplatesGet_564194; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get azure resource manager template.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_ArmTemplatesGet_564194; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; apiVersion: string = "2018-09-15";
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
  ##       : The name of the azure resource manager template.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(path_564206, "labName", newJString(labName))
  add(query_564207, "api-version", newJString(apiVersion))
  add(query_564207, "$expand", newJString(Expand))
  add(path_564206, "name", newJString(name))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(path_564206, "resourceGroupName", newJString(resourceGroupName))
  add(path_564206, "artifactSourceName", newJString(artifactSourceName))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var armTemplatesGet* = Call_ArmTemplatesGet_564194(name: "armTemplatesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/armtemplates/{name}",
    validator: validate_ArmTemplatesGet_564195, base: "", url: url_ArmTemplatesGet_564196,
    schemes: {Scheme.Https})
type
  Call_ArtifactsList_564208 = ref object of OpenApiRestCall_563564
proc url_ArtifactsList_564210(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsList_564209(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564211 = path.getOrDefault("labName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "labName", valid_564211
  var valid_564212 = path.getOrDefault("subscriptionId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "subscriptionId", valid_564212
  var valid_564213 = path.getOrDefault("resourceGroupName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "resourceGroupName", valid_564213
  var valid_564214 = path.getOrDefault("artifactSourceName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "artifactSourceName", valid_564214
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564215 = query.getOrDefault("$top")
  valid_564215 = validateParameter(valid_564215, JInt, required = false, default = nil)
  if valid_564215 != nil:
    section.add "$top", valid_564215
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564216 != nil:
    section.add "api-version", valid_564216
  var valid_564217 = query.getOrDefault("$expand")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "$expand", valid_564217
  var valid_564218 = query.getOrDefault("$orderby")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = nil)
  if valid_564218 != nil:
    section.add "$orderby", valid_564218
  var valid_564219 = query.getOrDefault("$filter")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "$filter", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_ArtifactsList_564208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts in a given artifact source.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_ArtifactsList_564208; labName: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; Top: int = 0; apiVersion: string = "2018-09-15";
          Expand: string = ""; Orderby: string = ""; Filter: string = ""): Recallable =
  ## artifactsList
  ## List artifacts in a given artifact source.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=title)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  ##   artifactSourceName: string (required)
  ##                     : The name of the artifact source.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(path_564222, "labName", newJString(labName))
  add(query_564223, "$top", newJInt(Top))
  add(query_564223, "api-version", newJString(apiVersion))
  add(query_564223, "$expand", newJString(Expand))
  add(path_564222, "subscriptionId", newJString(subscriptionId))
  add(query_564223, "$orderby", newJString(Orderby))
  add(path_564222, "resourceGroupName", newJString(resourceGroupName))
  add(query_564223, "$filter", newJString(Filter))
  add(path_564222, "artifactSourceName", newJString(artifactSourceName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_564208(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts",
    validator: validate_ArtifactsList_564209, base: "", url: url_ArtifactsList_564210,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGet_564224 = ref object of OpenApiRestCall_563564
proc url_ArtifactsGet_564226(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsGet_564225(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564227 = path.getOrDefault("labName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "labName", valid_564227
  var valid_564228 = path.getOrDefault("name")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "name", valid_564228
  var valid_564229 = path.getOrDefault("subscriptionId")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "subscriptionId", valid_564229
  var valid_564230 = path.getOrDefault("resourceGroupName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "resourceGroupName", valid_564230
  var valid_564231 = path.getOrDefault("artifactSourceName")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "artifactSourceName", valid_564231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=title)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564232 = query.getOrDefault("api-version")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564232 != nil:
    section.add "api-version", valid_564232
  var valid_564233 = query.getOrDefault("$expand")
  valid_564233 = validateParameter(valid_564233, JString, required = false,
                                 default = nil)
  if valid_564233 != nil:
    section.add "$expand", valid_564233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_ArtifactsGet_564224; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact.
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_ArtifactsGet_564224; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; apiVersion: string = "2018-09-15";
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
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(path_564236, "labName", newJString(labName))
  add(query_564237, "api-version", newJString(apiVersion))
  add(query_564237, "$expand", newJString(Expand))
  add(path_564236, "name", newJString(name))
  add(path_564236, "subscriptionId", newJString(subscriptionId))
  add(path_564236, "resourceGroupName", newJString(resourceGroupName))
  add(path_564236, "artifactSourceName", newJString(artifactSourceName))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_564224(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}",
    validator: validate_ArtifactsGet_564225, base: "", url: url_ArtifactsGet_564226,
    schemes: {Scheme.Https})
type
  Call_ArtifactsGenerateArmTemplate_564238 = ref object of OpenApiRestCall_563564
proc url_ArtifactsGenerateArmTemplate_564240(protocol: Scheme; host: string;
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

proc validate_ArtifactsGenerateArmTemplate_564239(path: JsonNode; query: JsonNode;
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
  var valid_564241 = path.getOrDefault("labName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "labName", valid_564241
  var valid_564242 = path.getOrDefault("name")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "name", valid_564242
  var valid_564243 = path.getOrDefault("subscriptionId")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "subscriptionId", valid_564243
  var valid_564244 = path.getOrDefault("resourceGroupName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "resourceGroupName", valid_564244
  var valid_564245 = path.getOrDefault("artifactSourceName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "artifactSourceName", valid_564245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564246 = query.getOrDefault("api-version")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564246 != nil:
    section.add "api-version", valid_564246
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

proc call*(call_564248: Call_ArtifactsGenerateArmTemplate_564238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates an ARM template for the given artifact, uploads the required files to a storage account, and validates the generated artifact.
  ## 
  let valid = call_564248.validator(path, query, header, formData, body)
  let scheme = call_564248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564248.url(scheme.get, call_564248.host, call_564248.base,
                         call_564248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564248, url, valid)

proc call*(call_564249: Call_ArtifactsGenerateArmTemplate_564238; labName: string;
          generateArmTemplateRequest: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          artifactSourceName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564250 = newJObject()
  var query_564251 = newJObject()
  var body_564252 = newJObject()
  add(path_564250, "labName", newJString(labName))
  add(query_564251, "api-version", newJString(apiVersion))
  if generateArmTemplateRequest != nil:
    body_564252 = generateArmTemplateRequest
  add(path_564250, "name", newJString(name))
  add(path_564250, "subscriptionId", newJString(subscriptionId))
  add(path_564250, "resourceGroupName", newJString(resourceGroupName))
  add(path_564250, "artifactSourceName", newJString(artifactSourceName))
  result = call_564249.call(path_564250, query_564251, nil, nil, body_564252)

var artifactsGenerateArmTemplate* = Call_ArtifactsGenerateArmTemplate_564238(
    name: "artifactsGenerateArmTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{artifactSourceName}/artifacts/{name}/generateArmTemplate",
    validator: validate_ArtifactsGenerateArmTemplate_564239, base: "",
    url: url_ArtifactsGenerateArmTemplate_564240, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesCreateOrUpdate_564266 = ref object of OpenApiRestCall_563564
proc url_ArtifactSourcesCreateOrUpdate_564268(protocol: Scheme; host: string;
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

proc validate_ArtifactSourcesCreateOrUpdate_564267(path: JsonNode; query: JsonNode;
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
  var valid_564269 = path.getOrDefault("labName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "labName", valid_564269
  var valid_564270 = path.getOrDefault("name")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "name", valid_564270
  var valid_564271 = path.getOrDefault("subscriptionId")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "subscriptionId", valid_564271
  var valid_564272 = path.getOrDefault("resourceGroupName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "resourceGroupName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564273 != nil:
    section.add "api-version", valid_564273
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

proc call*(call_564275: Call_ArtifactSourcesCreateOrUpdate_564266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing artifact source.
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_ArtifactSourcesCreateOrUpdate_564266; labName: string;
          name: string; subscriptionId: string; artifactSource: JsonNode;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  var body_564279 = newJObject()
  add(path_564277, "labName", newJString(labName))
  add(query_564278, "api-version", newJString(apiVersion))
  add(path_564277, "name", newJString(name))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  if artifactSource != nil:
    body_564279 = artifactSource
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  result = call_564276.call(path_564277, query_564278, nil, nil, body_564279)

var artifactSourcesCreateOrUpdate* = Call_ArtifactSourcesCreateOrUpdate_564266(
    name: "artifactSourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesCreateOrUpdate_564267, base: "",
    url: url_ArtifactSourcesCreateOrUpdate_564268, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesGet_564253 = ref object of OpenApiRestCall_563564
proc url_ArtifactSourcesGet_564255(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesGet_564254(path: JsonNode; query: JsonNode;
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
  var valid_564256 = path.getOrDefault("labName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "labName", valid_564256
  var valid_564257 = path.getOrDefault("name")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "name", valid_564257
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=displayName)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564260 = query.getOrDefault("api-version")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564260 != nil:
    section.add "api-version", valid_564260
  var valid_564261 = query.getOrDefault("$expand")
  valid_564261 = validateParameter(valid_564261, JString, required = false,
                                 default = nil)
  if valid_564261 != nil:
    section.add "$expand", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_ArtifactSourcesGet_564253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get artifact source.
  ## 
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_ArtifactSourcesGet_564253; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  add(path_564264, "labName", newJString(labName))
  add(query_564265, "api-version", newJString(apiVersion))
  add(query_564265, "$expand", newJString(Expand))
  add(path_564264, "name", newJString(name))
  add(path_564264, "subscriptionId", newJString(subscriptionId))
  add(path_564264, "resourceGroupName", newJString(resourceGroupName))
  result = call_564263.call(path_564264, query_564265, nil, nil, nil)

var artifactSourcesGet* = Call_ArtifactSourcesGet_564253(
    name: "artifactSourcesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesGet_564254, base: "",
    url: url_ArtifactSourcesGet_564255, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesUpdate_564292 = ref object of OpenApiRestCall_563564
proc url_ArtifactSourcesUpdate_564294(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesUpdate_564293(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of artifact sources. All other properties will be ignored.
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
  var valid_564295 = path.getOrDefault("labName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "labName", valid_564295
  var valid_564296 = path.getOrDefault("name")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "name", valid_564296
  var valid_564297 = path.getOrDefault("subscriptionId")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "subscriptionId", valid_564297
  var valid_564298 = path.getOrDefault("resourceGroupName")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "resourceGroupName", valid_564298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564299 = query.getOrDefault("api-version")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564299 != nil:
    section.add "api-version", valid_564299
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

proc call*(call_564301: Call_ArtifactSourcesUpdate_564292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of artifact sources. All other properties will be ignored.
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_ArtifactSourcesUpdate_564292; labName: string;
          name: string; subscriptionId: string; artifactSource: JsonNode;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## artifactSourcesUpdate
  ## Allows modifying tags of artifact sources. All other properties will be ignored.
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
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  var body_564305 = newJObject()
  add(path_564303, "labName", newJString(labName))
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "name", newJString(name))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  if artifactSource != nil:
    body_564305 = artifactSource
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  result = call_564302.call(path_564303, query_564304, nil, nil, body_564305)

var artifactSourcesUpdate* = Call_ArtifactSourcesUpdate_564292(
    name: "artifactSourcesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesUpdate_564293, base: "",
    url: url_ArtifactSourcesUpdate_564294, schemes: {Scheme.Https})
type
  Call_ArtifactSourcesDelete_564280 = ref object of OpenApiRestCall_563564
proc url_ArtifactSourcesDelete_564282(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactSourcesDelete_564281(path: JsonNode; query: JsonNode;
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
  var valid_564283 = path.getOrDefault("labName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "labName", valid_564283
  var valid_564284 = path.getOrDefault("name")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "name", valid_564284
  var valid_564285 = path.getOrDefault("subscriptionId")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "subscriptionId", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_ArtifactSourcesDelete_564280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete artifact source.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_ArtifactSourcesDelete_564280; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(path_564290, "labName", newJString(labName))
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "name", newJString(name))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var artifactSourcesDelete* = Call_ArtifactSourcesDelete_564280(
    name: "artifactSourcesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/artifactsources/{name}",
    validator: validate_ArtifactSourcesDelete_564281, base: "",
    url: url_ArtifactSourcesDelete_564282, schemes: {Scheme.Https})
type
  Call_CostsCreateOrUpdate_564319 = ref object of OpenApiRestCall_563564
proc url_CostsCreateOrUpdate_564321(protocol: Scheme; host: string; base: string;
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

proc validate_CostsCreateOrUpdate_564320(path: JsonNode; query: JsonNode;
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
  var valid_564322 = path.getOrDefault("labName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "labName", valid_564322
  var valid_564323 = path.getOrDefault("name")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "name", valid_564323
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("resourceGroupName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "resourceGroupName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564326 != nil:
    section.add "api-version", valid_564326
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

proc call*(call_564328: Call_CostsCreateOrUpdate_564319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing cost.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_CostsCreateOrUpdate_564319; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          labCost: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  var body_564332 = newJObject()
  add(path_564330, "labName", newJString(labName))
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "name", newJString(name))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  if labCost != nil:
    body_564332 = labCost
  result = call_564329.call(path_564330, query_564331, nil, nil, body_564332)

var costsCreateOrUpdate* = Call_CostsCreateOrUpdate_564319(
    name: "costsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
    validator: validate_CostsCreateOrUpdate_564320, base: "",
    url: url_CostsCreateOrUpdate_564321, schemes: {Scheme.Https})
type
  Call_CostsGet_564306 = ref object of OpenApiRestCall_563564
proc url_CostsGet_564308(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CostsGet_564307(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564309 = path.getOrDefault("labName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "labName", valid_564309
  var valid_564310 = path.getOrDefault("name")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "name", valid_564310
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=labCostDetails)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  var valid_564314 = query.getOrDefault("$expand")
  valid_564314 = validateParameter(valid_564314, JString, required = false,
                                 default = nil)
  if valid_564314 != nil:
    section.add "$expand", valid_564314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_CostsGet_564306; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cost.
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_CostsGet_564306; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  add(path_564317, "labName", newJString(labName))
  add(query_564318, "api-version", newJString(apiVersion))
  add(query_564318, "$expand", newJString(Expand))
  add(path_564317, "name", newJString(name))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  add(path_564317, "resourceGroupName", newJString(resourceGroupName))
  result = call_564316.call(path_564317, query_564318, nil, nil, nil)

var costsGet* = Call_CostsGet_564306(name: "costsGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/costs/{name}",
                                  validator: validate_CostsGet_564307, base: "",
                                  url: url_CostsGet_564308,
                                  schemes: {Scheme.Https})
type
  Call_CustomImagesList_564333 = ref object of OpenApiRestCall_563564
proc url_CustomImagesList_564335(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesList_564334(path: JsonNode; query: JsonNode;
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
  var valid_564336 = path.getOrDefault("labName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "labName", valid_564336
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
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564339 = query.getOrDefault("$top")
  valid_564339 = validateParameter(valid_564339, JInt, required = false, default = nil)
  if valid_564339 != nil:
    section.add "$top", valid_564339
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564340 != nil:
    section.add "api-version", valid_564340
  var valid_564341 = query.getOrDefault("$expand")
  valid_564341 = validateParameter(valid_564341, JString, required = false,
                                 default = nil)
  if valid_564341 != nil:
    section.add "$expand", valid_564341
  var valid_564342 = query.getOrDefault("$orderby")
  valid_564342 = validateParameter(valid_564342, JString, required = false,
                                 default = nil)
  if valid_564342 != nil:
    section.add "$orderby", valid_564342
  var valid_564343 = query.getOrDefault("$filter")
  valid_564343 = validateParameter(valid_564343, JString, required = false,
                                 default = nil)
  if valid_564343 != nil:
    section.add "$filter", valid_564343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564344: Call_CustomImagesList_564333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List custom images in a given lab.
  ## 
  let valid = call_564344.validator(path, query, header, formData, body)
  let scheme = call_564344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564344.url(scheme.get, call_564344.host, call_564344.base,
                         call_564344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564344, url, valid)

proc call*(call_564345: Call_CustomImagesList_564333; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## customImagesList
  ## List custom images in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=vm)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564346 = newJObject()
  var query_564347 = newJObject()
  add(path_564346, "labName", newJString(labName))
  add(query_564347, "$top", newJInt(Top))
  add(query_564347, "api-version", newJString(apiVersion))
  add(query_564347, "$expand", newJString(Expand))
  add(path_564346, "subscriptionId", newJString(subscriptionId))
  add(query_564347, "$orderby", newJString(Orderby))
  add(path_564346, "resourceGroupName", newJString(resourceGroupName))
  add(query_564347, "$filter", newJString(Filter))
  result = call_564345.call(path_564346, query_564347, nil, nil, nil)

var customImagesList* = Call_CustomImagesList_564333(name: "customImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages",
    validator: validate_CustomImagesList_564334, base: "",
    url: url_CustomImagesList_564335, schemes: {Scheme.Https})
type
  Call_CustomImagesCreateOrUpdate_564361 = ref object of OpenApiRestCall_563564
proc url_CustomImagesCreateOrUpdate_564363(protocol: Scheme; host: string;
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

proc validate_CustomImagesCreateOrUpdate_564362(path: JsonNode; query: JsonNode;
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
  var valid_564364 = path.getOrDefault("labName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "labName", valid_564364
  var valid_564365 = path.getOrDefault("name")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "name", valid_564365
  var valid_564366 = path.getOrDefault("subscriptionId")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "subscriptionId", valid_564366
  var valid_564367 = path.getOrDefault("resourceGroupName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "resourceGroupName", valid_564367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564368 = query.getOrDefault("api-version")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564368 != nil:
    section.add "api-version", valid_564368
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

proc call*(call_564370: Call_CustomImagesCreateOrUpdate_564361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing custom image. This operation can take a while to complete.
  ## 
  let valid = call_564370.validator(path, query, header, formData, body)
  let scheme = call_564370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564370.url(scheme.get, call_564370.host, call_564370.base,
                         call_564370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564370, url, valid)

proc call*(call_564371: Call_CustomImagesCreateOrUpdate_564361; labName: string;
          customImage: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564372 = newJObject()
  var query_564373 = newJObject()
  var body_564374 = newJObject()
  add(path_564372, "labName", newJString(labName))
  if customImage != nil:
    body_564374 = customImage
  add(query_564373, "api-version", newJString(apiVersion))
  add(path_564372, "name", newJString(name))
  add(path_564372, "subscriptionId", newJString(subscriptionId))
  add(path_564372, "resourceGroupName", newJString(resourceGroupName))
  result = call_564371.call(path_564372, query_564373, nil, nil, body_564374)

var customImagesCreateOrUpdate* = Call_CustomImagesCreateOrUpdate_564361(
    name: "customImagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesCreateOrUpdate_564362, base: "",
    url: url_CustomImagesCreateOrUpdate_564363, schemes: {Scheme.Https})
type
  Call_CustomImagesGet_564348 = ref object of OpenApiRestCall_563564
proc url_CustomImagesGet_564350(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesGet_564349(path: JsonNode; query: JsonNode;
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
  var valid_564351 = path.getOrDefault("labName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "labName", valid_564351
  var valid_564352 = path.getOrDefault("name")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "name", valid_564352
  var valid_564353 = path.getOrDefault("subscriptionId")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "subscriptionId", valid_564353
  var valid_564354 = path.getOrDefault("resourceGroupName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "resourceGroupName", valid_564354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=vm)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564355 = query.getOrDefault("api-version")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564355 != nil:
    section.add "api-version", valid_564355
  var valid_564356 = query.getOrDefault("$expand")
  valid_564356 = validateParameter(valid_564356, JString, required = false,
                                 default = nil)
  if valid_564356 != nil:
    section.add "$expand", valid_564356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564357: Call_CustomImagesGet_564348; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get custom image.
  ## 
  let valid = call_564357.validator(path, query, header, formData, body)
  let scheme = call_564357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564357.url(scheme.get, call_564357.host, call_564357.base,
                         call_564357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564357, url, valid)

proc call*(call_564358: Call_CustomImagesGet_564348; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_564359 = newJObject()
  var query_564360 = newJObject()
  add(path_564359, "labName", newJString(labName))
  add(query_564360, "api-version", newJString(apiVersion))
  add(query_564360, "$expand", newJString(Expand))
  add(path_564359, "name", newJString(name))
  add(path_564359, "subscriptionId", newJString(subscriptionId))
  add(path_564359, "resourceGroupName", newJString(resourceGroupName))
  result = call_564358.call(path_564359, query_564360, nil, nil, nil)

var customImagesGet* = Call_CustomImagesGet_564348(name: "customImagesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesGet_564349, base: "", url: url_CustomImagesGet_564350,
    schemes: {Scheme.Https})
type
  Call_CustomImagesUpdate_564387 = ref object of OpenApiRestCall_563564
proc url_CustomImagesUpdate_564389(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesUpdate_564388(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Allows modifying tags of custom images. All other properties will be ignored.
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
  var valid_564390 = path.getOrDefault("labName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "labName", valid_564390
  var valid_564391 = path.getOrDefault("name")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "name", valid_564391
  var valid_564392 = path.getOrDefault("subscriptionId")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "subscriptionId", valid_564392
  var valid_564393 = path.getOrDefault("resourceGroupName")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "resourceGroupName", valid_564393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564394 = query.getOrDefault("api-version")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564394 != nil:
    section.add "api-version", valid_564394
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

proc call*(call_564396: Call_CustomImagesUpdate_564387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of custom images. All other properties will be ignored.
  ## 
  let valid = call_564396.validator(path, query, header, formData, body)
  let scheme = call_564396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564396.url(scheme.get, call_564396.host, call_564396.base,
                         call_564396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564396, url, valid)

proc call*(call_564397: Call_CustomImagesUpdate_564387; labName: string;
          customImage: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## customImagesUpdate
  ## Allows modifying tags of custom images. All other properties will be ignored.
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
  var path_564398 = newJObject()
  var query_564399 = newJObject()
  var body_564400 = newJObject()
  add(path_564398, "labName", newJString(labName))
  if customImage != nil:
    body_564400 = customImage
  add(query_564399, "api-version", newJString(apiVersion))
  add(path_564398, "name", newJString(name))
  add(path_564398, "subscriptionId", newJString(subscriptionId))
  add(path_564398, "resourceGroupName", newJString(resourceGroupName))
  result = call_564397.call(path_564398, query_564399, nil, nil, body_564400)

var customImagesUpdate* = Call_CustomImagesUpdate_564387(
    name: "customImagesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesUpdate_564388, base: "",
    url: url_CustomImagesUpdate_564389, schemes: {Scheme.Https})
type
  Call_CustomImagesDelete_564375 = ref object of OpenApiRestCall_563564
proc url_CustomImagesDelete_564377(protocol: Scheme; host: string; base: string;
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

proc validate_CustomImagesDelete_564376(path: JsonNode; query: JsonNode;
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
  var valid_564378 = path.getOrDefault("labName")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "labName", valid_564378
  var valid_564379 = path.getOrDefault("name")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "name", valid_564379
  var valid_564380 = path.getOrDefault("subscriptionId")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "subscriptionId", valid_564380
  var valid_564381 = path.getOrDefault("resourceGroupName")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "resourceGroupName", valid_564381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564382 = query.getOrDefault("api-version")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564382 != nil:
    section.add "api-version", valid_564382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564383: Call_CustomImagesDelete_564375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete custom image. This operation can take a while to complete.
  ## 
  let valid = call_564383.validator(path, query, header, formData, body)
  let scheme = call_564383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564383.url(scheme.get, call_564383.host, call_564383.base,
                         call_564383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564383, url, valid)

proc call*(call_564384: Call_CustomImagesDelete_564375; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564385 = newJObject()
  var query_564386 = newJObject()
  add(path_564385, "labName", newJString(labName))
  add(query_564386, "api-version", newJString(apiVersion))
  add(path_564385, "name", newJString(name))
  add(path_564385, "subscriptionId", newJString(subscriptionId))
  add(path_564385, "resourceGroupName", newJString(resourceGroupName))
  result = call_564384.call(path_564385, query_564386, nil, nil, nil)

var customImagesDelete* = Call_CustomImagesDelete_564375(
    name: "customImagesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/customimages/{name}",
    validator: validate_CustomImagesDelete_564376, base: "",
    url: url_CustomImagesDelete_564377, schemes: {Scheme.Https})
type
  Call_FormulasList_564401 = ref object of OpenApiRestCall_563564
proc url_FormulasList_564403(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasList_564402(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564404 = path.getOrDefault("labName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "labName", valid_564404
  var valid_564405 = path.getOrDefault("subscriptionId")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "subscriptionId", valid_564405
  var valid_564406 = path.getOrDefault("resourceGroupName")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "resourceGroupName", valid_564406
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564407 = query.getOrDefault("$top")
  valid_564407 = validateParameter(valid_564407, JInt, required = false, default = nil)
  if valid_564407 != nil:
    section.add "$top", valid_564407
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564408 = query.getOrDefault("api-version")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564408 != nil:
    section.add "api-version", valid_564408
  var valid_564409 = query.getOrDefault("$expand")
  valid_564409 = validateParameter(valid_564409, JString, required = false,
                                 default = nil)
  if valid_564409 != nil:
    section.add "$expand", valid_564409
  var valid_564410 = query.getOrDefault("$orderby")
  valid_564410 = validateParameter(valid_564410, JString, required = false,
                                 default = nil)
  if valid_564410 != nil:
    section.add "$orderby", valid_564410
  var valid_564411 = query.getOrDefault("$filter")
  valid_564411 = validateParameter(valid_564411, JString, required = false,
                                 default = nil)
  if valid_564411 != nil:
    section.add "$filter", valid_564411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564412: Call_FormulasList_564401; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List formulas in a given lab.
  ## 
  let valid = call_564412.validator(path, query, header, formData, body)
  let scheme = call_564412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564412.url(scheme.get, call_564412.host, call_564412.base,
                         call_564412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564412, url, valid)

proc call*(call_564413: Call_FormulasList_564401; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## formulasList
  ## List formulas in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564414 = newJObject()
  var query_564415 = newJObject()
  add(path_564414, "labName", newJString(labName))
  add(query_564415, "$top", newJInt(Top))
  add(query_564415, "api-version", newJString(apiVersion))
  add(query_564415, "$expand", newJString(Expand))
  add(path_564414, "subscriptionId", newJString(subscriptionId))
  add(query_564415, "$orderby", newJString(Orderby))
  add(path_564414, "resourceGroupName", newJString(resourceGroupName))
  add(query_564415, "$filter", newJString(Filter))
  result = call_564413.call(path_564414, query_564415, nil, nil, nil)

var formulasList* = Call_FormulasList_564401(name: "formulasList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas",
    validator: validate_FormulasList_564402, base: "", url: url_FormulasList_564403,
    schemes: {Scheme.Https})
type
  Call_FormulasCreateOrUpdate_564429 = ref object of OpenApiRestCall_563564
proc url_FormulasCreateOrUpdate_564431(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasCreateOrUpdate_564430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing formula. This operation can take a while to complete.
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
  var valid_564432 = path.getOrDefault("labName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "labName", valid_564432
  var valid_564433 = path.getOrDefault("name")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "name", valid_564433
  var valid_564434 = path.getOrDefault("subscriptionId")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "subscriptionId", valid_564434
  var valid_564435 = path.getOrDefault("resourceGroupName")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "resourceGroupName", valid_564435
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564436 = query.getOrDefault("api-version")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564436 != nil:
    section.add "api-version", valid_564436
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

proc call*(call_564438: Call_FormulasCreateOrUpdate_564429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing formula. This operation can take a while to complete.
  ## 
  let valid = call_564438.validator(path, query, header, formData, body)
  let scheme = call_564438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564438.url(scheme.get, call_564438.host, call_564438.base,
                         call_564438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564438, url, valid)

proc call*(call_564439: Call_FormulasCreateOrUpdate_564429; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          formula: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## formulasCreateOrUpdate
  ## Create or replace an existing formula. This operation can take a while to complete.
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
  var path_564440 = newJObject()
  var query_564441 = newJObject()
  var body_564442 = newJObject()
  add(path_564440, "labName", newJString(labName))
  add(query_564441, "api-version", newJString(apiVersion))
  add(path_564440, "name", newJString(name))
  add(path_564440, "subscriptionId", newJString(subscriptionId))
  add(path_564440, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_564442 = formula
  result = call_564439.call(path_564440, query_564441, nil, nil, body_564442)

var formulasCreateOrUpdate* = Call_FormulasCreateOrUpdate_564429(
    name: "formulasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasCreateOrUpdate_564430, base: "",
    url: url_FormulasCreateOrUpdate_564431, schemes: {Scheme.Https})
type
  Call_FormulasGet_564416 = ref object of OpenApiRestCall_563564
proc url_FormulasGet_564418(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasGet_564417(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564419 = path.getOrDefault("labName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "labName", valid_564419
  var valid_564420 = path.getOrDefault("name")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "name", valid_564420
  var valid_564421 = path.getOrDefault("subscriptionId")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "subscriptionId", valid_564421
  var valid_564422 = path.getOrDefault("resourceGroupName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "resourceGroupName", valid_564422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564423 = query.getOrDefault("api-version")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564423 != nil:
    section.add "api-version", valid_564423
  var valid_564424 = query.getOrDefault("$expand")
  valid_564424 = validateParameter(valid_564424, JString, required = false,
                                 default = nil)
  if valid_564424 != nil:
    section.add "$expand", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_FormulasGet_564416; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get formula.
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_FormulasGet_564416; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(path_564427, "labName", newJString(labName))
  add(query_564428, "api-version", newJString(apiVersion))
  add(query_564428, "$expand", newJString(Expand))
  add(path_564427, "name", newJString(name))
  add(path_564427, "subscriptionId", newJString(subscriptionId))
  add(path_564427, "resourceGroupName", newJString(resourceGroupName))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var formulasGet* = Call_FormulasGet_564416(name: "formulasGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
                                        validator: validate_FormulasGet_564417,
                                        base: "", url: url_FormulasGet_564418,
                                        schemes: {Scheme.Https})
type
  Call_FormulasUpdate_564455 = ref object of OpenApiRestCall_563564
proc url_FormulasUpdate_564457(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasUpdate_564456(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Allows modifying tags of formulas. All other properties will be ignored.
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564462 = query.getOrDefault("api-version")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564462 != nil:
    section.add "api-version", valid_564462
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

proc call*(call_564464: Call_FormulasUpdate_564455; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of formulas. All other properties will be ignored.
  ## 
  let valid = call_564464.validator(path, query, header, formData, body)
  let scheme = call_564464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564464.url(scheme.get, call_564464.host, call_564464.base,
                         call_564464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564464, url, valid)

proc call*(call_564465: Call_FormulasUpdate_564455; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; formula: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## formulasUpdate
  ## Allows modifying tags of formulas. All other properties will be ignored.
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
  var path_564466 = newJObject()
  var query_564467 = newJObject()
  var body_564468 = newJObject()
  add(path_564466, "labName", newJString(labName))
  add(query_564467, "api-version", newJString(apiVersion))
  add(path_564466, "name", newJString(name))
  add(path_564466, "subscriptionId", newJString(subscriptionId))
  add(path_564466, "resourceGroupName", newJString(resourceGroupName))
  if formula != nil:
    body_564468 = formula
  result = call_564465.call(path_564466, query_564467, nil, nil, body_564468)

var formulasUpdate* = Call_FormulasUpdate_564455(name: "formulasUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasUpdate_564456, base: "", url: url_FormulasUpdate_564457,
    schemes: {Scheme.Https})
type
  Call_FormulasDelete_564443 = ref object of OpenApiRestCall_563564
proc url_FormulasDelete_564445(protocol: Scheme; host: string; base: string;
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

proc validate_FormulasDelete_564444(path: JsonNode; query: JsonNode;
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
  var valid_564446 = path.getOrDefault("labName")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "labName", valid_564446
  var valid_564447 = path.getOrDefault("name")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "name", valid_564447
  var valid_564448 = path.getOrDefault("subscriptionId")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "subscriptionId", valid_564448
  var valid_564449 = path.getOrDefault("resourceGroupName")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "resourceGroupName", valid_564449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564450 = query.getOrDefault("api-version")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564450 != nil:
    section.add "api-version", valid_564450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564451: Call_FormulasDelete_564443; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete formula.
  ## 
  let valid = call_564451.validator(path, query, header, formData, body)
  let scheme = call_564451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564451.url(scheme.get, call_564451.host, call_564451.base,
                         call_564451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564451, url, valid)

proc call*(call_564452: Call_FormulasDelete_564443; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564453 = newJObject()
  var query_564454 = newJObject()
  add(path_564453, "labName", newJString(labName))
  add(query_564454, "api-version", newJString(apiVersion))
  add(path_564453, "name", newJString(name))
  add(path_564453, "subscriptionId", newJString(subscriptionId))
  add(path_564453, "resourceGroupName", newJString(resourceGroupName))
  result = call_564452.call(path_564453, query_564454, nil, nil, nil)

var formulasDelete* = Call_FormulasDelete_564443(name: "formulasDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/formulas/{name}",
    validator: validate_FormulasDelete_564444, base: "", url: url_FormulasDelete_564445,
    schemes: {Scheme.Https})
type
  Call_GalleryImagesList_564469 = ref object of OpenApiRestCall_563564
proc url_GalleryImagesList_564471(protocol: Scheme; host: string; base: string;
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

proc validate_GalleryImagesList_564470(path: JsonNode; query: JsonNode;
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
  var valid_564472 = path.getOrDefault("labName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "labName", valid_564472
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
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=author)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564475 = query.getOrDefault("$top")
  valid_564475 = validateParameter(valid_564475, JInt, required = false, default = nil)
  if valid_564475 != nil:
    section.add "$top", valid_564475
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564476 = query.getOrDefault("api-version")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564476 != nil:
    section.add "api-version", valid_564476
  var valid_564477 = query.getOrDefault("$expand")
  valid_564477 = validateParameter(valid_564477, JString, required = false,
                                 default = nil)
  if valid_564477 != nil:
    section.add "$expand", valid_564477
  var valid_564478 = query.getOrDefault("$orderby")
  valid_564478 = validateParameter(valid_564478, JString, required = false,
                                 default = nil)
  if valid_564478 != nil:
    section.add "$orderby", valid_564478
  var valid_564479 = query.getOrDefault("$filter")
  valid_564479 = validateParameter(valid_564479, JString, required = false,
                                 default = nil)
  if valid_564479 != nil:
    section.add "$filter", valid_564479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564480: Call_GalleryImagesList_564469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List gallery images in a given lab.
  ## 
  let valid = call_564480.validator(path, query, header, formData, body)
  let scheme = call_564480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564480.url(scheme.get, call_564480.host, call_564480.base,
                         call_564480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564480, url, valid)

proc call*(call_564481: Call_GalleryImagesList_564469; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## galleryImagesList
  ## List gallery images in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=author)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564482 = newJObject()
  var query_564483 = newJObject()
  add(path_564482, "labName", newJString(labName))
  add(query_564483, "$top", newJInt(Top))
  add(query_564483, "api-version", newJString(apiVersion))
  add(query_564483, "$expand", newJString(Expand))
  add(path_564482, "subscriptionId", newJString(subscriptionId))
  add(query_564483, "$orderby", newJString(Orderby))
  add(path_564482, "resourceGroupName", newJString(resourceGroupName))
  add(query_564483, "$filter", newJString(Filter))
  result = call_564481.call(path_564482, query_564483, nil, nil, nil)

var galleryImagesList* = Call_GalleryImagesList_564469(name: "galleryImagesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/galleryimages",
    validator: validate_GalleryImagesList_564470, base: "",
    url: url_GalleryImagesList_564471, schemes: {Scheme.Https})
type
  Call_NotificationChannelsList_564484 = ref object of OpenApiRestCall_563564
proc url_NotificationChannelsList_564486(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsList_564485(path: JsonNode; query: JsonNode;
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
  var valid_564487 = path.getOrDefault("labName")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "labName", valid_564487
  var valid_564488 = path.getOrDefault("subscriptionId")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "subscriptionId", valid_564488
  var valid_564489 = path.getOrDefault("resourceGroupName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "resourceGroupName", valid_564489
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564490 = query.getOrDefault("$top")
  valid_564490 = validateParameter(valid_564490, JInt, required = false, default = nil)
  if valid_564490 != nil:
    section.add "$top", valid_564490
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564491 = query.getOrDefault("api-version")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564491 != nil:
    section.add "api-version", valid_564491
  var valid_564492 = query.getOrDefault("$expand")
  valid_564492 = validateParameter(valid_564492, JString, required = false,
                                 default = nil)
  if valid_564492 != nil:
    section.add "$expand", valid_564492
  var valid_564493 = query.getOrDefault("$orderby")
  valid_564493 = validateParameter(valid_564493, JString, required = false,
                                 default = nil)
  if valid_564493 != nil:
    section.add "$orderby", valid_564493
  var valid_564494 = query.getOrDefault("$filter")
  valid_564494 = validateParameter(valid_564494, JString, required = false,
                                 default = nil)
  if valid_564494 != nil:
    section.add "$filter", valid_564494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564495: Call_NotificationChannelsList_564484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List notification channels in a given lab.
  ## 
  let valid = call_564495.validator(path, query, header, formData, body)
  let scheme = call_564495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564495.url(scheme.get, call_564495.host, call_564495.base,
                         call_564495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564495, url, valid)

proc call*(call_564496: Call_NotificationChannelsList_564484; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## notificationChannelsList
  ## List notification channels in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564497 = newJObject()
  var query_564498 = newJObject()
  add(path_564497, "labName", newJString(labName))
  add(query_564498, "$top", newJInt(Top))
  add(query_564498, "api-version", newJString(apiVersion))
  add(query_564498, "$expand", newJString(Expand))
  add(path_564497, "subscriptionId", newJString(subscriptionId))
  add(query_564498, "$orderby", newJString(Orderby))
  add(path_564497, "resourceGroupName", newJString(resourceGroupName))
  add(query_564498, "$filter", newJString(Filter))
  result = call_564496.call(path_564497, query_564498, nil, nil, nil)

var notificationChannelsList* = Call_NotificationChannelsList_564484(
    name: "notificationChannelsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels",
    validator: validate_NotificationChannelsList_564485, base: "",
    url: url_NotificationChannelsList_564486, schemes: {Scheme.Https})
type
  Call_NotificationChannelsCreateOrUpdate_564512 = ref object of OpenApiRestCall_563564
proc url_NotificationChannelsCreateOrUpdate_564514(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsCreateOrUpdate_564513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564515 = path.getOrDefault("labName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "labName", valid_564515
  var valid_564516 = path.getOrDefault("name")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "name", valid_564516
  var valid_564517 = path.getOrDefault("subscriptionId")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "subscriptionId", valid_564517
  var valid_564518 = path.getOrDefault("resourceGroupName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "resourceGroupName", valid_564518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564519 = query.getOrDefault("api-version")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564519 != nil:
    section.add "api-version", valid_564519
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

proc call*(call_564521: Call_NotificationChannelsCreateOrUpdate_564512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing notification channel.
  ## 
  let valid = call_564521.validator(path, query, header, formData, body)
  let scheme = call_564521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564521.url(scheme.get, call_564521.host, call_564521.base,
                         call_564521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564521, url, valid)

proc call*(call_564522: Call_NotificationChannelsCreateOrUpdate_564512;
          labName: string; notificationChannel: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsCreateOrUpdate
  ## Create or replace an existing notification channel.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564523 = newJObject()
  var query_564524 = newJObject()
  var body_564525 = newJObject()
  add(path_564523, "labName", newJString(labName))
  add(query_564524, "api-version", newJString(apiVersion))
  if notificationChannel != nil:
    body_564525 = notificationChannel
  add(path_564523, "name", newJString(name))
  add(path_564523, "subscriptionId", newJString(subscriptionId))
  add(path_564523, "resourceGroupName", newJString(resourceGroupName))
  result = call_564522.call(path_564523, query_564524, nil, nil, body_564525)

var notificationChannelsCreateOrUpdate* = Call_NotificationChannelsCreateOrUpdate_564512(
    name: "notificationChannelsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsCreateOrUpdate_564513, base: "",
    url: url_NotificationChannelsCreateOrUpdate_564514, schemes: {Scheme.Https})
type
  Call_NotificationChannelsGet_564499 = ref object of OpenApiRestCall_563564
proc url_NotificationChannelsGet_564501(protocol: Scheme; host: string; base: string;
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

proc validate_NotificationChannelsGet_564500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564502 = path.getOrDefault("labName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "labName", valid_564502
  var valid_564503 = path.getOrDefault("name")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "name", valid_564503
  var valid_564504 = path.getOrDefault("subscriptionId")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "subscriptionId", valid_564504
  var valid_564505 = path.getOrDefault("resourceGroupName")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "resourceGroupName", valid_564505
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564506 = query.getOrDefault("api-version")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564506 != nil:
    section.add "api-version", valid_564506
  var valid_564507 = query.getOrDefault("$expand")
  valid_564507 = validateParameter(valid_564507, JString, required = false,
                                 default = nil)
  if valid_564507 != nil:
    section.add "$expand", valid_564507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564508: Call_NotificationChannelsGet_564499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get notification channel.
  ## 
  let valid = call_564508.validator(path, query, header, formData, body)
  let scheme = call_564508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564508.url(scheme.get, call_564508.host, call_564508.base,
                         call_564508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564508, url, valid)

proc call*(call_564509: Call_NotificationChannelsGet_564499; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
  ## notificationChannelsGet
  ## Get notification channel.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=webHookUrl)'
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564510 = newJObject()
  var query_564511 = newJObject()
  add(path_564510, "labName", newJString(labName))
  add(query_564511, "api-version", newJString(apiVersion))
  add(query_564511, "$expand", newJString(Expand))
  add(path_564510, "name", newJString(name))
  add(path_564510, "subscriptionId", newJString(subscriptionId))
  add(path_564510, "resourceGroupName", newJString(resourceGroupName))
  result = call_564509.call(path_564510, query_564511, nil, nil, nil)

var notificationChannelsGet* = Call_NotificationChannelsGet_564499(
    name: "notificationChannelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsGet_564500, base: "",
    url: url_NotificationChannelsGet_564501, schemes: {Scheme.Https})
type
  Call_NotificationChannelsUpdate_564538 = ref object of OpenApiRestCall_563564
proc url_NotificationChannelsUpdate_564540(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsUpdate_564539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of notification channels. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564541 = path.getOrDefault("labName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "labName", valid_564541
  var valid_564542 = path.getOrDefault("name")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "name", valid_564542
  var valid_564543 = path.getOrDefault("subscriptionId")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "subscriptionId", valid_564543
  var valid_564544 = path.getOrDefault("resourceGroupName")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "resourceGroupName", valid_564544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564545 = query.getOrDefault("api-version")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564545 != nil:
    section.add "api-version", valid_564545
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

proc call*(call_564547: Call_NotificationChannelsUpdate_564538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of notification channels. All other properties will be ignored.
  ## 
  let valid = call_564547.validator(path, query, header, formData, body)
  let scheme = call_564547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564547.url(scheme.get, call_564547.host, call_564547.base,
                         call_564547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564547, url, valid)

proc call*(call_564548: Call_NotificationChannelsUpdate_564538; labName: string;
          notificationChannel: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsUpdate
  ## Allows modifying tags of notification channels. All other properties will be ignored.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   notificationChannel: JObject (required)
  ##                      : A notification.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564549 = newJObject()
  var query_564550 = newJObject()
  var body_564551 = newJObject()
  add(path_564549, "labName", newJString(labName))
  add(query_564550, "api-version", newJString(apiVersion))
  if notificationChannel != nil:
    body_564551 = notificationChannel
  add(path_564549, "name", newJString(name))
  add(path_564549, "subscriptionId", newJString(subscriptionId))
  add(path_564549, "resourceGroupName", newJString(resourceGroupName))
  result = call_564548.call(path_564549, query_564550, nil, nil, body_564551)

var notificationChannelsUpdate* = Call_NotificationChannelsUpdate_564538(
    name: "notificationChannelsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsUpdate_564539, base: "",
    url: url_NotificationChannelsUpdate_564540, schemes: {Scheme.Https})
type
  Call_NotificationChannelsDelete_564526 = ref object of OpenApiRestCall_563564
proc url_NotificationChannelsDelete_564528(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsDelete_564527(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete notification channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_564529 = path.getOrDefault("labName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "labName", valid_564529
  var valid_564530 = path.getOrDefault("name")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "name", valid_564530
  var valid_564531 = path.getOrDefault("subscriptionId")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "subscriptionId", valid_564531
  var valid_564532 = path.getOrDefault("resourceGroupName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "resourceGroupName", valid_564532
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564533 = query.getOrDefault("api-version")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564533 != nil:
    section.add "api-version", valid_564533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564534: Call_NotificationChannelsDelete_564526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete notification channel.
  ## 
  let valid = call_564534.validator(path, query, header, formData, body)
  let scheme = call_564534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564534.url(scheme.get, call_564534.host, call_564534.base,
                         call_564534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564534, url, valid)

proc call*(call_564535: Call_NotificationChannelsDelete_564526; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsDelete
  ## Delete notification channel.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564536 = newJObject()
  var query_564537 = newJObject()
  add(path_564536, "labName", newJString(labName))
  add(query_564537, "api-version", newJString(apiVersion))
  add(path_564536, "name", newJString(name))
  add(path_564536, "subscriptionId", newJString(subscriptionId))
  add(path_564536, "resourceGroupName", newJString(resourceGroupName))
  result = call_564535.call(path_564536, query_564537, nil, nil, nil)

var notificationChannelsDelete* = Call_NotificationChannelsDelete_564526(
    name: "notificationChannelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}",
    validator: validate_NotificationChannelsDelete_564527, base: "",
    url: url_NotificationChannelsDelete_564528, schemes: {Scheme.Https})
type
  Call_NotificationChannelsNotify_564552 = ref object of OpenApiRestCall_563564
proc url_NotificationChannelsNotify_564554(protocol: Scheme; host: string;
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

proc validate_NotificationChannelsNotify_564553(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send notification to provided channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the notification channel.
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
  var valid_564557 = path.getOrDefault("subscriptionId")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "subscriptionId", valid_564557
  var valid_564558 = path.getOrDefault("resourceGroupName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "resourceGroupName", valid_564558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564559 = query.getOrDefault("api-version")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564559 != nil:
    section.add "api-version", valid_564559
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

proc call*(call_564561: Call_NotificationChannelsNotify_564552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send notification to provided channel.
  ## 
  let valid = call_564561.validator(path, query, header, formData, body)
  let scheme = call_564561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564561.url(scheme.get, call_564561.host, call_564561.base,
                         call_564561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564561, url, valid)

proc call*(call_564562: Call_NotificationChannelsNotify_564552; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          notifyParameters: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## notificationChannelsNotify
  ## Send notification to provided channel.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the notification channel.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   notifyParameters: JObject (required)
  ##                   : Properties for generating a Notification.
  var path_564563 = newJObject()
  var query_564564 = newJObject()
  var body_564565 = newJObject()
  add(path_564563, "labName", newJString(labName))
  add(query_564564, "api-version", newJString(apiVersion))
  add(path_564563, "name", newJString(name))
  add(path_564563, "subscriptionId", newJString(subscriptionId))
  add(path_564563, "resourceGroupName", newJString(resourceGroupName))
  if notifyParameters != nil:
    body_564565 = notifyParameters
  result = call_564562.call(path_564563, query_564564, nil, nil, body_564565)

var notificationChannelsNotify* = Call_NotificationChannelsNotify_564552(
    name: "notificationChannelsNotify", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/notificationchannels/{name}/notify",
    validator: validate_NotificationChannelsNotify_564553, base: "",
    url: url_NotificationChannelsNotify_564554, schemes: {Scheme.Https})
type
  Call_PolicySetsEvaluatePolicies_564566 = ref object of OpenApiRestCall_563564
proc url_PolicySetsEvaluatePolicies_564568(protocol: Scheme; host: string;
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

proc validate_PolicySetsEvaluatePolicies_564567(path: JsonNode; query: JsonNode;
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
  var valid_564571 = path.getOrDefault("subscriptionId")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "subscriptionId", valid_564571
  var valid_564572 = path.getOrDefault("resourceGroupName")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "resourceGroupName", valid_564572
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564573 = query.getOrDefault("api-version")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564573 != nil:
    section.add "api-version", valid_564573
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

proc call*(call_564575: Call_PolicySetsEvaluatePolicies_564566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Evaluates lab policy.
  ## 
  let valid = call_564575.validator(path, query, header, formData, body)
  let scheme = call_564575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564575.url(scheme.get, call_564575.host, call_564575.base,
                         call_564575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564575, url, valid)

proc call*(call_564576: Call_PolicySetsEvaluatePolicies_564566; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          evaluatePoliciesRequest: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564577 = newJObject()
  var query_564578 = newJObject()
  var body_564579 = newJObject()
  add(path_564577, "labName", newJString(labName))
  add(query_564578, "api-version", newJString(apiVersion))
  add(path_564577, "name", newJString(name))
  add(path_564577, "subscriptionId", newJString(subscriptionId))
  add(path_564577, "resourceGroupName", newJString(resourceGroupName))
  if evaluatePoliciesRequest != nil:
    body_564579 = evaluatePoliciesRequest
  result = call_564576.call(path_564577, query_564578, nil, nil, body_564579)

var policySetsEvaluatePolicies* = Call_PolicySetsEvaluatePolicies_564566(
    name: "policySetsEvaluatePolicies", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{name}/evaluatePolicies",
    validator: validate_PolicySetsEvaluatePolicies_564567, base: "",
    url: url_PolicySetsEvaluatePolicies_564568, schemes: {Scheme.Https})
type
  Call_PoliciesList_564580 = ref object of OpenApiRestCall_563564
proc url_PoliciesList_564582(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesList_564581(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564583 = path.getOrDefault("labName")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "labName", valid_564583
  var valid_564584 = path.getOrDefault("policySetName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "policySetName", valid_564584
  var valid_564585 = path.getOrDefault("subscriptionId")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "subscriptionId", valid_564585
  var valid_564586 = path.getOrDefault("resourceGroupName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "resourceGroupName", valid_564586
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564587 = query.getOrDefault("$top")
  valid_564587 = validateParameter(valid_564587, JInt, required = false, default = nil)
  if valid_564587 != nil:
    section.add "$top", valid_564587
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564588 = query.getOrDefault("api-version")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564588 != nil:
    section.add "api-version", valid_564588
  var valid_564589 = query.getOrDefault("$expand")
  valid_564589 = validateParameter(valid_564589, JString, required = false,
                                 default = nil)
  if valid_564589 != nil:
    section.add "$expand", valid_564589
  var valid_564590 = query.getOrDefault("$orderby")
  valid_564590 = validateParameter(valid_564590, JString, required = false,
                                 default = nil)
  if valid_564590 != nil:
    section.add "$orderby", valid_564590
  var valid_564591 = query.getOrDefault("$filter")
  valid_564591 = validateParameter(valid_564591, JString, required = false,
                                 default = nil)
  if valid_564591 != nil:
    section.add "$filter", valid_564591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564592: Call_PoliciesList_564580; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List policies in a given policy set.
  ## 
  let valid = call_564592.validator(path, query, header, formData, body)
  let scheme = call_564592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564592.url(scheme.get, call_564592.host, call_564592.base,
                         call_564592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564592, url, valid)

proc call*(call_564593: Call_PoliciesList_564580; labName: string;
          policySetName: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; apiVersion: string = "2018-09-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## policiesList
  ## List policies in a given policy set.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=description)'
  ##   policySetName: string (required)
  ##                : The name of the policy set.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564594 = newJObject()
  var query_564595 = newJObject()
  add(path_564594, "labName", newJString(labName))
  add(query_564595, "$top", newJInt(Top))
  add(query_564595, "api-version", newJString(apiVersion))
  add(query_564595, "$expand", newJString(Expand))
  add(path_564594, "policySetName", newJString(policySetName))
  add(path_564594, "subscriptionId", newJString(subscriptionId))
  add(query_564595, "$orderby", newJString(Orderby))
  add(path_564594, "resourceGroupName", newJString(resourceGroupName))
  add(query_564595, "$filter", newJString(Filter))
  result = call_564593.call(path_564594, query_564595, nil, nil, nil)

var policiesList* = Call_PoliciesList_564580(name: "policiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies",
    validator: validate_PoliciesList_564581, base: "", url: url_PoliciesList_564582,
    schemes: {Scheme.Https})
type
  Call_PoliciesCreateOrUpdate_564610 = ref object of OpenApiRestCall_563564
proc url_PoliciesCreateOrUpdate_564612(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesCreateOrUpdate_564611(path: JsonNode; query: JsonNode;
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
  var valid_564613 = path.getOrDefault("labName")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "labName", valid_564613
  var valid_564614 = path.getOrDefault("name")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "name", valid_564614
  var valid_564615 = path.getOrDefault("policySetName")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "policySetName", valid_564615
  var valid_564616 = path.getOrDefault("subscriptionId")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "subscriptionId", valid_564616
  var valid_564617 = path.getOrDefault("resourceGroupName")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "resourceGroupName", valid_564617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564618 = query.getOrDefault("api-version")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564618 != nil:
    section.add "api-version", valid_564618
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

proc call*(call_564620: Call_PoliciesCreateOrUpdate_564610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing policy.
  ## 
  let valid = call_564620.validator(path, query, header, formData, body)
  let scheme = call_564620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564620.url(scheme.get, call_564620.host, call_564620.base,
                         call_564620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564620, url, valid)

proc call*(call_564621: Call_PoliciesCreateOrUpdate_564610; labName: string;
          policy: JsonNode; name: string; policySetName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564622 = newJObject()
  var query_564623 = newJObject()
  var body_564624 = newJObject()
  add(path_564622, "labName", newJString(labName))
  add(query_564623, "api-version", newJString(apiVersion))
  if policy != nil:
    body_564624 = policy
  add(path_564622, "name", newJString(name))
  add(path_564622, "policySetName", newJString(policySetName))
  add(path_564622, "subscriptionId", newJString(subscriptionId))
  add(path_564622, "resourceGroupName", newJString(resourceGroupName))
  result = call_564621.call(path_564622, query_564623, nil, nil, body_564624)

var policiesCreateOrUpdate* = Call_PoliciesCreateOrUpdate_564610(
    name: "policiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesCreateOrUpdate_564611, base: "",
    url: url_PoliciesCreateOrUpdate_564612, schemes: {Scheme.Https})
type
  Call_PoliciesGet_564596 = ref object of OpenApiRestCall_563564
proc url_PoliciesGet_564598(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesGet_564597(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564599 = path.getOrDefault("labName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "labName", valid_564599
  var valid_564600 = path.getOrDefault("name")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "name", valid_564600
  var valid_564601 = path.getOrDefault("policySetName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "policySetName", valid_564601
  var valid_564602 = path.getOrDefault("subscriptionId")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "subscriptionId", valid_564602
  var valid_564603 = path.getOrDefault("resourceGroupName")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "resourceGroupName", valid_564603
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=description)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564604 = query.getOrDefault("api-version")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564604 != nil:
    section.add "api-version", valid_564604
  var valid_564605 = query.getOrDefault("$expand")
  valid_564605 = validateParameter(valid_564605, JString, required = false,
                                 default = nil)
  if valid_564605 != nil:
    section.add "$expand", valid_564605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564606: Call_PoliciesGet_564596; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get policy.
  ## 
  let valid = call_564606.validator(path, query, header, formData, body)
  let scheme = call_564606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564606.url(scheme.get, call_564606.host, call_564606.base,
                         call_564606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564606, url, valid)

proc call*(call_564607: Call_PoliciesGet_564596; labName: string; name: string;
          policySetName: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_564608 = newJObject()
  var query_564609 = newJObject()
  add(path_564608, "labName", newJString(labName))
  add(query_564609, "api-version", newJString(apiVersion))
  add(query_564609, "$expand", newJString(Expand))
  add(path_564608, "name", newJString(name))
  add(path_564608, "policySetName", newJString(policySetName))
  add(path_564608, "subscriptionId", newJString(subscriptionId))
  add(path_564608, "resourceGroupName", newJString(resourceGroupName))
  result = call_564607.call(path_564608, query_564609, nil, nil, nil)

var policiesGet* = Call_PoliciesGet_564596(name: "policiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
                                        validator: validate_PoliciesGet_564597,
                                        base: "", url: url_PoliciesGet_564598,
                                        schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_564638 = ref object of OpenApiRestCall_563564
proc url_PoliciesUpdate_564640(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesUpdate_564639(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Allows modifying tags of policies. All other properties will be ignored.
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
  var valid_564641 = path.getOrDefault("labName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "labName", valid_564641
  var valid_564642 = path.getOrDefault("name")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "name", valid_564642
  var valid_564643 = path.getOrDefault("policySetName")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "policySetName", valid_564643
  var valid_564644 = path.getOrDefault("subscriptionId")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "subscriptionId", valid_564644
  var valid_564645 = path.getOrDefault("resourceGroupName")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "resourceGroupName", valid_564645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564646 = query.getOrDefault("api-version")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564646 != nil:
    section.add "api-version", valid_564646
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

proc call*(call_564648: Call_PoliciesUpdate_564638; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of policies. All other properties will be ignored.
  ## 
  let valid = call_564648.validator(path, query, header, formData, body)
  let scheme = call_564648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564648.url(scheme.get, call_564648.host, call_564648.base,
                         call_564648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564648, url, valid)

proc call*(call_564649: Call_PoliciesUpdate_564638; labName: string;
          policy: JsonNode; name: string; policySetName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## policiesUpdate
  ## Allows modifying tags of policies. All other properties will be ignored.
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
  var path_564650 = newJObject()
  var query_564651 = newJObject()
  var body_564652 = newJObject()
  add(path_564650, "labName", newJString(labName))
  add(query_564651, "api-version", newJString(apiVersion))
  if policy != nil:
    body_564652 = policy
  add(path_564650, "name", newJString(name))
  add(path_564650, "policySetName", newJString(policySetName))
  add(path_564650, "subscriptionId", newJString(subscriptionId))
  add(path_564650, "resourceGroupName", newJString(resourceGroupName))
  result = call_564649.call(path_564650, query_564651, nil, nil, body_564652)

var policiesUpdate* = Call_PoliciesUpdate_564638(name: "policiesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesUpdate_564639, base: "", url: url_PoliciesUpdate_564640,
    schemes: {Scheme.Https})
type
  Call_PoliciesDelete_564625 = ref object of OpenApiRestCall_563564
proc url_PoliciesDelete_564627(protocol: Scheme; host: string; base: string;
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

proc validate_PoliciesDelete_564626(path: JsonNode; query: JsonNode;
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
  var valid_564628 = path.getOrDefault("labName")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "labName", valid_564628
  var valid_564629 = path.getOrDefault("name")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "name", valid_564629
  var valid_564630 = path.getOrDefault("policySetName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "policySetName", valid_564630
  var valid_564631 = path.getOrDefault("subscriptionId")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "subscriptionId", valid_564631
  var valid_564632 = path.getOrDefault("resourceGroupName")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "resourceGroupName", valid_564632
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564633 = query.getOrDefault("api-version")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564633 != nil:
    section.add "api-version", valid_564633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564634: Call_PoliciesDelete_564625; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete policy.
  ## 
  let valid = call_564634.validator(path, query, header, formData, body)
  let scheme = call_564634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564634.url(scheme.get, call_564634.host, call_564634.base,
                         call_564634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564634, url, valid)

proc call*(call_564635: Call_PoliciesDelete_564625; labName: string; name: string;
          policySetName: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564636 = newJObject()
  var query_564637 = newJObject()
  add(path_564636, "labName", newJString(labName))
  add(query_564637, "api-version", newJString(apiVersion))
  add(path_564636, "name", newJString(name))
  add(path_564636, "policySetName", newJString(policySetName))
  add(path_564636, "subscriptionId", newJString(subscriptionId))
  add(path_564636, "resourceGroupName", newJString(resourceGroupName))
  result = call_564635.call(path_564636, query_564637, nil, nil, nil)

var policiesDelete* = Call_PoliciesDelete_564625(name: "policiesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/policysets/{policySetName}/policies/{name}",
    validator: validate_PoliciesDelete_564626, base: "", url: url_PoliciesDelete_564627,
    schemes: {Scheme.Https})
type
  Call_SchedulesList_564653 = ref object of OpenApiRestCall_563564
proc url_SchedulesList_564655(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesList_564654(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564656 = path.getOrDefault("labName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "labName", valid_564656
  var valid_564657 = path.getOrDefault("subscriptionId")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "subscriptionId", valid_564657
  var valid_564658 = path.getOrDefault("resourceGroupName")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = nil)
  if valid_564658 != nil:
    section.add "resourceGroupName", valid_564658
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564659 = query.getOrDefault("$top")
  valid_564659 = validateParameter(valid_564659, JInt, required = false, default = nil)
  if valid_564659 != nil:
    section.add "$top", valid_564659
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564660 = query.getOrDefault("api-version")
  valid_564660 = validateParameter(valid_564660, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564660 != nil:
    section.add "api-version", valid_564660
  var valid_564661 = query.getOrDefault("$expand")
  valid_564661 = validateParameter(valid_564661, JString, required = false,
                                 default = nil)
  if valid_564661 != nil:
    section.add "$expand", valid_564661
  var valid_564662 = query.getOrDefault("$orderby")
  valid_564662 = validateParameter(valid_564662, JString, required = false,
                                 default = nil)
  if valid_564662 != nil:
    section.add "$orderby", valid_564662
  var valid_564663 = query.getOrDefault("$filter")
  valid_564663 = validateParameter(valid_564663, JString, required = false,
                                 default = nil)
  if valid_564663 != nil:
    section.add "$filter", valid_564663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564664: Call_SchedulesList_564653; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given lab.
  ## 
  let valid = call_564664.validator(path, query, header, formData, body)
  let scheme = call_564664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564664.url(scheme.get, call_564664.host, call_564664.base,
                         call_564664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564664, url, valid)

proc call*(call_564665: Call_SchedulesList_564653; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## schedulesList
  ## List schedules in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564666 = newJObject()
  var query_564667 = newJObject()
  add(path_564666, "labName", newJString(labName))
  add(query_564667, "$top", newJInt(Top))
  add(query_564667, "api-version", newJString(apiVersion))
  add(query_564667, "$expand", newJString(Expand))
  add(path_564666, "subscriptionId", newJString(subscriptionId))
  add(query_564667, "$orderby", newJString(Orderby))
  add(path_564666, "resourceGroupName", newJString(resourceGroupName))
  add(query_564667, "$filter", newJString(Filter))
  result = call_564665.call(path_564666, query_564667, nil, nil, nil)

var schedulesList* = Call_SchedulesList_564653(name: "schedulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules",
    validator: validate_SchedulesList_564654, base: "", url: url_SchedulesList_564655,
    schemes: {Scheme.Https})
type
  Call_SchedulesCreateOrUpdate_564681 = ref object of OpenApiRestCall_563564
proc url_SchedulesCreateOrUpdate_564683(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesCreateOrUpdate_564682(path: JsonNode; query: JsonNode;
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
  var valid_564684 = path.getOrDefault("labName")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "labName", valid_564684
  var valid_564685 = path.getOrDefault("name")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = nil)
  if valid_564685 != nil:
    section.add "name", valid_564685
  var valid_564686 = path.getOrDefault("subscriptionId")
  valid_564686 = validateParameter(valid_564686, JString, required = true,
                                 default = nil)
  if valid_564686 != nil:
    section.add "subscriptionId", valid_564686
  var valid_564687 = path.getOrDefault("resourceGroupName")
  valid_564687 = validateParameter(valid_564687, JString, required = true,
                                 default = nil)
  if valid_564687 != nil:
    section.add "resourceGroupName", valid_564687
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564688 = query.getOrDefault("api-version")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564688 != nil:
    section.add "api-version", valid_564688
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

proc call*(call_564690: Call_SchedulesCreateOrUpdate_564681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_564690.validator(path, query, header, formData, body)
  let scheme = call_564690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564690.url(scheme.get, call_564690.host, call_564690.base,
                         call_564690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564690, url, valid)

proc call*(call_564691: Call_SchedulesCreateOrUpdate_564681; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          schedule: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564692 = newJObject()
  var query_564693 = newJObject()
  var body_564694 = newJObject()
  add(path_564692, "labName", newJString(labName))
  add(query_564693, "api-version", newJString(apiVersion))
  add(path_564692, "name", newJString(name))
  add(path_564692, "subscriptionId", newJString(subscriptionId))
  add(path_564692, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_564694 = schedule
  result = call_564691.call(path_564692, query_564693, nil, nil, body_564694)

var schedulesCreateOrUpdate* = Call_SchedulesCreateOrUpdate_564681(
    name: "schedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesCreateOrUpdate_564682, base: "",
    url: url_SchedulesCreateOrUpdate_564683, schemes: {Scheme.Https})
type
  Call_SchedulesGet_564668 = ref object of OpenApiRestCall_563564
proc url_SchedulesGet_564670(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesGet_564669(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564671 = path.getOrDefault("labName")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "labName", valid_564671
  var valid_564672 = path.getOrDefault("name")
  valid_564672 = validateParameter(valid_564672, JString, required = true,
                                 default = nil)
  if valid_564672 != nil:
    section.add "name", valid_564672
  var valid_564673 = path.getOrDefault("subscriptionId")
  valid_564673 = validateParameter(valid_564673, JString, required = true,
                                 default = nil)
  if valid_564673 != nil:
    section.add "subscriptionId", valid_564673
  var valid_564674 = path.getOrDefault("resourceGroupName")
  valid_564674 = validateParameter(valid_564674, JString, required = true,
                                 default = nil)
  if valid_564674 != nil:
    section.add "resourceGroupName", valid_564674
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564675 = query.getOrDefault("api-version")
  valid_564675 = validateParameter(valid_564675, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564675 != nil:
    section.add "api-version", valid_564675
  var valid_564676 = query.getOrDefault("$expand")
  valid_564676 = validateParameter(valid_564676, JString, required = false,
                                 default = nil)
  if valid_564676 != nil:
    section.add "$expand", valid_564676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564677: Call_SchedulesGet_564668; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_564677.validator(path, query, header, formData, body)
  let scheme = call_564677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564677.url(scheme.get, call_564677.host, call_564677.base,
                         call_564677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564677, url, valid)

proc call*(call_564678: Call_SchedulesGet_564668; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_564679 = newJObject()
  var query_564680 = newJObject()
  add(path_564679, "labName", newJString(labName))
  add(query_564680, "api-version", newJString(apiVersion))
  add(query_564680, "$expand", newJString(Expand))
  add(path_564679, "name", newJString(name))
  add(path_564679, "subscriptionId", newJString(subscriptionId))
  add(path_564679, "resourceGroupName", newJString(resourceGroupName))
  result = call_564678.call(path_564679, query_564680, nil, nil, nil)

var schedulesGet* = Call_SchedulesGet_564668(name: "schedulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesGet_564669, base: "", url: url_SchedulesGet_564670,
    schemes: {Scheme.Https})
type
  Call_SchedulesUpdate_564707 = ref object of OpenApiRestCall_563564
proc url_SchedulesUpdate_564709(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesUpdate_564708(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var valid_564710 = path.getOrDefault("labName")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "labName", valid_564710
  var valid_564711 = path.getOrDefault("name")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "name", valid_564711
  var valid_564712 = path.getOrDefault("subscriptionId")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "subscriptionId", valid_564712
  var valid_564713 = path.getOrDefault("resourceGroupName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "resourceGroupName", valid_564713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564714 = query.getOrDefault("api-version")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564714 != nil:
    section.add "api-version", valid_564714
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

proc call*(call_564716: Call_SchedulesUpdate_564707; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_564716.validator(path, query, header, formData, body)
  let scheme = call_564716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564716.url(scheme.get, call_564716.host, call_564716.base,
                         call_564716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564716, url, valid)

proc call*(call_564717: Call_SchedulesUpdate_564707; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## schedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var path_564718 = newJObject()
  var query_564719 = newJObject()
  var body_564720 = newJObject()
  add(path_564718, "labName", newJString(labName))
  add(query_564719, "api-version", newJString(apiVersion))
  add(path_564718, "name", newJString(name))
  add(path_564718, "subscriptionId", newJString(subscriptionId))
  add(path_564718, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_564720 = schedule
  result = call_564717.call(path_564718, query_564719, nil, nil, body_564720)

var schedulesUpdate* = Call_SchedulesUpdate_564707(name: "schedulesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesUpdate_564708, base: "", url: url_SchedulesUpdate_564709,
    schemes: {Scheme.Https})
type
  Call_SchedulesDelete_564695 = ref object of OpenApiRestCall_563564
proc url_SchedulesDelete_564697(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesDelete_564696(path: JsonNode; query: JsonNode;
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
  var valid_564698 = path.getOrDefault("labName")
  valid_564698 = validateParameter(valid_564698, JString, required = true,
                                 default = nil)
  if valid_564698 != nil:
    section.add "labName", valid_564698
  var valid_564699 = path.getOrDefault("name")
  valid_564699 = validateParameter(valid_564699, JString, required = true,
                                 default = nil)
  if valid_564699 != nil:
    section.add "name", valid_564699
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564702 = query.getOrDefault("api-version")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564702 != nil:
    section.add "api-version", valid_564702
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564703: Call_SchedulesDelete_564695; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_564703.validator(path, query, header, formData, body)
  let scheme = call_564703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564703.url(scheme.get, call_564703.host, call_564703.base,
                         call_564703.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564703, url, valid)

proc call*(call_564704: Call_SchedulesDelete_564695; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564705 = newJObject()
  var query_564706 = newJObject()
  add(path_564705, "labName", newJString(labName))
  add(query_564706, "api-version", newJString(apiVersion))
  add(path_564705, "name", newJString(name))
  add(path_564705, "subscriptionId", newJString(subscriptionId))
  add(path_564705, "resourceGroupName", newJString(resourceGroupName))
  result = call_564704.call(path_564705, query_564706, nil, nil, nil)

var schedulesDelete* = Call_SchedulesDelete_564695(name: "schedulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}",
    validator: validate_SchedulesDelete_564696, base: "", url: url_SchedulesDelete_564697,
    schemes: {Scheme.Https})
type
  Call_SchedulesExecute_564721 = ref object of OpenApiRestCall_563564
proc url_SchedulesExecute_564723(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesExecute_564722(path: JsonNode; query: JsonNode;
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
  var valid_564724 = path.getOrDefault("labName")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "labName", valid_564724
  var valid_564725 = path.getOrDefault("name")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "name", valid_564725
  var valid_564726 = path.getOrDefault("subscriptionId")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "subscriptionId", valid_564726
  var valid_564727 = path.getOrDefault("resourceGroupName")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "resourceGroupName", valid_564727
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564728 = query.getOrDefault("api-version")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564728 != nil:
    section.add "api-version", valid_564728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564729: Call_SchedulesExecute_564721; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_564729.validator(path, query, header, formData, body)
  let scheme = call_564729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564729.url(scheme.get, call_564729.host, call_564729.base,
                         call_564729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564729, url, valid)

proc call*(call_564730: Call_SchedulesExecute_564721; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564731 = newJObject()
  var query_564732 = newJObject()
  add(path_564731, "labName", newJString(labName))
  add(query_564732, "api-version", newJString(apiVersion))
  add(path_564731, "name", newJString(name))
  add(path_564731, "subscriptionId", newJString(subscriptionId))
  add(path_564731, "resourceGroupName", newJString(resourceGroupName))
  result = call_564730.call(path_564731, query_564732, nil, nil, nil)

var schedulesExecute* = Call_SchedulesExecute_564721(name: "schedulesExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/execute",
    validator: validate_SchedulesExecute_564722, base: "",
    url: url_SchedulesExecute_564723, schemes: {Scheme.Https})
type
  Call_SchedulesListApplicable_564733 = ref object of OpenApiRestCall_563564
proc url_SchedulesListApplicable_564735(protocol: Scheme; host: string; base: string;
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

proc validate_SchedulesListApplicable_564734(path: JsonNode; query: JsonNode;
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
  var valid_564736 = path.getOrDefault("labName")
  valid_564736 = validateParameter(valid_564736, JString, required = true,
                                 default = nil)
  if valid_564736 != nil:
    section.add "labName", valid_564736
  var valid_564737 = path.getOrDefault("name")
  valid_564737 = validateParameter(valid_564737, JString, required = true,
                                 default = nil)
  if valid_564737 != nil:
    section.add "name", valid_564737
  var valid_564738 = path.getOrDefault("subscriptionId")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "subscriptionId", valid_564738
  var valid_564739 = path.getOrDefault("resourceGroupName")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "resourceGroupName", valid_564739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564740 = query.getOrDefault("api-version")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564740 != nil:
    section.add "api-version", valid_564740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564741: Call_SchedulesListApplicable_564733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all applicable schedules
  ## 
  let valid = call_564741.validator(path, query, header, formData, body)
  let scheme = call_564741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564741.url(scheme.get, call_564741.host, call_564741.base,
                         call_564741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564741, url, valid)

proc call*(call_564742: Call_SchedulesListApplicable_564733; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564743 = newJObject()
  var query_564744 = newJObject()
  add(path_564743, "labName", newJString(labName))
  add(query_564744, "api-version", newJString(apiVersion))
  add(path_564743, "name", newJString(name))
  add(path_564743, "subscriptionId", newJString(subscriptionId))
  add(path_564743, "resourceGroupName", newJString(resourceGroupName))
  result = call_564742.call(path_564743, query_564744, nil, nil, nil)

var schedulesListApplicable* = Call_SchedulesListApplicable_564733(
    name: "schedulesListApplicable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/schedules/{name}/listApplicable",
    validator: validate_SchedulesListApplicable_564734, base: "",
    url: url_SchedulesListApplicable_564735, schemes: {Scheme.Https})
type
  Call_ServiceRunnersCreateOrUpdate_564757 = ref object of OpenApiRestCall_563564
proc url_ServiceRunnersCreateOrUpdate_564759(protocol: Scheme; host: string;
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

proc validate_ServiceRunnersCreateOrUpdate_564758(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing service runner.
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
  var valid_564760 = path.getOrDefault("labName")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "labName", valid_564760
  var valid_564761 = path.getOrDefault("name")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "name", valid_564761
  var valid_564762 = path.getOrDefault("subscriptionId")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "subscriptionId", valid_564762
  var valid_564763 = path.getOrDefault("resourceGroupName")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "resourceGroupName", valid_564763
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564764 = query.getOrDefault("api-version")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564764 != nil:
    section.add "api-version", valid_564764
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

proc call*(call_564766: Call_ServiceRunnersCreateOrUpdate_564757; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing service runner.
  ## 
  let valid = call_564766.validator(path, query, header, formData, body)
  let scheme = call_564766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564766.url(scheme.get, call_564766.host, call_564766.base,
                         call_564766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564766, url, valid)

proc call*(call_564767: Call_ServiceRunnersCreateOrUpdate_564757;
          serviceRunner: JsonNode; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceRunnersCreateOrUpdate
  ## Create or replace an existing service runner.
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
  var path_564768 = newJObject()
  var query_564769 = newJObject()
  var body_564770 = newJObject()
  if serviceRunner != nil:
    body_564770 = serviceRunner
  add(path_564768, "labName", newJString(labName))
  add(query_564769, "api-version", newJString(apiVersion))
  add(path_564768, "name", newJString(name))
  add(path_564768, "subscriptionId", newJString(subscriptionId))
  add(path_564768, "resourceGroupName", newJString(resourceGroupName))
  result = call_564767.call(path_564768, query_564769, nil, nil, body_564770)

var serviceRunnersCreateOrUpdate* = Call_ServiceRunnersCreateOrUpdate_564757(
    name: "serviceRunnersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersCreateOrUpdate_564758, base: "",
    url: url_ServiceRunnersCreateOrUpdate_564759, schemes: {Scheme.Https})
type
  Call_ServiceRunnersGet_564745 = ref object of OpenApiRestCall_563564
proc url_ServiceRunnersGet_564747(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceRunnersGet_564746(path: JsonNode; query: JsonNode;
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
  var valid_564748 = path.getOrDefault("labName")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = nil)
  if valid_564748 != nil:
    section.add "labName", valid_564748
  var valid_564749 = path.getOrDefault("name")
  valid_564749 = validateParameter(valid_564749, JString, required = true,
                                 default = nil)
  if valid_564749 != nil:
    section.add "name", valid_564749
  var valid_564750 = path.getOrDefault("subscriptionId")
  valid_564750 = validateParameter(valid_564750, JString, required = true,
                                 default = nil)
  if valid_564750 != nil:
    section.add "subscriptionId", valid_564750
  var valid_564751 = path.getOrDefault("resourceGroupName")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = nil)
  if valid_564751 != nil:
    section.add "resourceGroupName", valid_564751
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564752 = query.getOrDefault("api-version")
  valid_564752 = validateParameter(valid_564752, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564752 != nil:
    section.add "api-version", valid_564752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564753: Call_ServiceRunnersGet_564745; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service runner.
  ## 
  let valid = call_564753.validator(path, query, header, formData, body)
  let scheme = call_564753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564753.url(scheme.get, call_564753.host, call_564753.base,
                         call_564753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564753, url, valid)

proc call*(call_564754: Call_ServiceRunnersGet_564745; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564755 = newJObject()
  var query_564756 = newJObject()
  add(path_564755, "labName", newJString(labName))
  add(query_564756, "api-version", newJString(apiVersion))
  add(path_564755, "name", newJString(name))
  add(path_564755, "subscriptionId", newJString(subscriptionId))
  add(path_564755, "resourceGroupName", newJString(resourceGroupName))
  result = call_564754.call(path_564755, query_564756, nil, nil, nil)

var serviceRunnersGet* = Call_ServiceRunnersGet_564745(name: "serviceRunnersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersGet_564746, base: "",
    url: url_ServiceRunnersGet_564747, schemes: {Scheme.Https})
type
  Call_ServiceRunnersDelete_564771 = ref object of OpenApiRestCall_563564
proc url_ServiceRunnersDelete_564773(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceRunnersDelete_564772(path: JsonNode; query: JsonNode;
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
  var valid_564774 = path.getOrDefault("labName")
  valid_564774 = validateParameter(valid_564774, JString, required = true,
                                 default = nil)
  if valid_564774 != nil:
    section.add "labName", valid_564774
  var valid_564775 = path.getOrDefault("name")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "name", valid_564775
  var valid_564776 = path.getOrDefault("subscriptionId")
  valid_564776 = validateParameter(valid_564776, JString, required = true,
                                 default = nil)
  if valid_564776 != nil:
    section.add "subscriptionId", valid_564776
  var valid_564777 = path.getOrDefault("resourceGroupName")
  valid_564777 = validateParameter(valid_564777, JString, required = true,
                                 default = nil)
  if valid_564777 != nil:
    section.add "resourceGroupName", valid_564777
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564778 = query.getOrDefault("api-version")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564778 != nil:
    section.add "api-version", valid_564778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564779: Call_ServiceRunnersDelete_564771; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete service runner.
  ## 
  let valid = call_564779.validator(path, query, header, formData, body)
  let scheme = call_564779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564779.url(scheme.get, call_564779.host, call_564779.base,
                         call_564779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564779, url, valid)

proc call*(call_564780: Call_ServiceRunnersDelete_564771; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564781 = newJObject()
  var query_564782 = newJObject()
  add(path_564781, "labName", newJString(labName))
  add(query_564782, "api-version", newJString(apiVersion))
  add(path_564781, "name", newJString(name))
  add(path_564781, "subscriptionId", newJString(subscriptionId))
  add(path_564781, "resourceGroupName", newJString(resourceGroupName))
  result = call_564780.call(path_564781, query_564782, nil, nil, nil)

var serviceRunnersDelete* = Call_ServiceRunnersDelete_564771(
    name: "serviceRunnersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/servicerunners/{name}",
    validator: validate_ServiceRunnersDelete_564772, base: "",
    url: url_ServiceRunnersDelete_564773, schemes: {Scheme.Https})
type
  Call_UsersList_564783 = ref object of OpenApiRestCall_563564
proc url_UsersList_564785(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersList_564784(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564786 = path.getOrDefault("labName")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "labName", valid_564786
  var valid_564787 = path.getOrDefault("subscriptionId")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "subscriptionId", valid_564787
  var valid_564788 = path.getOrDefault("resourceGroupName")
  valid_564788 = validateParameter(valid_564788, JString, required = true,
                                 default = nil)
  if valid_564788 != nil:
    section.add "resourceGroupName", valid_564788
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564789 = query.getOrDefault("$top")
  valid_564789 = validateParameter(valid_564789, JInt, required = false, default = nil)
  if valid_564789 != nil:
    section.add "$top", valid_564789
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564790 = query.getOrDefault("api-version")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564790 != nil:
    section.add "api-version", valid_564790
  var valid_564791 = query.getOrDefault("$expand")
  valid_564791 = validateParameter(valid_564791, JString, required = false,
                                 default = nil)
  if valid_564791 != nil:
    section.add "$expand", valid_564791
  var valid_564792 = query.getOrDefault("$orderby")
  valid_564792 = validateParameter(valid_564792, JString, required = false,
                                 default = nil)
  if valid_564792 != nil:
    section.add "$orderby", valid_564792
  var valid_564793 = query.getOrDefault("$filter")
  valid_564793 = validateParameter(valid_564793, JString, required = false,
                                 default = nil)
  if valid_564793 != nil:
    section.add "$filter", valid_564793
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564794: Call_UsersList_564783; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List user profiles in a given lab.
  ## 
  let valid = call_564794.validator(path, query, header, formData, body)
  let scheme = call_564794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564794.url(scheme.get, call_564794.host, call_564794.base,
                         call_564794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564794, url, valid)

proc call*(call_564795: Call_UsersList_564783; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## usersList
  ## List user profiles in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=identity)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_564796 = newJObject()
  var query_564797 = newJObject()
  add(path_564796, "labName", newJString(labName))
  add(query_564797, "$top", newJInt(Top))
  add(query_564797, "api-version", newJString(apiVersion))
  add(query_564797, "$expand", newJString(Expand))
  add(path_564796, "subscriptionId", newJString(subscriptionId))
  add(query_564797, "$orderby", newJString(Orderby))
  add(path_564796, "resourceGroupName", newJString(resourceGroupName))
  add(query_564797, "$filter", newJString(Filter))
  result = call_564795.call(path_564796, query_564797, nil, nil, nil)

var usersList* = Call_UsersList_564783(name: "usersList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users",
                                    validator: validate_UsersList_564784,
                                    base: "", url: url_UsersList_564785,
                                    schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_564811 = ref object of OpenApiRestCall_563564
proc url_UsersCreateOrUpdate_564813(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_564812(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create or replace an existing user profile. This operation can take a while to complete.
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
  var valid_564814 = path.getOrDefault("labName")
  valid_564814 = validateParameter(valid_564814, JString, required = true,
                                 default = nil)
  if valid_564814 != nil:
    section.add "labName", valid_564814
  var valid_564815 = path.getOrDefault("name")
  valid_564815 = validateParameter(valid_564815, JString, required = true,
                                 default = nil)
  if valid_564815 != nil:
    section.add "name", valid_564815
  var valid_564816 = path.getOrDefault("subscriptionId")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "subscriptionId", valid_564816
  var valid_564817 = path.getOrDefault("resourceGroupName")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = nil)
  if valid_564817 != nil:
    section.add "resourceGroupName", valid_564817
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564818 = query.getOrDefault("api-version")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564818 != nil:
    section.add "api-version", valid_564818
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

proc call*(call_564820: Call_UsersCreateOrUpdate_564811; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing user profile. This operation can take a while to complete.
  ## 
  let valid = call_564820.validator(path, query, header, formData, body)
  let scheme = call_564820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564820.url(scheme.get, call_564820.host, call_564820.base,
                         call_564820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564820, url, valid)

proc call*(call_564821: Call_UsersCreateOrUpdate_564811; labName: string;
          name: string; subscriptionId: string; user: JsonNode;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## usersCreateOrUpdate
  ## Create or replace an existing user profile. This operation can take a while to complete.
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
  var path_564822 = newJObject()
  var query_564823 = newJObject()
  var body_564824 = newJObject()
  add(path_564822, "labName", newJString(labName))
  add(query_564823, "api-version", newJString(apiVersion))
  add(path_564822, "name", newJString(name))
  add(path_564822, "subscriptionId", newJString(subscriptionId))
  if user != nil:
    body_564824 = user
  add(path_564822, "resourceGroupName", newJString(resourceGroupName))
  result = call_564821.call(path_564822, query_564823, nil, nil, body_564824)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_564811(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
    validator: validate_UsersCreateOrUpdate_564812, base: "",
    url: url_UsersCreateOrUpdate_564813, schemes: {Scheme.Https})
type
  Call_UsersGet_564798 = ref object of OpenApiRestCall_563564
proc url_UsersGet_564800(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_564799(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564801 = path.getOrDefault("labName")
  valid_564801 = validateParameter(valid_564801, JString, required = true,
                                 default = nil)
  if valid_564801 != nil:
    section.add "labName", valid_564801
  var valid_564802 = path.getOrDefault("name")
  valid_564802 = validateParameter(valid_564802, JString, required = true,
                                 default = nil)
  if valid_564802 != nil:
    section.add "name", valid_564802
  var valid_564803 = path.getOrDefault("subscriptionId")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "subscriptionId", valid_564803
  var valid_564804 = path.getOrDefault("resourceGroupName")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "resourceGroupName", valid_564804
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=identity)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564805 = query.getOrDefault("api-version")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564805 != nil:
    section.add "api-version", valid_564805
  var valid_564806 = query.getOrDefault("$expand")
  valid_564806 = validateParameter(valid_564806, JString, required = false,
                                 default = nil)
  if valid_564806 != nil:
    section.add "$expand", valid_564806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564807: Call_UsersGet_564798; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get user profile.
  ## 
  let valid = call_564807.validator(path, query, header, formData, body)
  let scheme = call_564807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564807.url(scheme.get, call_564807.host, call_564807.base,
                         call_564807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564807, url, valid)

proc call*(call_564808: Call_UsersGet_564798; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_564809 = newJObject()
  var query_564810 = newJObject()
  add(path_564809, "labName", newJString(labName))
  add(query_564810, "api-version", newJString(apiVersion))
  add(query_564810, "$expand", newJString(Expand))
  add(path_564809, "name", newJString(name))
  add(path_564809, "subscriptionId", newJString(subscriptionId))
  add(path_564809, "resourceGroupName", newJString(resourceGroupName))
  result = call_564808.call(path_564809, query_564810, nil, nil, nil)

var usersGet* = Call_UsersGet_564798(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                  validator: validate_UsersGet_564799, base: "",
                                  url: url_UsersGet_564800,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_564837 = ref object of OpenApiRestCall_563564
proc url_UsersUpdate_564839(protocol: Scheme; host: string; base: string;
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

proc validate_UsersUpdate_564838(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of user profiles. All other properties will be ignored.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564844 = query.getOrDefault("api-version")
  valid_564844 = validateParameter(valid_564844, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564844 != nil:
    section.add "api-version", valid_564844
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

proc call*(call_564846: Call_UsersUpdate_564837; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of user profiles. All other properties will be ignored.
  ## 
  let valid = call_564846.validator(path, query, header, formData, body)
  let scheme = call_564846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564846.url(scheme.get, call_564846.host, call_564846.base,
                         call_564846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564846, url, valid)

proc call*(call_564847: Call_UsersUpdate_564837; labName: string; name: string;
          subscriptionId: string; user: JsonNode; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## usersUpdate
  ## Allows modifying tags of user profiles. All other properties will be ignored.
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
  var path_564848 = newJObject()
  var query_564849 = newJObject()
  var body_564850 = newJObject()
  add(path_564848, "labName", newJString(labName))
  add(query_564849, "api-version", newJString(apiVersion))
  add(path_564848, "name", newJString(name))
  add(path_564848, "subscriptionId", newJString(subscriptionId))
  if user != nil:
    body_564850 = user
  add(path_564848, "resourceGroupName", newJString(resourceGroupName))
  result = call_564847.call(path_564848, query_564849, nil, nil, body_564850)

var usersUpdate* = Call_UsersUpdate_564837(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersUpdate_564838,
                                        base: "", url: url_UsersUpdate_564839,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_564825 = ref object of OpenApiRestCall_563564
proc url_UsersDelete_564827(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_564826(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564828 = path.getOrDefault("labName")
  valid_564828 = validateParameter(valid_564828, JString, required = true,
                                 default = nil)
  if valid_564828 != nil:
    section.add "labName", valid_564828
  var valid_564829 = path.getOrDefault("name")
  valid_564829 = validateParameter(valid_564829, JString, required = true,
                                 default = nil)
  if valid_564829 != nil:
    section.add "name", valid_564829
  var valid_564830 = path.getOrDefault("subscriptionId")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = nil)
  if valid_564830 != nil:
    section.add "subscriptionId", valid_564830
  var valid_564831 = path.getOrDefault("resourceGroupName")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "resourceGroupName", valid_564831
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564832 = query.getOrDefault("api-version")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564832 != nil:
    section.add "api-version", valid_564832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564833: Call_UsersDelete_564825; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user profile. This operation can take a while to complete.
  ## 
  let valid = call_564833.validator(path, query, header, formData, body)
  let scheme = call_564833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564833.url(scheme.get, call_564833.host, call_564833.base,
                         call_564833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564833, url, valid)

proc call*(call_564834: Call_UsersDelete_564825; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564835 = newJObject()
  var query_564836 = newJObject()
  add(path_564835, "labName", newJString(labName))
  add(query_564836, "api-version", newJString(apiVersion))
  add(path_564835, "name", newJString(name))
  add(path_564835, "subscriptionId", newJString(subscriptionId))
  add(path_564835, "resourceGroupName", newJString(resourceGroupName))
  result = call_564834.call(path_564835, query_564836, nil, nil, nil)

var usersDelete* = Call_UsersDelete_564825(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{name}",
                                        validator: validate_UsersDelete_564826,
                                        base: "", url: url_UsersDelete_564827,
                                        schemes: {Scheme.Https})
type
  Call_DisksList_564851 = ref object of OpenApiRestCall_563564
proc url_DisksList_564853(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksList_564852(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564854 = path.getOrDefault("labName")
  valid_564854 = validateParameter(valid_564854, JString, required = true,
                                 default = nil)
  if valid_564854 != nil:
    section.add "labName", valid_564854
  var valid_564855 = path.getOrDefault("subscriptionId")
  valid_564855 = validateParameter(valid_564855, JString, required = true,
                                 default = nil)
  if valid_564855 != nil:
    section.add "subscriptionId", valid_564855
  var valid_564856 = path.getOrDefault("resourceGroupName")
  valid_564856 = validateParameter(valid_564856, JString, required = true,
                                 default = nil)
  if valid_564856 != nil:
    section.add "resourceGroupName", valid_564856
  var valid_564857 = path.getOrDefault("userName")
  valid_564857 = validateParameter(valid_564857, JString, required = true,
                                 default = nil)
  if valid_564857 != nil:
    section.add "userName", valid_564857
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564858 = query.getOrDefault("$top")
  valid_564858 = validateParameter(valid_564858, JInt, required = false, default = nil)
  if valid_564858 != nil:
    section.add "$top", valid_564858
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564859 = query.getOrDefault("api-version")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564859 != nil:
    section.add "api-version", valid_564859
  var valid_564860 = query.getOrDefault("$expand")
  valid_564860 = validateParameter(valid_564860, JString, required = false,
                                 default = nil)
  if valid_564860 != nil:
    section.add "$expand", valid_564860
  var valid_564861 = query.getOrDefault("$orderby")
  valid_564861 = validateParameter(valid_564861, JString, required = false,
                                 default = nil)
  if valid_564861 != nil:
    section.add "$orderby", valid_564861
  var valid_564862 = query.getOrDefault("$filter")
  valid_564862 = validateParameter(valid_564862, JString, required = false,
                                 default = nil)
  if valid_564862 != nil:
    section.add "$filter", valid_564862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564863: Call_DisksList_564851; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disks in a given user profile.
  ## 
  let valid = call_564863.validator(path, query, header, formData, body)
  let scheme = call_564863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564863.url(scheme.get, call_564863.host, call_564863.base,
                         call_564863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564863, url, valid)

proc call*(call_564864: Call_DisksList_564851; labName: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          Top: int = 0; apiVersion: string = "2018-09-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## disksList
  ## List disks in a given user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=diskType)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564865 = newJObject()
  var query_564866 = newJObject()
  add(path_564865, "labName", newJString(labName))
  add(query_564866, "$top", newJInt(Top))
  add(query_564866, "api-version", newJString(apiVersion))
  add(query_564866, "$expand", newJString(Expand))
  add(path_564865, "subscriptionId", newJString(subscriptionId))
  add(query_564866, "$orderby", newJString(Orderby))
  add(path_564865, "resourceGroupName", newJString(resourceGroupName))
  add(query_564866, "$filter", newJString(Filter))
  add(path_564865, "userName", newJString(userName))
  result = call_564864.call(path_564865, query_564866, nil, nil, nil)

var disksList* = Call_DisksList_564851(name: "disksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks",
                                    validator: validate_DisksList_564852,
                                    base: "", url: url_DisksList_564853,
                                    schemes: {Scheme.Https})
type
  Call_DisksCreateOrUpdate_564881 = ref object of OpenApiRestCall_563564
proc url_DisksCreateOrUpdate_564883(protocol: Scheme; host: string; base: string;
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

proc validate_DisksCreateOrUpdate_564882(path: JsonNode; query: JsonNode;
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
  var valid_564884 = path.getOrDefault("labName")
  valid_564884 = validateParameter(valid_564884, JString, required = true,
                                 default = nil)
  if valid_564884 != nil:
    section.add "labName", valid_564884
  var valid_564885 = path.getOrDefault("name")
  valid_564885 = validateParameter(valid_564885, JString, required = true,
                                 default = nil)
  if valid_564885 != nil:
    section.add "name", valid_564885
  var valid_564886 = path.getOrDefault("subscriptionId")
  valid_564886 = validateParameter(valid_564886, JString, required = true,
                                 default = nil)
  if valid_564886 != nil:
    section.add "subscriptionId", valid_564886
  var valid_564887 = path.getOrDefault("resourceGroupName")
  valid_564887 = validateParameter(valid_564887, JString, required = true,
                                 default = nil)
  if valid_564887 != nil:
    section.add "resourceGroupName", valid_564887
  var valid_564888 = path.getOrDefault("userName")
  valid_564888 = validateParameter(valid_564888, JString, required = true,
                                 default = nil)
  if valid_564888 != nil:
    section.add "userName", valid_564888
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564889 = query.getOrDefault("api-version")
  valid_564889 = validateParameter(valid_564889, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564889 != nil:
    section.add "api-version", valid_564889
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

proc call*(call_564891: Call_DisksCreateOrUpdate_564881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing disk. This operation can take a while to complete.
  ## 
  let valid = call_564891.validator(path, query, header, formData, body)
  let scheme = call_564891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564891.url(scheme.get, call_564891.host, call_564891.base,
                         call_564891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564891, url, valid)

proc call*(call_564892: Call_DisksCreateOrUpdate_564881; labName: string;
          name: string; disk: JsonNode; subscriptionId: string;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564893 = newJObject()
  var query_564894 = newJObject()
  var body_564895 = newJObject()
  add(path_564893, "labName", newJString(labName))
  add(query_564894, "api-version", newJString(apiVersion))
  add(path_564893, "name", newJString(name))
  if disk != nil:
    body_564895 = disk
  add(path_564893, "subscriptionId", newJString(subscriptionId))
  add(path_564893, "resourceGroupName", newJString(resourceGroupName))
  add(path_564893, "userName", newJString(userName))
  result = call_564892.call(path_564893, query_564894, nil, nil, body_564895)

var disksCreateOrUpdate* = Call_DisksCreateOrUpdate_564881(
    name: "disksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
    validator: validate_DisksCreateOrUpdate_564882, base: "",
    url: url_DisksCreateOrUpdate_564883, schemes: {Scheme.Https})
type
  Call_DisksGet_564867 = ref object of OpenApiRestCall_563564
proc url_DisksGet_564869(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_DisksGet_564868(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564870 = path.getOrDefault("labName")
  valid_564870 = validateParameter(valid_564870, JString, required = true,
                                 default = nil)
  if valid_564870 != nil:
    section.add "labName", valid_564870
  var valid_564871 = path.getOrDefault("name")
  valid_564871 = validateParameter(valid_564871, JString, required = true,
                                 default = nil)
  if valid_564871 != nil:
    section.add "name", valid_564871
  var valid_564872 = path.getOrDefault("subscriptionId")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "subscriptionId", valid_564872
  var valid_564873 = path.getOrDefault("resourceGroupName")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "resourceGroupName", valid_564873
  var valid_564874 = path.getOrDefault("userName")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = nil)
  if valid_564874 != nil:
    section.add "userName", valid_564874
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=diskType)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564875 = query.getOrDefault("api-version")
  valid_564875 = validateParameter(valid_564875, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564875 != nil:
    section.add "api-version", valid_564875
  var valid_564876 = query.getOrDefault("$expand")
  valid_564876 = validateParameter(valid_564876, JString, required = false,
                                 default = nil)
  if valid_564876 != nil:
    section.add "$expand", valid_564876
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564877: Call_DisksGet_564867; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get disk.
  ## 
  let valid = call_564877.validator(path, query, header, formData, body)
  let scheme = call_564877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564877.url(scheme.get, call_564877.host, call_564877.base,
                         call_564877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564877, url, valid)

proc call*(call_564878: Call_DisksGet_564867; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_564879 = newJObject()
  var query_564880 = newJObject()
  add(path_564879, "labName", newJString(labName))
  add(query_564880, "api-version", newJString(apiVersion))
  add(query_564880, "$expand", newJString(Expand))
  add(path_564879, "name", newJString(name))
  add(path_564879, "subscriptionId", newJString(subscriptionId))
  add(path_564879, "resourceGroupName", newJString(resourceGroupName))
  add(path_564879, "userName", newJString(userName))
  result = call_564878.call(path_564879, query_564880, nil, nil, nil)

var disksGet* = Call_DisksGet_564867(name: "disksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                  validator: validate_DisksGet_564868, base: "",
                                  url: url_DisksGet_564869,
                                  schemes: {Scheme.Https})
type
  Call_DisksUpdate_564909 = ref object of OpenApiRestCall_563564
proc url_DisksUpdate_564911(protocol: Scheme; host: string; base: string;
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

proc validate_DisksUpdate_564910(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of disks. All other properties will be ignored.
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
  var valid_564912 = path.getOrDefault("labName")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "labName", valid_564912
  var valid_564913 = path.getOrDefault("name")
  valid_564913 = validateParameter(valid_564913, JString, required = true,
                                 default = nil)
  if valid_564913 != nil:
    section.add "name", valid_564913
  var valid_564914 = path.getOrDefault("subscriptionId")
  valid_564914 = validateParameter(valid_564914, JString, required = true,
                                 default = nil)
  if valid_564914 != nil:
    section.add "subscriptionId", valid_564914
  var valid_564915 = path.getOrDefault("resourceGroupName")
  valid_564915 = validateParameter(valid_564915, JString, required = true,
                                 default = nil)
  if valid_564915 != nil:
    section.add "resourceGroupName", valid_564915
  var valid_564916 = path.getOrDefault("userName")
  valid_564916 = validateParameter(valid_564916, JString, required = true,
                                 default = nil)
  if valid_564916 != nil:
    section.add "userName", valid_564916
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564917 = query.getOrDefault("api-version")
  valid_564917 = validateParameter(valid_564917, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564917 != nil:
    section.add "api-version", valid_564917
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

proc call*(call_564919: Call_DisksUpdate_564909; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of disks. All other properties will be ignored.
  ## 
  let valid = call_564919.validator(path, query, header, formData, body)
  let scheme = call_564919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564919.url(scheme.get, call_564919.host, call_564919.base,
                         call_564919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564919, url, valid)

proc call*(call_564920: Call_DisksUpdate_564909; labName: string; name: string;
          disk: JsonNode; subscriptionId: string; resourceGroupName: string;
          userName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## disksUpdate
  ## Allows modifying tags of disks. All other properties will be ignored.
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
  var path_564921 = newJObject()
  var query_564922 = newJObject()
  var body_564923 = newJObject()
  add(path_564921, "labName", newJString(labName))
  add(query_564922, "api-version", newJString(apiVersion))
  add(path_564921, "name", newJString(name))
  if disk != nil:
    body_564923 = disk
  add(path_564921, "subscriptionId", newJString(subscriptionId))
  add(path_564921, "resourceGroupName", newJString(resourceGroupName))
  add(path_564921, "userName", newJString(userName))
  result = call_564920.call(path_564921, query_564922, nil, nil, body_564923)

var disksUpdate* = Call_DisksUpdate_564909(name: "disksUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                        validator: validate_DisksUpdate_564910,
                                        base: "", url: url_DisksUpdate_564911,
                                        schemes: {Scheme.Https})
type
  Call_DisksDelete_564896 = ref object of OpenApiRestCall_563564
proc url_DisksDelete_564898(protocol: Scheme; host: string; base: string;
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

proc validate_DisksDelete_564897(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564899 = path.getOrDefault("labName")
  valid_564899 = validateParameter(valid_564899, JString, required = true,
                                 default = nil)
  if valid_564899 != nil:
    section.add "labName", valid_564899
  var valid_564900 = path.getOrDefault("name")
  valid_564900 = validateParameter(valid_564900, JString, required = true,
                                 default = nil)
  if valid_564900 != nil:
    section.add "name", valid_564900
  var valid_564901 = path.getOrDefault("subscriptionId")
  valid_564901 = validateParameter(valid_564901, JString, required = true,
                                 default = nil)
  if valid_564901 != nil:
    section.add "subscriptionId", valid_564901
  var valid_564902 = path.getOrDefault("resourceGroupName")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = nil)
  if valid_564902 != nil:
    section.add "resourceGroupName", valid_564902
  var valid_564903 = path.getOrDefault("userName")
  valid_564903 = validateParameter(valid_564903, JString, required = true,
                                 default = nil)
  if valid_564903 != nil:
    section.add "userName", valid_564903
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564904 = query.getOrDefault("api-version")
  valid_564904 = validateParameter(valid_564904, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564904 != nil:
    section.add "api-version", valid_564904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564905: Call_DisksDelete_564896; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete disk. This operation can take a while to complete.
  ## 
  let valid = call_564905.validator(path, query, header, formData, body)
  let scheme = call_564905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564905.url(scheme.get, call_564905.host, call_564905.base,
                         call_564905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564905, url, valid)

proc call*(call_564906: Call_DisksDelete_564896; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564907 = newJObject()
  var query_564908 = newJObject()
  add(path_564907, "labName", newJString(labName))
  add(query_564908, "api-version", newJString(apiVersion))
  add(path_564907, "name", newJString(name))
  add(path_564907, "subscriptionId", newJString(subscriptionId))
  add(path_564907, "resourceGroupName", newJString(resourceGroupName))
  add(path_564907, "userName", newJString(userName))
  result = call_564906.call(path_564907, query_564908, nil, nil, nil)

var disksDelete* = Call_DisksDelete_564896(name: "disksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}",
                                        validator: validate_DisksDelete_564897,
                                        base: "", url: url_DisksDelete_564898,
                                        schemes: {Scheme.Https})
type
  Call_DisksAttach_564924 = ref object of OpenApiRestCall_563564
proc url_DisksAttach_564926(protocol: Scheme; host: string; base: string;
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

proc validate_DisksAttach_564925(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564927 = path.getOrDefault("labName")
  valid_564927 = validateParameter(valid_564927, JString, required = true,
                                 default = nil)
  if valid_564927 != nil:
    section.add "labName", valid_564927
  var valid_564928 = path.getOrDefault("name")
  valid_564928 = validateParameter(valid_564928, JString, required = true,
                                 default = nil)
  if valid_564928 != nil:
    section.add "name", valid_564928
  var valid_564929 = path.getOrDefault("subscriptionId")
  valid_564929 = validateParameter(valid_564929, JString, required = true,
                                 default = nil)
  if valid_564929 != nil:
    section.add "subscriptionId", valid_564929
  var valid_564930 = path.getOrDefault("resourceGroupName")
  valid_564930 = validateParameter(valid_564930, JString, required = true,
                                 default = nil)
  if valid_564930 != nil:
    section.add "resourceGroupName", valid_564930
  var valid_564931 = path.getOrDefault("userName")
  valid_564931 = validateParameter(valid_564931, JString, required = true,
                                 default = nil)
  if valid_564931 != nil:
    section.add "userName", valid_564931
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564932 = query.getOrDefault("api-version")
  valid_564932 = validateParameter(valid_564932, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564932 != nil:
    section.add "api-version", valid_564932
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

proc call*(call_564934: Call_DisksAttach_564924; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach and create the lease of the disk to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_564934.validator(path, query, header, formData, body)
  let scheme = call_564934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564934.url(scheme.get, call_564934.host, call_564934.base,
                         call_564934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564934, url, valid)

proc call*(call_564935: Call_DisksAttach_564924; labName: string;
          attachDiskProperties: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564936 = newJObject()
  var query_564937 = newJObject()
  var body_564938 = newJObject()
  add(path_564936, "labName", newJString(labName))
  if attachDiskProperties != nil:
    body_564938 = attachDiskProperties
  add(query_564937, "api-version", newJString(apiVersion))
  add(path_564936, "name", newJString(name))
  add(path_564936, "subscriptionId", newJString(subscriptionId))
  add(path_564936, "resourceGroupName", newJString(resourceGroupName))
  add(path_564936, "userName", newJString(userName))
  result = call_564935.call(path_564936, query_564937, nil, nil, body_564938)

var disksAttach* = Call_DisksAttach_564924(name: "disksAttach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/attach",
                                        validator: validate_DisksAttach_564925,
                                        base: "", url: url_DisksAttach_564926,
                                        schemes: {Scheme.Https})
type
  Call_DisksDetach_564939 = ref object of OpenApiRestCall_563564
proc url_DisksDetach_564941(protocol: Scheme; host: string; base: string;
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

proc validate_DisksDetach_564940(path: JsonNode; query: JsonNode; header: JsonNode;
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
                                 default = newJString("2018-09-15"))
  if valid_564947 != nil:
    section.add "api-version", valid_564947
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

proc call*(call_564949: Call_DisksDetach_564939; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach and break the lease of the disk attached to the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_564949.validator(path, query, header, formData, body)
  let scheme = call_564949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564949.url(scheme.get, call_564949.host, call_564949.base,
                         call_564949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564949, url, valid)

proc call*(call_564950: Call_DisksDetach_564939; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          detachDiskProperties: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564951 = newJObject()
  var query_564952 = newJObject()
  var body_564953 = newJObject()
  add(path_564951, "labName", newJString(labName))
  add(query_564952, "api-version", newJString(apiVersion))
  add(path_564951, "name", newJString(name))
  add(path_564951, "subscriptionId", newJString(subscriptionId))
  add(path_564951, "resourceGroupName", newJString(resourceGroupName))
  add(path_564951, "userName", newJString(userName))
  if detachDiskProperties != nil:
    body_564953 = detachDiskProperties
  result = call_564950.call(path_564951, query_564952, nil, nil, body_564953)

var disksDetach* = Call_DisksDetach_564939(name: "disksDetach",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/disks/{name}/detach",
                                        validator: validate_DisksDetach_564940,
                                        base: "", url: url_DisksDetach_564941,
                                        schemes: {Scheme.Https})
type
  Call_EnvironmentsList_564954 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsList_564956(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsList_564955(path: JsonNode; query: JsonNode;
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
  var valid_564957 = path.getOrDefault("labName")
  valid_564957 = validateParameter(valid_564957, JString, required = true,
                                 default = nil)
  if valid_564957 != nil:
    section.add "labName", valid_564957
  var valid_564958 = path.getOrDefault("subscriptionId")
  valid_564958 = validateParameter(valid_564958, JString, required = true,
                                 default = nil)
  if valid_564958 != nil:
    section.add "subscriptionId", valid_564958
  var valid_564959 = path.getOrDefault("resourceGroupName")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "resourceGroupName", valid_564959
  var valid_564960 = path.getOrDefault("userName")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "userName", valid_564960
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_564961 = query.getOrDefault("$top")
  valid_564961 = validateParameter(valid_564961, JInt, required = false, default = nil)
  if valid_564961 != nil:
    section.add "$top", valid_564961
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564962 = query.getOrDefault("api-version")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564962 != nil:
    section.add "api-version", valid_564962
  var valid_564963 = query.getOrDefault("$expand")
  valid_564963 = validateParameter(valid_564963, JString, required = false,
                                 default = nil)
  if valid_564963 != nil:
    section.add "$expand", valid_564963
  var valid_564964 = query.getOrDefault("$orderby")
  valid_564964 = validateParameter(valid_564964, JString, required = false,
                                 default = nil)
  if valid_564964 != nil:
    section.add "$orderby", valid_564964
  var valid_564965 = query.getOrDefault("$filter")
  valid_564965 = validateParameter(valid_564965, JString, required = false,
                                 default = nil)
  if valid_564965 != nil:
    section.add "$filter", valid_564965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564966: Call_EnvironmentsList_564954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List environments in a given user profile.
  ## 
  let valid = call_564966.validator(path, query, header, formData, body)
  let scheme = call_564966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564966.url(scheme.get, call_564966.host, call_564966.base,
                         call_564966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564966, url, valid)

proc call*(call_564967: Call_EnvironmentsList_564954; labName: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          Top: int = 0; apiVersion: string = "2018-09-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## environmentsList
  ## List environments in a given user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_564968 = newJObject()
  var query_564969 = newJObject()
  add(path_564968, "labName", newJString(labName))
  add(query_564969, "$top", newJInt(Top))
  add(query_564969, "api-version", newJString(apiVersion))
  add(query_564969, "$expand", newJString(Expand))
  add(path_564968, "subscriptionId", newJString(subscriptionId))
  add(query_564969, "$orderby", newJString(Orderby))
  add(path_564968, "resourceGroupName", newJString(resourceGroupName))
  add(query_564969, "$filter", newJString(Filter))
  add(path_564968, "userName", newJString(userName))
  result = call_564967.call(path_564968, query_564969, nil, nil, nil)

var environmentsList* = Call_EnvironmentsList_564954(name: "environmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments",
    validator: validate_EnvironmentsList_564955, base: "",
    url: url_EnvironmentsList_564956, schemes: {Scheme.Https})
type
  Call_EnvironmentsCreateOrUpdate_564984 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsCreateOrUpdate_564986(protocol: Scheme; host: string;
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

proc validate_EnvironmentsCreateOrUpdate_564985(path: JsonNode; query: JsonNode;
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
  var valid_564987 = path.getOrDefault("labName")
  valid_564987 = validateParameter(valid_564987, JString, required = true,
                                 default = nil)
  if valid_564987 != nil:
    section.add "labName", valid_564987
  var valid_564988 = path.getOrDefault("name")
  valid_564988 = validateParameter(valid_564988, JString, required = true,
                                 default = nil)
  if valid_564988 != nil:
    section.add "name", valid_564988
  var valid_564989 = path.getOrDefault("subscriptionId")
  valid_564989 = validateParameter(valid_564989, JString, required = true,
                                 default = nil)
  if valid_564989 != nil:
    section.add "subscriptionId", valid_564989
  var valid_564990 = path.getOrDefault("resourceGroupName")
  valid_564990 = validateParameter(valid_564990, JString, required = true,
                                 default = nil)
  if valid_564990 != nil:
    section.add "resourceGroupName", valid_564990
  var valid_564991 = path.getOrDefault("userName")
  valid_564991 = validateParameter(valid_564991, JString, required = true,
                                 default = nil)
  if valid_564991 != nil:
    section.add "userName", valid_564991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564992 = query.getOrDefault("api-version")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564992 != nil:
    section.add "api-version", valid_564992
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

proc call*(call_564994: Call_EnvironmentsCreateOrUpdate_564984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing environment. This operation can take a while to complete.
  ## 
  let valid = call_564994.validator(path, query, header, formData, body)
  let scheme = call_564994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564994.url(scheme.get, call_564994.host, call_564994.base,
                         call_564994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564994, url, valid)

proc call*(call_564995: Call_EnvironmentsCreateOrUpdate_564984; labName: string;
          name: string; subscriptionId: string; dtlEnvironment: JsonNode;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_564996 = newJObject()
  var query_564997 = newJObject()
  var body_564998 = newJObject()
  add(path_564996, "labName", newJString(labName))
  add(query_564997, "api-version", newJString(apiVersion))
  add(path_564996, "name", newJString(name))
  add(path_564996, "subscriptionId", newJString(subscriptionId))
  if dtlEnvironment != nil:
    body_564998 = dtlEnvironment
  add(path_564996, "resourceGroupName", newJString(resourceGroupName))
  add(path_564996, "userName", newJString(userName))
  result = call_564995.call(path_564996, query_564997, nil, nil, body_564998)

var environmentsCreateOrUpdate* = Call_EnvironmentsCreateOrUpdate_564984(
    name: "environmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsCreateOrUpdate_564985, base: "",
    url: url_EnvironmentsCreateOrUpdate_564986, schemes: {Scheme.Https})
type
  Call_EnvironmentsGet_564970 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsGet_564972(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsGet_564971(path: JsonNode; query: JsonNode;
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
  var valid_564973 = path.getOrDefault("labName")
  valid_564973 = validateParameter(valid_564973, JString, required = true,
                                 default = nil)
  if valid_564973 != nil:
    section.add "labName", valid_564973
  var valid_564974 = path.getOrDefault("name")
  valid_564974 = validateParameter(valid_564974, JString, required = true,
                                 default = nil)
  if valid_564974 != nil:
    section.add "name", valid_564974
  var valid_564975 = path.getOrDefault("subscriptionId")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = nil)
  if valid_564975 != nil:
    section.add "subscriptionId", valid_564975
  var valid_564976 = path.getOrDefault("resourceGroupName")
  valid_564976 = validateParameter(valid_564976, JString, required = true,
                                 default = nil)
  if valid_564976 != nil:
    section.add "resourceGroupName", valid_564976
  var valid_564977 = path.getOrDefault("userName")
  valid_564977 = validateParameter(valid_564977, JString, required = true,
                                 default = nil)
  if valid_564977 != nil:
    section.add "userName", valid_564977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=deploymentProperties)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564978 = query.getOrDefault("api-version")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_564978 != nil:
    section.add "api-version", valid_564978
  var valid_564979 = query.getOrDefault("$expand")
  valid_564979 = validateParameter(valid_564979, JString, required = false,
                                 default = nil)
  if valid_564979 != nil:
    section.add "$expand", valid_564979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564980: Call_EnvironmentsGet_564970; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get environment.
  ## 
  let valid = call_564980.validator(path, query, header, formData, body)
  let scheme = call_564980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564980.url(scheme.get, call_564980.host, call_564980.base,
                         call_564980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564980, url, valid)

proc call*(call_564981: Call_EnvironmentsGet_564970; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_564982 = newJObject()
  var query_564983 = newJObject()
  add(path_564982, "labName", newJString(labName))
  add(query_564983, "api-version", newJString(apiVersion))
  add(query_564983, "$expand", newJString(Expand))
  add(path_564982, "name", newJString(name))
  add(path_564982, "subscriptionId", newJString(subscriptionId))
  add(path_564982, "resourceGroupName", newJString(resourceGroupName))
  add(path_564982, "userName", newJString(userName))
  result = call_564981.call(path_564982, query_564983, nil, nil, nil)

var environmentsGet* = Call_EnvironmentsGet_564970(name: "environmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsGet_564971, base: "", url: url_EnvironmentsGet_564972,
    schemes: {Scheme.Https})
type
  Call_EnvironmentsUpdate_565012 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsUpdate_565014(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsUpdate_565013(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Allows modifying tags of environments. All other properties will be ignored.
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
                                 default = newJString("2018-09-15"))
  if valid_565020 != nil:
    section.add "api-version", valid_565020
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

proc call*(call_565022: Call_EnvironmentsUpdate_565012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of environments. All other properties will be ignored.
  ## 
  let valid = call_565022.validator(path, query, header, formData, body)
  let scheme = call_565022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565022.url(scheme.get, call_565022.host, call_565022.base,
                         call_565022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565022, url, valid)

proc call*(call_565023: Call_EnvironmentsUpdate_565012; labName: string;
          name: string; subscriptionId: string; dtlEnvironment: JsonNode;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## environmentsUpdate
  ## Allows modifying tags of environments. All other properties will be ignored.
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
  var path_565024 = newJObject()
  var query_565025 = newJObject()
  var body_565026 = newJObject()
  add(path_565024, "labName", newJString(labName))
  add(query_565025, "api-version", newJString(apiVersion))
  add(path_565024, "name", newJString(name))
  add(path_565024, "subscriptionId", newJString(subscriptionId))
  if dtlEnvironment != nil:
    body_565026 = dtlEnvironment
  add(path_565024, "resourceGroupName", newJString(resourceGroupName))
  add(path_565024, "userName", newJString(userName))
  result = call_565023.call(path_565024, query_565025, nil, nil, body_565026)

var environmentsUpdate* = Call_EnvironmentsUpdate_565012(
    name: "environmentsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsUpdate_565013, base: "",
    url: url_EnvironmentsUpdate_565014, schemes: {Scheme.Https})
type
  Call_EnvironmentsDelete_564999 = ref object of OpenApiRestCall_563564
proc url_EnvironmentsDelete_565001(protocol: Scheme; host: string; base: string;
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

proc validate_EnvironmentsDelete_565000(path: JsonNode; query: JsonNode;
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
  var valid_565002 = path.getOrDefault("labName")
  valid_565002 = validateParameter(valid_565002, JString, required = true,
                                 default = nil)
  if valid_565002 != nil:
    section.add "labName", valid_565002
  var valid_565003 = path.getOrDefault("name")
  valid_565003 = validateParameter(valid_565003, JString, required = true,
                                 default = nil)
  if valid_565003 != nil:
    section.add "name", valid_565003
  var valid_565004 = path.getOrDefault("subscriptionId")
  valid_565004 = validateParameter(valid_565004, JString, required = true,
                                 default = nil)
  if valid_565004 != nil:
    section.add "subscriptionId", valid_565004
  var valid_565005 = path.getOrDefault("resourceGroupName")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "resourceGroupName", valid_565005
  var valid_565006 = path.getOrDefault("userName")
  valid_565006 = validateParameter(valid_565006, JString, required = true,
                                 default = nil)
  if valid_565006 != nil:
    section.add "userName", valid_565006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565007 = query.getOrDefault("api-version")
  valid_565007 = validateParameter(valid_565007, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565007 != nil:
    section.add "api-version", valid_565007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565008: Call_EnvironmentsDelete_564999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete environment. This operation can take a while to complete.
  ## 
  let valid = call_565008.validator(path, query, header, formData, body)
  let scheme = call_565008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565008.url(scheme.get, call_565008.host, call_565008.base,
                         call_565008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565008, url, valid)

proc call*(call_565009: Call_EnvironmentsDelete_564999; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          userName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565010 = newJObject()
  var query_565011 = newJObject()
  add(path_565010, "labName", newJString(labName))
  add(query_565011, "api-version", newJString(apiVersion))
  add(path_565010, "name", newJString(name))
  add(path_565010, "subscriptionId", newJString(subscriptionId))
  add(path_565010, "resourceGroupName", newJString(resourceGroupName))
  add(path_565010, "userName", newJString(userName))
  result = call_565009.call(path_565010, query_565011, nil, nil, nil)

var environmentsDelete* = Call_EnvironmentsDelete_564999(
    name: "environmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/environments/{name}",
    validator: validate_EnvironmentsDelete_565000, base: "",
    url: url_EnvironmentsDelete_565001, schemes: {Scheme.Https})
type
  Call_SecretsList_565027 = ref object of OpenApiRestCall_563564
proc url_SecretsList_565029(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsList_565028(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_565030 = path.getOrDefault("labName")
  valid_565030 = validateParameter(valid_565030, JString, required = true,
                                 default = nil)
  if valid_565030 != nil:
    section.add "labName", valid_565030
  var valid_565031 = path.getOrDefault("subscriptionId")
  valid_565031 = validateParameter(valid_565031, JString, required = true,
                                 default = nil)
  if valid_565031 != nil:
    section.add "subscriptionId", valid_565031
  var valid_565032 = path.getOrDefault("resourceGroupName")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "resourceGroupName", valid_565032
  var valid_565033 = path.getOrDefault("userName")
  valid_565033 = validateParameter(valid_565033, JString, required = true,
                                 default = nil)
  if valid_565033 != nil:
    section.add "userName", valid_565033
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_565034 = query.getOrDefault("$top")
  valid_565034 = validateParameter(valid_565034, JInt, required = false, default = nil)
  if valid_565034 != nil:
    section.add "$top", valid_565034
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565035 = query.getOrDefault("api-version")
  valid_565035 = validateParameter(valid_565035, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565035 != nil:
    section.add "api-version", valid_565035
  var valid_565036 = query.getOrDefault("$expand")
  valid_565036 = validateParameter(valid_565036, JString, required = false,
                                 default = nil)
  if valid_565036 != nil:
    section.add "$expand", valid_565036
  var valid_565037 = query.getOrDefault("$orderby")
  valid_565037 = validateParameter(valid_565037, JString, required = false,
                                 default = nil)
  if valid_565037 != nil:
    section.add "$orderby", valid_565037
  var valid_565038 = query.getOrDefault("$filter")
  valid_565038 = validateParameter(valid_565038, JString, required = false,
                                 default = nil)
  if valid_565038 != nil:
    section.add "$filter", valid_565038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565039: Call_SecretsList_565027; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List secrets in a given user profile.
  ## 
  let valid = call_565039.validator(path, query, header, formData, body)
  let scheme = call_565039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565039.url(scheme.get, call_565039.host, call_565039.base,
                         call_565039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565039, url, valid)

proc call*(call_565040: Call_SecretsList_565027; labName: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          Top: int = 0; apiVersion: string = "2018-09-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## secretsList
  ## List secrets in a given user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=value)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565041 = newJObject()
  var query_565042 = newJObject()
  add(path_565041, "labName", newJString(labName))
  add(query_565042, "$top", newJInt(Top))
  add(query_565042, "api-version", newJString(apiVersion))
  add(query_565042, "$expand", newJString(Expand))
  add(path_565041, "subscriptionId", newJString(subscriptionId))
  add(query_565042, "$orderby", newJString(Orderby))
  add(path_565041, "resourceGroupName", newJString(resourceGroupName))
  add(query_565042, "$filter", newJString(Filter))
  add(path_565041, "userName", newJString(userName))
  result = call_565040.call(path_565041, query_565042, nil, nil, nil)

var secretsList* = Call_SecretsList_565027(name: "secretsList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets",
                                        validator: validate_SecretsList_565028,
                                        base: "", url: url_SecretsList_565029,
                                        schemes: {Scheme.Https})
type
  Call_SecretsCreateOrUpdate_565057 = ref object of OpenApiRestCall_563564
proc url_SecretsCreateOrUpdate_565059(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsCreateOrUpdate_565058(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing secret. This operation can take a while to complete.
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
  var valid_565060 = path.getOrDefault("labName")
  valid_565060 = validateParameter(valid_565060, JString, required = true,
                                 default = nil)
  if valid_565060 != nil:
    section.add "labName", valid_565060
  var valid_565061 = path.getOrDefault("name")
  valid_565061 = validateParameter(valid_565061, JString, required = true,
                                 default = nil)
  if valid_565061 != nil:
    section.add "name", valid_565061
  var valid_565062 = path.getOrDefault("subscriptionId")
  valid_565062 = validateParameter(valid_565062, JString, required = true,
                                 default = nil)
  if valid_565062 != nil:
    section.add "subscriptionId", valid_565062
  var valid_565063 = path.getOrDefault("resourceGroupName")
  valid_565063 = validateParameter(valid_565063, JString, required = true,
                                 default = nil)
  if valid_565063 != nil:
    section.add "resourceGroupName", valid_565063
  var valid_565064 = path.getOrDefault("userName")
  valid_565064 = validateParameter(valid_565064, JString, required = true,
                                 default = nil)
  if valid_565064 != nil:
    section.add "userName", valid_565064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565065 = query.getOrDefault("api-version")
  valid_565065 = validateParameter(valid_565065, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565065 != nil:
    section.add "api-version", valid_565065
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

proc call*(call_565067: Call_SecretsCreateOrUpdate_565057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing secret. This operation can take a while to complete.
  ## 
  let valid = call_565067.validator(path, query, header, formData, body)
  let scheme = call_565067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565067.url(scheme.get, call_565067.host, call_565067.base,
                         call_565067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565067, url, valid)

proc call*(call_565068: Call_SecretsCreateOrUpdate_565057; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          userName: string; secret: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## secretsCreateOrUpdate
  ## Create or replace an existing secret. This operation can take a while to complete.
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
  var path_565069 = newJObject()
  var query_565070 = newJObject()
  var body_565071 = newJObject()
  add(path_565069, "labName", newJString(labName))
  add(query_565070, "api-version", newJString(apiVersion))
  add(path_565069, "name", newJString(name))
  add(path_565069, "subscriptionId", newJString(subscriptionId))
  add(path_565069, "resourceGroupName", newJString(resourceGroupName))
  add(path_565069, "userName", newJString(userName))
  if secret != nil:
    body_565071 = secret
  result = call_565068.call(path_565069, query_565070, nil, nil, body_565071)

var secretsCreateOrUpdate* = Call_SecretsCreateOrUpdate_565057(
    name: "secretsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsCreateOrUpdate_565058, base: "",
    url: url_SecretsCreateOrUpdate_565059, schemes: {Scheme.Https})
type
  Call_SecretsGet_565043 = ref object of OpenApiRestCall_563564
proc url_SecretsGet_565045(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SecretsGet_565044(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_565046 = path.getOrDefault("labName")
  valid_565046 = validateParameter(valid_565046, JString, required = true,
                                 default = nil)
  if valid_565046 != nil:
    section.add "labName", valid_565046
  var valid_565047 = path.getOrDefault("name")
  valid_565047 = validateParameter(valid_565047, JString, required = true,
                                 default = nil)
  if valid_565047 != nil:
    section.add "name", valid_565047
  var valid_565048 = path.getOrDefault("subscriptionId")
  valid_565048 = validateParameter(valid_565048, JString, required = true,
                                 default = nil)
  if valid_565048 != nil:
    section.add "subscriptionId", valid_565048
  var valid_565049 = path.getOrDefault("resourceGroupName")
  valid_565049 = validateParameter(valid_565049, JString, required = true,
                                 default = nil)
  if valid_565049 != nil:
    section.add "resourceGroupName", valid_565049
  var valid_565050 = path.getOrDefault("userName")
  valid_565050 = validateParameter(valid_565050, JString, required = true,
                                 default = nil)
  if valid_565050 != nil:
    section.add "userName", valid_565050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=value)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565051 = query.getOrDefault("api-version")
  valid_565051 = validateParameter(valid_565051, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565051 != nil:
    section.add "api-version", valid_565051
  var valid_565052 = query.getOrDefault("$expand")
  valid_565052 = validateParameter(valid_565052, JString, required = false,
                                 default = nil)
  if valid_565052 != nil:
    section.add "$expand", valid_565052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565053: Call_SecretsGet_565043; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get secret.
  ## 
  let valid = call_565053.validator(path, query, header, formData, body)
  let scheme = call_565053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565053.url(scheme.get, call_565053.host, call_565053.base,
                         call_565053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565053, url, valid)

proc call*(call_565054: Call_SecretsGet_565043; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_565055 = newJObject()
  var query_565056 = newJObject()
  add(path_565055, "labName", newJString(labName))
  add(query_565056, "api-version", newJString(apiVersion))
  add(query_565056, "$expand", newJString(Expand))
  add(path_565055, "name", newJString(name))
  add(path_565055, "subscriptionId", newJString(subscriptionId))
  add(path_565055, "resourceGroupName", newJString(resourceGroupName))
  add(path_565055, "userName", newJString(userName))
  result = call_565054.call(path_565055, query_565056, nil, nil, nil)

var secretsGet* = Call_SecretsGet_565043(name: "secretsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
                                      validator: validate_SecretsGet_565044,
                                      base: "", url: url_SecretsGet_565045,
                                      schemes: {Scheme.Https})
type
  Call_SecretsUpdate_565085 = ref object of OpenApiRestCall_563564
proc url_SecretsUpdate_565087(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsUpdate_565086(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of secrets. All other properties will be ignored.
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
  var valid_565088 = path.getOrDefault("labName")
  valid_565088 = validateParameter(valid_565088, JString, required = true,
                                 default = nil)
  if valid_565088 != nil:
    section.add "labName", valid_565088
  var valid_565089 = path.getOrDefault("name")
  valid_565089 = validateParameter(valid_565089, JString, required = true,
                                 default = nil)
  if valid_565089 != nil:
    section.add "name", valid_565089
  var valid_565090 = path.getOrDefault("subscriptionId")
  valid_565090 = validateParameter(valid_565090, JString, required = true,
                                 default = nil)
  if valid_565090 != nil:
    section.add "subscriptionId", valid_565090
  var valid_565091 = path.getOrDefault("resourceGroupName")
  valid_565091 = validateParameter(valid_565091, JString, required = true,
                                 default = nil)
  if valid_565091 != nil:
    section.add "resourceGroupName", valid_565091
  var valid_565092 = path.getOrDefault("userName")
  valid_565092 = validateParameter(valid_565092, JString, required = true,
                                 default = nil)
  if valid_565092 != nil:
    section.add "userName", valid_565092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565093 = query.getOrDefault("api-version")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565093 != nil:
    section.add "api-version", valid_565093
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

proc call*(call_565095: Call_SecretsUpdate_565085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of secrets. All other properties will be ignored.
  ## 
  let valid = call_565095.validator(path, query, header, formData, body)
  let scheme = call_565095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565095.url(scheme.get, call_565095.host, call_565095.base,
                         call_565095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565095, url, valid)

proc call*(call_565096: Call_SecretsUpdate_565085; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          secret: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## secretsUpdate
  ## Allows modifying tags of secrets. All other properties will be ignored.
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
  var path_565097 = newJObject()
  var query_565098 = newJObject()
  var body_565099 = newJObject()
  add(path_565097, "labName", newJString(labName))
  add(query_565098, "api-version", newJString(apiVersion))
  add(path_565097, "name", newJString(name))
  add(path_565097, "subscriptionId", newJString(subscriptionId))
  add(path_565097, "resourceGroupName", newJString(resourceGroupName))
  add(path_565097, "userName", newJString(userName))
  if secret != nil:
    body_565099 = secret
  result = call_565096.call(path_565097, query_565098, nil, nil, body_565099)

var secretsUpdate* = Call_SecretsUpdate_565085(name: "secretsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsUpdate_565086, base: "", url: url_SecretsUpdate_565087,
    schemes: {Scheme.Https})
type
  Call_SecretsDelete_565072 = ref object of OpenApiRestCall_563564
proc url_SecretsDelete_565074(protocol: Scheme; host: string; base: string;
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

proc validate_SecretsDelete_565073(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_565075 = path.getOrDefault("labName")
  valid_565075 = validateParameter(valid_565075, JString, required = true,
                                 default = nil)
  if valid_565075 != nil:
    section.add "labName", valid_565075
  var valid_565076 = path.getOrDefault("name")
  valid_565076 = validateParameter(valid_565076, JString, required = true,
                                 default = nil)
  if valid_565076 != nil:
    section.add "name", valid_565076
  var valid_565077 = path.getOrDefault("subscriptionId")
  valid_565077 = validateParameter(valid_565077, JString, required = true,
                                 default = nil)
  if valid_565077 != nil:
    section.add "subscriptionId", valid_565077
  var valid_565078 = path.getOrDefault("resourceGroupName")
  valid_565078 = validateParameter(valid_565078, JString, required = true,
                                 default = nil)
  if valid_565078 != nil:
    section.add "resourceGroupName", valid_565078
  var valid_565079 = path.getOrDefault("userName")
  valid_565079 = validateParameter(valid_565079, JString, required = true,
                                 default = nil)
  if valid_565079 != nil:
    section.add "userName", valid_565079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565080 = query.getOrDefault("api-version")
  valid_565080 = validateParameter(valid_565080, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565080 != nil:
    section.add "api-version", valid_565080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565081: Call_SecretsDelete_565072; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete secret.
  ## 
  let valid = call_565081.validator(path, query, header, formData, body)
  let scheme = call_565081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565081.url(scheme.get, call_565081.host, call_565081.base,
                         call_565081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565081, url, valid)

proc call*(call_565082: Call_SecretsDelete_565072; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565083 = newJObject()
  var query_565084 = newJObject()
  add(path_565083, "labName", newJString(labName))
  add(query_565084, "api-version", newJString(apiVersion))
  add(path_565083, "name", newJString(name))
  add(path_565083, "subscriptionId", newJString(subscriptionId))
  add(path_565083, "resourceGroupName", newJString(resourceGroupName))
  add(path_565083, "userName", newJString(userName))
  result = call_565082.call(path_565083, query_565084, nil, nil, nil)

var secretsDelete* = Call_SecretsDelete_565072(name: "secretsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/secrets/{name}",
    validator: validate_SecretsDelete_565073, base: "", url: url_SecretsDelete_565074,
    schemes: {Scheme.Https})
type
  Call_ServiceFabricsList_565100 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricsList_565102(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceFabricsList_565101(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List service fabrics in a given user profile.
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
  var valid_565103 = path.getOrDefault("labName")
  valid_565103 = validateParameter(valid_565103, JString, required = true,
                                 default = nil)
  if valid_565103 != nil:
    section.add "labName", valid_565103
  var valid_565104 = path.getOrDefault("subscriptionId")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "subscriptionId", valid_565104
  var valid_565105 = path.getOrDefault("resourceGroupName")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "resourceGroupName", valid_565105
  var valid_565106 = path.getOrDefault("userName")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "userName", valid_565106
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_565107 = query.getOrDefault("$top")
  valid_565107 = validateParameter(valid_565107, JInt, required = false, default = nil)
  if valid_565107 != nil:
    section.add "$top", valid_565107
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565108 = query.getOrDefault("api-version")
  valid_565108 = validateParameter(valid_565108, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565108 != nil:
    section.add "api-version", valid_565108
  var valid_565109 = query.getOrDefault("$expand")
  valid_565109 = validateParameter(valid_565109, JString, required = false,
                                 default = nil)
  if valid_565109 != nil:
    section.add "$expand", valid_565109
  var valid_565110 = query.getOrDefault("$orderby")
  valid_565110 = validateParameter(valid_565110, JString, required = false,
                                 default = nil)
  if valid_565110 != nil:
    section.add "$orderby", valid_565110
  var valid_565111 = query.getOrDefault("$filter")
  valid_565111 = validateParameter(valid_565111, JString, required = false,
                                 default = nil)
  if valid_565111 != nil:
    section.add "$filter", valid_565111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565112: Call_ServiceFabricsList_565100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List service fabrics in a given user profile.
  ## 
  let valid = call_565112.validator(path, query, header, formData, body)
  let scheme = call_565112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565112.url(scheme.get, call_565112.host, call_565112.base,
                         call_565112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565112, url, valid)

proc call*(call_565113: Call_ServiceFabricsList_565100; labName: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          Top: int = 0; apiVersion: string = "2018-09-15"; Expand: string = "";
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## serviceFabricsList
  ## List service fabrics in a given user profile.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565114 = newJObject()
  var query_565115 = newJObject()
  add(path_565114, "labName", newJString(labName))
  add(query_565115, "$top", newJInt(Top))
  add(query_565115, "api-version", newJString(apiVersion))
  add(query_565115, "$expand", newJString(Expand))
  add(path_565114, "subscriptionId", newJString(subscriptionId))
  add(query_565115, "$orderby", newJString(Orderby))
  add(path_565114, "resourceGroupName", newJString(resourceGroupName))
  add(query_565115, "$filter", newJString(Filter))
  add(path_565114, "userName", newJString(userName))
  result = call_565113.call(path_565114, query_565115, nil, nil, nil)

var serviceFabricsList* = Call_ServiceFabricsList_565100(
    name: "serviceFabricsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics",
    validator: validate_ServiceFabricsList_565101, base: "",
    url: url_ServiceFabricsList_565102, schemes: {Scheme.Https})
type
  Call_ServiceFabricsCreateOrUpdate_565130 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricsCreateOrUpdate_565132(protocol: Scheme; host: string;
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

proc validate_ServiceFabricsCreateOrUpdate_565131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing service fabric. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565133 = path.getOrDefault("labName")
  valid_565133 = validateParameter(valid_565133, JString, required = true,
                                 default = nil)
  if valid_565133 != nil:
    section.add "labName", valid_565133
  var valid_565134 = path.getOrDefault("name")
  valid_565134 = validateParameter(valid_565134, JString, required = true,
                                 default = nil)
  if valid_565134 != nil:
    section.add "name", valid_565134
  var valid_565135 = path.getOrDefault("subscriptionId")
  valid_565135 = validateParameter(valid_565135, JString, required = true,
                                 default = nil)
  if valid_565135 != nil:
    section.add "subscriptionId", valid_565135
  var valid_565136 = path.getOrDefault("resourceGroupName")
  valid_565136 = validateParameter(valid_565136, JString, required = true,
                                 default = nil)
  if valid_565136 != nil:
    section.add "resourceGroupName", valid_565136
  var valid_565137 = path.getOrDefault("userName")
  valid_565137 = validateParameter(valid_565137, JString, required = true,
                                 default = nil)
  if valid_565137 != nil:
    section.add "userName", valid_565137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565138 = query.getOrDefault("api-version")
  valid_565138 = validateParameter(valid_565138, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565138 != nil:
    section.add "api-version", valid_565138
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

proc call*(call_565140: Call_ServiceFabricsCreateOrUpdate_565130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing service fabric. This operation can take a while to complete.
  ## 
  let valid = call_565140.validator(path, query, header, formData, body)
  let scheme = call_565140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565140.url(scheme.get, call_565140.host, call_565140.base,
                         call_565140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565140, url, valid)

proc call*(call_565141: Call_ServiceFabricsCreateOrUpdate_565130; labName: string;
          serviceFabric: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsCreateOrUpdate
  ## Create or replace an existing service fabric. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565142 = newJObject()
  var query_565143 = newJObject()
  var body_565144 = newJObject()
  add(path_565142, "labName", newJString(labName))
  add(query_565143, "api-version", newJString(apiVersion))
  if serviceFabric != nil:
    body_565144 = serviceFabric
  add(path_565142, "name", newJString(name))
  add(path_565142, "subscriptionId", newJString(subscriptionId))
  add(path_565142, "resourceGroupName", newJString(resourceGroupName))
  add(path_565142, "userName", newJString(userName))
  result = call_565141.call(path_565142, query_565143, nil, nil, body_565144)

var serviceFabricsCreateOrUpdate* = Call_ServiceFabricsCreateOrUpdate_565130(
    name: "serviceFabricsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsCreateOrUpdate_565131, base: "",
    url: url_ServiceFabricsCreateOrUpdate_565132, schemes: {Scheme.Https})
type
  Call_ServiceFabricsGet_565116 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricsGet_565118(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceFabricsGet_565117(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get service fabric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565119 = path.getOrDefault("labName")
  valid_565119 = validateParameter(valid_565119, JString, required = true,
                                 default = nil)
  if valid_565119 != nil:
    section.add "labName", valid_565119
  var valid_565120 = path.getOrDefault("name")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "name", valid_565120
  var valid_565121 = path.getOrDefault("subscriptionId")
  valid_565121 = validateParameter(valid_565121, JString, required = true,
                                 default = nil)
  if valid_565121 != nil:
    section.add "subscriptionId", valid_565121
  var valid_565122 = path.getOrDefault("resourceGroupName")
  valid_565122 = validateParameter(valid_565122, JString, required = true,
                                 default = nil)
  if valid_565122 != nil:
    section.add "resourceGroupName", valid_565122
  var valid_565123 = path.getOrDefault("userName")
  valid_565123 = validateParameter(valid_565123, JString, required = true,
                                 default = nil)
  if valid_565123 != nil:
    section.add "userName", valid_565123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565124 = query.getOrDefault("api-version")
  valid_565124 = validateParameter(valid_565124, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565124 != nil:
    section.add "api-version", valid_565124
  var valid_565125 = query.getOrDefault("$expand")
  valid_565125 = validateParameter(valid_565125, JString, required = false,
                                 default = nil)
  if valid_565125 != nil:
    section.add "$expand", valid_565125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565126: Call_ServiceFabricsGet_565116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service fabric.
  ## 
  let valid = call_565126.validator(path, query, header, formData, body)
  let scheme = call_565126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565126.url(scheme.get, call_565126.host, call_565126.base,
                         call_565126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565126, url, valid)

proc call*(call_565127: Call_ServiceFabricsGet_565116; labName: string; name: string;
          subscriptionId: string; resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
  ## serviceFabricsGet
  ## Get service fabric.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=applicableSchedule)'
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565128 = newJObject()
  var query_565129 = newJObject()
  add(path_565128, "labName", newJString(labName))
  add(query_565129, "api-version", newJString(apiVersion))
  add(query_565129, "$expand", newJString(Expand))
  add(path_565128, "name", newJString(name))
  add(path_565128, "subscriptionId", newJString(subscriptionId))
  add(path_565128, "resourceGroupName", newJString(resourceGroupName))
  add(path_565128, "userName", newJString(userName))
  result = call_565127.call(path_565128, query_565129, nil, nil, nil)

var serviceFabricsGet* = Call_ServiceFabricsGet_565116(name: "serviceFabricsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsGet_565117, base: "",
    url: url_ServiceFabricsGet_565118, schemes: {Scheme.Https})
type
  Call_ServiceFabricsUpdate_565158 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricsUpdate_565160(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceFabricsUpdate_565159(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of service fabrics. All other properties will be ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565161 = path.getOrDefault("labName")
  valid_565161 = validateParameter(valid_565161, JString, required = true,
                                 default = nil)
  if valid_565161 != nil:
    section.add "labName", valid_565161
  var valid_565162 = path.getOrDefault("name")
  valid_565162 = validateParameter(valid_565162, JString, required = true,
                                 default = nil)
  if valid_565162 != nil:
    section.add "name", valid_565162
  var valid_565163 = path.getOrDefault("subscriptionId")
  valid_565163 = validateParameter(valid_565163, JString, required = true,
                                 default = nil)
  if valid_565163 != nil:
    section.add "subscriptionId", valid_565163
  var valid_565164 = path.getOrDefault("resourceGroupName")
  valid_565164 = validateParameter(valid_565164, JString, required = true,
                                 default = nil)
  if valid_565164 != nil:
    section.add "resourceGroupName", valid_565164
  var valid_565165 = path.getOrDefault("userName")
  valid_565165 = validateParameter(valid_565165, JString, required = true,
                                 default = nil)
  if valid_565165 != nil:
    section.add "userName", valid_565165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565166 = query.getOrDefault("api-version")
  valid_565166 = validateParameter(valid_565166, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565166 != nil:
    section.add "api-version", valid_565166
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

proc call*(call_565168: Call_ServiceFabricsUpdate_565158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of service fabrics. All other properties will be ignored.
  ## 
  let valid = call_565168.validator(path, query, header, formData, body)
  let scheme = call_565168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565168.url(scheme.get, call_565168.host, call_565168.base,
                         call_565168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565168, url, valid)

proc call*(call_565169: Call_ServiceFabricsUpdate_565158; labName: string;
          serviceFabric: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsUpdate
  ## Allows modifying tags of service fabrics. All other properties will be ignored.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   serviceFabric: JObject (required)
  ##                : A Service Fabric.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565170 = newJObject()
  var query_565171 = newJObject()
  var body_565172 = newJObject()
  add(path_565170, "labName", newJString(labName))
  add(query_565171, "api-version", newJString(apiVersion))
  if serviceFabric != nil:
    body_565172 = serviceFabric
  add(path_565170, "name", newJString(name))
  add(path_565170, "subscriptionId", newJString(subscriptionId))
  add(path_565170, "resourceGroupName", newJString(resourceGroupName))
  add(path_565170, "userName", newJString(userName))
  result = call_565169.call(path_565170, query_565171, nil, nil, body_565172)

var serviceFabricsUpdate* = Call_ServiceFabricsUpdate_565158(
    name: "serviceFabricsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsUpdate_565159, base: "",
    url: url_ServiceFabricsUpdate_565160, schemes: {Scheme.Https})
type
  Call_ServiceFabricsDelete_565145 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricsDelete_565147(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceFabricsDelete_565146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete service fabric. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565148 = path.getOrDefault("labName")
  valid_565148 = validateParameter(valid_565148, JString, required = true,
                                 default = nil)
  if valid_565148 != nil:
    section.add "labName", valid_565148
  var valid_565149 = path.getOrDefault("name")
  valid_565149 = validateParameter(valid_565149, JString, required = true,
                                 default = nil)
  if valid_565149 != nil:
    section.add "name", valid_565149
  var valid_565150 = path.getOrDefault("subscriptionId")
  valid_565150 = validateParameter(valid_565150, JString, required = true,
                                 default = nil)
  if valid_565150 != nil:
    section.add "subscriptionId", valid_565150
  var valid_565151 = path.getOrDefault("resourceGroupName")
  valid_565151 = validateParameter(valid_565151, JString, required = true,
                                 default = nil)
  if valid_565151 != nil:
    section.add "resourceGroupName", valid_565151
  var valid_565152 = path.getOrDefault("userName")
  valid_565152 = validateParameter(valid_565152, JString, required = true,
                                 default = nil)
  if valid_565152 != nil:
    section.add "userName", valid_565152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565153 = query.getOrDefault("api-version")
  valid_565153 = validateParameter(valid_565153, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565153 != nil:
    section.add "api-version", valid_565153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565154: Call_ServiceFabricsDelete_565145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete service fabric. This operation can take a while to complete.
  ## 
  let valid = call_565154.validator(path, query, header, formData, body)
  let scheme = call_565154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565154.url(scheme.get, call_565154.host, call_565154.base,
                         call_565154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565154, url, valid)

proc call*(call_565155: Call_ServiceFabricsDelete_565145; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          userName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsDelete
  ## Delete service fabric. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565156 = newJObject()
  var query_565157 = newJObject()
  add(path_565156, "labName", newJString(labName))
  add(query_565157, "api-version", newJString(apiVersion))
  add(path_565156, "name", newJString(name))
  add(path_565156, "subscriptionId", newJString(subscriptionId))
  add(path_565156, "resourceGroupName", newJString(resourceGroupName))
  add(path_565156, "userName", newJString(userName))
  result = call_565155.call(path_565156, query_565157, nil, nil, nil)

var serviceFabricsDelete* = Call_ServiceFabricsDelete_565145(
    name: "serviceFabricsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}",
    validator: validate_ServiceFabricsDelete_565146, base: "",
    url: url_ServiceFabricsDelete_565147, schemes: {Scheme.Https})
type
  Call_ServiceFabricsListApplicableSchedules_565173 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricsListApplicableSchedules_565175(protocol: Scheme;
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

proc validate_ServiceFabricsListApplicableSchedules_565174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565176 = path.getOrDefault("labName")
  valid_565176 = validateParameter(valid_565176, JString, required = true,
                                 default = nil)
  if valid_565176 != nil:
    section.add "labName", valid_565176
  var valid_565177 = path.getOrDefault("name")
  valid_565177 = validateParameter(valid_565177, JString, required = true,
                                 default = nil)
  if valid_565177 != nil:
    section.add "name", valid_565177
  var valid_565178 = path.getOrDefault("subscriptionId")
  valid_565178 = validateParameter(valid_565178, JString, required = true,
                                 default = nil)
  if valid_565178 != nil:
    section.add "subscriptionId", valid_565178
  var valid_565179 = path.getOrDefault("resourceGroupName")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "resourceGroupName", valid_565179
  var valid_565180 = path.getOrDefault("userName")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "userName", valid_565180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565181 = query.getOrDefault("api-version")
  valid_565181 = validateParameter(valid_565181, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565181 != nil:
    section.add "api-version", valid_565181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565182: Call_ServiceFabricsListApplicableSchedules_565173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  let valid = call_565182.validator(path, query, header, formData, body)
  let scheme = call_565182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565182.url(scheme.get, call_565182.host, call_565182.base,
                         call_565182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565182, url, valid)

proc call*(call_565183: Call_ServiceFabricsListApplicableSchedules_565173;
          labName: string; name: string; subscriptionId: string;
          resourceGroupName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsListApplicableSchedules
  ## Lists the applicable start/stop schedules, if any.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565184 = newJObject()
  var query_565185 = newJObject()
  add(path_565184, "labName", newJString(labName))
  add(query_565185, "api-version", newJString(apiVersion))
  add(path_565184, "name", newJString(name))
  add(path_565184, "subscriptionId", newJString(subscriptionId))
  add(path_565184, "resourceGroupName", newJString(resourceGroupName))
  add(path_565184, "userName", newJString(userName))
  result = call_565183.call(path_565184, query_565185, nil, nil, nil)

var serviceFabricsListApplicableSchedules* = Call_ServiceFabricsListApplicableSchedules_565173(
    name: "serviceFabricsListApplicableSchedules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}/listApplicableSchedules",
    validator: validate_ServiceFabricsListApplicableSchedules_565174, base: "",
    url: url_ServiceFabricsListApplicableSchedules_565175, schemes: {Scheme.Https})
type
  Call_ServiceFabricsStart_565186 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricsStart_565188(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceFabricsStart_565187(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Start a service fabric. This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565189 = path.getOrDefault("labName")
  valid_565189 = validateParameter(valid_565189, JString, required = true,
                                 default = nil)
  if valid_565189 != nil:
    section.add "labName", valid_565189
  var valid_565190 = path.getOrDefault("name")
  valid_565190 = validateParameter(valid_565190, JString, required = true,
                                 default = nil)
  if valid_565190 != nil:
    section.add "name", valid_565190
  var valid_565191 = path.getOrDefault("subscriptionId")
  valid_565191 = validateParameter(valid_565191, JString, required = true,
                                 default = nil)
  if valid_565191 != nil:
    section.add "subscriptionId", valid_565191
  var valid_565192 = path.getOrDefault("resourceGroupName")
  valid_565192 = validateParameter(valid_565192, JString, required = true,
                                 default = nil)
  if valid_565192 != nil:
    section.add "resourceGroupName", valid_565192
  var valid_565193 = path.getOrDefault("userName")
  valid_565193 = validateParameter(valid_565193, JString, required = true,
                                 default = nil)
  if valid_565193 != nil:
    section.add "userName", valid_565193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565194 = query.getOrDefault("api-version")
  valid_565194 = validateParameter(valid_565194, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565194 != nil:
    section.add "api-version", valid_565194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565195: Call_ServiceFabricsStart_565186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a service fabric. This operation can take a while to complete.
  ## 
  let valid = call_565195.validator(path, query, header, formData, body)
  let scheme = call_565195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565195.url(scheme.get, call_565195.host, call_565195.base,
                         call_565195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565195, url, valid)

proc call*(call_565196: Call_ServiceFabricsStart_565186; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          userName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsStart
  ## Start a service fabric. This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565197 = newJObject()
  var query_565198 = newJObject()
  add(path_565197, "labName", newJString(labName))
  add(query_565198, "api-version", newJString(apiVersion))
  add(path_565197, "name", newJString(name))
  add(path_565197, "subscriptionId", newJString(subscriptionId))
  add(path_565197, "resourceGroupName", newJString(resourceGroupName))
  add(path_565197, "userName", newJString(userName))
  result = call_565196.call(path_565197, query_565198, nil, nil, nil)

var serviceFabricsStart* = Call_ServiceFabricsStart_565186(
    name: "serviceFabricsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}/start",
    validator: validate_ServiceFabricsStart_565187, base: "",
    url: url_ServiceFabricsStart_565188, schemes: {Scheme.Https})
type
  Call_ServiceFabricsStop_565199 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricsStop_565201(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceFabricsStop_565200(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Stop a service fabric This operation can take a while to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   labName: JString (required)
  ##          : The name of the lab.
  ##   name: JString (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565202 = path.getOrDefault("labName")
  valid_565202 = validateParameter(valid_565202, JString, required = true,
                                 default = nil)
  if valid_565202 != nil:
    section.add "labName", valid_565202
  var valid_565203 = path.getOrDefault("name")
  valid_565203 = validateParameter(valid_565203, JString, required = true,
                                 default = nil)
  if valid_565203 != nil:
    section.add "name", valid_565203
  var valid_565204 = path.getOrDefault("subscriptionId")
  valid_565204 = validateParameter(valid_565204, JString, required = true,
                                 default = nil)
  if valid_565204 != nil:
    section.add "subscriptionId", valid_565204
  var valid_565205 = path.getOrDefault("resourceGroupName")
  valid_565205 = validateParameter(valid_565205, JString, required = true,
                                 default = nil)
  if valid_565205 != nil:
    section.add "resourceGroupName", valid_565205
  var valid_565206 = path.getOrDefault("userName")
  valid_565206 = validateParameter(valid_565206, JString, required = true,
                                 default = nil)
  if valid_565206 != nil:
    section.add "userName", valid_565206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565207 = query.getOrDefault("api-version")
  valid_565207 = validateParameter(valid_565207, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565207 != nil:
    section.add "api-version", valid_565207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565208: Call_ServiceFabricsStop_565199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a service fabric This operation can take a while to complete.
  ## 
  let valid = call_565208.validator(path, query, header, formData, body)
  let scheme = call_565208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565208.url(scheme.get, call_565208.host, call_565208.base,
                         call_565208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565208, url, valid)

proc call*(call_565209: Call_ServiceFabricsStop_565199; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          userName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricsStop
  ## Stop a service fabric This operation can take a while to complete.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : The name of the service fabric.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565210 = newJObject()
  var query_565211 = newJObject()
  add(path_565210, "labName", newJString(labName))
  add(query_565211, "api-version", newJString(apiVersion))
  add(path_565210, "name", newJString(name))
  add(path_565210, "subscriptionId", newJString(subscriptionId))
  add(path_565210, "resourceGroupName", newJString(resourceGroupName))
  add(path_565210, "userName", newJString(userName))
  result = call_565209.call(path_565210, query_565211, nil, nil, nil)

var serviceFabricsStop* = Call_ServiceFabricsStop_565199(
    name: "serviceFabricsStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{name}/stop",
    validator: validate_ServiceFabricsStop_565200, base: "",
    url: url_ServiceFabricsStop_565201, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesList_565212 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricSchedulesList_565214(protocol: Scheme; host: string;
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

proc validate_ServiceFabricSchedulesList_565213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List schedules in a given service fabric.
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
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565215 = path.getOrDefault("labName")
  valid_565215 = validateParameter(valid_565215, JString, required = true,
                                 default = nil)
  if valid_565215 != nil:
    section.add "labName", valid_565215
  var valid_565216 = path.getOrDefault("subscriptionId")
  valid_565216 = validateParameter(valid_565216, JString, required = true,
                                 default = nil)
  if valid_565216 != nil:
    section.add "subscriptionId", valid_565216
  var valid_565217 = path.getOrDefault("resourceGroupName")
  valid_565217 = validateParameter(valid_565217, JString, required = true,
                                 default = nil)
  if valid_565217 != nil:
    section.add "resourceGroupName", valid_565217
  var valid_565218 = path.getOrDefault("serviceFabricName")
  valid_565218 = validateParameter(valid_565218, JString, required = true,
                                 default = nil)
  if valid_565218 != nil:
    section.add "serviceFabricName", valid_565218
  var valid_565219 = path.getOrDefault("userName")
  valid_565219 = validateParameter(valid_565219, JString, required = true,
                                 default = nil)
  if valid_565219 != nil:
    section.add "userName", valid_565219
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_565220 = query.getOrDefault("$top")
  valid_565220 = validateParameter(valid_565220, JInt, required = false, default = nil)
  if valid_565220 != nil:
    section.add "$top", valid_565220
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565221 = query.getOrDefault("api-version")
  valid_565221 = validateParameter(valid_565221, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565221 != nil:
    section.add "api-version", valid_565221
  var valid_565222 = query.getOrDefault("$expand")
  valid_565222 = validateParameter(valid_565222, JString, required = false,
                                 default = nil)
  if valid_565222 != nil:
    section.add "$expand", valid_565222
  var valid_565223 = query.getOrDefault("$orderby")
  valid_565223 = validateParameter(valid_565223, JString, required = false,
                                 default = nil)
  if valid_565223 != nil:
    section.add "$orderby", valid_565223
  var valid_565224 = query.getOrDefault("$filter")
  valid_565224 = validateParameter(valid_565224, JString, required = false,
                                 default = nil)
  if valid_565224 != nil:
    section.add "$filter", valid_565224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565225: Call_ServiceFabricSchedulesList_565212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given service fabric.
  ## 
  let valid = call_565225.validator(path, query, header, formData, body)
  let scheme = call_565225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565225.url(scheme.get, call_565225.host, call_565225.base,
                         call_565225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565225, url, valid)

proc call*(call_565226: Call_ServiceFabricSchedulesList_565212; labName: string;
          subscriptionId: string; resourceGroupName: string;
          serviceFabricName: string; userName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## serviceFabricSchedulesList
  ## List schedules in a given service fabric.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565227 = newJObject()
  var query_565228 = newJObject()
  add(path_565227, "labName", newJString(labName))
  add(query_565228, "$top", newJInt(Top))
  add(query_565228, "api-version", newJString(apiVersion))
  add(query_565228, "$expand", newJString(Expand))
  add(path_565227, "subscriptionId", newJString(subscriptionId))
  add(query_565228, "$orderby", newJString(Orderby))
  add(path_565227, "resourceGroupName", newJString(resourceGroupName))
  add(query_565228, "$filter", newJString(Filter))
  add(path_565227, "serviceFabricName", newJString(serviceFabricName))
  add(path_565227, "userName", newJString(userName))
  result = call_565226.call(path_565227, query_565228, nil, nil, nil)

var serviceFabricSchedulesList* = Call_ServiceFabricSchedulesList_565212(
    name: "serviceFabricSchedulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules",
    validator: validate_ServiceFabricSchedulesList_565213, base: "",
    url: url_ServiceFabricSchedulesList_565214, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesCreateOrUpdate_565244 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricSchedulesCreateOrUpdate_565246(protocol: Scheme;
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

proc validate_ServiceFabricSchedulesCreateOrUpdate_565245(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565247 = path.getOrDefault("labName")
  valid_565247 = validateParameter(valid_565247, JString, required = true,
                                 default = nil)
  if valid_565247 != nil:
    section.add "labName", valid_565247
  var valid_565248 = path.getOrDefault("name")
  valid_565248 = validateParameter(valid_565248, JString, required = true,
                                 default = nil)
  if valid_565248 != nil:
    section.add "name", valid_565248
  var valid_565249 = path.getOrDefault("subscriptionId")
  valid_565249 = validateParameter(valid_565249, JString, required = true,
                                 default = nil)
  if valid_565249 != nil:
    section.add "subscriptionId", valid_565249
  var valid_565250 = path.getOrDefault("resourceGroupName")
  valid_565250 = validateParameter(valid_565250, JString, required = true,
                                 default = nil)
  if valid_565250 != nil:
    section.add "resourceGroupName", valid_565250
  var valid_565251 = path.getOrDefault("serviceFabricName")
  valid_565251 = validateParameter(valid_565251, JString, required = true,
                                 default = nil)
  if valid_565251 != nil:
    section.add "serviceFabricName", valid_565251
  var valid_565252 = path.getOrDefault("userName")
  valid_565252 = validateParameter(valid_565252, JString, required = true,
                                 default = nil)
  if valid_565252 != nil:
    section.add "userName", valid_565252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565253 = query.getOrDefault("api-version")
  valid_565253 = validateParameter(valid_565253, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565253 != nil:
    section.add "api-version", valid_565253
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

proc call*(call_565255: Call_ServiceFabricSchedulesCreateOrUpdate_565244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_565255.validator(path, query, header, formData, body)
  let scheme = call_565255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565255.url(scheme.get, call_565255.host, call_565255.base,
                         call_565255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565255, url, valid)

proc call*(call_565256: Call_ServiceFabricSchedulesCreateOrUpdate_565244;
          labName: string; name: string; subscriptionId: string;
          resourceGroupName: string; schedule: JsonNode; serviceFabricName: string;
          userName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesCreateOrUpdate
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
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565257 = newJObject()
  var query_565258 = newJObject()
  var body_565259 = newJObject()
  add(path_565257, "labName", newJString(labName))
  add(query_565258, "api-version", newJString(apiVersion))
  add(path_565257, "name", newJString(name))
  add(path_565257, "subscriptionId", newJString(subscriptionId))
  add(path_565257, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565259 = schedule
  add(path_565257, "serviceFabricName", newJString(serviceFabricName))
  add(path_565257, "userName", newJString(userName))
  result = call_565256.call(path_565257, query_565258, nil, nil, body_565259)

var serviceFabricSchedulesCreateOrUpdate* = Call_ServiceFabricSchedulesCreateOrUpdate_565244(
    name: "serviceFabricSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesCreateOrUpdate_565245, base: "",
    url: url_ServiceFabricSchedulesCreateOrUpdate_565246, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesGet_565229 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricSchedulesGet_565231(protocol: Scheme; host: string;
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

proc validate_ServiceFabricSchedulesGet_565230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565232 = path.getOrDefault("labName")
  valid_565232 = validateParameter(valid_565232, JString, required = true,
                                 default = nil)
  if valid_565232 != nil:
    section.add "labName", valid_565232
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
  var valid_565236 = path.getOrDefault("serviceFabricName")
  valid_565236 = validateParameter(valid_565236, JString, required = true,
                                 default = nil)
  if valid_565236 != nil:
    section.add "serviceFabricName", valid_565236
  var valid_565237 = path.getOrDefault("userName")
  valid_565237 = validateParameter(valid_565237, JString, required = true,
                                 default = nil)
  if valid_565237 != nil:
    section.add "userName", valid_565237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565238 = query.getOrDefault("api-version")
  valid_565238 = validateParameter(valid_565238, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565238 != nil:
    section.add "api-version", valid_565238
  var valid_565239 = query.getOrDefault("$expand")
  valid_565239 = validateParameter(valid_565239, JString, required = false,
                                 default = nil)
  if valid_565239 != nil:
    section.add "$expand", valid_565239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565240: Call_ServiceFabricSchedulesGet_565229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_565240.validator(path, query, header, formData, body)
  let scheme = call_565240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565240.url(scheme.get, call_565240.host, call_565240.base,
                         call_565240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565240, url, valid)

proc call*(call_565241: Call_ServiceFabricSchedulesGet_565229; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          serviceFabricName: string; userName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
  ## serviceFabricSchedulesGet
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
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565242 = newJObject()
  var query_565243 = newJObject()
  add(path_565242, "labName", newJString(labName))
  add(query_565243, "api-version", newJString(apiVersion))
  add(query_565243, "$expand", newJString(Expand))
  add(path_565242, "name", newJString(name))
  add(path_565242, "subscriptionId", newJString(subscriptionId))
  add(path_565242, "resourceGroupName", newJString(resourceGroupName))
  add(path_565242, "serviceFabricName", newJString(serviceFabricName))
  add(path_565242, "userName", newJString(userName))
  result = call_565241.call(path_565242, query_565243, nil, nil, nil)

var serviceFabricSchedulesGet* = Call_ServiceFabricSchedulesGet_565229(
    name: "serviceFabricSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesGet_565230, base: "",
    url: url_ServiceFabricSchedulesGet_565231, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesUpdate_565274 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricSchedulesUpdate_565276(protocol: Scheme; host: string;
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

proc validate_ServiceFabricSchedulesUpdate_565275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565277 = path.getOrDefault("labName")
  valid_565277 = validateParameter(valid_565277, JString, required = true,
                                 default = nil)
  if valid_565277 != nil:
    section.add "labName", valid_565277
  var valid_565278 = path.getOrDefault("name")
  valid_565278 = validateParameter(valid_565278, JString, required = true,
                                 default = nil)
  if valid_565278 != nil:
    section.add "name", valid_565278
  var valid_565279 = path.getOrDefault("subscriptionId")
  valid_565279 = validateParameter(valid_565279, JString, required = true,
                                 default = nil)
  if valid_565279 != nil:
    section.add "subscriptionId", valid_565279
  var valid_565280 = path.getOrDefault("resourceGroupName")
  valid_565280 = validateParameter(valid_565280, JString, required = true,
                                 default = nil)
  if valid_565280 != nil:
    section.add "resourceGroupName", valid_565280
  var valid_565281 = path.getOrDefault("serviceFabricName")
  valid_565281 = validateParameter(valid_565281, JString, required = true,
                                 default = nil)
  if valid_565281 != nil:
    section.add "serviceFabricName", valid_565281
  var valid_565282 = path.getOrDefault("userName")
  valid_565282 = validateParameter(valid_565282, JString, required = true,
                                 default = nil)
  if valid_565282 != nil:
    section.add "userName", valid_565282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565283 = query.getOrDefault("api-version")
  valid_565283 = validateParameter(valid_565283, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565283 != nil:
    section.add "api-version", valid_565283
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

proc call*(call_565285: Call_ServiceFabricSchedulesUpdate_565274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_565285.validator(path, query, header, formData, body)
  let scheme = call_565285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565285.url(scheme.get, call_565285.host, call_565285.base,
                         call_565285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565285, url, valid)

proc call*(call_565286: Call_ServiceFabricSchedulesUpdate_565274; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          schedule: JsonNode; serviceFabricName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565287 = newJObject()
  var query_565288 = newJObject()
  var body_565289 = newJObject()
  add(path_565287, "labName", newJString(labName))
  add(query_565288, "api-version", newJString(apiVersion))
  add(path_565287, "name", newJString(name))
  add(path_565287, "subscriptionId", newJString(subscriptionId))
  add(path_565287, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565289 = schedule
  add(path_565287, "serviceFabricName", newJString(serviceFabricName))
  add(path_565287, "userName", newJString(userName))
  result = call_565286.call(path_565287, query_565288, nil, nil, body_565289)

var serviceFabricSchedulesUpdate* = Call_ServiceFabricSchedulesUpdate_565274(
    name: "serviceFabricSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesUpdate_565275, base: "",
    url: url_ServiceFabricSchedulesUpdate_565276, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesDelete_565260 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricSchedulesDelete_565262(protocol: Scheme; host: string;
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

proc validate_ServiceFabricSchedulesDelete_565261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565263 = path.getOrDefault("labName")
  valid_565263 = validateParameter(valid_565263, JString, required = true,
                                 default = nil)
  if valid_565263 != nil:
    section.add "labName", valid_565263
  var valid_565264 = path.getOrDefault("name")
  valid_565264 = validateParameter(valid_565264, JString, required = true,
                                 default = nil)
  if valid_565264 != nil:
    section.add "name", valid_565264
  var valid_565265 = path.getOrDefault("subscriptionId")
  valid_565265 = validateParameter(valid_565265, JString, required = true,
                                 default = nil)
  if valid_565265 != nil:
    section.add "subscriptionId", valid_565265
  var valid_565266 = path.getOrDefault("resourceGroupName")
  valid_565266 = validateParameter(valid_565266, JString, required = true,
                                 default = nil)
  if valid_565266 != nil:
    section.add "resourceGroupName", valid_565266
  var valid_565267 = path.getOrDefault("serviceFabricName")
  valid_565267 = validateParameter(valid_565267, JString, required = true,
                                 default = nil)
  if valid_565267 != nil:
    section.add "serviceFabricName", valid_565267
  var valid_565268 = path.getOrDefault("userName")
  valid_565268 = validateParameter(valid_565268, JString, required = true,
                                 default = nil)
  if valid_565268 != nil:
    section.add "userName", valid_565268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565269 = query.getOrDefault("api-version")
  valid_565269 = validateParameter(valid_565269, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565269 != nil:
    section.add "api-version", valid_565269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565270: Call_ServiceFabricSchedulesDelete_565260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_565270.validator(path, query, header, formData, body)
  let scheme = call_565270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565270.url(scheme.get, call_565270.host, call_565270.base,
                         call_565270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565270, url, valid)

proc call*(call_565271: Call_ServiceFabricSchedulesDelete_565260; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          serviceFabricName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesDelete
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
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565272 = newJObject()
  var query_565273 = newJObject()
  add(path_565272, "labName", newJString(labName))
  add(query_565273, "api-version", newJString(apiVersion))
  add(path_565272, "name", newJString(name))
  add(path_565272, "subscriptionId", newJString(subscriptionId))
  add(path_565272, "resourceGroupName", newJString(resourceGroupName))
  add(path_565272, "serviceFabricName", newJString(serviceFabricName))
  add(path_565272, "userName", newJString(userName))
  result = call_565271.call(path_565272, query_565273, nil, nil, nil)

var serviceFabricSchedulesDelete* = Call_ServiceFabricSchedulesDelete_565260(
    name: "serviceFabricSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}",
    validator: validate_ServiceFabricSchedulesDelete_565261, base: "",
    url: url_ServiceFabricSchedulesDelete_565262, schemes: {Scheme.Https})
type
  Call_ServiceFabricSchedulesExecute_565290 = ref object of OpenApiRestCall_563564
proc url_ServiceFabricSchedulesExecute_565292(protocol: Scheme; host: string;
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

proc validate_ServiceFabricSchedulesExecute_565291(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  ##   serviceFabricName: JString (required)
  ##                    : The name of the service fabric.
  ##   userName: JString (required)
  ##           : The name of the user profile.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `labName` field"
  var valid_565293 = path.getOrDefault("labName")
  valid_565293 = validateParameter(valid_565293, JString, required = true,
                                 default = nil)
  if valid_565293 != nil:
    section.add "labName", valid_565293
  var valid_565294 = path.getOrDefault("name")
  valid_565294 = validateParameter(valid_565294, JString, required = true,
                                 default = nil)
  if valid_565294 != nil:
    section.add "name", valid_565294
  var valid_565295 = path.getOrDefault("subscriptionId")
  valid_565295 = validateParameter(valid_565295, JString, required = true,
                                 default = nil)
  if valid_565295 != nil:
    section.add "subscriptionId", valid_565295
  var valid_565296 = path.getOrDefault("resourceGroupName")
  valid_565296 = validateParameter(valid_565296, JString, required = true,
                                 default = nil)
  if valid_565296 != nil:
    section.add "resourceGroupName", valid_565296
  var valid_565297 = path.getOrDefault("serviceFabricName")
  valid_565297 = validateParameter(valid_565297, JString, required = true,
                                 default = nil)
  if valid_565297 != nil:
    section.add "serviceFabricName", valid_565297
  var valid_565298 = path.getOrDefault("userName")
  valid_565298 = validateParameter(valid_565298, JString, required = true,
                                 default = nil)
  if valid_565298 != nil:
    section.add "userName", valid_565298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565299 = query.getOrDefault("api-version")
  valid_565299 = validateParameter(valid_565299, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565299 != nil:
    section.add "api-version", valid_565299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565300: Call_ServiceFabricSchedulesExecute_565290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_565300.validator(path, query, header, formData, body)
  let scheme = call_565300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565300.url(scheme.get, call_565300.host, call_565300.base,
                         call_565300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565300, url, valid)

proc call*(call_565301: Call_ServiceFabricSchedulesExecute_565290; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          serviceFabricName: string; userName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## serviceFabricSchedulesExecute
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
  ##   serviceFabricName: string (required)
  ##                    : The name of the service fabric.
  ##   userName: string (required)
  ##           : The name of the user profile.
  var path_565302 = newJObject()
  var query_565303 = newJObject()
  add(path_565302, "labName", newJString(labName))
  add(query_565303, "api-version", newJString(apiVersion))
  add(path_565302, "name", newJString(name))
  add(path_565302, "subscriptionId", newJString(subscriptionId))
  add(path_565302, "resourceGroupName", newJString(resourceGroupName))
  add(path_565302, "serviceFabricName", newJString(serviceFabricName))
  add(path_565302, "userName", newJString(userName))
  result = call_565301.call(path_565302, query_565303, nil, nil, nil)

var serviceFabricSchedulesExecute* = Call_ServiceFabricSchedulesExecute_565290(
    name: "serviceFabricSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/users/{userName}/servicefabrics/{serviceFabricName}/schedules/{name}/execute",
    validator: validate_ServiceFabricSchedulesExecute_565291, base: "",
    url: url_ServiceFabricSchedulesExecute_565292, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_565304 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesList_565306(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesList_565305(path: JsonNode; query: JsonNode;
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
  var valid_565307 = path.getOrDefault("labName")
  valid_565307 = validateParameter(valid_565307, JString, required = true,
                                 default = nil)
  if valid_565307 != nil:
    section.add "labName", valid_565307
  var valid_565308 = path.getOrDefault("subscriptionId")
  valid_565308 = validateParameter(valid_565308, JString, required = true,
                                 default = nil)
  if valid_565308 != nil:
    section.add "subscriptionId", valid_565308
  var valid_565309 = path.getOrDefault("resourceGroupName")
  valid_565309 = validateParameter(valid_565309, JString, required = true,
                                 default = nil)
  if valid_565309 != nil:
    section.add "resourceGroupName", valid_565309
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_565310 = query.getOrDefault("$top")
  valid_565310 = validateParameter(valid_565310, JInt, required = false, default = nil)
  if valid_565310 != nil:
    section.add "$top", valid_565310
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565311 = query.getOrDefault("api-version")
  valid_565311 = validateParameter(valid_565311, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565311 != nil:
    section.add "api-version", valid_565311
  var valid_565312 = query.getOrDefault("$expand")
  valid_565312 = validateParameter(valid_565312, JString, required = false,
                                 default = nil)
  if valid_565312 != nil:
    section.add "$expand", valid_565312
  var valid_565313 = query.getOrDefault("$orderby")
  valid_565313 = validateParameter(valid_565313, JString, required = false,
                                 default = nil)
  if valid_565313 != nil:
    section.add "$orderby", valid_565313
  var valid_565314 = query.getOrDefault("$filter")
  valid_565314 = validateParameter(valid_565314, JString, required = false,
                                 default = nil)
  if valid_565314 != nil:
    section.add "$filter", valid_565314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565315: Call_VirtualMachinesList_565304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual machines in a given lab.
  ## 
  let valid = call_565315.validator(path, query, header, formData, body)
  let scheme = call_565315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565315.url(scheme.get, call_565315.host, call_565315.base,
                         call_565315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565315, url, valid)

proc call*(call_565316: Call_VirtualMachinesList_565304; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## virtualMachinesList
  ## List virtual machines in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_565317 = newJObject()
  var query_565318 = newJObject()
  add(path_565317, "labName", newJString(labName))
  add(query_565318, "$top", newJInt(Top))
  add(query_565318, "api-version", newJString(apiVersion))
  add(query_565318, "$expand", newJString(Expand))
  add(path_565317, "subscriptionId", newJString(subscriptionId))
  add(query_565318, "$orderby", newJString(Orderby))
  add(path_565317, "resourceGroupName", newJString(resourceGroupName))
  add(query_565318, "$filter", newJString(Filter))
  result = call_565316.call(path_565317, query_565318, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_565304(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines",
    validator: validate_VirtualMachinesList_565305, base: "",
    url: url_VirtualMachinesList_565306, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_565332 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesCreateOrUpdate_565334(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesCreateOrUpdate_565333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or replace an existing virtual machine. This operation can take a while to complete.
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
  var valid_565335 = path.getOrDefault("labName")
  valid_565335 = validateParameter(valid_565335, JString, required = true,
                                 default = nil)
  if valid_565335 != nil:
    section.add "labName", valid_565335
  var valid_565336 = path.getOrDefault("name")
  valid_565336 = validateParameter(valid_565336, JString, required = true,
                                 default = nil)
  if valid_565336 != nil:
    section.add "name", valid_565336
  var valid_565337 = path.getOrDefault("subscriptionId")
  valid_565337 = validateParameter(valid_565337, JString, required = true,
                                 default = nil)
  if valid_565337 != nil:
    section.add "subscriptionId", valid_565337
  var valid_565338 = path.getOrDefault("resourceGroupName")
  valid_565338 = validateParameter(valid_565338, JString, required = true,
                                 default = nil)
  if valid_565338 != nil:
    section.add "resourceGroupName", valid_565338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565339 = query.getOrDefault("api-version")
  valid_565339 = validateParameter(valid_565339, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565339 != nil:
    section.add "api-version", valid_565339
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

proc call*(call_565341: Call_VirtualMachinesCreateOrUpdate_565332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565341.validator(path, query, header, formData, body)
  let scheme = call_565341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565341.url(scheme.get, call_565341.host, call_565341.base,
                         call_565341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565341, url, valid)

proc call*(call_565342: Call_VirtualMachinesCreateOrUpdate_565332; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          labVirtualMachine: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesCreateOrUpdate
  ## Create or replace an existing virtual machine. This operation can take a while to complete.
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
  var path_565343 = newJObject()
  var query_565344 = newJObject()
  var body_565345 = newJObject()
  add(path_565343, "labName", newJString(labName))
  add(query_565344, "api-version", newJString(apiVersion))
  add(path_565343, "name", newJString(name))
  add(path_565343, "subscriptionId", newJString(subscriptionId))
  add(path_565343, "resourceGroupName", newJString(resourceGroupName))
  if labVirtualMachine != nil:
    body_565345 = labVirtualMachine
  result = call_565342.call(path_565343, query_565344, nil, nil, body_565345)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_565332(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesCreateOrUpdate_565333, base: "",
    url: url_VirtualMachinesCreateOrUpdate_565334, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_565319 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesGet_565321(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesGet_565320(path: JsonNode; query: JsonNode;
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
  var valid_565322 = path.getOrDefault("labName")
  valid_565322 = validateParameter(valid_565322, JString, required = true,
                                 default = nil)
  if valid_565322 != nil:
    section.add "labName", valid_565322
  var valid_565323 = path.getOrDefault("name")
  valid_565323 = validateParameter(valid_565323, JString, required = true,
                                 default = nil)
  if valid_565323 != nil:
    section.add "name", valid_565323
  var valid_565324 = path.getOrDefault("subscriptionId")
  valid_565324 = validateParameter(valid_565324, JString, required = true,
                                 default = nil)
  if valid_565324 != nil:
    section.add "subscriptionId", valid_565324
  var valid_565325 = path.getOrDefault("resourceGroupName")
  valid_565325 = validateParameter(valid_565325, JString, required = true,
                                 default = nil)
  if valid_565325 != nil:
    section.add "resourceGroupName", valid_565325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=artifacts,computeVm,networkInterface,applicableSchedule)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565326 = query.getOrDefault("api-version")
  valid_565326 = validateParameter(valid_565326, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565326 != nil:
    section.add "api-version", valid_565326
  var valid_565327 = query.getOrDefault("$expand")
  valid_565327 = validateParameter(valid_565327, JString, required = false,
                                 default = nil)
  if valid_565327 != nil:
    section.add "$expand", valid_565327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565328: Call_VirtualMachinesGet_565319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual machine.
  ## 
  let valid = call_565328.validator(path, query, header, formData, body)
  let scheme = call_565328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565328.url(scheme.get, call_565328.host, call_565328.base,
                         call_565328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565328, url, valid)

proc call*(call_565329: Call_VirtualMachinesGet_565319; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_565330 = newJObject()
  var query_565331 = newJObject()
  add(path_565330, "labName", newJString(labName))
  add(query_565331, "api-version", newJString(apiVersion))
  add(query_565331, "$expand", newJString(Expand))
  add(path_565330, "name", newJString(name))
  add(path_565330, "subscriptionId", newJString(subscriptionId))
  add(path_565330, "resourceGroupName", newJString(resourceGroupName))
  result = call_565329.call(path_565330, query_565331, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_565319(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesGet_565320, base: "",
    url: url_VirtualMachinesGet_565321, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_565358 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesUpdate_565360(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUpdate_565359(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of virtual machines. All other properties will be ignored.
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
  var valid_565361 = path.getOrDefault("labName")
  valid_565361 = validateParameter(valid_565361, JString, required = true,
                                 default = nil)
  if valid_565361 != nil:
    section.add "labName", valid_565361
  var valid_565362 = path.getOrDefault("name")
  valid_565362 = validateParameter(valid_565362, JString, required = true,
                                 default = nil)
  if valid_565362 != nil:
    section.add "name", valid_565362
  var valid_565363 = path.getOrDefault("subscriptionId")
  valid_565363 = validateParameter(valid_565363, JString, required = true,
                                 default = nil)
  if valid_565363 != nil:
    section.add "subscriptionId", valid_565363
  var valid_565364 = path.getOrDefault("resourceGroupName")
  valid_565364 = validateParameter(valid_565364, JString, required = true,
                                 default = nil)
  if valid_565364 != nil:
    section.add "resourceGroupName", valid_565364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565365 = query.getOrDefault("api-version")
  valid_565365 = validateParameter(valid_565365, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565365 != nil:
    section.add "api-version", valid_565365
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

proc call*(call_565367: Call_VirtualMachinesUpdate_565358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of virtual machines. All other properties will be ignored.
  ## 
  let valid = call_565367.validator(path, query, header, formData, body)
  let scheme = call_565367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565367.url(scheme.get, call_565367.host, call_565367.base,
                         call_565367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565367, url, valid)

proc call*(call_565368: Call_VirtualMachinesUpdate_565358; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          labVirtualMachine: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesUpdate
  ## Allows modifying tags of virtual machines. All other properties will be ignored.
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
  var path_565369 = newJObject()
  var query_565370 = newJObject()
  var body_565371 = newJObject()
  add(path_565369, "labName", newJString(labName))
  add(query_565370, "api-version", newJString(apiVersion))
  add(path_565369, "name", newJString(name))
  add(path_565369, "subscriptionId", newJString(subscriptionId))
  add(path_565369, "resourceGroupName", newJString(resourceGroupName))
  if labVirtualMachine != nil:
    body_565371 = labVirtualMachine
  result = call_565368.call(path_565369, query_565370, nil, nil, body_565371)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_565358(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesUpdate_565359, base: "",
    url: url_VirtualMachinesUpdate_565360, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_565346 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesDelete_565348(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesDelete_565347(path: JsonNode; query: JsonNode;
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
  var valid_565349 = path.getOrDefault("labName")
  valid_565349 = validateParameter(valid_565349, JString, required = true,
                                 default = nil)
  if valid_565349 != nil:
    section.add "labName", valid_565349
  var valid_565350 = path.getOrDefault("name")
  valid_565350 = validateParameter(valid_565350, JString, required = true,
                                 default = nil)
  if valid_565350 != nil:
    section.add "name", valid_565350
  var valid_565351 = path.getOrDefault("subscriptionId")
  valid_565351 = validateParameter(valid_565351, JString, required = true,
                                 default = nil)
  if valid_565351 != nil:
    section.add "subscriptionId", valid_565351
  var valid_565352 = path.getOrDefault("resourceGroupName")
  valid_565352 = validateParameter(valid_565352, JString, required = true,
                                 default = nil)
  if valid_565352 != nil:
    section.add "resourceGroupName", valid_565352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565353 = query.getOrDefault("api-version")
  valid_565353 = validateParameter(valid_565353, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565353 != nil:
    section.add "api-version", valid_565353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565354: Call_VirtualMachinesDelete_565346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565354.validator(path, query, header, formData, body)
  let scheme = call_565354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565354.url(scheme.get, call_565354.host, call_565354.base,
                         call_565354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565354, url, valid)

proc call*(call_565355: Call_VirtualMachinesDelete_565346; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565356 = newJObject()
  var query_565357 = newJObject()
  add(path_565356, "labName", newJString(labName))
  add(query_565357, "api-version", newJString(apiVersion))
  add(path_565356, "name", newJString(name))
  add(path_565356, "subscriptionId", newJString(subscriptionId))
  add(path_565356, "resourceGroupName", newJString(resourceGroupName))
  result = call_565355.call(path_565356, query_565357, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_565346(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}",
    validator: validate_VirtualMachinesDelete_565347, base: "",
    url: url_VirtualMachinesDelete_565348, schemes: {Scheme.Https})
type
  Call_VirtualMachinesAddDataDisk_565372 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesAddDataDisk_565374(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesAddDataDisk_565373(path: JsonNode; query: JsonNode;
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
  var valid_565375 = path.getOrDefault("labName")
  valid_565375 = validateParameter(valid_565375, JString, required = true,
                                 default = nil)
  if valid_565375 != nil:
    section.add "labName", valid_565375
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
                                 default = newJString("2018-09-15"))
  if valid_565379 != nil:
    section.add "api-version", valid_565379
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

proc call*(call_565381: Call_VirtualMachinesAddDataDisk_565372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Attach a new or existing data disk to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565381.validator(path, query, header, formData, body)
  let scheme = call_565381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565381.url(scheme.get, call_565381.host, call_565381.base,
                         call_565381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565381, url, valid)

proc call*(call_565382: Call_VirtualMachinesAddDataDisk_565372; labName: string;
          dataDiskProperties: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565383 = newJObject()
  var query_565384 = newJObject()
  var body_565385 = newJObject()
  add(path_565383, "labName", newJString(labName))
  if dataDiskProperties != nil:
    body_565385 = dataDiskProperties
  add(query_565384, "api-version", newJString(apiVersion))
  add(path_565383, "name", newJString(name))
  add(path_565383, "subscriptionId", newJString(subscriptionId))
  add(path_565383, "resourceGroupName", newJString(resourceGroupName))
  result = call_565382.call(path_565383, query_565384, nil, nil, body_565385)

var virtualMachinesAddDataDisk* = Call_VirtualMachinesAddDataDisk_565372(
    name: "virtualMachinesAddDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/addDataDisk",
    validator: validate_VirtualMachinesAddDataDisk_565373, base: "",
    url: url_VirtualMachinesAddDataDisk_565374, schemes: {Scheme.Https})
type
  Call_VirtualMachinesApplyArtifacts_565386 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesApplyArtifacts_565388(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesApplyArtifacts_565387(path: JsonNode; query: JsonNode;
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
  var valid_565389 = path.getOrDefault("labName")
  valid_565389 = validateParameter(valid_565389, JString, required = true,
                                 default = nil)
  if valid_565389 != nil:
    section.add "labName", valid_565389
  var valid_565390 = path.getOrDefault("name")
  valid_565390 = validateParameter(valid_565390, JString, required = true,
                                 default = nil)
  if valid_565390 != nil:
    section.add "name", valid_565390
  var valid_565391 = path.getOrDefault("subscriptionId")
  valid_565391 = validateParameter(valid_565391, JString, required = true,
                                 default = nil)
  if valid_565391 != nil:
    section.add "subscriptionId", valid_565391
  var valid_565392 = path.getOrDefault("resourceGroupName")
  valid_565392 = validateParameter(valid_565392, JString, required = true,
                                 default = nil)
  if valid_565392 != nil:
    section.add "resourceGroupName", valid_565392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565393 = query.getOrDefault("api-version")
  valid_565393 = validateParameter(valid_565393, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565393 != nil:
    section.add "api-version", valid_565393
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

proc call*(call_565395: Call_VirtualMachinesApplyArtifacts_565386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply artifacts to virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565395.validator(path, query, header, formData, body)
  let scheme = call_565395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565395.url(scheme.get, call_565395.host, call_565395.base,
                         call_565395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565395, url, valid)

proc call*(call_565396: Call_VirtualMachinesApplyArtifacts_565386; labName: string;
          applyArtifactsRequest: JsonNode; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565397 = newJObject()
  var query_565398 = newJObject()
  var body_565399 = newJObject()
  add(path_565397, "labName", newJString(labName))
  if applyArtifactsRequest != nil:
    body_565399 = applyArtifactsRequest
  add(query_565398, "api-version", newJString(apiVersion))
  add(path_565397, "name", newJString(name))
  add(path_565397, "subscriptionId", newJString(subscriptionId))
  add(path_565397, "resourceGroupName", newJString(resourceGroupName))
  result = call_565396.call(path_565397, query_565398, nil, nil, body_565399)

var virtualMachinesApplyArtifacts* = Call_VirtualMachinesApplyArtifacts_565386(
    name: "virtualMachinesApplyArtifacts", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/applyArtifacts",
    validator: validate_VirtualMachinesApplyArtifacts_565387, base: "",
    url: url_VirtualMachinesApplyArtifacts_565388, schemes: {Scheme.Https})
type
  Call_VirtualMachinesClaim_565400 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesClaim_565402(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesClaim_565401(path: JsonNode; query: JsonNode;
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
  var valid_565403 = path.getOrDefault("labName")
  valid_565403 = validateParameter(valid_565403, JString, required = true,
                                 default = nil)
  if valid_565403 != nil:
    section.add "labName", valid_565403
  var valid_565404 = path.getOrDefault("name")
  valid_565404 = validateParameter(valid_565404, JString, required = true,
                                 default = nil)
  if valid_565404 != nil:
    section.add "name", valid_565404
  var valid_565405 = path.getOrDefault("subscriptionId")
  valid_565405 = validateParameter(valid_565405, JString, required = true,
                                 default = nil)
  if valid_565405 != nil:
    section.add "subscriptionId", valid_565405
  var valid_565406 = path.getOrDefault("resourceGroupName")
  valid_565406 = validateParameter(valid_565406, JString, required = true,
                                 default = nil)
  if valid_565406 != nil:
    section.add "resourceGroupName", valid_565406
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565407 = query.getOrDefault("api-version")
  valid_565407 = validateParameter(valid_565407, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565407 != nil:
    section.add "api-version", valid_565407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565408: Call_VirtualMachinesClaim_565400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  let valid = call_565408.validator(path, query, header, formData, body)
  let scheme = call_565408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565408.url(scheme.get, call_565408.host, call_565408.base,
                         call_565408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565408, url, valid)

proc call*(call_565409: Call_VirtualMachinesClaim_565400; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565410 = newJObject()
  var query_565411 = newJObject()
  add(path_565410, "labName", newJString(labName))
  add(query_565411, "api-version", newJString(apiVersion))
  add(path_565410, "name", newJString(name))
  add(path_565410, "subscriptionId", newJString(subscriptionId))
  add(path_565410, "resourceGroupName", newJString(resourceGroupName))
  result = call_565409.call(path_565410, query_565411, nil, nil, nil)

var virtualMachinesClaim* = Call_VirtualMachinesClaim_565400(
    name: "virtualMachinesClaim", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/claim",
    validator: validate_VirtualMachinesClaim_565401, base: "",
    url: url_VirtualMachinesClaim_565402, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDetachDataDisk_565412 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesDetachDataDisk_565414(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesDetachDataDisk_565413(path: JsonNode; query: JsonNode;
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
  var valid_565415 = path.getOrDefault("labName")
  valid_565415 = validateParameter(valid_565415, JString, required = true,
                                 default = nil)
  if valid_565415 != nil:
    section.add "labName", valid_565415
  var valid_565416 = path.getOrDefault("name")
  valid_565416 = validateParameter(valid_565416, JString, required = true,
                                 default = nil)
  if valid_565416 != nil:
    section.add "name", valid_565416
  var valid_565417 = path.getOrDefault("subscriptionId")
  valid_565417 = validateParameter(valid_565417, JString, required = true,
                                 default = nil)
  if valid_565417 != nil:
    section.add "subscriptionId", valid_565417
  var valid_565418 = path.getOrDefault("resourceGroupName")
  valid_565418 = validateParameter(valid_565418, JString, required = true,
                                 default = nil)
  if valid_565418 != nil:
    section.add "resourceGroupName", valid_565418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565419 = query.getOrDefault("api-version")
  valid_565419 = validateParameter(valid_565419, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565419 != nil:
    section.add "api-version", valid_565419
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

proc call*(call_565421: Call_VirtualMachinesDetachDataDisk_565412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the specified disk from the virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565421.validator(path, query, header, formData, body)
  let scheme = call_565421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565421.url(scheme.get, call_565421.host, call_565421.base,
                         call_565421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565421, url, valid)

proc call*(call_565422: Call_VirtualMachinesDetachDataDisk_565412; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          detachDataDiskProperties: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565423 = newJObject()
  var query_565424 = newJObject()
  var body_565425 = newJObject()
  add(path_565423, "labName", newJString(labName))
  add(query_565424, "api-version", newJString(apiVersion))
  add(path_565423, "name", newJString(name))
  add(path_565423, "subscriptionId", newJString(subscriptionId))
  add(path_565423, "resourceGroupName", newJString(resourceGroupName))
  if detachDataDiskProperties != nil:
    body_565425 = detachDataDiskProperties
  result = call_565422.call(path_565423, query_565424, nil, nil, body_565425)

var virtualMachinesDetachDataDisk* = Call_VirtualMachinesDetachDataDisk_565412(
    name: "virtualMachinesDetachDataDisk", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/detachDataDisk",
    validator: validate_VirtualMachinesDetachDataDisk_565413, base: "",
    url: url_VirtualMachinesDetachDataDisk_565414, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGetRdpFileContents_565426 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesGetRdpFileContents_565428(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesGetRdpFileContents_565427(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a string that represents the contents of the RDP file for the virtual machine
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
  var valid_565429 = path.getOrDefault("labName")
  valid_565429 = validateParameter(valid_565429, JString, required = true,
                                 default = nil)
  if valid_565429 != nil:
    section.add "labName", valid_565429
  var valid_565430 = path.getOrDefault("name")
  valid_565430 = validateParameter(valid_565430, JString, required = true,
                                 default = nil)
  if valid_565430 != nil:
    section.add "name", valid_565430
  var valid_565431 = path.getOrDefault("subscriptionId")
  valid_565431 = validateParameter(valid_565431, JString, required = true,
                                 default = nil)
  if valid_565431 != nil:
    section.add "subscriptionId", valid_565431
  var valid_565432 = path.getOrDefault("resourceGroupName")
  valid_565432 = validateParameter(valid_565432, JString, required = true,
                                 default = nil)
  if valid_565432 != nil:
    section.add "resourceGroupName", valid_565432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565433 = query.getOrDefault("api-version")
  valid_565433 = validateParameter(valid_565433, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565433 != nil:
    section.add "api-version", valid_565433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565434: Call_VirtualMachinesGetRdpFileContents_565426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a string that represents the contents of the RDP file for the virtual machine
  ## 
  let valid = call_565434.validator(path, query, header, formData, body)
  let scheme = call_565434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565434.url(scheme.get, call_565434.host, call_565434.base,
                         call_565434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565434, url, valid)

proc call*(call_565435: Call_VirtualMachinesGetRdpFileContents_565426;
          labName: string; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesGetRdpFileContents
  ## Gets a string that represents the contents of the RDP file for the virtual machine
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
  var path_565436 = newJObject()
  var query_565437 = newJObject()
  add(path_565436, "labName", newJString(labName))
  add(query_565437, "api-version", newJString(apiVersion))
  add(path_565436, "name", newJString(name))
  add(path_565436, "subscriptionId", newJString(subscriptionId))
  add(path_565436, "resourceGroupName", newJString(resourceGroupName))
  result = call_565435.call(path_565436, query_565437, nil, nil, nil)

var virtualMachinesGetRdpFileContents* = Call_VirtualMachinesGetRdpFileContents_565426(
    name: "virtualMachinesGetRdpFileContents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/getRdpFileContents",
    validator: validate_VirtualMachinesGetRdpFileContents_565427, base: "",
    url: url_VirtualMachinesGetRdpFileContents_565428, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListApplicableSchedules_565438 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesListApplicableSchedules_565440(protocol: Scheme;
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

proc validate_VirtualMachinesListApplicableSchedules_565439(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the applicable start/stop schedules, if any.
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
  var valid_565441 = path.getOrDefault("labName")
  valid_565441 = validateParameter(valid_565441, JString, required = true,
                                 default = nil)
  if valid_565441 != nil:
    section.add "labName", valid_565441
  var valid_565442 = path.getOrDefault("name")
  valid_565442 = validateParameter(valid_565442, JString, required = true,
                                 default = nil)
  if valid_565442 != nil:
    section.add "name", valid_565442
  var valid_565443 = path.getOrDefault("subscriptionId")
  valid_565443 = validateParameter(valid_565443, JString, required = true,
                                 default = nil)
  if valid_565443 != nil:
    section.add "subscriptionId", valid_565443
  var valid_565444 = path.getOrDefault("resourceGroupName")
  valid_565444 = validateParameter(valid_565444, JString, required = true,
                                 default = nil)
  if valid_565444 != nil:
    section.add "resourceGroupName", valid_565444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565445 = query.getOrDefault("api-version")
  valid_565445 = validateParameter(valid_565445, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565445 != nil:
    section.add "api-version", valid_565445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565446: Call_VirtualMachinesListApplicableSchedules_565438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the applicable start/stop schedules, if any.
  ## 
  let valid = call_565446.validator(path, query, header, formData, body)
  let scheme = call_565446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565446.url(scheme.get, call_565446.host, call_565446.base,
                         call_565446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565446, url, valid)

proc call*(call_565447: Call_VirtualMachinesListApplicableSchedules_565438;
          labName: string; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesListApplicableSchedules
  ## Lists the applicable start/stop schedules, if any.
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
  var path_565448 = newJObject()
  var query_565449 = newJObject()
  add(path_565448, "labName", newJString(labName))
  add(query_565449, "api-version", newJString(apiVersion))
  add(path_565448, "name", newJString(name))
  add(path_565448, "subscriptionId", newJString(subscriptionId))
  add(path_565448, "resourceGroupName", newJString(resourceGroupName))
  result = call_565447.call(path_565448, query_565449, nil, nil, nil)

var virtualMachinesListApplicableSchedules* = Call_VirtualMachinesListApplicableSchedules_565438(
    name: "virtualMachinesListApplicableSchedules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/listApplicableSchedules",
    validator: validate_VirtualMachinesListApplicableSchedules_565439, base: "",
    url: url_VirtualMachinesListApplicableSchedules_565440,
    schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_565450 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesRedeploy_565452(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRedeploy_565451(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redeploy a virtual machine This operation can take a while to complete.
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
  var valid_565453 = path.getOrDefault("labName")
  valid_565453 = validateParameter(valid_565453, JString, required = true,
                                 default = nil)
  if valid_565453 != nil:
    section.add "labName", valid_565453
  var valid_565454 = path.getOrDefault("name")
  valid_565454 = validateParameter(valid_565454, JString, required = true,
                                 default = nil)
  if valid_565454 != nil:
    section.add "name", valid_565454
  var valid_565455 = path.getOrDefault("subscriptionId")
  valid_565455 = validateParameter(valid_565455, JString, required = true,
                                 default = nil)
  if valid_565455 != nil:
    section.add "subscriptionId", valid_565455
  var valid_565456 = path.getOrDefault("resourceGroupName")
  valid_565456 = validateParameter(valid_565456, JString, required = true,
                                 default = nil)
  if valid_565456 != nil:
    section.add "resourceGroupName", valid_565456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565457 = query.getOrDefault("api-version")
  valid_565457 = validateParameter(valid_565457, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565457 != nil:
    section.add "api-version", valid_565457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565458: Call_VirtualMachinesRedeploy_565450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Redeploy a virtual machine This operation can take a while to complete.
  ## 
  let valid = call_565458.validator(path, query, header, formData, body)
  let scheme = call_565458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565458.url(scheme.get, call_565458.host, call_565458.base,
                         call_565458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565458, url, valid)

proc call*(call_565459: Call_VirtualMachinesRedeploy_565450; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesRedeploy
  ## Redeploy a virtual machine This operation can take a while to complete.
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
  var path_565460 = newJObject()
  var query_565461 = newJObject()
  add(path_565460, "labName", newJString(labName))
  add(query_565461, "api-version", newJString(apiVersion))
  add(path_565460, "name", newJString(name))
  add(path_565460, "subscriptionId", newJString(subscriptionId))
  add(path_565460, "resourceGroupName", newJString(resourceGroupName))
  result = call_565459.call(path_565460, query_565461, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_565450(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/redeploy",
    validator: validate_VirtualMachinesRedeploy_565451, base: "",
    url: url_VirtualMachinesRedeploy_565452, schemes: {Scheme.Https})
type
  Call_VirtualMachinesResize_565462 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesResize_565464(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesResize_565463(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resize Virtual Machine. This operation can take a while to complete.
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
  var valid_565465 = path.getOrDefault("labName")
  valid_565465 = validateParameter(valid_565465, JString, required = true,
                                 default = nil)
  if valid_565465 != nil:
    section.add "labName", valid_565465
  var valid_565466 = path.getOrDefault("name")
  valid_565466 = validateParameter(valid_565466, JString, required = true,
                                 default = nil)
  if valid_565466 != nil:
    section.add "name", valid_565466
  var valid_565467 = path.getOrDefault("subscriptionId")
  valid_565467 = validateParameter(valid_565467, JString, required = true,
                                 default = nil)
  if valid_565467 != nil:
    section.add "subscriptionId", valid_565467
  var valid_565468 = path.getOrDefault("resourceGroupName")
  valid_565468 = validateParameter(valid_565468, JString, required = true,
                                 default = nil)
  if valid_565468 != nil:
    section.add "resourceGroupName", valid_565468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565469 = query.getOrDefault("api-version")
  valid_565469 = validateParameter(valid_565469, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565469 != nil:
    section.add "api-version", valid_565469
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

proc call*(call_565471: Call_VirtualMachinesResize_565462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resize Virtual Machine. This operation can take a while to complete.
  ## 
  let valid = call_565471.validator(path, query, header, formData, body)
  let scheme = call_565471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565471.url(scheme.get, call_565471.host, call_565471.base,
                         call_565471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565471, url, valid)

proc call*(call_565472: Call_VirtualMachinesResize_565462;
          resizeLabVirtualMachineProperties: JsonNode; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesResize
  ## Resize Virtual Machine. This operation can take a while to complete.
  ##   resizeLabVirtualMachineProperties: JObject (required)
  ##                                    : Request body for resizing a virtual machine.
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
  var path_565473 = newJObject()
  var query_565474 = newJObject()
  var body_565475 = newJObject()
  if resizeLabVirtualMachineProperties != nil:
    body_565475 = resizeLabVirtualMachineProperties
  add(path_565473, "labName", newJString(labName))
  add(query_565474, "api-version", newJString(apiVersion))
  add(path_565473, "name", newJString(name))
  add(path_565473, "subscriptionId", newJString(subscriptionId))
  add(path_565473, "resourceGroupName", newJString(resourceGroupName))
  result = call_565472.call(path_565473, query_565474, nil, nil, body_565475)

var virtualMachinesResize* = Call_VirtualMachinesResize_565462(
    name: "virtualMachinesResize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/resize",
    validator: validate_VirtualMachinesResize_565463, base: "",
    url: url_VirtualMachinesResize_565464, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_565476 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesRestart_565478(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRestart_565477(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restart a virtual machine. This operation can take a while to complete.
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
  var valid_565479 = path.getOrDefault("labName")
  valid_565479 = validateParameter(valid_565479, JString, required = true,
                                 default = nil)
  if valid_565479 != nil:
    section.add "labName", valid_565479
  var valid_565480 = path.getOrDefault("name")
  valid_565480 = validateParameter(valid_565480, JString, required = true,
                                 default = nil)
  if valid_565480 != nil:
    section.add "name", valid_565480
  var valid_565481 = path.getOrDefault("subscriptionId")
  valid_565481 = validateParameter(valid_565481, JString, required = true,
                                 default = nil)
  if valid_565481 != nil:
    section.add "subscriptionId", valid_565481
  var valid_565482 = path.getOrDefault("resourceGroupName")
  valid_565482 = validateParameter(valid_565482, JString, required = true,
                                 default = nil)
  if valid_565482 != nil:
    section.add "resourceGroupName", valid_565482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565483 = query.getOrDefault("api-version")
  valid_565483 = validateParameter(valid_565483, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565483 != nil:
    section.add "api-version", valid_565483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565484: Call_VirtualMachinesRestart_565476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restart a virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565484.validator(path, query, header, formData, body)
  let scheme = call_565484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565484.url(scheme.get, call_565484.host, call_565484.base,
                         call_565484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565484, url, valid)

proc call*(call_565485: Call_VirtualMachinesRestart_565476; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesRestart
  ## Restart a virtual machine. This operation can take a while to complete.
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
  var path_565486 = newJObject()
  var query_565487 = newJObject()
  add(path_565486, "labName", newJString(labName))
  add(query_565487, "api-version", newJString(apiVersion))
  add(path_565486, "name", newJString(name))
  add(path_565486, "subscriptionId", newJString(subscriptionId))
  add(path_565486, "resourceGroupName", newJString(resourceGroupName))
  result = call_565485.call(path_565486, query_565487, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_565476(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/restart",
    validator: validate_VirtualMachinesRestart_565477, base: "",
    url: url_VirtualMachinesRestart_565478, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_565488 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesStart_565490(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStart_565489(path: JsonNode; query: JsonNode;
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
  var valid_565491 = path.getOrDefault("labName")
  valid_565491 = validateParameter(valid_565491, JString, required = true,
                                 default = nil)
  if valid_565491 != nil:
    section.add "labName", valid_565491
  var valid_565492 = path.getOrDefault("name")
  valid_565492 = validateParameter(valid_565492, JString, required = true,
                                 default = nil)
  if valid_565492 != nil:
    section.add "name", valid_565492
  var valid_565493 = path.getOrDefault("subscriptionId")
  valid_565493 = validateParameter(valid_565493, JString, required = true,
                                 default = nil)
  if valid_565493 != nil:
    section.add "subscriptionId", valid_565493
  var valid_565494 = path.getOrDefault("resourceGroupName")
  valid_565494 = validateParameter(valid_565494, JString, required = true,
                                 default = nil)
  if valid_565494 != nil:
    section.add "resourceGroupName", valid_565494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565495 = query.getOrDefault("api-version")
  valid_565495 = validateParameter(valid_565495, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565495 != nil:
    section.add "api-version", valid_565495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565496: Call_VirtualMachinesStart_565488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start a virtual machine. This operation can take a while to complete.
  ## 
  let valid = call_565496.validator(path, query, header, formData, body)
  let scheme = call_565496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565496.url(scheme.get, call_565496.host, call_565496.base,
                         call_565496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565496, url, valid)

proc call*(call_565497: Call_VirtualMachinesStart_565488; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565498 = newJObject()
  var query_565499 = newJObject()
  add(path_565498, "labName", newJString(labName))
  add(query_565499, "api-version", newJString(apiVersion))
  add(path_565498, "name", newJString(name))
  add(path_565498, "subscriptionId", newJString(subscriptionId))
  add(path_565498, "resourceGroupName", newJString(resourceGroupName))
  result = call_565497.call(path_565498, query_565499, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_565488(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/start",
    validator: validate_VirtualMachinesStart_565489, base: "",
    url: url_VirtualMachinesStart_565490, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStop_565500 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesStop_565502(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStop_565501(path: JsonNode; query: JsonNode;
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
  var valid_565503 = path.getOrDefault("labName")
  valid_565503 = validateParameter(valid_565503, JString, required = true,
                                 default = nil)
  if valid_565503 != nil:
    section.add "labName", valid_565503
  var valid_565504 = path.getOrDefault("name")
  valid_565504 = validateParameter(valid_565504, JString, required = true,
                                 default = nil)
  if valid_565504 != nil:
    section.add "name", valid_565504
  var valid_565505 = path.getOrDefault("subscriptionId")
  valid_565505 = validateParameter(valid_565505, JString, required = true,
                                 default = nil)
  if valid_565505 != nil:
    section.add "subscriptionId", valid_565505
  var valid_565506 = path.getOrDefault("resourceGroupName")
  valid_565506 = validateParameter(valid_565506, JString, required = true,
                                 default = nil)
  if valid_565506 != nil:
    section.add "resourceGroupName", valid_565506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565507 = query.getOrDefault("api-version")
  valid_565507 = validateParameter(valid_565507, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565507 != nil:
    section.add "api-version", valid_565507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565508: Call_VirtualMachinesStop_565500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop a virtual machine This operation can take a while to complete.
  ## 
  let valid = call_565508.validator(path, query, header, formData, body)
  let scheme = call_565508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565508.url(scheme.get, call_565508.host, call_565508.base,
                         call_565508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565508, url, valid)

proc call*(call_565509: Call_VirtualMachinesStop_565500; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565510 = newJObject()
  var query_565511 = newJObject()
  add(path_565510, "labName", newJString(labName))
  add(query_565511, "api-version", newJString(apiVersion))
  add(path_565510, "name", newJString(name))
  add(path_565510, "subscriptionId", newJString(subscriptionId))
  add(path_565510, "resourceGroupName", newJString(resourceGroupName))
  result = call_565509.call(path_565510, query_565511, nil, nil, nil)

var virtualMachinesStop* = Call_VirtualMachinesStop_565500(
    name: "virtualMachinesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/stop",
    validator: validate_VirtualMachinesStop_565501, base: "",
    url: url_VirtualMachinesStop_565502, schemes: {Scheme.Https})
type
  Call_VirtualMachinesTransferDisks_565512 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesTransferDisks_565514(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesTransferDisks_565513(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Transfers all data disks attached to the virtual machine to be owned by the current user. This operation can take a while to complete.
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
  var valid_565515 = path.getOrDefault("labName")
  valid_565515 = validateParameter(valid_565515, JString, required = true,
                                 default = nil)
  if valid_565515 != nil:
    section.add "labName", valid_565515
  var valid_565516 = path.getOrDefault("name")
  valid_565516 = validateParameter(valid_565516, JString, required = true,
                                 default = nil)
  if valid_565516 != nil:
    section.add "name", valid_565516
  var valid_565517 = path.getOrDefault("subscriptionId")
  valid_565517 = validateParameter(valid_565517, JString, required = true,
                                 default = nil)
  if valid_565517 != nil:
    section.add "subscriptionId", valid_565517
  var valid_565518 = path.getOrDefault("resourceGroupName")
  valid_565518 = validateParameter(valid_565518, JString, required = true,
                                 default = nil)
  if valid_565518 != nil:
    section.add "resourceGroupName", valid_565518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565519 = query.getOrDefault("api-version")
  valid_565519 = validateParameter(valid_565519, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565519 != nil:
    section.add "api-version", valid_565519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565520: Call_VirtualMachinesTransferDisks_565512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Transfers all data disks attached to the virtual machine to be owned by the current user. This operation can take a while to complete.
  ## 
  let valid = call_565520.validator(path, query, header, formData, body)
  let scheme = call_565520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565520.url(scheme.get, call_565520.host, call_565520.base,
                         call_565520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565520, url, valid)

proc call*(call_565521: Call_VirtualMachinesTransferDisks_565512; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesTransferDisks
  ## Transfers all data disks attached to the virtual machine to be owned by the current user. This operation can take a while to complete.
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
  var path_565522 = newJObject()
  var query_565523 = newJObject()
  add(path_565522, "labName", newJString(labName))
  add(query_565523, "api-version", newJString(apiVersion))
  add(path_565522, "name", newJString(name))
  add(path_565522, "subscriptionId", newJString(subscriptionId))
  add(path_565522, "resourceGroupName", newJString(resourceGroupName))
  result = call_565521.call(path_565522, query_565523, nil, nil, nil)

var virtualMachinesTransferDisks* = Call_VirtualMachinesTransferDisks_565512(
    name: "virtualMachinesTransferDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/transferDisks",
    validator: validate_VirtualMachinesTransferDisks_565513, base: "",
    url: url_VirtualMachinesTransferDisks_565514, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUnClaim_565524 = ref object of OpenApiRestCall_563564
proc url_VirtualMachinesUnClaim_565526(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUnClaim_565525(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Release ownership of an existing virtual machine This operation can take a while to complete.
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
  var valid_565527 = path.getOrDefault("labName")
  valid_565527 = validateParameter(valid_565527, JString, required = true,
                                 default = nil)
  if valid_565527 != nil:
    section.add "labName", valid_565527
  var valid_565528 = path.getOrDefault("name")
  valid_565528 = validateParameter(valid_565528, JString, required = true,
                                 default = nil)
  if valid_565528 != nil:
    section.add "name", valid_565528
  var valid_565529 = path.getOrDefault("subscriptionId")
  valid_565529 = validateParameter(valid_565529, JString, required = true,
                                 default = nil)
  if valid_565529 != nil:
    section.add "subscriptionId", valid_565529
  var valid_565530 = path.getOrDefault("resourceGroupName")
  valid_565530 = validateParameter(valid_565530, JString, required = true,
                                 default = nil)
  if valid_565530 != nil:
    section.add "resourceGroupName", valid_565530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565531 = query.getOrDefault("api-version")
  valid_565531 = validateParameter(valid_565531, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565531 != nil:
    section.add "api-version", valid_565531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565532: Call_VirtualMachinesUnClaim_565524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Release ownership of an existing virtual machine This operation can take a while to complete.
  ## 
  let valid = call_565532.validator(path, query, header, formData, body)
  let scheme = call_565532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565532.url(scheme.get, call_565532.host, call_565532.base,
                         call_565532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565532, url, valid)

proc call*(call_565533: Call_VirtualMachinesUnClaim_565524; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachinesUnClaim
  ## Release ownership of an existing virtual machine This operation can take a while to complete.
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
  var path_565534 = newJObject()
  var query_565535 = newJObject()
  add(path_565534, "labName", newJString(labName))
  add(query_565535, "api-version", newJString(apiVersion))
  add(path_565534, "name", newJString(name))
  add(path_565534, "subscriptionId", newJString(subscriptionId))
  add(path_565534, "resourceGroupName", newJString(resourceGroupName))
  result = call_565533.call(path_565534, query_565535, nil, nil, nil)

var virtualMachinesUnClaim* = Call_VirtualMachinesUnClaim_565524(
    name: "virtualMachinesUnClaim", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{name}/unClaim",
    validator: validate_VirtualMachinesUnClaim_565525, base: "",
    url: url_VirtualMachinesUnClaim_565526, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesList_565536 = ref object of OpenApiRestCall_563564
proc url_VirtualMachineSchedulesList_565538(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesList_565537(path: JsonNode; query: JsonNode;
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
  var valid_565539 = path.getOrDefault("labName")
  valid_565539 = validateParameter(valid_565539, JString, required = true,
                                 default = nil)
  if valid_565539 != nil:
    section.add "labName", valid_565539
  var valid_565540 = path.getOrDefault("virtualMachineName")
  valid_565540 = validateParameter(valid_565540, JString, required = true,
                                 default = nil)
  if valid_565540 != nil:
    section.add "virtualMachineName", valid_565540
  var valid_565541 = path.getOrDefault("subscriptionId")
  valid_565541 = validateParameter(valid_565541, JString, required = true,
                                 default = nil)
  if valid_565541 != nil:
    section.add "subscriptionId", valid_565541
  var valid_565542 = path.getOrDefault("resourceGroupName")
  valid_565542 = validateParameter(valid_565542, JString, required = true,
                                 default = nil)
  if valid_565542 != nil:
    section.add "resourceGroupName", valid_565542
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_565543 = query.getOrDefault("$top")
  valid_565543 = validateParameter(valid_565543, JInt, required = false, default = nil)
  if valid_565543 != nil:
    section.add "$top", valid_565543
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565544 = query.getOrDefault("api-version")
  valid_565544 = validateParameter(valid_565544, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565544 != nil:
    section.add "api-version", valid_565544
  var valid_565545 = query.getOrDefault("$expand")
  valid_565545 = validateParameter(valid_565545, JString, required = false,
                                 default = nil)
  if valid_565545 != nil:
    section.add "$expand", valid_565545
  var valid_565546 = query.getOrDefault("$orderby")
  valid_565546 = validateParameter(valid_565546, JString, required = false,
                                 default = nil)
  if valid_565546 != nil:
    section.add "$orderby", valid_565546
  var valid_565547 = query.getOrDefault("$filter")
  valid_565547 = validateParameter(valid_565547, JString, required = false,
                                 default = nil)
  if valid_565547 != nil:
    section.add "$filter", valid_565547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565548: Call_VirtualMachineSchedulesList_565536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List schedules in a given virtual machine.
  ## 
  let valid = call_565548.validator(path, query, header, formData, body)
  let scheme = call_565548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565548.url(scheme.get, call_565548.host, call_565548.base,
                         call_565548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565548, url, valid)

proc call*(call_565549: Call_VirtualMachineSchedulesList_565536; labName: string;
          virtualMachineName: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; apiVersion: string = "2018-09-15";
          Expand: string = ""; Orderby: string = ""; Filter: string = ""): Recallable =
  ## virtualMachineSchedulesList
  ## List schedules in a given virtual machine.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   virtualMachineName: string (required)
  ##                     : The name of the virtual machine.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_565550 = newJObject()
  var query_565551 = newJObject()
  add(path_565550, "labName", newJString(labName))
  add(query_565551, "$top", newJInt(Top))
  add(query_565551, "api-version", newJString(apiVersion))
  add(query_565551, "$expand", newJString(Expand))
  add(path_565550, "virtualMachineName", newJString(virtualMachineName))
  add(path_565550, "subscriptionId", newJString(subscriptionId))
  add(query_565551, "$orderby", newJString(Orderby))
  add(path_565550, "resourceGroupName", newJString(resourceGroupName))
  add(query_565551, "$filter", newJString(Filter))
  result = call_565549.call(path_565550, query_565551, nil, nil, nil)

var virtualMachineSchedulesList* = Call_VirtualMachineSchedulesList_565536(
    name: "virtualMachineSchedulesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules",
    validator: validate_VirtualMachineSchedulesList_565537, base: "",
    url: url_VirtualMachineSchedulesList_565538, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesCreateOrUpdate_565566 = ref object of OpenApiRestCall_563564
proc url_VirtualMachineSchedulesCreateOrUpdate_565568(protocol: Scheme;
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

proc validate_VirtualMachineSchedulesCreateOrUpdate_565567(path: JsonNode;
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
  var valid_565569 = path.getOrDefault("labName")
  valid_565569 = validateParameter(valid_565569, JString, required = true,
                                 default = nil)
  if valid_565569 != nil:
    section.add "labName", valid_565569
  var valid_565570 = path.getOrDefault("virtualMachineName")
  valid_565570 = validateParameter(valid_565570, JString, required = true,
                                 default = nil)
  if valid_565570 != nil:
    section.add "virtualMachineName", valid_565570
  var valid_565571 = path.getOrDefault("name")
  valid_565571 = validateParameter(valid_565571, JString, required = true,
                                 default = nil)
  if valid_565571 != nil:
    section.add "name", valid_565571
  var valid_565572 = path.getOrDefault("subscriptionId")
  valid_565572 = validateParameter(valid_565572, JString, required = true,
                                 default = nil)
  if valid_565572 != nil:
    section.add "subscriptionId", valid_565572
  var valid_565573 = path.getOrDefault("resourceGroupName")
  valid_565573 = validateParameter(valid_565573, JString, required = true,
                                 default = nil)
  if valid_565573 != nil:
    section.add "resourceGroupName", valid_565573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565574 = query.getOrDefault("api-version")
  valid_565574 = validateParameter(valid_565574, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565574 != nil:
    section.add "api-version", valid_565574
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

proc call*(call_565576: Call_VirtualMachineSchedulesCreateOrUpdate_565566;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_565576.validator(path, query, header, formData, body)
  let scheme = call_565576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565576.url(scheme.get, call_565576.host, call_565576.base,
                         call_565576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565576, url, valid)

proc call*(call_565577: Call_VirtualMachineSchedulesCreateOrUpdate_565566;
          labName: string; virtualMachineName: string; name: string;
          subscriptionId: string; resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565578 = newJObject()
  var query_565579 = newJObject()
  var body_565580 = newJObject()
  add(path_565578, "labName", newJString(labName))
  add(query_565579, "api-version", newJString(apiVersion))
  add(path_565578, "virtualMachineName", newJString(virtualMachineName))
  add(path_565578, "name", newJString(name))
  add(path_565578, "subscriptionId", newJString(subscriptionId))
  add(path_565578, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565580 = schedule
  result = call_565577.call(path_565578, query_565579, nil, nil, body_565580)

var virtualMachineSchedulesCreateOrUpdate* = Call_VirtualMachineSchedulesCreateOrUpdate_565566(
    name: "virtualMachineSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesCreateOrUpdate_565567, base: "",
    url: url_VirtualMachineSchedulesCreateOrUpdate_565568, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesGet_565552 = ref object of OpenApiRestCall_563564
proc url_VirtualMachineSchedulesGet_565554(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesGet_565553(path: JsonNode; query: JsonNode;
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
  var valid_565555 = path.getOrDefault("labName")
  valid_565555 = validateParameter(valid_565555, JString, required = true,
                                 default = nil)
  if valid_565555 != nil:
    section.add "labName", valid_565555
  var valid_565556 = path.getOrDefault("virtualMachineName")
  valid_565556 = validateParameter(valid_565556, JString, required = true,
                                 default = nil)
  if valid_565556 != nil:
    section.add "virtualMachineName", valid_565556
  var valid_565557 = path.getOrDefault("name")
  valid_565557 = validateParameter(valid_565557, JString, required = true,
                                 default = nil)
  if valid_565557 != nil:
    section.add "name", valid_565557
  var valid_565558 = path.getOrDefault("subscriptionId")
  valid_565558 = validateParameter(valid_565558, JString, required = true,
                                 default = nil)
  if valid_565558 != nil:
    section.add "subscriptionId", valid_565558
  var valid_565559 = path.getOrDefault("resourceGroupName")
  valid_565559 = validateParameter(valid_565559, JString, required = true,
                                 default = nil)
  if valid_565559 != nil:
    section.add "resourceGroupName", valid_565559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565560 = query.getOrDefault("api-version")
  valid_565560 = validateParameter(valid_565560, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565560 != nil:
    section.add "api-version", valid_565560
  var valid_565561 = query.getOrDefault("$expand")
  valid_565561 = validateParameter(valid_565561, JString, required = false,
                                 default = nil)
  if valid_565561 != nil:
    section.add "$expand", valid_565561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565562: Call_VirtualMachineSchedulesGet_565552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_565562.validator(path, query, header, formData, body)
  let scheme = call_565562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565562.url(scheme.get, call_565562.host, call_565562.base,
                         call_565562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565562, url, valid)

proc call*(call_565563: Call_VirtualMachineSchedulesGet_565552; labName: string;
          virtualMachineName: string; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15";
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
  var path_565564 = newJObject()
  var query_565565 = newJObject()
  add(path_565564, "labName", newJString(labName))
  add(query_565565, "api-version", newJString(apiVersion))
  add(query_565565, "$expand", newJString(Expand))
  add(path_565564, "virtualMachineName", newJString(virtualMachineName))
  add(path_565564, "name", newJString(name))
  add(path_565564, "subscriptionId", newJString(subscriptionId))
  add(path_565564, "resourceGroupName", newJString(resourceGroupName))
  result = call_565563.call(path_565564, query_565565, nil, nil, nil)

var virtualMachineSchedulesGet* = Call_VirtualMachineSchedulesGet_565552(
    name: "virtualMachineSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesGet_565553, base: "",
    url: url_VirtualMachineSchedulesGet_565554, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesUpdate_565594 = ref object of OpenApiRestCall_563564
proc url_VirtualMachineSchedulesUpdate_565596(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesUpdate_565595(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var valid_565597 = path.getOrDefault("labName")
  valid_565597 = validateParameter(valid_565597, JString, required = true,
                                 default = nil)
  if valid_565597 != nil:
    section.add "labName", valid_565597
  var valid_565598 = path.getOrDefault("virtualMachineName")
  valid_565598 = validateParameter(valid_565598, JString, required = true,
                                 default = nil)
  if valid_565598 != nil:
    section.add "virtualMachineName", valid_565598
  var valid_565599 = path.getOrDefault("name")
  valid_565599 = validateParameter(valid_565599, JString, required = true,
                                 default = nil)
  if valid_565599 != nil:
    section.add "name", valid_565599
  var valid_565600 = path.getOrDefault("subscriptionId")
  valid_565600 = validateParameter(valid_565600, JString, required = true,
                                 default = nil)
  if valid_565600 != nil:
    section.add "subscriptionId", valid_565600
  var valid_565601 = path.getOrDefault("resourceGroupName")
  valid_565601 = validateParameter(valid_565601, JString, required = true,
                                 default = nil)
  if valid_565601 != nil:
    section.add "resourceGroupName", valid_565601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565602 = query.getOrDefault("api-version")
  valid_565602 = validateParameter(valid_565602, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565602 != nil:
    section.add "api-version", valid_565602
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

proc call*(call_565604: Call_VirtualMachineSchedulesUpdate_565594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_565604.validator(path, query, header, formData, body)
  let scheme = call_565604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565604.url(scheme.get, call_565604.host, call_565604.base,
                         call_565604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565604, url, valid)

proc call*(call_565605: Call_VirtualMachineSchedulesUpdate_565594; labName: string;
          virtualMachineName: string; name: string; subscriptionId: string;
          resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## virtualMachineSchedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var path_565606 = newJObject()
  var query_565607 = newJObject()
  var body_565608 = newJObject()
  add(path_565606, "labName", newJString(labName))
  add(query_565607, "api-version", newJString(apiVersion))
  add(path_565606, "virtualMachineName", newJString(virtualMachineName))
  add(path_565606, "name", newJString(name))
  add(path_565606, "subscriptionId", newJString(subscriptionId))
  add(path_565606, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565608 = schedule
  result = call_565605.call(path_565606, query_565607, nil, nil, body_565608)

var virtualMachineSchedulesUpdate* = Call_VirtualMachineSchedulesUpdate_565594(
    name: "virtualMachineSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesUpdate_565595, base: "",
    url: url_VirtualMachineSchedulesUpdate_565596, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesDelete_565581 = ref object of OpenApiRestCall_563564
proc url_VirtualMachineSchedulesDelete_565583(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesDelete_565582(path: JsonNode; query: JsonNode;
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
  var valid_565584 = path.getOrDefault("labName")
  valid_565584 = validateParameter(valid_565584, JString, required = true,
                                 default = nil)
  if valid_565584 != nil:
    section.add "labName", valid_565584
  var valid_565585 = path.getOrDefault("virtualMachineName")
  valid_565585 = validateParameter(valid_565585, JString, required = true,
                                 default = nil)
  if valid_565585 != nil:
    section.add "virtualMachineName", valid_565585
  var valid_565586 = path.getOrDefault("name")
  valid_565586 = validateParameter(valid_565586, JString, required = true,
                                 default = nil)
  if valid_565586 != nil:
    section.add "name", valid_565586
  var valid_565587 = path.getOrDefault("subscriptionId")
  valid_565587 = validateParameter(valid_565587, JString, required = true,
                                 default = nil)
  if valid_565587 != nil:
    section.add "subscriptionId", valid_565587
  var valid_565588 = path.getOrDefault("resourceGroupName")
  valid_565588 = validateParameter(valid_565588, JString, required = true,
                                 default = nil)
  if valid_565588 != nil:
    section.add "resourceGroupName", valid_565588
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565589 = query.getOrDefault("api-version")
  valid_565589 = validateParameter(valid_565589, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565589 != nil:
    section.add "api-version", valid_565589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565590: Call_VirtualMachineSchedulesDelete_565581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_565590.validator(path, query, header, formData, body)
  let scheme = call_565590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565590.url(scheme.get, call_565590.host, call_565590.base,
                         call_565590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565590, url, valid)

proc call*(call_565591: Call_VirtualMachineSchedulesDelete_565581; labName: string;
          virtualMachineName: string; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565592 = newJObject()
  var query_565593 = newJObject()
  add(path_565592, "labName", newJString(labName))
  add(query_565593, "api-version", newJString(apiVersion))
  add(path_565592, "virtualMachineName", newJString(virtualMachineName))
  add(path_565592, "name", newJString(name))
  add(path_565592, "subscriptionId", newJString(subscriptionId))
  add(path_565592, "resourceGroupName", newJString(resourceGroupName))
  result = call_565591.call(path_565592, query_565593, nil, nil, nil)

var virtualMachineSchedulesDelete* = Call_VirtualMachineSchedulesDelete_565581(
    name: "virtualMachineSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}",
    validator: validate_VirtualMachineSchedulesDelete_565582, base: "",
    url: url_VirtualMachineSchedulesDelete_565583, schemes: {Scheme.Https})
type
  Call_VirtualMachineSchedulesExecute_565609 = ref object of OpenApiRestCall_563564
proc url_VirtualMachineSchedulesExecute_565611(protocol: Scheme; host: string;
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

proc validate_VirtualMachineSchedulesExecute_565610(path: JsonNode;
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
  var valid_565612 = path.getOrDefault("labName")
  valid_565612 = validateParameter(valid_565612, JString, required = true,
                                 default = nil)
  if valid_565612 != nil:
    section.add "labName", valid_565612
  var valid_565613 = path.getOrDefault("virtualMachineName")
  valid_565613 = validateParameter(valid_565613, JString, required = true,
                                 default = nil)
  if valid_565613 != nil:
    section.add "virtualMachineName", valid_565613
  var valid_565614 = path.getOrDefault("name")
  valid_565614 = validateParameter(valid_565614, JString, required = true,
                                 default = nil)
  if valid_565614 != nil:
    section.add "name", valid_565614
  var valid_565615 = path.getOrDefault("subscriptionId")
  valid_565615 = validateParameter(valid_565615, JString, required = true,
                                 default = nil)
  if valid_565615 != nil:
    section.add "subscriptionId", valid_565615
  var valid_565616 = path.getOrDefault("resourceGroupName")
  valid_565616 = validateParameter(valid_565616, JString, required = true,
                                 default = nil)
  if valid_565616 != nil:
    section.add "resourceGroupName", valid_565616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565617 = query.getOrDefault("api-version")
  valid_565617 = validateParameter(valid_565617, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565617 != nil:
    section.add "api-version", valid_565617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565618: Call_VirtualMachineSchedulesExecute_565609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_565618.validator(path, query, header, formData, body)
  let scheme = call_565618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565618.url(scheme.get, call_565618.host, call_565618.base,
                         call_565618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565618, url, valid)

proc call*(call_565619: Call_VirtualMachineSchedulesExecute_565609;
          labName: string; virtualMachineName: string; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565620 = newJObject()
  var query_565621 = newJObject()
  add(path_565620, "labName", newJString(labName))
  add(query_565621, "api-version", newJString(apiVersion))
  add(path_565620, "virtualMachineName", newJString(virtualMachineName))
  add(path_565620, "name", newJString(name))
  add(path_565620, "subscriptionId", newJString(subscriptionId))
  add(path_565620, "resourceGroupName", newJString(resourceGroupName))
  result = call_565619.call(path_565620, query_565621, nil, nil, nil)

var virtualMachineSchedulesExecute* = Call_VirtualMachineSchedulesExecute_565609(
    name: "virtualMachineSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualmachines/{virtualMachineName}/schedules/{name}/execute",
    validator: validate_VirtualMachineSchedulesExecute_565610, base: "",
    url: url_VirtualMachineSchedulesExecute_565611, schemes: {Scheme.Https})
type
  Call_VirtualNetworksList_565622 = ref object of OpenApiRestCall_563564
proc url_VirtualNetworksList_565624(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksList_565623(path: JsonNode; query: JsonNode;
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
  var valid_565625 = path.getOrDefault("labName")
  valid_565625 = validateParameter(valid_565625, JString, required = true,
                                 default = nil)
  if valid_565625 != nil:
    section.add "labName", valid_565625
  var valid_565626 = path.getOrDefault("subscriptionId")
  valid_565626 = validateParameter(valid_565626, JString, required = true,
                                 default = nil)
  if valid_565626 != nil:
    section.add "subscriptionId", valid_565626
  var valid_565627 = path.getOrDefault("resourceGroupName")
  valid_565627 = validateParameter(valid_565627, JString, required = true,
                                 default = nil)
  if valid_565627 != nil:
    section.add "resourceGroupName", valid_565627
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_565628 = query.getOrDefault("$top")
  valid_565628 = validateParameter(valid_565628, JInt, required = false, default = nil)
  if valid_565628 != nil:
    section.add "$top", valid_565628
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565629 = query.getOrDefault("api-version")
  valid_565629 = validateParameter(valid_565629, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565629 != nil:
    section.add "api-version", valid_565629
  var valid_565630 = query.getOrDefault("$expand")
  valid_565630 = validateParameter(valid_565630, JString, required = false,
                                 default = nil)
  if valid_565630 != nil:
    section.add "$expand", valid_565630
  var valid_565631 = query.getOrDefault("$orderby")
  valid_565631 = validateParameter(valid_565631, JString, required = false,
                                 default = nil)
  if valid_565631 != nil:
    section.add "$orderby", valid_565631
  var valid_565632 = query.getOrDefault("$filter")
  valid_565632 = validateParameter(valid_565632, JString, required = false,
                                 default = nil)
  if valid_565632 != nil:
    section.add "$filter", valid_565632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565633: Call_VirtualNetworksList_565622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List virtual networks in a given lab.
  ## 
  let valid = call_565633.validator(path, query, header, formData, body)
  let scheme = call_565633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565633.url(scheme.get, call_565633.host, call_565633.base,
                         call_565633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565633, url, valid)

proc call*(call_565634: Call_VirtualNetworksList_565622; labName: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## virtualNetworksList
  ## List virtual networks in a given lab.
  ##   labName: string (required)
  ##          : The name of the lab.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_565635 = newJObject()
  var query_565636 = newJObject()
  add(path_565635, "labName", newJString(labName))
  add(query_565636, "$top", newJInt(Top))
  add(query_565636, "api-version", newJString(apiVersion))
  add(query_565636, "$expand", newJString(Expand))
  add(path_565635, "subscriptionId", newJString(subscriptionId))
  add(query_565636, "$orderby", newJString(Orderby))
  add(path_565635, "resourceGroupName", newJString(resourceGroupName))
  add(query_565636, "$filter", newJString(Filter))
  result = call_565634.call(path_565635, query_565636, nil, nil, nil)

var virtualNetworksList* = Call_VirtualNetworksList_565622(
    name: "virtualNetworksList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks",
    validator: validate_VirtualNetworksList_565623, base: "",
    url: url_VirtualNetworksList_565624, schemes: {Scheme.Https})
type
  Call_VirtualNetworksCreateOrUpdate_565650 = ref object of OpenApiRestCall_563564
proc url_VirtualNetworksCreateOrUpdate_565652(protocol: Scheme; host: string;
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

proc validate_VirtualNetworksCreateOrUpdate_565651(path: JsonNode; query: JsonNode;
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
  var valid_565653 = path.getOrDefault("labName")
  valid_565653 = validateParameter(valid_565653, JString, required = true,
                                 default = nil)
  if valid_565653 != nil:
    section.add "labName", valid_565653
  var valid_565654 = path.getOrDefault("name")
  valid_565654 = validateParameter(valid_565654, JString, required = true,
                                 default = nil)
  if valid_565654 != nil:
    section.add "name", valid_565654
  var valid_565655 = path.getOrDefault("subscriptionId")
  valid_565655 = validateParameter(valid_565655, JString, required = true,
                                 default = nil)
  if valid_565655 != nil:
    section.add "subscriptionId", valid_565655
  var valid_565656 = path.getOrDefault("resourceGroupName")
  valid_565656 = validateParameter(valid_565656, JString, required = true,
                                 default = nil)
  if valid_565656 != nil:
    section.add "resourceGroupName", valid_565656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565657 = query.getOrDefault("api-version")
  valid_565657 = validateParameter(valid_565657, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565657 != nil:
    section.add "api-version", valid_565657
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

proc call*(call_565659: Call_VirtualNetworksCreateOrUpdate_565650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing virtual network. This operation can take a while to complete.
  ## 
  let valid = call_565659.validator(path, query, header, formData, body)
  let scheme = call_565659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565659.url(scheme.get, call_565659.host, call_565659.base,
                         call_565659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565659, url, valid)

proc call*(call_565660: Call_VirtualNetworksCreateOrUpdate_565650; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          virtualNetwork: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565661 = newJObject()
  var query_565662 = newJObject()
  var body_565663 = newJObject()
  add(path_565661, "labName", newJString(labName))
  add(query_565662, "api-version", newJString(apiVersion))
  add(path_565661, "name", newJString(name))
  add(path_565661, "subscriptionId", newJString(subscriptionId))
  add(path_565661, "resourceGroupName", newJString(resourceGroupName))
  if virtualNetwork != nil:
    body_565663 = virtualNetwork
  result = call_565660.call(path_565661, query_565662, nil, nil, body_565663)

var virtualNetworksCreateOrUpdate* = Call_VirtualNetworksCreateOrUpdate_565650(
    name: "virtualNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksCreateOrUpdate_565651, base: "",
    url: url_VirtualNetworksCreateOrUpdate_565652, schemes: {Scheme.Https})
type
  Call_VirtualNetworksGet_565637 = ref object of OpenApiRestCall_563564
proc url_VirtualNetworksGet_565639(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksGet_565638(path: JsonNode; query: JsonNode;
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
  var valid_565640 = path.getOrDefault("labName")
  valid_565640 = validateParameter(valid_565640, JString, required = true,
                                 default = nil)
  if valid_565640 != nil:
    section.add "labName", valid_565640
  var valid_565641 = path.getOrDefault("name")
  valid_565641 = validateParameter(valid_565641, JString, required = true,
                                 default = nil)
  if valid_565641 != nil:
    section.add "name", valid_565641
  var valid_565642 = path.getOrDefault("subscriptionId")
  valid_565642 = validateParameter(valid_565642, JString, required = true,
                                 default = nil)
  if valid_565642 != nil:
    section.add "subscriptionId", valid_565642
  var valid_565643 = path.getOrDefault("resourceGroupName")
  valid_565643 = validateParameter(valid_565643, JString, required = true,
                                 default = nil)
  if valid_565643 != nil:
    section.add "resourceGroupName", valid_565643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($expand=externalSubnets)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565644 = query.getOrDefault("api-version")
  valid_565644 = validateParameter(valid_565644, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565644 != nil:
    section.add "api-version", valid_565644
  var valid_565645 = query.getOrDefault("$expand")
  valid_565645 = validateParameter(valid_565645, JString, required = false,
                                 default = nil)
  if valid_565645 != nil:
    section.add "$expand", valid_565645
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565646: Call_VirtualNetworksGet_565637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get virtual network.
  ## 
  let valid = call_565646.validator(path, query, header, formData, body)
  let scheme = call_565646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565646.url(scheme.get, call_565646.host, call_565646.base,
                         call_565646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565646, url, valid)

proc call*(call_565647: Call_VirtualNetworksGet_565637; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_565648 = newJObject()
  var query_565649 = newJObject()
  add(path_565648, "labName", newJString(labName))
  add(query_565649, "api-version", newJString(apiVersion))
  add(query_565649, "$expand", newJString(Expand))
  add(path_565648, "name", newJString(name))
  add(path_565648, "subscriptionId", newJString(subscriptionId))
  add(path_565648, "resourceGroupName", newJString(resourceGroupName))
  result = call_565647.call(path_565648, query_565649, nil, nil, nil)

var virtualNetworksGet* = Call_VirtualNetworksGet_565637(
    name: "virtualNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksGet_565638, base: "",
    url: url_VirtualNetworksGet_565639, schemes: {Scheme.Https})
type
  Call_VirtualNetworksUpdate_565676 = ref object of OpenApiRestCall_563564
proc url_VirtualNetworksUpdate_565678(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksUpdate_565677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of virtual networks. All other properties will be ignored.
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
  var valid_565679 = path.getOrDefault("labName")
  valid_565679 = validateParameter(valid_565679, JString, required = true,
                                 default = nil)
  if valid_565679 != nil:
    section.add "labName", valid_565679
  var valid_565680 = path.getOrDefault("name")
  valid_565680 = validateParameter(valid_565680, JString, required = true,
                                 default = nil)
  if valid_565680 != nil:
    section.add "name", valid_565680
  var valid_565681 = path.getOrDefault("subscriptionId")
  valid_565681 = validateParameter(valid_565681, JString, required = true,
                                 default = nil)
  if valid_565681 != nil:
    section.add "subscriptionId", valid_565681
  var valid_565682 = path.getOrDefault("resourceGroupName")
  valid_565682 = validateParameter(valid_565682, JString, required = true,
                                 default = nil)
  if valid_565682 != nil:
    section.add "resourceGroupName", valid_565682
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565683 = query.getOrDefault("api-version")
  valid_565683 = validateParameter(valid_565683, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565683 != nil:
    section.add "api-version", valid_565683
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

proc call*(call_565685: Call_VirtualNetworksUpdate_565676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of virtual networks. All other properties will be ignored.
  ## 
  let valid = call_565685.validator(path, query, header, formData, body)
  let scheme = call_565685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565685.url(scheme.get, call_565685.host, call_565685.base,
                         call_565685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565685, url, valid)

proc call*(call_565686: Call_VirtualNetworksUpdate_565676; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          virtualNetwork: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
  ## virtualNetworksUpdate
  ## Allows modifying tags of virtual networks. All other properties will be ignored.
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
  var path_565687 = newJObject()
  var query_565688 = newJObject()
  var body_565689 = newJObject()
  add(path_565687, "labName", newJString(labName))
  add(query_565688, "api-version", newJString(apiVersion))
  add(path_565687, "name", newJString(name))
  add(path_565687, "subscriptionId", newJString(subscriptionId))
  add(path_565687, "resourceGroupName", newJString(resourceGroupName))
  if virtualNetwork != nil:
    body_565689 = virtualNetwork
  result = call_565686.call(path_565687, query_565688, nil, nil, body_565689)

var virtualNetworksUpdate* = Call_VirtualNetworksUpdate_565676(
    name: "virtualNetworksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksUpdate_565677, base: "",
    url: url_VirtualNetworksUpdate_565678, schemes: {Scheme.Https})
type
  Call_VirtualNetworksDelete_565664 = ref object of OpenApiRestCall_563564
proc url_VirtualNetworksDelete_565666(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualNetworksDelete_565665(path: JsonNode; query: JsonNode;
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
  var valid_565667 = path.getOrDefault("labName")
  valid_565667 = validateParameter(valid_565667, JString, required = true,
                                 default = nil)
  if valid_565667 != nil:
    section.add "labName", valid_565667
  var valid_565668 = path.getOrDefault("name")
  valid_565668 = validateParameter(valid_565668, JString, required = true,
                                 default = nil)
  if valid_565668 != nil:
    section.add "name", valid_565668
  var valid_565669 = path.getOrDefault("subscriptionId")
  valid_565669 = validateParameter(valid_565669, JString, required = true,
                                 default = nil)
  if valid_565669 != nil:
    section.add "subscriptionId", valid_565669
  var valid_565670 = path.getOrDefault("resourceGroupName")
  valid_565670 = validateParameter(valid_565670, JString, required = true,
                                 default = nil)
  if valid_565670 != nil:
    section.add "resourceGroupName", valid_565670
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565671 = query.getOrDefault("api-version")
  valid_565671 = validateParameter(valid_565671, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565671 != nil:
    section.add "api-version", valid_565671
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565672: Call_VirtualNetworksDelete_565664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete virtual network. This operation can take a while to complete.
  ## 
  let valid = call_565672.validator(path, query, header, formData, body)
  let scheme = call_565672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565672.url(scheme.get, call_565672.host, call_565672.base,
                         call_565672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565672, url, valid)

proc call*(call_565673: Call_VirtualNetworksDelete_565664; labName: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565674 = newJObject()
  var query_565675 = newJObject()
  add(path_565674, "labName", newJString(labName))
  add(query_565675, "api-version", newJString(apiVersion))
  add(path_565674, "name", newJString(name))
  add(path_565674, "subscriptionId", newJString(subscriptionId))
  add(path_565674, "resourceGroupName", newJString(resourceGroupName))
  result = call_565673.call(path_565674, query_565675, nil, nil, nil)

var virtualNetworksDelete* = Call_VirtualNetworksDelete_565664(
    name: "virtualNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{labName}/virtualnetworks/{name}",
    validator: validate_VirtualNetworksDelete_565665, base: "",
    url: url_VirtualNetworksDelete_565666, schemes: {Scheme.Https})
type
  Call_LabsCreateOrUpdate_565702 = ref object of OpenApiRestCall_563564
proc url_LabsCreateOrUpdate_565704(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateOrUpdate_565703(path: JsonNode; query: JsonNode;
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
  var valid_565705 = path.getOrDefault("name")
  valid_565705 = validateParameter(valid_565705, JString, required = true,
                                 default = nil)
  if valid_565705 != nil:
    section.add "name", valid_565705
  var valid_565706 = path.getOrDefault("subscriptionId")
  valid_565706 = validateParameter(valid_565706, JString, required = true,
                                 default = nil)
  if valid_565706 != nil:
    section.add "subscriptionId", valid_565706
  var valid_565707 = path.getOrDefault("resourceGroupName")
  valid_565707 = validateParameter(valid_565707, JString, required = true,
                                 default = nil)
  if valid_565707 != nil:
    section.add "resourceGroupName", valid_565707
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565708 = query.getOrDefault("api-version")
  valid_565708 = validateParameter(valid_565708, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565708 != nil:
    section.add "api-version", valid_565708
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

proc call*(call_565710: Call_LabsCreateOrUpdate_565702; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing lab. This operation can take a while to complete.
  ## 
  let valid = call_565710.validator(path, query, header, formData, body)
  let scheme = call_565710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565710.url(scheme.get, call_565710.host, call_565710.base,
                         call_565710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565710, url, valid)

proc call*(call_565711: Call_LabsCreateOrUpdate_565702; lab: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565712 = newJObject()
  var query_565713 = newJObject()
  var body_565714 = newJObject()
  if lab != nil:
    body_565714 = lab
  add(query_565713, "api-version", newJString(apiVersion))
  add(path_565712, "name", newJString(name))
  add(path_565712, "subscriptionId", newJString(subscriptionId))
  add(path_565712, "resourceGroupName", newJString(resourceGroupName))
  result = call_565711.call(path_565712, query_565713, nil, nil, body_565714)

var labsCreateOrUpdate* = Call_LabsCreateOrUpdate_565702(
    name: "labsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
    validator: validate_LabsCreateOrUpdate_565703, base: "",
    url: url_LabsCreateOrUpdate_565704, schemes: {Scheme.Https})
type
  Call_LabsGet_565690 = ref object of OpenApiRestCall_563564
proc url_LabsGet_565692(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsGet_565691(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_565693 = path.getOrDefault("name")
  valid_565693 = validateParameter(valid_565693, JString, required = true,
                                 default = nil)
  if valid_565693 != nil:
    section.add "name", valid_565693
  var valid_565694 = path.getOrDefault("subscriptionId")
  valid_565694 = validateParameter(valid_565694, JString, required = true,
                                 default = nil)
  if valid_565694 != nil:
    section.add "subscriptionId", valid_565694
  var valid_565695 = path.getOrDefault("resourceGroupName")
  valid_565695 = validateParameter(valid_565695, JString, required = true,
                                 default = nil)
  if valid_565695 != nil:
    section.add "resourceGroupName", valid_565695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=defaultStorageAccount)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565696 = query.getOrDefault("api-version")
  valid_565696 = validateParameter(valid_565696, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565696 != nil:
    section.add "api-version", valid_565696
  var valid_565697 = query.getOrDefault("$expand")
  valid_565697 = validateParameter(valid_565697, JString, required = false,
                                 default = nil)
  if valid_565697 != nil:
    section.add "$expand", valid_565697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565698: Call_LabsGet_565690; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get lab.
  ## 
  let valid = call_565698.validator(path, query, header, formData, body)
  let scheme = call_565698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565698.url(scheme.get, call_565698.host, call_565698.base,
                         call_565698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565698, url, valid)

proc call*(call_565699: Call_LabsGet_565690; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15";
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
  var path_565700 = newJObject()
  var query_565701 = newJObject()
  add(query_565701, "api-version", newJString(apiVersion))
  add(query_565701, "$expand", newJString(Expand))
  add(path_565700, "name", newJString(name))
  add(path_565700, "subscriptionId", newJString(subscriptionId))
  add(path_565700, "resourceGroupName", newJString(resourceGroupName))
  result = call_565699.call(path_565700, query_565701, nil, nil, nil)

var labsGet* = Call_LabsGet_565690(name: "labsGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                validator: validate_LabsGet_565691, base: "",
                                url: url_LabsGet_565692, schemes: {Scheme.Https})
type
  Call_LabsUpdate_565726 = ref object of OpenApiRestCall_563564
proc url_LabsUpdate_565728(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsUpdate_565727(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of labs. All other properties will be ignored.
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
  var valid_565729 = path.getOrDefault("name")
  valid_565729 = validateParameter(valid_565729, JString, required = true,
                                 default = nil)
  if valid_565729 != nil:
    section.add "name", valid_565729
  var valid_565730 = path.getOrDefault("subscriptionId")
  valid_565730 = validateParameter(valid_565730, JString, required = true,
                                 default = nil)
  if valid_565730 != nil:
    section.add "subscriptionId", valid_565730
  var valid_565731 = path.getOrDefault("resourceGroupName")
  valid_565731 = validateParameter(valid_565731, JString, required = true,
                                 default = nil)
  if valid_565731 != nil:
    section.add "resourceGroupName", valid_565731
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565732 = query.getOrDefault("api-version")
  valid_565732 = validateParameter(valid_565732, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565732 != nil:
    section.add "api-version", valid_565732
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

proc call*(call_565734: Call_LabsUpdate_565726; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of labs. All other properties will be ignored.
  ## 
  let valid = call_565734.validator(path, query, header, formData, body)
  let scheme = call_565734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565734.url(scheme.get, call_565734.host, call_565734.base,
                         call_565734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565734, url, valid)

proc call*(call_565735: Call_LabsUpdate_565726; lab: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsUpdate
  ## Allows modifying tags of labs. All other properties will be ignored.
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
  var path_565736 = newJObject()
  var query_565737 = newJObject()
  var body_565738 = newJObject()
  if lab != nil:
    body_565738 = lab
  add(query_565737, "api-version", newJString(apiVersion))
  add(path_565736, "name", newJString(name))
  add(path_565736, "subscriptionId", newJString(subscriptionId))
  add(path_565736, "resourceGroupName", newJString(resourceGroupName))
  result = call_565735.call(path_565736, query_565737, nil, nil, body_565738)

var labsUpdate* = Call_LabsUpdate_565726(name: "labsUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsUpdate_565727,
                                      base: "", url: url_LabsUpdate_565728,
                                      schemes: {Scheme.Https})
type
  Call_LabsDelete_565715 = ref object of OpenApiRestCall_563564
proc url_LabsDelete_565717(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_LabsDelete_565716(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_565718 = path.getOrDefault("name")
  valid_565718 = validateParameter(valid_565718, JString, required = true,
                                 default = nil)
  if valid_565718 != nil:
    section.add "name", valid_565718
  var valid_565719 = path.getOrDefault("subscriptionId")
  valid_565719 = validateParameter(valid_565719, JString, required = true,
                                 default = nil)
  if valid_565719 != nil:
    section.add "subscriptionId", valid_565719
  var valid_565720 = path.getOrDefault("resourceGroupName")
  valid_565720 = validateParameter(valid_565720, JString, required = true,
                                 default = nil)
  if valid_565720 != nil:
    section.add "resourceGroupName", valid_565720
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565721 = query.getOrDefault("api-version")
  valid_565721 = validateParameter(valid_565721, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565721 != nil:
    section.add "api-version", valid_565721
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565722: Call_LabsDelete_565715; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete lab. This operation can take a while to complete.
  ## 
  let valid = call_565722.validator(path, query, header, formData, body)
  let scheme = call_565722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565722.url(scheme.get, call_565722.host, call_565722.base,
                         call_565722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565722, url, valid)

proc call*(call_565723: Call_LabsDelete_565715; name: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565724 = newJObject()
  var query_565725 = newJObject()
  add(query_565725, "api-version", newJString(apiVersion))
  add(path_565724, "name", newJString(name))
  add(path_565724, "subscriptionId", newJString(subscriptionId))
  add(path_565724, "resourceGroupName", newJString(resourceGroupName))
  result = call_565723.call(path_565724, query_565725, nil, nil, nil)

var labsDelete* = Call_LabsDelete_565715(name: "labsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}",
                                      validator: validate_LabsDelete_565716,
                                      base: "", url: url_LabsDelete_565717,
                                      schemes: {Scheme.Https})
type
  Call_LabsClaimAnyVm_565739 = ref object of OpenApiRestCall_563564
proc url_LabsClaimAnyVm_565741(protocol: Scheme; host: string; base: string;
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

proc validate_LabsClaimAnyVm_565740(path: JsonNode; query: JsonNode;
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
  var valid_565742 = path.getOrDefault("name")
  valid_565742 = validateParameter(valid_565742, JString, required = true,
                                 default = nil)
  if valid_565742 != nil:
    section.add "name", valid_565742
  var valid_565743 = path.getOrDefault("subscriptionId")
  valid_565743 = validateParameter(valid_565743, JString, required = true,
                                 default = nil)
  if valid_565743 != nil:
    section.add "subscriptionId", valid_565743
  var valid_565744 = path.getOrDefault("resourceGroupName")
  valid_565744 = validateParameter(valid_565744, JString, required = true,
                                 default = nil)
  if valid_565744 != nil:
    section.add "resourceGroupName", valid_565744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565745 = query.getOrDefault("api-version")
  valid_565745 = validateParameter(valid_565745, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565745 != nil:
    section.add "api-version", valid_565745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565746: Call_LabsClaimAnyVm_565739; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Claim a random claimable virtual machine in the lab. This operation can take a while to complete.
  ## 
  let valid = call_565746.validator(path, query, header, formData, body)
  let scheme = call_565746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565746.url(scheme.get, call_565746.host, call_565746.base,
                         call_565746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565746, url, valid)

proc call*(call_565747: Call_LabsClaimAnyVm_565739; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565748 = newJObject()
  var query_565749 = newJObject()
  add(query_565749, "api-version", newJString(apiVersion))
  add(path_565748, "name", newJString(name))
  add(path_565748, "subscriptionId", newJString(subscriptionId))
  add(path_565748, "resourceGroupName", newJString(resourceGroupName))
  result = call_565747.call(path_565748, query_565749, nil, nil, nil)

var labsClaimAnyVm* = Call_LabsClaimAnyVm_565739(name: "labsClaimAnyVm",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/claimAnyVm",
    validator: validate_LabsClaimAnyVm_565740, base: "", url: url_LabsClaimAnyVm_565741,
    schemes: {Scheme.Https})
type
  Call_LabsCreateEnvironment_565750 = ref object of OpenApiRestCall_563564
proc url_LabsCreateEnvironment_565752(protocol: Scheme; host: string; base: string;
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

proc validate_LabsCreateEnvironment_565751(path: JsonNode; query: JsonNode;
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
  var valid_565753 = path.getOrDefault("name")
  valid_565753 = validateParameter(valid_565753, JString, required = true,
                                 default = nil)
  if valid_565753 != nil:
    section.add "name", valid_565753
  var valid_565754 = path.getOrDefault("subscriptionId")
  valid_565754 = validateParameter(valid_565754, JString, required = true,
                                 default = nil)
  if valid_565754 != nil:
    section.add "subscriptionId", valid_565754
  var valid_565755 = path.getOrDefault("resourceGroupName")
  valid_565755 = validateParameter(valid_565755, JString, required = true,
                                 default = nil)
  if valid_565755 != nil:
    section.add "resourceGroupName", valid_565755
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565756 = query.getOrDefault("api-version")
  valid_565756 = validateParameter(valid_565756, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565756 != nil:
    section.add "api-version", valid_565756
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

proc call*(call_565758: Call_LabsCreateEnvironment_565750; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create virtual machines in a lab. This operation can take a while to complete.
  ## 
  let valid = call_565758.validator(path, query, header, formData, body)
  let scheme = call_565758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565758.url(scheme.get, call_565758.host, call_565758.base,
                         call_565758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565758, url, valid)

proc call*(call_565759: Call_LabsCreateEnvironment_565750; name: string;
          subscriptionId: string; labVirtualMachineCreationParameter: JsonNode;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565760 = newJObject()
  var query_565761 = newJObject()
  var body_565762 = newJObject()
  add(query_565761, "api-version", newJString(apiVersion))
  add(path_565760, "name", newJString(name))
  add(path_565760, "subscriptionId", newJString(subscriptionId))
  if labVirtualMachineCreationParameter != nil:
    body_565762 = labVirtualMachineCreationParameter
  add(path_565760, "resourceGroupName", newJString(resourceGroupName))
  result = call_565759.call(path_565760, query_565761, nil, nil, body_565762)

var labsCreateEnvironment* = Call_LabsCreateEnvironment_565750(
    name: "labsCreateEnvironment", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment",
    validator: validate_LabsCreateEnvironment_565751, base: "",
    url: url_LabsCreateEnvironment_565752, schemes: {Scheme.Https})
type
  Call_LabsExportResourceUsage_565763 = ref object of OpenApiRestCall_563564
proc url_LabsExportResourceUsage_565765(protocol: Scheme; host: string; base: string;
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

proc validate_LabsExportResourceUsage_565764(path: JsonNode; query: JsonNode;
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
  var valid_565766 = path.getOrDefault("name")
  valid_565766 = validateParameter(valid_565766, JString, required = true,
                                 default = nil)
  if valid_565766 != nil:
    section.add "name", valid_565766
  var valid_565767 = path.getOrDefault("subscriptionId")
  valid_565767 = validateParameter(valid_565767, JString, required = true,
                                 default = nil)
  if valid_565767 != nil:
    section.add "subscriptionId", valid_565767
  var valid_565768 = path.getOrDefault("resourceGroupName")
  valid_565768 = validateParameter(valid_565768, JString, required = true,
                                 default = nil)
  if valid_565768 != nil:
    section.add "resourceGroupName", valid_565768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565769 = query.getOrDefault("api-version")
  valid_565769 = validateParameter(valid_565769, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565769 != nil:
    section.add "api-version", valid_565769
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

proc call*(call_565771: Call_LabsExportResourceUsage_565763; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the lab resource usage into a storage account This operation can take a while to complete.
  ## 
  let valid = call_565771.validator(path, query, header, formData, body)
  let scheme = call_565771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565771.url(scheme.get, call_565771.host, call_565771.base,
                         call_565771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565771, url, valid)

proc call*(call_565772: Call_LabsExportResourceUsage_565763; name: string;
          subscriptionId: string; exportResourceUsageParameters: JsonNode;
          resourceGroupName: string; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565773 = newJObject()
  var query_565774 = newJObject()
  var body_565775 = newJObject()
  add(query_565774, "api-version", newJString(apiVersion))
  add(path_565773, "name", newJString(name))
  add(path_565773, "subscriptionId", newJString(subscriptionId))
  if exportResourceUsageParameters != nil:
    body_565775 = exportResourceUsageParameters
  add(path_565773, "resourceGroupName", newJString(resourceGroupName))
  result = call_565772.call(path_565773, query_565774, nil, nil, body_565775)

var labsExportResourceUsage* = Call_LabsExportResourceUsage_565763(
    name: "labsExportResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/exportResourceUsage",
    validator: validate_LabsExportResourceUsage_565764, base: "",
    url: url_LabsExportResourceUsage_565765, schemes: {Scheme.Https})
type
  Call_LabsGenerateUploadUri_565776 = ref object of OpenApiRestCall_563564
proc url_LabsGenerateUploadUri_565778(protocol: Scheme; host: string; base: string;
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

proc validate_LabsGenerateUploadUri_565777(path: JsonNode; query: JsonNode;
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
  var valid_565779 = path.getOrDefault("name")
  valid_565779 = validateParameter(valid_565779, JString, required = true,
                                 default = nil)
  if valid_565779 != nil:
    section.add "name", valid_565779
  var valid_565780 = path.getOrDefault("subscriptionId")
  valid_565780 = validateParameter(valid_565780, JString, required = true,
                                 default = nil)
  if valid_565780 != nil:
    section.add "subscriptionId", valid_565780
  var valid_565781 = path.getOrDefault("resourceGroupName")
  valid_565781 = validateParameter(valid_565781, JString, required = true,
                                 default = nil)
  if valid_565781 != nil:
    section.add "resourceGroupName", valid_565781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565782 = query.getOrDefault("api-version")
  valid_565782 = validateParameter(valid_565782, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565782 != nil:
    section.add "api-version", valid_565782
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

proc call*(call_565784: Call_LabsGenerateUploadUri_565776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate a URI for uploading custom disk images to a Lab.
  ## 
  let valid = call_565784.validator(path, query, header, formData, body)
  let scheme = call_565784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565784.url(scheme.get, call_565784.host, call_565784.base,
                         call_565784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565784, url, valid)

proc call*(call_565785: Call_LabsGenerateUploadUri_565776; name: string;
          subscriptionId: string; resourceGroupName: string;
          generateUploadUriParameter: JsonNode; apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565786 = newJObject()
  var query_565787 = newJObject()
  var body_565788 = newJObject()
  add(query_565787, "api-version", newJString(apiVersion))
  add(path_565786, "name", newJString(name))
  add(path_565786, "subscriptionId", newJString(subscriptionId))
  add(path_565786, "resourceGroupName", newJString(resourceGroupName))
  if generateUploadUriParameter != nil:
    body_565788 = generateUploadUriParameter
  result = call_565785.call(path_565786, query_565787, nil, nil, body_565788)

var labsGenerateUploadUri* = Call_LabsGenerateUploadUri_565776(
    name: "labsGenerateUploadUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri",
    validator: validate_LabsGenerateUploadUri_565777, base: "",
    url: url_LabsGenerateUploadUri_565778, schemes: {Scheme.Https})
type
  Call_LabsImportVirtualMachine_565789 = ref object of OpenApiRestCall_563564
proc url_LabsImportVirtualMachine_565791(protocol: Scheme; host: string;
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

proc validate_LabsImportVirtualMachine_565790(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Import a virtual machine into a different lab. This operation can take a while to complete.
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
  var valid_565792 = path.getOrDefault("name")
  valid_565792 = validateParameter(valid_565792, JString, required = true,
                                 default = nil)
  if valid_565792 != nil:
    section.add "name", valid_565792
  var valid_565793 = path.getOrDefault("subscriptionId")
  valid_565793 = validateParameter(valid_565793, JString, required = true,
                                 default = nil)
  if valid_565793 != nil:
    section.add "subscriptionId", valid_565793
  var valid_565794 = path.getOrDefault("resourceGroupName")
  valid_565794 = validateParameter(valid_565794, JString, required = true,
                                 default = nil)
  if valid_565794 != nil:
    section.add "resourceGroupName", valid_565794
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565795 = query.getOrDefault("api-version")
  valid_565795 = validateParameter(valid_565795, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565795 != nil:
    section.add "api-version", valid_565795
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

proc call*(call_565797: Call_LabsImportVirtualMachine_565789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Import a virtual machine into a different lab. This operation can take a while to complete.
  ## 
  let valid = call_565797.validator(path, query, header, formData, body)
  let scheme = call_565797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565797.url(scheme.get, call_565797.host, call_565797.base,
                         call_565797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565797, url, valid)

proc call*(call_565798: Call_LabsImportVirtualMachine_565789;
          importLabVirtualMachineRequest: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
  ## labsImportVirtualMachine
  ## Import a virtual machine into a different lab. This operation can take a while to complete.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   importLabVirtualMachineRequest: JObject (required)
  ##                                 : This represents the payload required to import a virtual machine from a different lab into the current one
  ##   name: string (required)
  ##       : The name of the lab.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565799 = newJObject()
  var query_565800 = newJObject()
  var body_565801 = newJObject()
  add(query_565800, "api-version", newJString(apiVersion))
  if importLabVirtualMachineRequest != nil:
    body_565801 = importLabVirtualMachineRequest
  add(path_565799, "name", newJString(name))
  add(path_565799, "subscriptionId", newJString(subscriptionId))
  add(path_565799, "resourceGroupName", newJString(resourceGroupName))
  result = call_565798.call(path_565799, query_565800, nil, nil, body_565801)

var labsImportVirtualMachine* = Call_LabsImportVirtualMachine_565789(
    name: "labsImportVirtualMachine", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/importVirtualMachine",
    validator: validate_LabsImportVirtualMachine_565790, base: "",
    url: url_LabsImportVirtualMachine_565791, schemes: {Scheme.Https})
type
  Call_LabsListVhds_565802 = ref object of OpenApiRestCall_563564
proc url_LabsListVhds_565804(protocol: Scheme; host: string; base: string;
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

proc validate_LabsListVhds_565803(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_565805 = path.getOrDefault("name")
  valid_565805 = validateParameter(valid_565805, JString, required = true,
                                 default = nil)
  if valid_565805 != nil:
    section.add "name", valid_565805
  var valid_565806 = path.getOrDefault("subscriptionId")
  valid_565806 = validateParameter(valid_565806, JString, required = true,
                                 default = nil)
  if valid_565806 != nil:
    section.add "subscriptionId", valid_565806
  var valid_565807 = path.getOrDefault("resourceGroupName")
  valid_565807 = validateParameter(valid_565807, JString, required = true,
                                 default = nil)
  if valid_565807 != nil:
    section.add "resourceGroupName", valid_565807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565808 = query.getOrDefault("api-version")
  valid_565808 = validateParameter(valid_565808, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565808 != nil:
    section.add "api-version", valid_565808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565809: Call_LabsListVhds_565802; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List disk images available for custom image creation.
  ## 
  let valid = call_565809.validator(path, query, header, formData, body)
  let scheme = call_565809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565809.url(scheme.get, call_565809.host, call_565809.base,
                         call_565809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565809, url, valid)

proc call*(call_565810: Call_LabsListVhds_565802; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565811 = newJObject()
  var query_565812 = newJObject()
  add(query_565812, "api-version", newJString(apiVersion))
  add(path_565811, "name", newJString(name))
  add(path_565811, "subscriptionId", newJString(subscriptionId))
  add(path_565811, "resourceGroupName", newJString(resourceGroupName))
  result = call_565810.call(path_565811, query_565812, nil, nil, nil)

var labsListVhds* = Call_LabsListVhds_565802(name: "labsListVhds",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds",
    validator: validate_LabsListVhds_565803, base: "", url: url_LabsListVhds_565804,
    schemes: {Scheme.Https})
type
  Call_GlobalSchedulesListByResourceGroup_565813 = ref object of OpenApiRestCall_563564
proc url_GlobalSchedulesListByResourceGroup_565815(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesListByResourceGroup_565814(path: JsonNode;
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
  var valid_565816 = path.getOrDefault("subscriptionId")
  valid_565816 = validateParameter(valid_565816, JString, required = true,
                                 default = nil)
  if valid_565816 != nil:
    section.add "subscriptionId", valid_565816
  var valid_565817 = path.getOrDefault("resourceGroupName")
  valid_565817 = validateParameter(valid_565817, JString, required = true,
                                 default = nil)
  if valid_565817 != nil:
    section.add "resourceGroupName", valid_565817
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  ##   $orderby: JString
  ##           : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   $filter: JString
  ##          : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  section = newJObject()
  var valid_565818 = query.getOrDefault("$top")
  valid_565818 = validateParameter(valid_565818, JInt, required = false, default = nil)
  if valid_565818 != nil:
    section.add "$top", valid_565818
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565819 = query.getOrDefault("api-version")
  valid_565819 = validateParameter(valid_565819, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565819 != nil:
    section.add "api-version", valid_565819
  var valid_565820 = query.getOrDefault("$expand")
  valid_565820 = validateParameter(valid_565820, JString, required = false,
                                 default = nil)
  if valid_565820 != nil:
    section.add "$expand", valid_565820
  var valid_565821 = query.getOrDefault("$orderby")
  valid_565821 = validateParameter(valid_565821, JString, required = false,
                                 default = nil)
  if valid_565821 != nil:
    section.add "$orderby", valid_565821
  var valid_565822 = query.getOrDefault("$filter")
  valid_565822 = validateParameter(valid_565822, JString, required = false,
                                 default = nil)
  if valid_565822 != nil:
    section.add "$filter", valid_565822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565823: Call_GlobalSchedulesListByResourceGroup_565813;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List schedules in a resource group.
  ## 
  let valid = call_565823.validator(path, query, header, formData, body)
  let scheme = call_565823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565823.url(scheme.get, call_565823.host, call_565823.base,
                         call_565823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565823, url, valid)

proc call*(call_565824: Call_GlobalSchedulesListByResourceGroup_565813;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          apiVersion: string = "2018-09-15"; Expand: string = ""; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## globalSchedulesListByResourceGroup
  ## List schedules in a resource group.
  ##   Top: int
  ##      : The maximum number of resources to return from the operation. Example: '$top=10'
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   Expand: string
  ##         : Specify the $expand query. Example: 'properties($select=status)'
  ##   subscriptionId: string (required)
  ##                 : The subscription ID.
  ##   Orderby: string
  ##          : The ordering expression for the results, using OData notation. Example: '$orderby=name desc'
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation. Example: '$filter=contains(name,'myName')
  var path_565825 = newJObject()
  var query_565826 = newJObject()
  add(query_565826, "$top", newJInt(Top))
  add(query_565826, "api-version", newJString(apiVersion))
  add(query_565826, "$expand", newJString(Expand))
  add(path_565825, "subscriptionId", newJString(subscriptionId))
  add(query_565826, "$orderby", newJString(Orderby))
  add(path_565825, "resourceGroupName", newJString(resourceGroupName))
  add(query_565826, "$filter", newJString(Filter))
  result = call_565824.call(path_565825, query_565826, nil, nil, nil)

var globalSchedulesListByResourceGroup* = Call_GlobalSchedulesListByResourceGroup_565813(
    name: "globalSchedulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules",
    validator: validate_GlobalSchedulesListByResourceGroup_565814, base: "",
    url: url_GlobalSchedulesListByResourceGroup_565815, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesCreateOrUpdate_565839 = ref object of OpenApiRestCall_563564
proc url_GlobalSchedulesCreateOrUpdate_565841(protocol: Scheme; host: string;
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

proc validate_GlobalSchedulesCreateOrUpdate_565840(path: JsonNode; query: JsonNode;
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
  var valid_565842 = path.getOrDefault("name")
  valid_565842 = validateParameter(valid_565842, JString, required = true,
                                 default = nil)
  if valid_565842 != nil:
    section.add "name", valid_565842
  var valid_565843 = path.getOrDefault("subscriptionId")
  valid_565843 = validateParameter(valid_565843, JString, required = true,
                                 default = nil)
  if valid_565843 != nil:
    section.add "subscriptionId", valid_565843
  var valid_565844 = path.getOrDefault("resourceGroupName")
  valid_565844 = validateParameter(valid_565844, JString, required = true,
                                 default = nil)
  if valid_565844 != nil:
    section.add "resourceGroupName", valid_565844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565845 = query.getOrDefault("api-version")
  valid_565845 = validateParameter(valid_565845, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565845 != nil:
    section.add "api-version", valid_565845
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

proc call*(call_565847: Call_GlobalSchedulesCreateOrUpdate_565839; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or replace an existing schedule.
  ## 
  let valid = call_565847.validator(path, query, header, formData, body)
  let scheme = call_565847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565847.url(scheme.get, call_565847.host, call_565847.base,
                         call_565847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565847, url, valid)

proc call*(call_565848: Call_GlobalSchedulesCreateOrUpdate_565839; name: string;
          subscriptionId: string; resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565849 = newJObject()
  var query_565850 = newJObject()
  var body_565851 = newJObject()
  add(query_565850, "api-version", newJString(apiVersion))
  add(path_565849, "name", newJString(name))
  add(path_565849, "subscriptionId", newJString(subscriptionId))
  add(path_565849, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565851 = schedule
  result = call_565848.call(path_565849, query_565850, nil, nil, body_565851)

var globalSchedulesCreateOrUpdate* = Call_GlobalSchedulesCreateOrUpdate_565839(
    name: "globalSchedulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesCreateOrUpdate_565840, base: "",
    url: url_GlobalSchedulesCreateOrUpdate_565841, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesGet_565827 = ref object of OpenApiRestCall_563564
proc url_GlobalSchedulesGet_565829(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesGet_565828(path: JsonNode; query: JsonNode;
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
  var valid_565830 = path.getOrDefault("name")
  valid_565830 = validateParameter(valid_565830, JString, required = true,
                                 default = nil)
  if valid_565830 != nil:
    section.add "name", valid_565830
  var valid_565831 = path.getOrDefault("subscriptionId")
  valid_565831 = validateParameter(valid_565831, JString, required = true,
                                 default = nil)
  if valid_565831 != nil:
    section.add "subscriptionId", valid_565831
  var valid_565832 = path.getOrDefault("resourceGroupName")
  valid_565832 = validateParameter(valid_565832, JString, required = true,
                                 default = nil)
  if valid_565832 != nil:
    section.add "resourceGroupName", valid_565832
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Specify the $expand query. Example: 'properties($select=status)'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565833 = query.getOrDefault("api-version")
  valid_565833 = validateParameter(valid_565833, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565833 != nil:
    section.add "api-version", valid_565833
  var valid_565834 = query.getOrDefault("$expand")
  valid_565834 = validateParameter(valid_565834, JString, required = false,
                                 default = nil)
  if valid_565834 != nil:
    section.add "$expand", valid_565834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565835: Call_GlobalSchedulesGet_565827; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get schedule.
  ## 
  let valid = call_565835.validator(path, query, header, formData, body)
  let scheme = call_565835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565835.url(scheme.get, call_565835.host, call_565835.base,
                         call_565835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565835, url, valid)

proc call*(call_565836: Call_GlobalSchedulesGet_565827; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"; Expand: string = ""): Recallable =
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
  var path_565837 = newJObject()
  var query_565838 = newJObject()
  add(query_565838, "api-version", newJString(apiVersion))
  add(query_565838, "$expand", newJString(Expand))
  add(path_565837, "name", newJString(name))
  add(path_565837, "subscriptionId", newJString(subscriptionId))
  add(path_565837, "resourceGroupName", newJString(resourceGroupName))
  result = call_565836.call(path_565837, query_565838, nil, nil, nil)

var globalSchedulesGet* = Call_GlobalSchedulesGet_565827(
    name: "globalSchedulesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesGet_565828, base: "",
    url: url_GlobalSchedulesGet_565829, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesUpdate_565863 = ref object of OpenApiRestCall_563564
proc url_GlobalSchedulesUpdate_565865(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesUpdate_565864(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var valid_565866 = path.getOrDefault("name")
  valid_565866 = validateParameter(valid_565866, JString, required = true,
                                 default = nil)
  if valid_565866 != nil:
    section.add "name", valid_565866
  var valid_565867 = path.getOrDefault("subscriptionId")
  valid_565867 = validateParameter(valid_565867, JString, required = true,
                                 default = nil)
  if valid_565867 != nil:
    section.add "subscriptionId", valid_565867
  var valid_565868 = path.getOrDefault("resourceGroupName")
  valid_565868 = validateParameter(valid_565868, JString, required = true,
                                 default = nil)
  if valid_565868 != nil:
    section.add "resourceGroupName", valid_565868
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565869 = query.getOrDefault("api-version")
  valid_565869 = validateParameter(valid_565869, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565869 != nil:
    section.add "api-version", valid_565869
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

proc call*(call_565871: Call_GlobalSchedulesUpdate_565863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allows modifying tags of schedules. All other properties will be ignored.
  ## 
  let valid = call_565871.validator(path, query, header, formData, body)
  let scheme = call_565871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565871.url(scheme.get, call_565871.host, call_565871.base,
                         call_565871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565871, url, valid)

proc call*(call_565872: Call_GlobalSchedulesUpdate_565863; name: string;
          subscriptionId: string; resourceGroupName: string; schedule: JsonNode;
          apiVersion: string = "2018-09-15"): Recallable =
  ## globalSchedulesUpdate
  ## Allows modifying tags of schedules. All other properties will be ignored.
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
  var path_565873 = newJObject()
  var query_565874 = newJObject()
  var body_565875 = newJObject()
  add(query_565874, "api-version", newJString(apiVersion))
  add(path_565873, "name", newJString(name))
  add(path_565873, "subscriptionId", newJString(subscriptionId))
  add(path_565873, "resourceGroupName", newJString(resourceGroupName))
  if schedule != nil:
    body_565875 = schedule
  result = call_565872.call(path_565873, query_565874, nil, nil, body_565875)

var globalSchedulesUpdate* = Call_GlobalSchedulesUpdate_565863(
    name: "globalSchedulesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesUpdate_565864, base: "",
    url: url_GlobalSchedulesUpdate_565865, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesDelete_565852 = ref object of OpenApiRestCall_563564
proc url_GlobalSchedulesDelete_565854(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesDelete_565853(path: JsonNode; query: JsonNode;
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
  var valid_565855 = path.getOrDefault("name")
  valid_565855 = validateParameter(valid_565855, JString, required = true,
                                 default = nil)
  if valid_565855 != nil:
    section.add "name", valid_565855
  var valid_565856 = path.getOrDefault("subscriptionId")
  valid_565856 = validateParameter(valid_565856, JString, required = true,
                                 default = nil)
  if valid_565856 != nil:
    section.add "subscriptionId", valid_565856
  var valid_565857 = path.getOrDefault("resourceGroupName")
  valid_565857 = validateParameter(valid_565857, JString, required = true,
                                 default = nil)
  if valid_565857 != nil:
    section.add "resourceGroupName", valid_565857
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565858 = query.getOrDefault("api-version")
  valid_565858 = validateParameter(valid_565858, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565858 != nil:
    section.add "api-version", valid_565858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565859: Call_GlobalSchedulesDelete_565852; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schedule.
  ## 
  let valid = call_565859.validator(path, query, header, formData, body)
  let scheme = call_565859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565859.url(scheme.get, call_565859.host, call_565859.base,
                         call_565859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565859, url, valid)

proc call*(call_565860: Call_GlobalSchedulesDelete_565852; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565861 = newJObject()
  var query_565862 = newJObject()
  add(query_565862, "api-version", newJString(apiVersion))
  add(path_565861, "name", newJString(name))
  add(path_565861, "subscriptionId", newJString(subscriptionId))
  add(path_565861, "resourceGroupName", newJString(resourceGroupName))
  result = call_565860.call(path_565861, query_565862, nil, nil, nil)

var globalSchedulesDelete* = Call_GlobalSchedulesDelete_565852(
    name: "globalSchedulesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}",
    validator: validate_GlobalSchedulesDelete_565853, base: "",
    url: url_GlobalSchedulesDelete_565854, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesExecute_565876 = ref object of OpenApiRestCall_563564
proc url_GlobalSchedulesExecute_565878(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesExecute_565877(path: JsonNode; query: JsonNode;
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
  var valid_565879 = path.getOrDefault("name")
  valid_565879 = validateParameter(valid_565879, JString, required = true,
                                 default = nil)
  if valid_565879 != nil:
    section.add "name", valid_565879
  var valid_565880 = path.getOrDefault("subscriptionId")
  valid_565880 = validateParameter(valid_565880, JString, required = true,
                                 default = nil)
  if valid_565880 != nil:
    section.add "subscriptionId", valid_565880
  var valid_565881 = path.getOrDefault("resourceGroupName")
  valid_565881 = validateParameter(valid_565881, JString, required = true,
                                 default = nil)
  if valid_565881 != nil:
    section.add "resourceGroupName", valid_565881
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565882 = query.getOrDefault("api-version")
  valid_565882 = validateParameter(valid_565882, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565882 != nil:
    section.add "api-version", valid_565882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565883: Call_GlobalSchedulesExecute_565876; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Execute a schedule. This operation can take a while to complete.
  ## 
  let valid = call_565883.validator(path, query, header, formData, body)
  let scheme = call_565883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565883.url(scheme.get, call_565883.host, call_565883.base,
                         call_565883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565883, url, valid)

proc call*(call_565884: Call_GlobalSchedulesExecute_565876; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565885 = newJObject()
  var query_565886 = newJObject()
  add(query_565886, "api-version", newJString(apiVersion))
  add(path_565885, "name", newJString(name))
  add(path_565885, "subscriptionId", newJString(subscriptionId))
  add(path_565885, "resourceGroupName", newJString(resourceGroupName))
  result = call_565884.call(path_565885, query_565886, nil, nil, nil)

var globalSchedulesExecute* = Call_GlobalSchedulesExecute_565876(
    name: "globalSchedulesExecute", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/execute",
    validator: validate_GlobalSchedulesExecute_565877, base: "",
    url: url_GlobalSchedulesExecute_565878, schemes: {Scheme.Https})
type
  Call_GlobalSchedulesRetarget_565887 = ref object of OpenApiRestCall_563564
proc url_GlobalSchedulesRetarget_565889(protocol: Scheme; host: string; base: string;
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

proc validate_GlobalSchedulesRetarget_565888(path: JsonNode; query: JsonNode;
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
  var valid_565890 = path.getOrDefault("name")
  valid_565890 = validateParameter(valid_565890, JString, required = true,
                                 default = nil)
  if valid_565890 != nil:
    section.add "name", valid_565890
  var valid_565891 = path.getOrDefault("subscriptionId")
  valid_565891 = validateParameter(valid_565891, JString, required = true,
                                 default = nil)
  if valid_565891 != nil:
    section.add "subscriptionId", valid_565891
  var valid_565892 = path.getOrDefault("resourceGroupName")
  valid_565892 = validateParameter(valid_565892, JString, required = true,
                                 default = nil)
  if valid_565892 != nil:
    section.add "resourceGroupName", valid_565892
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565893 = query.getOrDefault("api-version")
  valid_565893 = validateParameter(valid_565893, JString, required = true,
                                 default = newJString("2018-09-15"))
  if valid_565893 != nil:
    section.add "api-version", valid_565893
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

proc call*(call_565895: Call_GlobalSchedulesRetarget_565887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a schedule's target resource Id. This operation can take a while to complete.
  ## 
  let valid = call_565895.validator(path, query, header, formData, body)
  let scheme = call_565895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565895.url(scheme.get, call_565895.host, call_565895.base,
                         call_565895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565895, url, valid)

proc call*(call_565896: Call_GlobalSchedulesRetarget_565887;
          retargetScheduleProperties: JsonNode; name: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-09-15"): Recallable =
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
  var path_565897 = newJObject()
  var query_565898 = newJObject()
  var body_565899 = newJObject()
  add(query_565898, "api-version", newJString(apiVersion))
  if retargetScheduleProperties != nil:
    body_565899 = retargetScheduleProperties
  add(path_565897, "name", newJString(name))
  add(path_565897, "subscriptionId", newJString(subscriptionId))
  add(path_565897, "resourceGroupName", newJString(resourceGroupName))
  result = call_565896.call(path_565897, query_565898, nil, nil, body_565899)

var globalSchedulesRetarget* = Call_GlobalSchedulesRetarget_565887(
    name: "globalSchedulesRetarget", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/schedules/{name}/retarget",
    validator: validate_GlobalSchedulesRetarget_565888, base: "",
    url: url_GlobalSchedulesRetarget_565889, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
