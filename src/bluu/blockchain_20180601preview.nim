
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: BlockchainManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## REST API for Azure Blockchain Service
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "blockchain"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the available operations of Microsoft.Blockchain resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563954 = query.getOrDefault("api-version")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_563954 != nil:
    section.add "api-version", valid_563954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563977: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available operations of Microsoft.Blockchain resource provider.
  ## 
  let valid = call_563977.validator(path, query, header, formData, body)
  let scheme = call_563977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563977.url(scheme.get, call_563977.host, call_563977.base,
                         call_563977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563977, url, valid)

proc call*(call_564048: Call_OperationsList_563778;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## operationsList
  ## Lists the available operations of Microsoft.Blockchain resource provider.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_564049 = newJObject()
  add(query_564049, "api-version", newJString(apiVersion))
  result = call_564048.call(nil, query_564049, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Blockchain/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_BlockchainMembersListAll_564089 = ref object of OpenApiRestCall_563556
proc url_BlockchainMembersListAll_564091(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
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
        value: "/providers/Microsoft.Blockchain/blockchainMembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMembersListAll_564090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the blockchain members for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_BlockchainMembersListAll_564089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the blockchain members for a subscription.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_BlockchainMembersListAll_564089;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersListAll
  ## Lists the blockchain members for a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var blockchainMembersListAll* = Call_BlockchainMembersListAll_564089(
    name: "blockchainMembersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/blockchainMembers",
    validator: validate_BlockchainMembersListAll_564090, base: "",
    url: url_BlockchainMembersListAll_564091, schemes: {Scheme.Https})
type
  Call_BlockchainMemberOperationResultsGet_564112 = ref object of OpenApiRestCall_563556
proc url_BlockchainMemberOperationResultsGet_564114(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blockchain/locations/"),
               (kind: VariableSegment, value: "locationName"), (
        kind: ConstantSegment, value: "/blockchainMemberOperationResults/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMemberOperationResultsGet_564113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Async operation result.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : Location name.
  ##   operationId: JString (required)
  ##              : Operation Id.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564115 = path.getOrDefault("locationName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "locationName", valid_564115
  var valid_564116 = path.getOrDefault("operationId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "operationId", valid_564116
  var valid_564117 = path.getOrDefault("subscriptionId")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "subscriptionId", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564118 = query.getOrDefault("api-version")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564118 != nil:
    section.add "api-version", valid_564118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_BlockchainMemberOperationResultsGet_564112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Async operation result.
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_BlockchainMemberOperationResultsGet_564112;
          locationName: string; operationId: string; subscriptionId: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMemberOperationResultsGet
  ## Get Async operation result.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   locationName: string (required)
  ##               : Location name.
  ##   operationId: string (required)
  ##              : Operation Id.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  add(query_564122, "api-version", newJString(apiVersion))
  add(path_564121, "locationName", newJString(locationName))
  add(path_564121, "operationId", newJString(operationId))
  add(path_564121, "subscriptionId", newJString(subscriptionId))
  result = call_564120.call(path_564121, query_564122, nil, nil, nil)

var blockchainMemberOperationResultsGet* = Call_BlockchainMemberOperationResultsGet_564112(
    name: "blockchainMemberOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/locations/{locationName}/blockchainMemberOperationResults/{operationId}",
    validator: validate_BlockchainMemberOperationResultsGet_564113, base: "",
    url: url_BlockchainMemberOperationResultsGet_564114, schemes: {Scheme.Https})
type
  Call_LocationsCheckNameAvailability_564123 = ref object of OpenApiRestCall_563556
proc url_LocationsCheckNameAvailability_564125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blockchain/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsCheckNameAvailability_564124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## To check whether a resource name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : Location Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564126 = path.getOrDefault("locationName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "locationName", valid_564126
  var valid_564127 = path.getOrDefault("subscriptionId")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "subscriptionId", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nameAvailabilityRequest: JObject
  ##                          : Name availability request payload.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_LocationsCheckNameAvailability_564123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## To check whether a resource name is available.
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_LocationsCheckNameAvailability_564123;
          locationName: string; subscriptionId: string;
          apiVersion: string = "2018-06-01-preview";
          nameAvailabilityRequest: JsonNode = nil): Recallable =
  ## locationsCheckNameAvailability
  ## To check whether a resource name is available.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   locationName: string (required)
  ##               : Location Name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   nameAvailabilityRequest: JObject
  ##                          : Name availability request payload.
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  var body_564134 = newJObject()
  add(query_564133, "api-version", newJString(apiVersion))
  add(path_564132, "locationName", newJString(locationName))
  add(path_564132, "subscriptionId", newJString(subscriptionId))
  if nameAvailabilityRequest != nil:
    body_564134 = nameAvailabilityRequest
  result = call_564131.call(path_564132, query_564133, nil, nil, body_564134)

var locationsCheckNameAvailability* = Call_LocationsCheckNameAvailability_564123(
    name: "locationsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/locations/{locationName}/checkNameAvailability",
    validator: validate_LocationsCheckNameAvailability_564124, base: "",
    url: url_LocationsCheckNameAvailability_564125, schemes: {Scheme.Https})
type
  Call_LocationsListConsortiums_564135 = ref object of OpenApiRestCall_563556
proc url_LocationsListConsortiums_564137(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blockchain/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/listConsortiums")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsListConsortiums_564136(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available consortiums for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : Location Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564138 = path.getOrDefault("locationName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "locationName", valid_564138
  var valid_564139 = path.getOrDefault("subscriptionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "subscriptionId", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564141: Call_LocationsListConsortiums_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available consortiums for a subscription.
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_LocationsListConsortiums_564135; locationName: string;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## locationsListConsortiums
  ## Lists the available consortiums for a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   locationName: string (required)
  ##               : Location Name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "locationName", newJString(locationName))
  add(path_564143, "subscriptionId", newJString(subscriptionId))
  result = call_564142.call(path_564143, query_564144, nil, nil, nil)

var locationsListConsortiums* = Call_LocationsListConsortiums_564135(
    name: "locationsListConsortiums", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/locations/{locationName}/listConsortiums",
    validator: validate_LocationsListConsortiums_564136, base: "",
    url: url_LocationsListConsortiums_564137, schemes: {Scheme.Https})
type
  Call_SkusList_564145 = ref object of OpenApiRestCall_563556
proc url_SkusList_564147(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blockchain/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SkusList_564146(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Skus of the resource type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564148 = path.getOrDefault("subscriptionId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "subscriptionId", valid_564148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564149 = query.getOrDefault("api-version")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564149 != nil:
    section.add "api-version", valid_564149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564150: Call_SkusList_564145; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Skus of the resource type.
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_SkusList_564145; subscriptionId: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## skusList
  ## Lists the Skus of the resource type.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  add(query_564153, "api-version", newJString(apiVersion))
  add(path_564152, "subscriptionId", newJString(subscriptionId))
  result = call_564151.call(path_564152, query_564153, nil, nil, nil)

var skusList* = Call_SkusList_564145(name: "skusList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/skus",
                                  validator: validate_SkusList_564146, base: "",
                                  url: url_SkusList_564147,
                                  schemes: {Scheme.Https})
type
  Call_BlockchainMembersList_564154 = ref object of OpenApiRestCall_563556
proc url_BlockchainMembersList_564156(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Blockchain/blockchainMembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMembersList_564155(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the blockchain members for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564157 = path.getOrDefault("subscriptionId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "subscriptionId", valid_564157
  var valid_564158 = path.getOrDefault("resourceGroupName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "resourceGroupName", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564159 = query.getOrDefault("api-version")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564159 != nil:
    section.add "api-version", valid_564159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564160: Call_BlockchainMembersList_564154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the blockchain members for a resource group.
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_BlockchainMembersList_564154; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersList
  ## Lists the blockchain members for a resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  add(query_564163, "api-version", newJString(apiVersion))
  add(path_564162, "subscriptionId", newJString(subscriptionId))
  add(path_564162, "resourceGroupName", newJString(resourceGroupName))
  result = call_564161.call(path_564162, query_564163, nil, nil, nil)

var blockchainMembersList* = Call_BlockchainMembersList_564154(
    name: "blockchainMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers",
    validator: validate_BlockchainMembersList_564155, base: "",
    url: url_BlockchainMembersList_564156, schemes: {Scheme.Https})
type
  Call_BlockchainMembersCreate_564175 = ref object of OpenApiRestCall_563556
proc url_BlockchainMembersCreate_564177(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMembersCreate_564176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564178 = path.getOrDefault("blockchainMemberName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "blockchainMemberName", valid_564178
  var valid_564179 = path.getOrDefault("subscriptionId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "subscriptionId", valid_564179
  var valid_564180 = path.getOrDefault("resourceGroupName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "resourceGroupName", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564181 != nil:
    section.add "api-version", valid_564181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   blockchainMember: JObject
  ##                   : Payload to create a blockchain member.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564183: Call_BlockchainMembersCreate_564175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a blockchain member.
  ## 
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_BlockchainMembersCreate_564175;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-06-01-preview";
          blockchainMember: JsonNode = nil): Recallable =
  ## blockchainMembersCreate
  ## Create a blockchain member.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   blockchainMember: JObject
  ##                   : Payload to create a blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564185 = newJObject()
  var query_564186 = newJObject()
  var body_564187 = newJObject()
  add(path_564185, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564186, "api-version", newJString(apiVersion))
  add(path_564185, "subscriptionId", newJString(subscriptionId))
  if blockchainMember != nil:
    body_564187 = blockchainMember
  add(path_564185, "resourceGroupName", newJString(resourceGroupName))
  result = call_564184.call(path_564185, query_564186, nil, nil, body_564187)

var blockchainMembersCreate* = Call_BlockchainMembersCreate_564175(
    name: "blockchainMembersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersCreate_564176, base: "",
    url: url_BlockchainMembersCreate_564177, schemes: {Scheme.Https})
type
  Call_BlockchainMembersGet_564164 = ref object of OpenApiRestCall_563556
proc url_BlockchainMembersGet_564166(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMembersGet_564165(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details about a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564167 = path.getOrDefault("blockchainMemberName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "blockchainMemberName", valid_564167
  var valid_564168 = path.getOrDefault("subscriptionId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "subscriptionId", valid_564168
  var valid_564169 = path.getOrDefault("resourceGroupName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "resourceGroupName", valid_564169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564170 != nil:
    section.add "api-version", valid_564170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_BlockchainMembersGet_564164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details about a blockchain member.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_BlockchainMembersGet_564164;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersGet
  ## Get details about a blockchain member.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  add(path_564173, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564174, "api-version", newJString(apiVersion))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(path_564173, "resourceGroupName", newJString(resourceGroupName))
  result = call_564172.call(path_564173, query_564174, nil, nil, nil)

var blockchainMembersGet* = Call_BlockchainMembersGet_564164(
    name: "blockchainMembersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersGet_564165, base: "",
    url: url_BlockchainMembersGet_564166, schemes: {Scheme.Https})
type
  Call_BlockchainMembersUpdate_564199 = ref object of OpenApiRestCall_563556
proc url_BlockchainMembersUpdate_564201(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMembersUpdate_564200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564202 = path.getOrDefault("blockchainMemberName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "blockchainMemberName", valid_564202
  var valid_564203 = path.getOrDefault("subscriptionId")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "subscriptionId", valid_564203
  var valid_564204 = path.getOrDefault("resourceGroupName")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "resourceGroupName", valid_564204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564205 != nil:
    section.add "api-version", valid_564205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   blockchainMember: JObject
  ##                   : Payload to update the blockchain member.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564207: Call_BlockchainMembersUpdate_564199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a blockchain member.
  ## 
  let valid = call_564207.validator(path, query, header, formData, body)
  let scheme = call_564207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564207.url(scheme.get, call_564207.host, call_564207.base,
                         call_564207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564207, url, valid)

proc call*(call_564208: Call_BlockchainMembersUpdate_564199;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-06-01-preview";
          blockchainMember: JsonNode = nil): Recallable =
  ## blockchainMembersUpdate
  ## Update a blockchain member.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   blockchainMember: JObject
  ##                   : Payload to update the blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564209 = newJObject()
  var query_564210 = newJObject()
  var body_564211 = newJObject()
  add(path_564209, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564210, "api-version", newJString(apiVersion))
  add(path_564209, "subscriptionId", newJString(subscriptionId))
  if blockchainMember != nil:
    body_564211 = blockchainMember
  add(path_564209, "resourceGroupName", newJString(resourceGroupName))
  result = call_564208.call(path_564209, query_564210, nil, nil, body_564211)

var blockchainMembersUpdate* = Call_BlockchainMembersUpdate_564199(
    name: "blockchainMembersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersUpdate_564200, base: "",
    url: url_BlockchainMembersUpdate_564201, schemes: {Scheme.Https})
type
  Call_BlockchainMembersDelete_564188 = ref object of OpenApiRestCall_563556
proc url_BlockchainMembersDelete_564190(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMembersDelete_564189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564191 = path.getOrDefault("blockchainMemberName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "blockchainMemberName", valid_564191
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("resourceGroupName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "resourceGroupName", valid_564193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564194 = query.getOrDefault("api-version")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564194 != nil:
    section.add "api-version", valid_564194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564195: Call_BlockchainMembersDelete_564188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blockchain member.
  ## 
  let valid = call_564195.validator(path, query, header, formData, body)
  let scheme = call_564195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564195.url(scheme.get, call_564195.host, call_564195.base,
                         call_564195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564195, url, valid)

proc call*(call_564196: Call_BlockchainMembersDelete_564188;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersDelete
  ## Delete a blockchain member.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564197 = newJObject()
  var query_564198 = newJObject()
  add(path_564197, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564198, "api-version", newJString(apiVersion))
  add(path_564197, "subscriptionId", newJString(subscriptionId))
  add(path_564197, "resourceGroupName", newJString(resourceGroupName))
  result = call_564196.call(path_564197, query_564198, nil, nil, nil)

var blockchainMembersDelete* = Call_BlockchainMembersDelete_564188(
    name: "blockchainMembersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersDelete_564189, base: "",
    url: url_BlockchainMembersDelete_564190, schemes: {Scheme.Https})
type
  Call_BlockchainMembersListConsortiumMembers_564212 = ref object of OpenApiRestCall_563556
proc url_BlockchainMembersListConsortiumMembers_564214(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/consortiumMembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMembersListConsortiumMembers_564213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the consortium members for a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564215 = path.getOrDefault("blockchainMemberName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "blockchainMemberName", valid_564215
  var valid_564216 = path.getOrDefault("subscriptionId")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "subscriptionId", valid_564216
  var valid_564217 = path.getOrDefault("resourceGroupName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "resourceGroupName", valid_564217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564218 = query.getOrDefault("api-version")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564218 != nil:
    section.add "api-version", valid_564218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564219: Call_BlockchainMembersListConsortiumMembers_564212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the consortium members for a blockchain member.
  ## 
  let valid = call_564219.validator(path, query, header, formData, body)
  let scheme = call_564219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564219.url(scheme.get, call_564219.host, call_564219.base,
                         call_564219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564219, url, valid)

proc call*(call_564220: Call_BlockchainMembersListConsortiumMembers_564212;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersListConsortiumMembers
  ## Lists the consortium members for a blockchain member.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564221 = newJObject()
  var query_564222 = newJObject()
  add(path_564221, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564222, "api-version", newJString(apiVersion))
  add(path_564221, "subscriptionId", newJString(subscriptionId))
  add(path_564221, "resourceGroupName", newJString(resourceGroupName))
  result = call_564220.call(path_564221, query_564222, nil, nil, nil)

var blockchainMembersListConsortiumMembers* = Call_BlockchainMembersListConsortiumMembers_564212(
    name: "blockchainMembersListConsortiumMembers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/consortiumMembers",
    validator: validate_BlockchainMembersListConsortiumMembers_564213, base: "",
    url: url_BlockchainMembersListConsortiumMembers_564214,
    schemes: {Scheme.Https})
type
  Call_BlockchainMembersListApiKeys_564223 = ref object of OpenApiRestCall_563556
proc url_BlockchainMembersListApiKeys_564225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/listApiKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMembersListApiKeys_564224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the API keys for a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564226 = path.getOrDefault("blockchainMemberName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "blockchainMemberName", valid_564226
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564229 != nil:
    section.add "api-version", valid_564229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564230: Call_BlockchainMembersListApiKeys_564223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the API keys for a blockchain member.
  ## 
  let valid = call_564230.validator(path, query, header, formData, body)
  let scheme = call_564230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564230.url(scheme.get, call_564230.host, call_564230.base,
                         call_564230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564230, url, valid)

proc call*(call_564231: Call_BlockchainMembersListApiKeys_564223;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersListApiKeys
  ## Lists the API keys for a blockchain member.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564232 = newJObject()
  var query_564233 = newJObject()
  add(path_564232, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564233, "api-version", newJString(apiVersion))
  add(path_564232, "subscriptionId", newJString(subscriptionId))
  add(path_564232, "resourceGroupName", newJString(resourceGroupName))
  result = call_564231.call(path_564232, query_564233, nil, nil, nil)

var blockchainMembersListApiKeys* = Call_BlockchainMembersListApiKeys_564223(
    name: "blockchainMembersListApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/listApiKeys",
    validator: validate_BlockchainMembersListApiKeys_564224, base: "",
    url: url_BlockchainMembersListApiKeys_564225, schemes: {Scheme.Https})
type
  Call_BlockchainMembersListRegenerateApiKeys_564234 = ref object of OpenApiRestCall_563556
proc url_BlockchainMembersListRegenerateApiKeys_564236(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/regenerateApiKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlockchainMembersListRegenerateApiKeys_564235(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate the API keys for a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564237 = path.getOrDefault("blockchainMemberName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "blockchainMemberName", valid_564237
  var valid_564238 = path.getOrDefault("subscriptionId")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "subscriptionId", valid_564238
  var valid_564239 = path.getOrDefault("resourceGroupName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "resourceGroupName", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564240 = query.getOrDefault("api-version")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564240 != nil:
    section.add "api-version", valid_564240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   apiKey: JObject
  ##         : api key to be regenerate
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564242: Call_BlockchainMembersListRegenerateApiKeys_564234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate the API keys for a blockchain member.
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_BlockchainMembersListRegenerateApiKeys_564234;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-06-01-preview";
          apiKey: JsonNode = nil): Recallable =
  ## blockchainMembersListRegenerateApiKeys
  ## Regenerate the API keys for a blockchain member.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   apiKey: JObject
  ##         : api key to be regenerate
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564244 = newJObject()
  var query_564245 = newJObject()
  var body_564246 = newJObject()
  add(path_564244, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564245, "api-version", newJString(apiVersion))
  if apiKey != nil:
    body_564246 = apiKey
  add(path_564244, "subscriptionId", newJString(subscriptionId))
  add(path_564244, "resourceGroupName", newJString(resourceGroupName))
  result = call_564243.call(path_564244, query_564245, nil, nil, body_564246)

var blockchainMembersListRegenerateApiKeys* = Call_BlockchainMembersListRegenerateApiKeys_564234(
    name: "blockchainMembersListRegenerateApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/regenerateApiKeys",
    validator: validate_BlockchainMembersListRegenerateApiKeys_564235, base: "",
    url: url_BlockchainMembersListRegenerateApiKeys_564236,
    schemes: {Scheme.Https})
type
  Call_TransactionNodesList_564247 = ref object of OpenApiRestCall_563556
proc url_TransactionNodesList_564249(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/transactionNodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionNodesList_564248(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transaction nodes for a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564250 = path.getOrDefault("blockchainMemberName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "blockchainMemberName", valid_564250
  var valid_564251 = path.getOrDefault("subscriptionId")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "subscriptionId", valid_564251
  var valid_564252 = path.getOrDefault("resourceGroupName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "resourceGroupName", valid_564252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564253 = query.getOrDefault("api-version")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564253 != nil:
    section.add "api-version", valid_564253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564254: Call_TransactionNodesList_564247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transaction nodes for a blockchain member.
  ## 
  let valid = call_564254.validator(path, query, header, formData, body)
  let scheme = call_564254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564254.url(scheme.get, call_564254.host, call_564254.base,
                         call_564254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564254, url, valid)

proc call*(call_564255: Call_TransactionNodesList_564247;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## transactionNodesList
  ## Lists the transaction nodes for a blockchain member.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564256 = newJObject()
  var query_564257 = newJObject()
  add(path_564256, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564257, "api-version", newJString(apiVersion))
  add(path_564256, "subscriptionId", newJString(subscriptionId))
  add(path_564256, "resourceGroupName", newJString(resourceGroupName))
  result = call_564255.call(path_564256, query_564257, nil, nil, nil)

var transactionNodesList* = Call_TransactionNodesList_564247(
    name: "transactionNodesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes",
    validator: validate_TransactionNodesList_564248, base: "",
    url: url_TransactionNodesList_564249, schemes: {Scheme.Https})
type
  Call_TransactionNodesCreate_564270 = ref object of OpenApiRestCall_563556
proc url_TransactionNodesCreate_564272(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  assert "transactionNodeName" in path,
        "`transactionNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/transactionNodes/"),
               (kind: VariableSegment, value: "transactionNodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionNodesCreate_564271(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564273 = path.getOrDefault("blockchainMemberName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "blockchainMemberName", valid_564273
  var valid_564274 = path.getOrDefault("subscriptionId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "subscriptionId", valid_564274
  var valid_564275 = path.getOrDefault("resourceGroupName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "resourceGroupName", valid_564275
  var valid_564276 = path.getOrDefault("transactionNodeName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "transactionNodeName", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564277 = query.getOrDefault("api-version")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564277 != nil:
    section.add "api-version", valid_564277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   transactionNode: JObject
  ##                  : Payload to create the transaction node.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564279: Call_TransactionNodesCreate_564270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the transaction node.
  ## 
  let valid = call_564279.validator(path, query, header, formData, body)
  let scheme = call_564279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564279.url(scheme.get, call_564279.host, call_564279.base,
                         call_564279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564279, url, valid)

proc call*(call_564280: Call_TransactionNodesCreate_564270;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"; transactionNode: JsonNode = nil): Recallable =
  ## transactionNodesCreate
  ## Create or update the transaction node.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNode: JObject
  ##                  : Payload to create the transaction node.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  var path_564281 = newJObject()
  var query_564282 = newJObject()
  var body_564283 = newJObject()
  add(path_564281, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564282, "api-version", newJString(apiVersion))
  add(path_564281, "subscriptionId", newJString(subscriptionId))
  add(path_564281, "resourceGroupName", newJString(resourceGroupName))
  if transactionNode != nil:
    body_564283 = transactionNode
  add(path_564281, "transactionNodeName", newJString(transactionNodeName))
  result = call_564280.call(path_564281, query_564282, nil, nil, body_564283)

var transactionNodesCreate* = Call_TransactionNodesCreate_564270(
    name: "transactionNodesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesCreate_564271, base: "",
    url: url_TransactionNodesCreate_564272, schemes: {Scheme.Https})
type
  Call_TransactionNodesGet_564258 = ref object of OpenApiRestCall_563556
proc url_TransactionNodesGet_564260(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  assert "transactionNodeName" in path,
        "`transactionNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/transactionNodes/"),
               (kind: VariableSegment, value: "transactionNodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionNodesGet_564259(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the details of the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564261 = path.getOrDefault("blockchainMemberName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "blockchainMemberName", valid_564261
  var valid_564262 = path.getOrDefault("subscriptionId")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "subscriptionId", valid_564262
  var valid_564263 = path.getOrDefault("resourceGroupName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "resourceGroupName", valid_564263
  var valid_564264 = path.getOrDefault("transactionNodeName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "transactionNodeName", valid_564264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564265 = query.getOrDefault("api-version")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564265 != nil:
    section.add "api-version", valid_564265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564266: Call_TransactionNodesGet_564258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the transaction node.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_TransactionNodesGet_564258;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## transactionNodesGet
  ## Get the details of the transaction node.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  add(path_564268, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564269, "api-version", newJString(apiVersion))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  add(path_564268, "transactionNodeName", newJString(transactionNodeName))
  result = call_564267.call(path_564268, query_564269, nil, nil, nil)

var transactionNodesGet* = Call_TransactionNodesGet_564258(
    name: "transactionNodesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesGet_564259, base: "",
    url: url_TransactionNodesGet_564260, schemes: {Scheme.Https})
type
  Call_TransactionNodesUpdate_564296 = ref object of OpenApiRestCall_563556
proc url_TransactionNodesUpdate_564298(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  assert "transactionNodeName" in path,
        "`transactionNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/transactionNodes/"),
               (kind: VariableSegment, value: "transactionNodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionNodesUpdate_564297(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564299 = path.getOrDefault("blockchainMemberName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "blockchainMemberName", valid_564299
  var valid_564300 = path.getOrDefault("subscriptionId")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "subscriptionId", valid_564300
  var valid_564301 = path.getOrDefault("resourceGroupName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "resourceGroupName", valid_564301
  var valid_564302 = path.getOrDefault("transactionNodeName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "transactionNodeName", valid_564302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564303 = query.getOrDefault("api-version")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564303 != nil:
    section.add "api-version", valid_564303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   transactionNode: JObject
  ##                  : Payload to create the transaction node.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564305: Call_TransactionNodesUpdate_564296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the transaction node.
  ## 
  let valid = call_564305.validator(path, query, header, formData, body)
  let scheme = call_564305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564305.url(scheme.get, call_564305.host, call_564305.base,
                         call_564305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564305, url, valid)

proc call*(call_564306: Call_TransactionNodesUpdate_564296;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"; transactionNode: JsonNode = nil): Recallable =
  ## transactionNodesUpdate
  ## Update the transaction node.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNode: JObject
  ##                  : Payload to create the transaction node.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  var path_564307 = newJObject()
  var query_564308 = newJObject()
  var body_564309 = newJObject()
  add(path_564307, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564308, "api-version", newJString(apiVersion))
  add(path_564307, "subscriptionId", newJString(subscriptionId))
  add(path_564307, "resourceGroupName", newJString(resourceGroupName))
  if transactionNode != nil:
    body_564309 = transactionNode
  add(path_564307, "transactionNodeName", newJString(transactionNodeName))
  result = call_564306.call(path_564307, query_564308, nil, nil, body_564309)

var transactionNodesUpdate* = Call_TransactionNodesUpdate_564296(
    name: "transactionNodesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesUpdate_564297, base: "",
    url: url_TransactionNodesUpdate_564298, schemes: {Scheme.Https})
type
  Call_TransactionNodesDelete_564284 = ref object of OpenApiRestCall_563556
proc url_TransactionNodesDelete_564286(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  assert "transactionNodeName" in path,
        "`transactionNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/transactionNodes/"),
               (kind: VariableSegment, value: "transactionNodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionNodesDelete_564285(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564287 = path.getOrDefault("blockchainMemberName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "blockchainMemberName", valid_564287
  var valid_564288 = path.getOrDefault("subscriptionId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "subscriptionId", valid_564288
  var valid_564289 = path.getOrDefault("resourceGroupName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "resourceGroupName", valid_564289
  var valid_564290 = path.getOrDefault("transactionNodeName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "transactionNodeName", valid_564290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564291 = query.getOrDefault("api-version")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564291 != nil:
    section.add "api-version", valid_564291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564292: Call_TransactionNodesDelete_564284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the transaction node.
  ## 
  let valid = call_564292.validator(path, query, header, formData, body)
  let scheme = call_564292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564292.url(scheme.get, call_564292.host, call_564292.base,
                         call_564292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564292, url, valid)

proc call*(call_564293: Call_TransactionNodesDelete_564284;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## transactionNodesDelete
  ## Delete the transaction node.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  var path_564294 = newJObject()
  var query_564295 = newJObject()
  add(path_564294, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564295, "api-version", newJString(apiVersion))
  add(path_564294, "subscriptionId", newJString(subscriptionId))
  add(path_564294, "resourceGroupName", newJString(resourceGroupName))
  add(path_564294, "transactionNodeName", newJString(transactionNodeName))
  result = call_564293.call(path_564294, query_564295, nil, nil, nil)

var transactionNodesDelete* = Call_TransactionNodesDelete_564284(
    name: "transactionNodesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesDelete_564285, base: "",
    url: url_TransactionNodesDelete_564286, schemes: {Scheme.Https})
type
  Call_TransactionNodesListApiKeys_564310 = ref object of OpenApiRestCall_563556
proc url_TransactionNodesListApiKeys_564312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  assert "transactionNodeName" in path,
        "`transactionNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/transactionNodes/"),
               (kind: VariableSegment, value: "transactionNodeName"),
               (kind: ConstantSegment, value: "/listApiKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionNodesListApiKeys_564311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the API keys for the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564313 = path.getOrDefault("blockchainMemberName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "blockchainMemberName", valid_564313
  var valid_564314 = path.getOrDefault("subscriptionId")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "subscriptionId", valid_564314
  var valid_564315 = path.getOrDefault("resourceGroupName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "resourceGroupName", valid_564315
  var valid_564316 = path.getOrDefault("transactionNodeName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "transactionNodeName", valid_564316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564317 = query.getOrDefault("api-version")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564317 != nil:
    section.add "api-version", valid_564317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564318: Call_TransactionNodesListApiKeys_564310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the API keys for the transaction node.
  ## 
  let valid = call_564318.validator(path, query, header, formData, body)
  let scheme = call_564318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564318.url(scheme.get, call_564318.host, call_564318.base,
                         call_564318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564318, url, valid)

proc call*(call_564319: Call_TransactionNodesListApiKeys_564310;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## transactionNodesListApiKeys
  ## List the API keys for the transaction node.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  var path_564320 = newJObject()
  var query_564321 = newJObject()
  add(path_564320, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564321, "api-version", newJString(apiVersion))
  add(path_564320, "subscriptionId", newJString(subscriptionId))
  add(path_564320, "resourceGroupName", newJString(resourceGroupName))
  add(path_564320, "transactionNodeName", newJString(transactionNodeName))
  result = call_564319.call(path_564320, query_564321, nil, nil, nil)

var transactionNodesListApiKeys* = Call_TransactionNodesListApiKeys_564310(
    name: "transactionNodesListApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}/listApiKeys",
    validator: validate_TransactionNodesListApiKeys_564311, base: "",
    url: url_TransactionNodesListApiKeys_564312, schemes: {Scheme.Https})
type
  Call_TransactionNodesListRegenerateApiKeys_564322 = ref object of OpenApiRestCall_563556
proc url_TransactionNodesListRegenerateApiKeys_564324(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "blockchainMemberName" in path,
        "`blockchainMemberName` is a required path parameter"
  assert "transactionNodeName" in path,
        "`transactionNodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blockchain/blockchainMembers/"),
               (kind: VariableSegment, value: "blockchainMemberName"),
               (kind: ConstantSegment, value: "/transactionNodes/"),
               (kind: VariableSegment, value: "transactionNodeName"),
               (kind: ConstantSegment, value: "/regenerateApiKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionNodesListRegenerateApiKeys_564323(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate the API keys for the blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blockchainMemberName` field"
  var valid_564325 = path.getOrDefault("blockchainMemberName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "blockchainMemberName", valid_564325
  var valid_564326 = path.getOrDefault("subscriptionId")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "subscriptionId", valid_564326
  var valid_564327 = path.getOrDefault("resourceGroupName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "resourceGroupName", valid_564327
  var valid_564328 = path.getOrDefault("transactionNodeName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "transactionNodeName", valid_564328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564329 = query.getOrDefault("api-version")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_564329 != nil:
    section.add "api-version", valid_564329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   apiKey: JObject
  ##         : api key to be regenerated
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564331: Call_TransactionNodesListRegenerateApiKeys_564322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate the API keys for the blockchain member.
  ## 
  let valid = call_564331.validator(path, query, header, formData, body)
  let scheme = call_564331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564331.url(scheme.get, call_564331.host, call_564331.base,
                         call_564331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564331, url, valid)

proc call*(call_564332: Call_TransactionNodesListRegenerateApiKeys_564322;
          blockchainMemberName: string; subscriptionId: string;
          resourceGroupName: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"; apiKey: JsonNode = nil): Recallable =
  ## transactionNodesListRegenerateApiKeys
  ## Regenerate the API keys for the blockchain member.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   apiKey: JObject
  ##         : api key to be regenerated
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  var path_564333 = newJObject()
  var query_564334 = newJObject()
  var body_564335 = newJObject()
  add(path_564333, "blockchainMemberName", newJString(blockchainMemberName))
  add(query_564334, "api-version", newJString(apiVersion))
  if apiKey != nil:
    body_564335 = apiKey
  add(path_564333, "subscriptionId", newJString(subscriptionId))
  add(path_564333, "resourceGroupName", newJString(resourceGroupName))
  add(path_564333, "transactionNodeName", newJString(transactionNodeName))
  result = call_564332.call(path_564333, query_564334, nil, nil, body_564335)

var transactionNodesListRegenerateApiKeys* = Call_TransactionNodesListRegenerateApiKeys_564322(
    name: "transactionNodesListRegenerateApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}/regenerateApiKeys",
    validator: validate_TransactionNodesListRegenerateApiKeys_564323, base: "",
    url: url_TransactionNodesListRegenerateApiKeys_564324, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
