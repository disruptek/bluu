
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "blockchain"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available operations of Microsoft.Blockchain resource provider.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_OperationsList_593647;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## operationsList
  ## Lists the available operations of Microsoft.Blockchain resource provider.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Blockchain/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_BlockchainMembersListAll_593956 = ref object of OpenApiRestCall_593425
proc url_BlockchainMembersListAll_593958(protocol: Scheme; host: string;
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

proc validate_BlockchainMembersListAll_593957(path: JsonNode; query: JsonNode;
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
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_BlockchainMembersListAll_593956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the blockchain members for a subscription.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_BlockchainMembersListAll_593956;
          subscriptionId: string; apiVersion: string = "2018-06-01-preview"): Recallable =
  ## blockchainMembersListAll
  ## Lists the blockchain members for a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var blockchainMembersListAll* = Call_BlockchainMembersListAll_593956(
    name: "blockchainMembersListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/blockchainMembers",
    validator: validate_BlockchainMembersListAll_593957, base: "",
    url: url_BlockchainMembersListAll_593958, schemes: {Scheme.Https})
type
  Call_BlockchainMemberOperationResultsGet_593979 = ref object of OpenApiRestCall_593425
proc url_BlockchainMemberOperationResultsGet_593981(protocol: Scheme; host: string;
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

proc validate_BlockchainMemberOperationResultsGet_593980(path: JsonNode;
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
  var valid_593982 = path.getOrDefault("subscriptionId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "subscriptionId", valid_593982
  var valid_593983 = path.getOrDefault("locationName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "locationName", valid_593983
  var valid_593984 = path.getOrDefault("operationId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "operationId", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_BlockchainMemberOperationResultsGet_593979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Async operation result.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_BlockchainMemberOperationResultsGet_593979;
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
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(query_593989, "api-version", newJString(apiVersion))
  add(path_593988, "subscriptionId", newJString(subscriptionId))
  add(path_593988, "locationName", newJString(locationName))
  add(path_593988, "operationId", newJString(operationId))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var blockchainMemberOperationResultsGet* = Call_BlockchainMemberOperationResultsGet_593979(
    name: "blockchainMemberOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/locations/{locationName}/blockchainMemberOperationResults/{operationId}",
    validator: validate_BlockchainMemberOperationResultsGet_593980, base: "",
    url: url_BlockchainMemberOperationResultsGet_593981, schemes: {Scheme.Https})
type
  Call_LocationsCheckNameAvailability_593990 = ref object of OpenApiRestCall_593425
proc url_LocationsCheckNameAvailability_593992(protocol: Scheme; host: string;
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

proc validate_LocationsCheckNameAvailability_593991(path: JsonNode;
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
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  var valid_593994 = path.getOrDefault("locationName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "locationName", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_593995 != nil:
    section.add "api-version", valid_593995
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

proc call*(call_593997: Call_LocationsCheckNameAvailability_593990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## To check whether a resource name is available.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_LocationsCheckNameAvailability_593990;
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  var body_594001 = newJObject()
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  add(path_593999, "locationName", newJString(locationName))
  if nameAvailabilityRequest != nil:
    body_594001 = nameAvailabilityRequest
  result = call_593998.call(path_593999, query_594000, nil, nil, body_594001)

var locationsCheckNameAvailability* = Call_LocationsCheckNameAvailability_593990(
    name: "locationsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/locations/{locationName}/checkNameAvailability",
    validator: validate_LocationsCheckNameAvailability_593991, base: "",
    url: url_LocationsCheckNameAvailability_593992, schemes: {Scheme.Https})
type
  Call_LocationsListConsortiums_594002 = ref object of OpenApiRestCall_593425
proc url_LocationsListConsortiums_594004(protocol: Scheme; host: string;
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

proc validate_LocationsListConsortiums_594003(path: JsonNode; query: JsonNode;
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
  var valid_594005 = path.getOrDefault("subscriptionId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "subscriptionId", valid_594005
  var valid_594006 = path.getOrDefault("locationName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "locationName", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_LocationsListConsortiums_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available consortiums for a subscription.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_LocationsListConsortiums_594002;
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
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  add(path_594010, "locationName", newJString(locationName))
  result = call_594009.call(path_594010, query_594011, nil, nil, nil)

var locationsListConsortiums* = Call_LocationsListConsortiums_594002(
    name: "locationsListConsortiums", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/locations/{locationName}/listConsortiums",
    validator: validate_LocationsListConsortiums_594003, base: "",
    url: url_LocationsListConsortiums_594004, schemes: {Scheme.Https})
type
  Call_SkusList_594012 = ref object of OpenApiRestCall_593425
proc url_SkusList_594014(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_SkusList_594013(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594015 = path.getOrDefault("subscriptionId")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "subscriptionId", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594016 != nil:
    section.add "api-version", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_SkusList_594012; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Skus of the resource type.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_SkusList_594012; subscriptionId: string;
          apiVersion: string = "2018-06-01-preview"): Recallable =
  ## skusList
  ## Lists the Skus of the resource type.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Gets the subscription Id which uniquely identifies the Microsoft Azure subscription. The subscription ID is part of the URI for every service call.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var skusList* = Call_SkusList_594012(name: "skusList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blockchain/skus",
                                  validator: validate_SkusList_594013, base: "",
                                  url: url_SkusList_594014,
                                  schemes: {Scheme.Https})
type
  Call_BlockchainMembersList_594021 = ref object of OpenApiRestCall_593425
proc url_BlockchainMembersList_594023(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersList_594022(path: JsonNode; query: JsonNode;
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
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_BlockchainMembersList_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the blockchain members for a resource group.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_BlockchainMembersList_594021;
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
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(path_594029, "resourceGroupName", newJString(resourceGroupName))
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var blockchainMembersList* = Call_BlockchainMembersList_594021(
    name: "blockchainMembersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers",
    validator: validate_BlockchainMembersList_594022, base: "",
    url: url_BlockchainMembersList_594023, schemes: {Scheme.Https})
type
  Call_BlockchainMembersCreate_594042 = ref object of OpenApiRestCall_593425
proc url_BlockchainMembersCreate_594044(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersCreate_594043(path: JsonNode; query: JsonNode;
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
  var valid_594045 = path.getOrDefault("resourceGroupName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "resourceGroupName", valid_594045
  var valid_594046 = path.getOrDefault("blockchainMemberName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "blockchainMemberName", valid_594046
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594048 != nil:
    section.add "api-version", valid_594048
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

proc call*(call_594050: Call_BlockchainMembersCreate_594042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a blockchain member.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_BlockchainMembersCreate_594042;
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  var body_594054 = newJObject()
  add(path_594052, "resourceGroupName", newJString(resourceGroupName))
  add(query_594053, "api-version", newJString(apiVersion))
  add(path_594052, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  if blockchainMember != nil:
    body_594054 = blockchainMember
  result = call_594051.call(path_594052, query_594053, nil, nil, body_594054)

var blockchainMembersCreate* = Call_BlockchainMembersCreate_594042(
    name: "blockchainMembersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersCreate_594043, base: "",
    url: url_BlockchainMembersCreate_594044, schemes: {Scheme.Https})
type
  Call_BlockchainMembersGet_594031 = ref object of OpenApiRestCall_593425
proc url_BlockchainMembersGet_594033(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersGet_594032(path: JsonNode; query: JsonNode;
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
  var valid_594034 = path.getOrDefault("resourceGroupName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "resourceGroupName", valid_594034
  var valid_594035 = path.getOrDefault("blockchainMemberName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "blockchainMemberName", valid_594035
  var valid_594036 = path.getOrDefault("subscriptionId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "subscriptionId", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_BlockchainMembersGet_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details about a blockchain member.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_BlockchainMembersGet_594031;
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
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(path_594040, "resourceGroupName", newJString(resourceGroupName))
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var blockchainMembersGet* = Call_BlockchainMembersGet_594031(
    name: "blockchainMembersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersGet_594032, base: "",
    url: url_BlockchainMembersGet_594033, schemes: {Scheme.Https})
type
  Call_BlockchainMembersUpdate_594066 = ref object of OpenApiRestCall_593425
proc url_BlockchainMembersUpdate_594068(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersUpdate_594067(path: JsonNode; query: JsonNode;
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
  var valid_594069 = path.getOrDefault("resourceGroupName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "resourceGroupName", valid_594069
  var valid_594070 = path.getOrDefault("blockchainMemberName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "blockchainMemberName", valid_594070
  var valid_594071 = path.getOrDefault("subscriptionId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "subscriptionId", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594072 != nil:
    section.add "api-version", valid_594072
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

proc call*(call_594074: Call_BlockchainMembersUpdate_594066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a blockchain member.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_BlockchainMembersUpdate_594066;
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
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  var body_594078 = newJObject()
  add(path_594076, "resourceGroupName", newJString(resourceGroupName))
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  if blockchainMember != nil:
    body_594078 = blockchainMember
  result = call_594075.call(path_594076, query_594077, nil, nil, body_594078)

var blockchainMembersUpdate* = Call_BlockchainMembersUpdate_594066(
    name: "blockchainMembersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersUpdate_594067, base: "",
    url: url_BlockchainMembersUpdate_594068, schemes: {Scheme.Https})
type
  Call_BlockchainMembersDelete_594055 = ref object of OpenApiRestCall_593425
proc url_BlockchainMembersDelete_594057(protocol: Scheme; host: string; base: string;
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

proc validate_BlockchainMembersDelete_594056(path: JsonNode; query: JsonNode;
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
  var valid_594058 = path.getOrDefault("resourceGroupName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "resourceGroupName", valid_594058
  var valid_594059 = path.getOrDefault("blockchainMemberName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "blockchainMemberName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594061 = query.getOrDefault("api-version")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594061 != nil:
    section.add "api-version", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_BlockchainMembersDelete_594055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blockchain member.
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_BlockchainMembersDelete_594055;
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
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  add(path_594064, "resourceGroupName", newJString(resourceGroupName))
  add(query_594065, "api-version", newJString(apiVersion))
  add(path_594064, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594064, "subscriptionId", newJString(subscriptionId))
  result = call_594063.call(path_594064, query_594065, nil, nil, nil)

var blockchainMembersDelete* = Call_BlockchainMembersDelete_594055(
    name: "blockchainMembersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}",
    validator: validate_BlockchainMembersDelete_594056, base: "",
    url: url_BlockchainMembersDelete_594057, schemes: {Scheme.Https})
type
  Call_BlockchainMembersListConsortiumMembers_594079 = ref object of OpenApiRestCall_593425
proc url_BlockchainMembersListConsortiumMembers_594081(protocol: Scheme;
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

proc validate_BlockchainMembersListConsortiumMembers_594080(path: JsonNode;
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
  var valid_594082 = path.getOrDefault("resourceGroupName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceGroupName", valid_594082
  var valid_594083 = path.getOrDefault("blockchainMemberName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "blockchainMemberName", valid_594083
  var valid_594084 = path.getOrDefault("subscriptionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "subscriptionId", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594085 != nil:
    section.add "api-version", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_BlockchainMembersListConsortiumMembers_594079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the consortium members for a blockchain member.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_BlockchainMembersListConsortiumMembers_594079;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var blockchainMembersListConsortiumMembers* = Call_BlockchainMembersListConsortiumMembers_594079(
    name: "blockchainMembersListConsortiumMembers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/consortiumMembers",
    validator: validate_BlockchainMembersListConsortiumMembers_594080, base: "",
    url: url_BlockchainMembersListConsortiumMembers_594081,
    schemes: {Scheme.Https})
type
  Call_BlockchainMembersListApiKeys_594090 = ref object of OpenApiRestCall_593425
proc url_BlockchainMembersListApiKeys_594092(protocol: Scheme; host: string;
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

proc validate_BlockchainMembersListApiKeys_594091(path: JsonNode; query: JsonNode;
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
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("blockchainMemberName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "blockchainMemberName", valid_594094
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_BlockchainMembersListApiKeys_594090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the API keys for a blockchain member.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_BlockchainMembersListApiKeys_594090;
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
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(path_594099, "resourceGroupName", newJString(resourceGroupName))
  add(query_594100, "api-version", newJString(apiVersion))
  add(path_594099, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594099, "subscriptionId", newJString(subscriptionId))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var blockchainMembersListApiKeys* = Call_BlockchainMembersListApiKeys_594090(
    name: "blockchainMembersListApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/listApiKeys",
    validator: validate_BlockchainMembersListApiKeys_594091, base: "",
    url: url_BlockchainMembersListApiKeys_594092, schemes: {Scheme.Https})
type
  Call_BlockchainMembersListRegenerateApiKeys_594101 = ref object of OpenApiRestCall_593425
proc url_BlockchainMembersListRegenerateApiKeys_594103(protocol: Scheme;
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

proc validate_BlockchainMembersListRegenerateApiKeys_594102(path: JsonNode;
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
  var valid_594104 = path.getOrDefault("resourceGroupName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "resourceGroupName", valid_594104
  var valid_594105 = path.getOrDefault("blockchainMemberName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "blockchainMemberName", valid_594105
  var valid_594106 = path.getOrDefault("subscriptionId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "subscriptionId", valid_594106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594107 = query.getOrDefault("api-version")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594107 != nil:
    section.add "api-version", valid_594107
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

proc call*(call_594109: Call_BlockchainMembersListRegenerateApiKeys_594101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate the API keys for a blockchain member.
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_BlockchainMembersListRegenerateApiKeys_594101;
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
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  var body_594113 = newJObject()
  add(path_594111, "resourceGroupName", newJString(resourceGroupName))
  add(query_594112, "api-version", newJString(apiVersion))
  add(path_594111, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594111, "subscriptionId", newJString(subscriptionId))
  if apiKey != nil:
    body_594113 = apiKey
  result = call_594110.call(path_594111, query_594112, nil, nil, body_594113)

var blockchainMembersListRegenerateApiKeys* = Call_BlockchainMembersListRegenerateApiKeys_594101(
    name: "blockchainMembersListRegenerateApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/regenerateApiKeys",
    validator: validate_BlockchainMembersListRegenerateApiKeys_594102, base: "",
    url: url_BlockchainMembersListRegenerateApiKeys_594103,
    schemes: {Scheme.Https})
type
  Call_TransactionNodesList_594114 = ref object of OpenApiRestCall_593425
proc url_TransactionNodesList_594116(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesList_594115(path: JsonNode; query: JsonNode;
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
  var valid_594117 = path.getOrDefault("resourceGroupName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "resourceGroupName", valid_594117
  var valid_594118 = path.getOrDefault("blockchainMemberName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "blockchainMemberName", valid_594118
  var valid_594119 = path.getOrDefault("subscriptionId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "subscriptionId", valid_594119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594120 = query.getOrDefault("api-version")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594120 != nil:
    section.add "api-version", valid_594120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594121: Call_TransactionNodesList_594114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transaction nodes for a blockchain member.
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_TransactionNodesList_594114;
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
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  add(path_594123, "resourceGroupName", newJString(resourceGroupName))
  add(query_594124, "api-version", newJString(apiVersion))
  add(path_594123, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594123, "subscriptionId", newJString(subscriptionId))
  result = call_594122.call(path_594123, query_594124, nil, nil, nil)

var transactionNodesList* = Call_TransactionNodesList_594114(
    name: "transactionNodesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes",
    validator: validate_TransactionNodesList_594115, base: "",
    url: url_TransactionNodesList_594116, schemes: {Scheme.Https})
type
  Call_TransactionNodesCreate_594137 = ref object of OpenApiRestCall_593425
proc url_TransactionNodesCreate_594139(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesCreate_594138(path: JsonNode; query: JsonNode;
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
  var valid_594140 = path.getOrDefault("resourceGroupName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "resourceGroupName", valid_594140
  var valid_594141 = path.getOrDefault("blockchainMemberName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "blockchainMemberName", valid_594141
  var valid_594142 = path.getOrDefault("subscriptionId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "subscriptionId", valid_594142
  var valid_594143 = path.getOrDefault("transactionNodeName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "transactionNodeName", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594144 != nil:
    section.add "api-version", valid_594144
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

proc call*(call_594146: Call_TransactionNodesCreate_594137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the transaction node.
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_TransactionNodesCreate_594137;
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
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  var body_594150 = newJObject()
  add(path_594148, "resourceGroupName", newJString(resourceGroupName))
  add(query_594149, "api-version", newJString(apiVersion))
  add(path_594148, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594148, "subscriptionId", newJString(subscriptionId))
  add(path_594148, "transactionNodeName", newJString(transactionNodeName))
  if transactionNode != nil:
    body_594150 = transactionNode
  result = call_594147.call(path_594148, query_594149, nil, nil, body_594150)

var transactionNodesCreate* = Call_TransactionNodesCreate_594137(
    name: "transactionNodesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesCreate_594138, base: "",
    url: url_TransactionNodesCreate_594139, schemes: {Scheme.Https})
type
  Call_TransactionNodesGet_594125 = ref object of OpenApiRestCall_593425
proc url_TransactionNodesGet_594127(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesGet_594126(path: JsonNode; query: JsonNode;
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
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("blockchainMemberName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "blockchainMemberName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  var valid_594131 = path.getOrDefault("transactionNodeName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "transactionNodeName", valid_594131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594132 = query.getOrDefault("api-version")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594132 != nil:
    section.add "api-version", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_TransactionNodesGet_594125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the transaction node.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_TransactionNodesGet_594125; resourceGroupName: string;
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
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  add(path_594135, "transactionNodeName", newJString(transactionNodeName))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var transactionNodesGet* = Call_TransactionNodesGet_594125(
    name: "transactionNodesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesGet_594126, base: "",
    url: url_TransactionNodesGet_594127, schemes: {Scheme.Https})
type
  Call_TransactionNodesUpdate_594163 = ref object of OpenApiRestCall_593425
proc url_TransactionNodesUpdate_594165(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesUpdate_594164(path: JsonNode; query: JsonNode;
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
  var valid_594166 = path.getOrDefault("resourceGroupName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "resourceGroupName", valid_594166
  var valid_594167 = path.getOrDefault("blockchainMemberName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "blockchainMemberName", valid_594167
  var valid_594168 = path.getOrDefault("subscriptionId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "subscriptionId", valid_594168
  var valid_594169 = path.getOrDefault("transactionNodeName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "transactionNodeName", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594170 = query.getOrDefault("api-version")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594170 != nil:
    section.add "api-version", valid_594170
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

proc call*(call_594172: Call_TransactionNodesUpdate_594163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the transaction node.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_TransactionNodesUpdate_594163;
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
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  var body_594176 = newJObject()
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(path_594174, "transactionNodeName", newJString(transactionNodeName))
  if transactionNode != nil:
    body_594176 = transactionNode
  result = call_594173.call(path_594174, query_594175, nil, nil, body_594176)

var transactionNodesUpdate* = Call_TransactionNodesUpdate_594163(
    name: "transactionNodesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesUpdate_594164, base: "",
    url: url_TransactionNodesUpdate_594165, schemes: {Scheme.Https})
type
  Call_TransactionNodesDelete_594151 = ref object of OpenApiRestCall_593425
proc url_TransactionNodesDelete_594153(protocol: Scheme; host: string; base: string;
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

proc validate_TransactionNodesDelete_594152(path: JsonNode; query: JsonNode;
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
  var valid_594154 = path.getOrDefault("resourceGroupName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "resourceGroupName", valid_594154
  var valid_594155 = path.getOrDefault("blockchainMemberName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "blockchainMemberName", valid_594155
  var valid_594156 = path.getOrDefault("subscriptionId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "subscriptionId", valid_594156
  var valid_594157 = path.getOrDefault("transactionNodeName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "transactionNodeName", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_TransactionNodesDelete_594151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the transaction node.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_TransactionNodesDelete_594151;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  add(path_594161, "transactionNodeName", newJString(transactionNodeName))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var transactionNodesDelete* = Call_TransactionNodesDelete_594151(
    name: "transactionNodesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}",
    validator: validate_TransactionNodesDelete_594152, base: "",
    url: url_TransactionNodesDelete_594153, schemes: {Scheme.Https})
type
  Call_TransactionNodesListApiKeys_594177 = ref object of OpenApiRestCall_593425
proc url_TransactionNodesListApiKeys_594179(protocol: Scheme; host: string;
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

proc validate_TransactionNodesListApiKeys_594178(path: JsonNode; query: JsonNode;
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
  var valid_594180 = path.getOrDefault("resourceGroupName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "resourceGroupName", valid_594180
  var valid_594181 = path.getOrDefault("blockchainMemberName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "blockchainMemberName", valid_594181
  var valid_594182 = path.getOrDefault("subscriptionId")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "subscriptionId", valid_594182
  var valid_594183 = path.getOrDefault("transactionNodeName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "transactionNodeName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_TransactionNodesListApiKeys_594177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the API keys for the transaction node.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_TransactionNodesListApiKeys_594177;
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
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "resourceGroupName", newJString(resourceGroupName))
  add(query_594188, "api-version", newJString(apiVersion))
  add(path_594187, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594187, "subscriptionId", newJString(subscriptionId))
  add(path_594187, "transactionNodeName", newJString(transactionNodeName))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var transactionNodesListApiKeys* = Call_TransactionNodesListApiKeys_594177(
    name: "transactionNodesListApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}/listApiKeys",
    validator: validate_TransactionNodesListApiKeys_594178, base: "",
    url: url_TransactionNodesListApiKeys_594179, schemes: {Scheme.Https})
type
  Call_TransactionNodesListRegenerateApiKeys_594189 = ref object of OpenApiRestCall_593425
proc url_TransactionNodesListRegenerateApiKeys_594191(protocol: Scheme;
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

proc validate_TransactionNodesListRegenerateApiKeys_594190(path: JsonNode;
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
  var valid_594192 = path.getOrDefault("resourceGroupName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "resourceGroupName", valid_594192
  var valid_594193 = path.getOrDefault("blockchainMemberName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "blockchainMemberName", valid_594193
  var valid_594194 = path.getOrDefault("subscriptionId")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "subscriptionId", valid_594194
  var valid_594195 = path.getOrDefault("transactionNodeName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "transactionNodeName", valid_594195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594196 = query.getOrDefault("api-version")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = newJString("2018-06-01-preview"))
  if valid_594196 != nil:
    section.add "api-version", valid_594196
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

proc call*(call_594198: Call_TransactionNodesListRegenerateApiKeys_594189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate the API keys for the blockchain member.
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_TransactionNodesListRegenerateApiKeys_594189;
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
  var path_594200 = newJObject()
  var query_594201 = newJObject()
  var body_594202 = newJObject()
  add(path_594200, "resourceGroupName", newJString(resourceGroupName))
  add(query_594201, "api-version", newJString(apiVersion))
  add(path_594200, "blockchainMemberName", newJString(blockchainMemberName))
  add(path_594200, "subscriptionId", newJString(subscriptionId))
  add(path_594200, "transactionNodeName", newJString(transactionNodeName))
  if apiKey != nil:
    body_594202 = apiKey
  result = call_594199.call(path_594200, query_594201, nil, nil, body_594202)

var transactionNodesListRegenerateApiKeys* = Call_TransactionNodesListRegenerateApiKeys_594189(
    name: "transactionNodesListRegenerateApiKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Blockchain/blockchainMembers/{blockchainMemberName}/transactionNodes/{transactionNodeName}/regenerateApiKeys",
    validator: validate_TransactionNodesListRegenerateApiKeys_594190, base: "",
    url: url_TransactionNodesListRegenerateApiKeys_594191, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
