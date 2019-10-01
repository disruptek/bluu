
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "blockchain"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
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
  var valid_568054 = query.getOrDefault("api-version")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568054 != nil:
    section.add "api-version", valid_568054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568077: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available operations of Microsoft.Blockchain resource provider.
  ## 
  let valid = call_568077.validator(path, query, header, formData, body)
  let scheme = call_568077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568077.url(scheme.get, call_568077.host, call_568077.base,
                         call_568077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568077, url, valid)

proc call*(call_568148: Call_OperationsList_567880;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## operationsList
  ## Lists the available operations of Microsoft.Blockchain resource provider.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_568149 = newJObject()
  add(query_568149, "api-version", newJString(apiVersion))
  result = call_568148.call(nil, query_568149, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Blockchain/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_BlockchainMembersListAll_568189 = ref object of OpenApiRestCall_567658
proc url_BlockchainMembersListAll_568191(protocol: Scheme; host: string;
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

proc validate_BlockchainMembersListAll_568190(path: JsonNode; query: JsonNode;
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
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_BlockchainMembersListAll_568189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the blockchain members for a subscription.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_BlockchainMembersListAll_568189;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersListAll
  ## Lists the blockchain members for a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var blockchainMembersListAll* = Call_BlockchainMembersListAll_568189(
    name: "blockchainMembersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/blockchainMembers",
    validator: validate_BlockchainMembersListAll_568190, base: "",
    url: url_BlockchainMembersListAll_568191, schemes: {Scheme.Https})
type
  Call_BlockchainMemberOperationResultsGet_568212 = ref object of OpenApiRestCall_567658
proc url_BlockchainMemberOperationResultsGet_568214(protocol: Scheme; host: string;
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

proc validate_BlockchainMemberOperationResultsGet_568213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Async operation result.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   locationName: JString (required)
  ##               : Location name.
  ##   operationId: JString (required)
  ##              : Operation Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  var valid_568216 = path.getOrDefault("locationName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "locationName", valid_568216
  var valid_568217 = path.getOrDefault("operationId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "operationId", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_BlockchainMemberOperationResultsGet_568212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Async operation result.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_BlockchainMemberOperationResultsGet_568212;
          subscriptionId: string; locationName: string; operationId: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMemberOperationResultsGet
  ## Get Async operation result.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   locationName: string (required)
  ##               : Location name.
  ##   operationId: string (required)
  ##              : Operation Id.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "subscriptionId", newJString(subscriptionId))
  add(path_568221, "locationName", newJString(locationName))
  add(path_568221, "operationId", newJString(operationId))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var blockchainMemberOperationResultsGet* = Call_BlockchainMemberOperationResultsGet_568212(
    name: "blockchainMemberOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/locations/{locationName}/blockchainMemberOperationResults/{operationId}",
    validator: validate_BlockchainMemberOperationResultsGet_568213, base: "",
    url: url_BlockchainMemberOperationResultsGet_568214, schemes: {Scheme.Https})
type
  Call_LocationsCheckNameAvailability_568223 = ref object of OpenApiRestCall_567658
proc url_LocationsCheckNameAvailability_568225(protocol: Scheme; host: string;
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

proc validate_LocationsCheckNameAvailability_568224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## To check whether a resource name is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   locationName: JString (required)
  ##               : Location Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568226 = path.getOrDefault("subscriptionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "subscriptionId", valid_568226
  var valid_568227 = path.getOrDefault("locationName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "locationName", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568228 != nil:
    section.add "api-version", valid_568228
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

proc call*(call_568230: Call_LocationsCheckNameAvailability_568223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## To check whether a resource name is available.
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_LocationsCheckNameAvailability_568223;
          subscriptionId: string; locationName: string;
          apiVersion: string = "2018-06-01-preview";
          nameAvailabilityRequest: JsonNode = nil): Recallable =
  ## locationsCheckNameAvailability
  ## To check whether a resource name is available.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   locationName: string (required)
  ##               : Location Name.
  ##   nameAvailabilityRequest: JObject
  ##                          : Name availability request payload.
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  var body_568234 = newJObject()
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "subscriptionId", newJString(subscriptionId))
  add(path_568232, "locationName", newJString(locationName))
  if nameAvailabilityRequest != nil:
    body_568234 = nameAvailabilityRequest
  result = call_568231.call(path_568232, query_568233, nil, nil, body_568234)

var locationsCheckNameAvailability* = Call_LocationsCheckNameAvailability_568223(
    name: "locationsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/locations/{locationName}/checkNameAvailability",
    validator: validate_LocationsCheckNameAvailability_568224, base: "",
    url: url_LocationsCheckNameAvailability_568225, schemes: {Scheme.Https})
type
  Call_LocationsListConsortiums_568235 = ref object of OpenApiRestCall_567658
proc url_LocationsListConsortiums_568237(protocol: Scheme; host: string;
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

proc validate_LocationsListConsortiums_568236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available consortiums for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   locationName: JString (required)
  ##               : Location Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568238 = path.getOrDefault("subscriptionId")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "subscriptionId", valid_568238
  var valid_568239 = path.getOrDefault("locationName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "locationName", valid_568239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568240 = query.getOrDefault("api-version")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568240 != nil:
    section.add "api-version", valid_568240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568241: Call_LocationsListConsortiums_568235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available consortiums for a subscription.
  ## 
  let valid = call_568241.validator(path, query, header, formData, body)
  let scheme = call_568241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568241.url(scheme.get, call_568241.host, call_568241.base,
                         call_568241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568241, url, valid)

proc call*(call_568242: Call_LocationsListConsortiums_568235;
          subscriptionId: string; locationName: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## locationsListConsortiums
  ## Lists the available consortiums for a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   locationName: string (required)
  ##               : Location Name.
  var path_568243 = newJObject()
  var query_568244 = newJObject()
  add(query_568244, "api-version", newJString(apiVersion))
  add(path_568243, "subscriptionId", newJString(subscriptionId))
  add(path_568243, "locationName", newJString(locationName))
  result = call_568242.call(path_568243, query_568244, nil, nil, nil)

var locationsListConsortiums* = Call_LocationsListConsortiums_568235(
    name: "locationsListConsortiums", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/locations/{locationName}/listConsortiums",
    validator: validate_LocationsListConsortiums_568236, base: "",
    url: url_LocationsListConsortiums_568237, schemes: {Scheme.Https})
type
  Call_SkusList_568245 = ref object of OpenApiRestCall_567658
proc url_SkusList_568247(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SkusList_568246(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568250: Call_SkusList_568245; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Skus of the resource type.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_SkusList_568245; subscriptionId: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## skusList
  ## Lists the Skus of the resource type.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  add(query_568253, "api-version", newJString(apiVersion))
  add(path_568252, "subscriptionId", newJString(subscriptionId))
  result = call_568251.call(path_568252, query_568253, nil, nil, nil)

var skusList* = Call_SkusList_568245(name: "skusList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/skus",
                                  validator: validate_SkusList_568246, base: "",
                                  url: url_SkusList_568247,
                                  schemes: {Scheme.Https})
type
  Call_BlockchainMembersList_568254 = ref object of OpenApiRestCall_567658
proc url_BlockchainMembersList_568256(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersList_568255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the blockchain members for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568257 = path.getOrDefault("resourceGroupName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "resourceGroupName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_BlockchainMembersList_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the blockchain members for a resource group.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_BlockchainMembersList_568254;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersList
  ## Lists the blockchain members for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  result = call_568261.call(path_568262, query_568263, nil, nil, nil)

var blockchainMembersList* = Call_BlockchainMembersList_568254(
    name: "blockchainMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers",
    validator: validate_BlockchainMembersList_568255, base: "",
    url: url_BlockchainMembersList_568256, schemes: {Scheme.Https})
type
  Call_BlockchainMembersCreate_568275 = ref object of OpenApiRestCall_567658
proc url_BlockchainMembersCreate_568277(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersCreate_568276(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568278 = path.getOrDefault("resourceGroupName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "resourceGroupName", valid_568278
  var valid_568279 = path.getOrDefault("blockchainMemberName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "blockchainMemberName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568281 != nil:
    section.add "api-version", valid_568281
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

proc call*(call_568283: Call_BlockchainMembersCreate_568275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a blockchain member.
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_BlockchainMembersCreate_568275;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview";
          blockchainMember: JsonNode = nil): Recallable =
  ## blockchainMembersCreate
  ## Create a blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   blockchainMember: JObject
  ##                   : Payload to create a blockchain member.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  var body_568287 = newJObject()
  add(path_568285, "resourceGroupName", newJString(resourceGroupName))
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  if blockchainMember != nil:
    body_568287 = blockchainMember
  result = call_568284.call(path_568285, query_568286, nil, nil, body_568287)

var blockchainMembersCreate* = Call_BlockchainMembersCreate_568275(
    name: "blockchainMembersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersCreate_568276, base: "",
    url: url_BlockchainMembersCreate_568277, schemes: {Scheme.Https})
type
  Call_BlockchainMembersGet_568264 = ref object of OpenApiRestCall_567658
proc url_BlockchainMembersGet_568266(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersGet_568265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details about a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568267 = path.getOrDefault("resourceGroupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "resourceGroupName", valid_568267
  var valid_568268 = path.getOrDefault("blockchainMemberName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "blockchainMemberName", valid_568268
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_BlockchainMembersGet_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details about a blockchain member.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_BlockchainMembersGet_568264;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersGet
  ## Get details about a blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  add(path_568273, "resourceGroupName", newJString(resourceGroupName))
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  result = call_568272.call(path_568273, query_568274, nil, nil, nil)

var blockchainMembersGet* = Call_BlockchainMembersGet_568264(
    name: "blockchainMembersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersGet_568265, base: "",
    url: url_BlockchainMembersGet_568266, schemes: {Scheme.Https})
type
  Call_BlockchainMembersUpdate_568299 = ref object of OpenApiRestCall_567658
proc url_BlockchainMembersUpdate_568301(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersUpdate_568300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568302 = path.getOrDefault("resourceGroupName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceGroupName", valid_568302
  var valid_568303 = path.getOrDefault("blockchainMemberName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "blockchainMemberName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568305 != nil:
    section.add "api-version", valid_568305
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

proc call*(call_568307: Call_BlockchainMembersUpdate_568299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a blockchain member.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_BlockchainMembersUpdate_568299;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview";
          blockchainMember: JsonNode = nil): Recallable =
  ## blockchainMembersUpdate
  ## Update a blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   blockchainMember: JObject
  ##                   : Payload to update the blockchain member.
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  var body_568311 = newJObject()
  add(path_568309, "resourceGroupName", newJString(resourceGroupName))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  if blockchainMember != nil:
    body_568311 = blockchainMember
  result = call_568308.call(path_568309, query_568310, nil, nil, body_568311)

var blockchainMembersUpdate* = Call_BlockchainMembersUpdate_568299(
    name: "blockchainMembersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersUpdate_568300, base: "",
    url: url_BlockchainMembersUpdate_568301, schemes: {Scheme.Https})
type
  Call_BlockchainMembersDelete_568288 = ref object of OpenApiRestCall_567658
proc url_BlockchainMembersDelete_568290(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersDelete_568289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568291 = path.getOrDefault("resourceGroupName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "resourceGroupName", valid_568291
  var valid_568292 = path.getOrDefault("blockchainMemberName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "blockchainMemberName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_BlockchainMembersDelete_568288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blockchain member.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_BlockchainMembersDelete_568288;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersDelete
  ## Delete a blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var blockchainMembersDelete* = Call_BlockchainMembersDelete_568288(
    name: "blockchainMembersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersDelete_568289, base: "",
    url: url_BlockchainMembersDelete_568290, schemes: {Scheme.Https})
type
  Call_BlockchainMembersListConsortiumMembers_568312 = ref object of OpenApiRestCall_567658
proc url_BlockchainMembersListConsortiumMembers_568314(protocol: Scheme;
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

proc validate_BlockchainMembersListConsortiumMembers_568313(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the consortium members for a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568315 = path.getOrDefault("resourceGroupName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "resourceGroupName", valid_568315
  var valid_568316 = path.getOrDefault("blockchainMemberName")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "blockchainMemberName", valid_568316
  var valid_568317 = path.getOrDefault("subscriptionId")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = nil)
  if valid_568317 != nil:
    section.add "subscriptionId", valid_568317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568318 = query.getOrDefault("api-version")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568318 != nil:
    section.add "api-version", valid_568318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568319: Call_BlockchainMembersListConsortiumMembers_568312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the consortium members for a blockchain member.
  ## 
  let valid = call_568319.validator(path, query, header, formData, body)
  let scheme = call_568319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568319.url(scheme.get, call_568319.host, call_568319.base,
                         call_568319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568319, url, valid)

proc call*(call_568320: Call_BlockchainMembersListConsortiumMembers_568312;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersListConsortiumMembers
  ## Lists the consortium members for a blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_568321 = newJObject()
  var query_568322 = newJObject()
  add(path_568321, "resourceGroupName", newJString(resourceGroupName))
  add(query_568322, "api-version", newJString(apiVersion))
  add(path_568321, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568321, "subscriptionId", newJString(subscriptionId))
  result = call_568320.call(path_568321, query_568322, nil, nil, nil)

var blockchainMembersListConsortiumMembers* = Call_BlockchainMembersListConsortiumMembers_568312(
    name: "blockchainMembersListConsortiumMembers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/consortiumMembers",
    validator: validate_BlockchainMembersListConsortiumMembers_568313, base: "",
    url: url_BlockchainMembersListConsortiumMembers_568314,
    schemes: {Scheme.Https})
type
  Call_BlockchainMembersListApiKeys_568323 = ref object of OpenApiRestCall_567658
proc url_BlockchainMembersListApiKeys_568325(protocol: Scheme; host: string;
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

proc validate_BlockchainMembersListApiKeys_568324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the API keys for a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("blockchainMemberName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "blockchainMemberName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568330: Call_BlockchainMembersListApiKeys_568323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the API keys for a blockchain member.
  ## 
  let valid = call_568330.validator(path, query, header, formData, body)
  let scheme = call_568330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568330.url(scheme.get, call_568330.host, call_568330.base,
                         call_568330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568330, url, valid)

proc call*(call_568331: Call_BlockchainMembersListApiKeys_568323;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersListApiKeys
  ## Lists the API keys for a blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_568332 = newJObject()
  var query_568333 = newJObject()
  add(path_568332, "resourceGroupName", newJString(resourceGroupName))
  add(query_568333, "api-version", newJString(apiVersion))
  add(path_568332, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568332, "subscriptionId", newJString(subscriptionId))
  result = call_568331.call(path_568332, query_568333, nil, nil, nil)

var blockchainMembersListApiKeys* = Call_BlockchainMembersListApiKeys_568323(
    name: "blockchainMembersListApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/listApiKeys",
    validator: validate_BlockchainMembersListApiKeys_568324, base: "",
    url: url_BlockchainMembersListApiKeys_568325, schemes: {Scheme.Https})
type
  Call_BlockchainMembersListRegenerateApiKeys_568334 = ref object of OpenApiRestCall_567658
proc url_BlockchainMembersListRegenerateApiKeys_568336(protocol: Scheme;
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

proc validate_BlockchainMembersListRegenerateApiKeys_568335(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate the API keys for a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568337 = path.getOrDefault("resourceGroupName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "resourceGroupName", valid_568337
  var valid_568338 = path.getOrDefault("blockchainMemberName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "blockchainMemberName", valid_568338
  var valid_568339 = path.getOrDefault("subscriptionId")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "subscriptionId", valid_568339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568340 = query.getOrDefault("api-version")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568340 != nil:
    section.add "api-version", valid_568340
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

proc call*(call_568342: Call_BlockchainMembersListRegenerateApiKeys_568334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate the API keys for a blockchain member.
  ## 
  let valid = call_568342.validator(path, query, header, formData, body)
  let scheme = call_568342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568342.url(scheme.get, call_568342.host, call_568342.base,
                         call_568342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568342, url, valid)

proc call*(call_568343: Call_BlockchainMembersListRegenerateApiKeys_568334;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview";
          apiKey: JsonNode = nil): Recallable =
  ## blockchainMembersListRegenerateApiKeys
  ## Regenerate the API keys for a blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   apiKey: JObject
  ##         : api key to be regenerate
  var path_568344 = newJObject()
  var query_568345 = newJObject()
  var body_568346 = newJObject()
  add(path_568344, "resourceGroupName", newJString(resourceGroupName))
  add(query_568345, "api-version", newJString(apiVersion))
  add(path_568344, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568344, "subscriptionId", newJString(subscriptionId))
  if apiKey != nil:
    body_568346 = apiKey
  result = call_568343.call(path_568344, query_568345, nil, nil, body_568346)

var blockchainMembersListRegenerateApiKeys* = Call_BlockchainMembersListRegenerateApiKeys_568334(
    name: "blockchainMembersListRegenerateApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/regenerateApiKeys",
    validator: validate_BlockchainMembersListRegenerateApiKeys_568335, base: "",
    url: url_BlockchainMembersListRegenerateApiKeys_568336,
    schemes: {Scheme.Https})
type
  Call_TransactionNodesList_568347 = ref object of OpenApiRestCall_567658
proc url_TransactionNodesList_568349(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesList_568348(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transaction nodes for a blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("blockchainMemberName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "blockchainMemberName", valid_568351
  var valid_568352 = path.getOrDefault("subscriptionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "subscriptionId", valid_568352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568353 = query.getOrDefault("api-version")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568353 != nil:
    section.add "api-version", valid_568353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568354: Call_TransactionNodesList_568347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transaction nodes for a blockchain member.
  ## 
  let valid = call_568354.validator(path, query, header, formData, body)
  let scheme = call_568354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568354.url(scheme.get, call_568354.host, call_568354.base,
                         call_568354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568354, url, valid)

proc call*(call_568355: Call_TransactionNodesList_568347;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## transactionNodesList
  ## Lists the transaction nodes for a blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_568356 = newJObject()
  var query_568357 = newJObject()
  add(path_568356, "resourceGroupName", newJString(resourceGroupName))
  add(query_568357, "api-version", newJString(apiVersion))
  add(path_568356, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568356, "subscriptionId", newJString(subscriptionId))
  result = call_568355.call(path_568356, query_568357, nil, nil, nil)

var transactionNodesList* = Call_TransactionNodesList_568347(
    name: "transactionNodesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes",
    validator: validate_TransactionNodesList_568348, base: "",
    url: url_TransactionNodesList_568349, schemes: {Scheme.Https})
type
  Call_TransactionNodesCreate_568370 = ref object of OpenApiRestCall_567658
proc url_TransactionNodesCreate_568372(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesCreate_568371(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568373 = path.getOrDefault("resourceGroupName")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "resourceGroupName", valid_568373
  var valid_568374 = path.getOrDefault("blockchainMemberName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "blockchainMemberName", valid_568374
  var valid_568375 = path.getOrDefault("subscriptionId")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "subscriptionId", valid_568375
  var valid_568376 = path.getOrDefault("transactionNodeName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "transactionNodeName", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568377 != nil:
    section.add "api-version", valid_568377
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

proc call*(call_568379: Call_TransactionNodesCreate_568370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the transaction node.
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_TransactionNodesCreate_568370;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"; transactionNode: JsonNode = nil): Recallable =
  ## transactionNodesCreate
  ## Create or update the transaction node.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  ##   transactionNode: JObject
  ##                  : Payload to create the transaction node.
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  var body_568383 = newJObject()
  add(path_568381, "resourceGroupName", newJString(resourceGroupName))
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  add(path_568381, "transactionNodeName", newJString(transactionNodeName))
  if transactionNode != nil:
    body_568383 = transactionNode
  result = call_568380.call(path_568381, query_568382, nil, nil, body_568383)

var transactionNodesCreate* = Call_TransactionNodesCreate_568370(
    name: "transactionNodesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesCreate_568371, base: "",
    url: url_TransactionNodesCreate_568372, schemes: {Scheme.Https})
type
  Call_TransactionNodesGet_568358 = ref object of OpenApiRestCall_567658
proc url_TransactionNodesGet_568360(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesGet_568359(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the details of the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568361 = path.getOrDefault("resourceGroupName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceGroupName", valid_568361
  var valid_568362 = path.getOrDefault("blockchainMemberName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "blockchainMemberName", valid_568362
  var valid_568363 = path.getOrDefault("subscriptionId")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "subscriptionId", valid_568363
  var valid_568364 = path.getOrDefault("transactionNodeName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "transactionNodeName", valid_568364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568365 = query.getOrDefault("api-version")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568365 != nil:
    section.add "api-version", valid_568365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568366: Call_TransactionNodesGet_568358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the transaction node.
  ## 
  let valid = call_568366.validator(path, query, header, formData, body)
  let scheme = call_568366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568366.url(scheme.get, call_568366.host, call_568366.base,
                         call_568366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568366, url, valid)

proc call*(call_568367: Call_TransactionNodesGet_568358; resourceGroupName: string;
          blockchainMemberName: string; subscriptionId: string;
          transactionNodeName: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## transactionNodesGet
  ## Get the details of the transaction node.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  var path_568368 = newJObject()
  var query_568369 = newJObject()
  add(path_568368, "resourceGroupName", newJString(resourceGroupName))
  add(query_568369, "api-version", newJString(apiVersion))
  add(path_568368, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568368, "subscriptionId", newJString(subscriptionId))
  add(path_568368, "transactionNodeName", newJString(transactionNodeName))
  result = call_568367.call(path_568368, query_568369, nil, nil, nil)

var transactionNodesGet* = Call_TransactionNodesGet_568358(
    name: "transactionNodesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesGet_568359, base: "",
    url: url_TransactionNodesGet_568360, schemes: {Scheme.Https})
type
  Call_TransactionNodesUpdate_568396 = ref object of OpenApiRestCall_567658
proc url_TransactionNodesUpdate_568398(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesUpdate_568397(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568399 = path.getOrDefault("resourceGroupName")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "resourceGroupName", valid_568399
  var valid_568400 = path.getOrDefault("blockchainMemberName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "blockchainMemberName", valid_568400
  var valid_568401 = path.getOrDefault("subscriptionId")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "subscriptionId", valid_568401
  var valid_568402 = path.getOrDefault("transactionNodeName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "transactionNodeName", valid_568402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568403 = query.getOrDefault("api-version")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568403 != nil:
    section.add "api-version", valid_568403
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

proc call*(call_568405: Call_TransactionNodesUpdate_568396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the transaction node.
  ## 
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_TransactionNodesUpdate_568396;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"; transactionNode: JsonNode = nil): Recallable =
  ## transactionNodesUpdate
  ## Update the transaction node.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  ##   transactionNode: JObject
  ##                  : Payload to create the transaction node.
  var path_568407 = newJObject()
  var query_568408 = newJObject()
  var body_568409 = newJObject()
  add(path_568407, "resourceGroupName", newJString(resourceGroupName))
  add(query_568408, "api-version", newJString(apiVersion))
  add(path_568407, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568407, "subscriptionId", newJString(subscriptionId))
  add(path_568407, "transactionNodeName", newJString(transactionNodeName))
  if transactionNode != nil:
    body_568409 = transactionNode
  result = call_568406.call(path_568407, query_568408, nil, nil, body_568409)

var transactionNodesUpdate* = Call_TransactionNodesUpdate_568396(
    name: "transactionNodesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesUpdate_568397, base: "",
    url: url_TransactionNodesUpdate_568398, schemes: {Scheme.Https})
type
  Call_TransactionNodesDelete_568384 = ref object of OpenApiRestCall_567658
proc url_TransactionNodesDelete_568386(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesDelete_568385(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568387 = path.getOrDefault("resourceGroupName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "resourceGroupName", valid_568387
  var valid_568388 = path.getOrDefault("blockchainMemberName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "blockchainMemberName", valid_568388
  var valid_568389 = path.getOrDefault("subscriptionId")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "subscriptionId", valid_568389
  var valid_568390 = path.getOrDefault("transactionNodeName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "transactionNodeName", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568391 != nil:
    section.add "api-version", valid_568391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568392: Call_TransactionNodesDelete_568384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the transaction node.
  ## 
  let valid = call_568392.validator(path, query, header, formData, body)
  let scheme = call_568392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568392.url(scheme.get, call_568392.host, call_568392.base,
                         call_568392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568392, url, valid)

proc call*(call_568393: Call_TransactionNodesDelete_568384;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## transactionNodesDelete
  ## Delete the transaction node.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  var path_568394 = newJObject()
  var query_568395 = newJObject()
  add(path_568394, "resourceGroupName", newJString(resourceGroupName))
  add(query_568395, "api-version", newJString(apiVersion))
  add(path_568394, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568394, "subscriptionId", newJString(subscriptionId))
  add(path_568394, "transactionNodeName", newJString(transactionNodeName))
  result = call_568393.call(path_568394, query_568395, nil, nil, nil)

var transactionNodesDelete* = Call_TransactionNodesDelete_568384(
    name: "transactionNodesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesDelete_568385, base: "",
    url: url_TransactionNodesDelete_568386, schemes: {Scheme.Https})
type
  Call_TransactionNodesListApiKeys_568410 = ref object of OpenApiRestCall_567658
proc url_TransactionNodesListApiKeys_568412(protocol: Scheme; host: string;
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

proc validate_TransactionNodesListApiKeys_568411(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the API keys for the transaction node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568413 = path.getOrDefault("resourceGroupName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "resourceGroupName", valid_568413
  var valid_568414 = path.getOrDefault("blockchainMemberName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "blockchainMemberName", valid_568414
  var valid_568415 = path.getOrDefault("subscriptionId")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "subscriptionId", valid_568415
  var valid_568416 = path.getOrDefault("transactionNodeName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "transactionNodeName", valid_568416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568417 = query.getOrDefault("api-version")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568417 != nil:
    section.add "api-version", valid_568417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568418: Call_TransactionNodesListApiKeys_568410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the API keys for the transaction node.
  ## 
  let valid = call_568418.validator(path, query, header, formData, body)
  let scheme = call_568418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568418.url(scheme.get, call_568418.host, call_568418.base,
                         call_568418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568418, url, valid)

proc call*(call_568419: Call_TransactionNodesListApiKeys_568410;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## transactionNodesListApiKeys
  ## List the API keys for the transaction node.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  var path_568420 = newJObject()
  var query_568421 = newJObject()
  add(path_568420, "resourceGroupName", newJString(resourceGroupName))
  add(query_568421, "api-version", newJString(apiVersion))
  add(path_568420, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568420, "subscriptionId", newJString(subscriptionId))
  add(path_568420, "transactionNodeName", newJString(transactionNodeName))
  result = call_568419.call(path_568420, query_568421, nil, nil, nil)

var transactionNodesListApiKeys* = Call_TransactionNodesListApiKeys_568410(
    name: "transactionNodesListApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}/listApiKeys",
    validator: validate_TransactionNodesListApiKeys_568411, base: "",
    url: url_TransactionNodesListApiKeys_568412, schemes: {Scheme.Https})
type
  Call_TransactionNodesListRegenerateApiKeys_568422 = ref object of OpenApiRestCall_567658
proc url_TransactionNodesListRegenerateApiKeys_568424(protocol: Scheme;
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

proc validate_TransactionNodesListRegenerateApiKeys_568423(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate the API keys for the blockchain member.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   blockchainMemberName: JString (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: JString (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: JString (required)
  ##                      : Transaction node name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568425 = path.getOrDefault("resourceGroupName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "resourceGroupName", valid_568425
  var valid_568426 = path.getOrDefault("blockchainMemberName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "blockchainMemberName", valid_568426
  var valid_568427 = path.getOrDefault("subscriptionId")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "subscriptionId", valid_568427
  var valid_568428 = path.getOrDefault("transactionNodeName")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = nil)
  if valid_568428 != nil:
    section.add "transactionNodeName", valid_568428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568429 = query.getOrDefault("api-version")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_568429 != nil:
    section.add "api-version", valid_568429
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

proc call*(call_568431: Call_TransactionNodesListRegenerateApiKeys_568422;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate the API keys for the blockchain member.
  ## 
  let valid = call_568431.validator(path, query, header, formData, body)
  let scheme = call_568431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568431.url(scheme.get, call_568431.host, call_568431.base,
                         call_568431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568431, url, valid)

proc call*(call_568432: Call_TransactionNodesListRegenerateApiKeys_568422;
          resourceGroupName: string; blockchainMemberName: string;
          subscriptionId: string; transactionNodeName: string;
          apiVersion: string = "2018-06-01-preview"; apiKey: JsonNode = nil): Recallable =
  ## transactionNodesListRegenerateApiKeys
  ## Regenerate the API keys for the blockchain member.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blockchainMemberName: string (required)
  ##                       : Blockchain member name.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  ##   transactionNodeName: string (required)
  ##                      : Transaction node name.
  ##   apiKey: JObject
  ##         : api key to be regenerated
  var path_568433 = newJObject()
  var query_568434 = newJObject()
  var body_568435 = newJObject()
  add(path_568433, "resourceGroupName", newJString(resourceGroupName))
  add(query_568434, "api-version", newJString(apiVersion))
  add(path_568433, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_568433, "subscriptionId", newJString(subscriptionId))
  add(path_568433, "transactionNodeName", newJString(transactionNodeName))
  if apiKey != nil:
    body_568435 = apiKey
  result = call_568432.call(path_568433, query_568434, nil, nil, body_568435)

var transactionNodesListRegenerateApiKeys* = Call_TransactionNodesListRegenerateApiKeys_568422(
    name: "transactionNodesListRegenerateApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}/regenerateApiKeys",
    validator: validate_TransactionNodesListRegenerateApiKeys_568423, base: "",
    url: url_TransactionNodesListRegenerateApiKeys_568424, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
