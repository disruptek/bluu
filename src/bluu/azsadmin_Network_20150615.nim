
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NetworkAdminManagementClient
## version: 2015-06-15
## termsOfService: (not provided)
## license: (not provided)
## 
## Network admin operation endpoints and objects.
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

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Network"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OnPremLocationsList_574679 = ref object of OpenApiRestCall_574457
proc url_OnPremLocationsList_574681(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OnPremLocationsList_574680(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns the list of supported locations
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
  var valid_574853 = query.getOrDefault("api-version")
  valid_574853 = validateParameter(valid_574853, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_574853 != nil:
    section.add "api-version", valid_574853
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574876: Call_OnPremLocationsList_574679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of supported locations
  ## 
  let valid = call_574876.validator(path, query, header, formData, body)
  let scheme = call_574876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574876.url(scheme.get, call_574876.host, call_574876.base,
                         call_574876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574876, url, valid)

proc call*(call_574947: Call_OnPremLocationsList_574679;
          apiVersion: string = "2015-06-15"): Recallable =
  ## onPremLocationsList
  ## Returns the list of supported locations
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_574948 = newJObject()
  add(query_574948, "api-version", newJString(apiVersion))
  result = call_574947.call(nil, query_574948, nil, nil, nil)

var onPremLocationsList* = Call_OnPremLocationsList_574679(
    name: "onPremLocationsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external",
    route: "/providers/Microsoft.Network.Admin/locations",
    validator: validate_OnPremLocationsList_574680, base: "",
    url: url_OnPremLocationsList_574681, schemes: {Scheme.Https})
type
  Call_LocationsOperationResultsList_574988 = ref object of OpenApiRestCall_574457
proc url_LocationsOperationResultsList_574990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Network.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/operationResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsOperationResultsList_574989(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of operation results for a location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_575005 = path.getOrDefault("location")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "location", valid_575005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575006 = query.getOrDefault("api-version")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_575006 != nil:
    section.add "api-version", valid_575006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575007: Call_LocationsOperationResultsList_574988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of operation results for a location
  ## 
  let valid = call_575007.validator(path, query, header, formData, body)
  let scheme = call_575007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575007.url(scheme.get, call_575007.host, call_575007.base,
                         call_575007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575007, url, valid)

proc call*(call_575008: Call_LocationsOperationResultsList_574988;
          location: string; apiVersion: string = "2015-06-15"): Recallable =
  ## locationsOperationResultsList
  ## Returns the list of operation results for a location
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575009 = newJObject()
  var query_575010 = newJObject()
  add(query_575010, "api-version", newJString(apiVersion))
  add(path_575009, "location", newJString(location))
  result = call_575008.call(path_575009, query_575010, nil, nil, nil)

var locationsOperationResultsList* = Call_LocationsOperationResultsList_574988(
    name: "locationsOperationResultsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/providers/Microsoft.Network.Admin/locations/{location}/operationResults",
    validator: validate_LocationsOperationResultsList_574989, base: "",
    url: url_LocationsOperationResultsList_574990, schemes: {Scheme.Https})
type
  Call_LocationsOperationsList_575011 = ref object of OpenApiRestCall_574457
proc url_LocationsOperationsList_575013(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Network.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsOperationsList_575012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of support REST operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_575014 = path.getOrDefault("location")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "location", valid_575014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575015 = query.getOrDefault("api-version")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_575015 != nil:
    section.add "api-version", valid_575015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575016: Call_LocationsOperationsList_575011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of support REST operations.
  ## 
  let valid = call_575016.validator(path, query, header, formData, body)
  let scheme = call_575016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575016.url(scheme.get, call_575016.host, call_575016.base,
                         call_575016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575016, url, valid)

proc call*(call_575017: Call_LocationsOperationsList_575011; location: string;
          apiVersion: string = "2015-06-15"): Recallable =
  ## locationsOperationsList
  ## Returns the list of support REST operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575018 = newJObject()
  var query_575019 = newJObject()
  add(query_575019, "api-version", newJString(apiVersion))
  add(path_575018, "location", newJString(location))
  result = call_575017.call(path_575018, query_575019, nil, nil, nil)

var locationsOperationsList* = Call_LocationsOperationsList_575011(
    name: "locationsOperationsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/providers/Microsoft.Network.Admin/locations/{location}/operations",
    validator: validate_LocationsOperationsList_575012, base: "",
    url: url_LocationsOperationsList_575013, schemes: {Scheme.Https})
type
  Call_OperationsList_575020 = ref object of OpenApiRestCall_574457
proc url_OperationsList_575022(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_575021(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the list of support REST operations.
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
  var valid_575023 = query.getOrDefault("api-version")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_575023 != nil:
    section.add "api-version", valid_575023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575024: Call_OperationsList_575020; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of support REST operations.
  ## 
  let valid = call_575024.validator(path, query, header, formData, body)
  let scheme = call_575024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575024.url(scheme.get, call_575024.host, call_575024.base,
                         call_575024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575024, url, valid)

proc call*(call_575025: Call_OperationsList_575020;
          apiVersion: string = "2015-06-15"): Recallable =
  ## operationsList
  ## Returns the list of support REST operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_575026 = newJObject()
  add(query_575026, "api-version", newJString(apiVersion))
  result = call_575025.call(nil, query_575026, nil, nil, nil)

var operationsList* = Call_OperationsList_575020(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external",
    route: "/providers/Microsoft.Network.Admin/operations",
    validator: validate_OperationsList_575021, base: "", url: url_OperationsList_575022,
    schemes: {Scheme.Https})
type
  Call_ResourceProviderStateGet_575027 = ref object of OpenApiRestCall_574457
proc url_ResourceProviderStateGet_575029(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Network.Admin/adminOverview")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceProviderStateGet_575028(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an overview of the state of the network resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575030 = path.getOrDefault("subscriptionId")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = nil)
  if valid_575030 != nil:
    section.add "subscriptionId", valid_575030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575031 = query.getOrDefault("api-version")
  valid_575031 = validateParameter(valid_575031, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_575031 != nil:
    section.add "api-version", valid_575031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575032: Call_ResourceProviderStateGet_575027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an overview of the state of the network resource provider.
  ## 
  let valid = call_575032.validator(path, query, header, formData, body)
  let scheme = call_575032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575032.url(scheme.get, call_575032.host, call_575032.base,
                         call_575032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575032, url, valid)

proc call*(call_575033: Call_ResourceProviderStateGet_575027;
          subscriptionId: string; apiVersion: string = "2015-06-15"): Recallable =
  ## resourceProviderStateGet
  ## Get an overview of the state of the network resource provider.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575034 = newJObject()
  var query_575035 = newJObject()
  add(query_575035, "api-version", newJString(apiVersion))
  add(path_575034, "subscriptionId", newJString(subscriptionId))
  result = call_575033.call(path_575034, query_575035, nil, nil, nil)

var resourceProviderStateGet* = Call_ResourceProviderStateGet_575027(
    name: "resourceProviderStateGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network.Admin/adminOverview",
    validator: validate_ResourceProviderStateGet_575028, base: "",
    url: url_ResourceProviderStateGet_575029, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
