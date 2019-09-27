
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Network"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OnPremLocationsList_593646 = ref object of OpenApiRestCall_593424
proc url_OnPremLocationsList_593648(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OnPremLocationsList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_OnPremLocationsList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of supported locations
  ## 
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_OnPremLocationsList_593646;
          apiVersion: string = "2015-06-15"): Recallable =
  ## onPremLocationsList
  ## Returns the list of supported locations
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_593915 = newJObject()
  add(query_593915, "api-version", newJString(apiVersion))
  result = call_593914.call(nil, query_593915, nil, nil, nil)

var onPremLocationsList* = Call_OnPremLocationsList_593646(
    name: "onPremLocationsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external",
    route: "/providers/Microsoft.Network.Admin/locations",
    validator: validate_OnPremLocationsList_593647, base: "",
    url: url_OnPremLocationsList_593648, schemes: {Scheme.Https})
type
  Call_LocationsOperationResultsList_593955 = ref object of OpenApiRestCall_593424
proc url_LocationsOperationResultsList_593957(protocol: Scheme; host: string;
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

proc validate_LocationsOperationResultsList_593956(path: JsonNode; query: JsonNode;
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
  var valid_593972 = path.getOrDefault("location")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "location", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_LocationsOperationResultsList_593955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of operation results for a location
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_LocationsOperationResultsList_593955;
          location: string; apiVersion: string = "2015-06-15"): Recallable =
  ## locationsOperationResultsList
  ## Returns the list of operation results for a location
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(query_593977, "api-version", newJString(apiVersion))
  add(path_593976, "location", newJString(location))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var locationsOperationResultsList* = Call_LocationsOperationResultsList_593955(
    name: "locationsOperationResultsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/providers/Microsoft.Network.Admin/locations/{location}/operationResults",
    validator: validate_LocationsOperationResultsList_593956, base: "",
    url: url_LocationsOperationResultsList_593957, schemes: {Scheme.Https})
type
  Call_LocationsOperationsList_593978 = ref object of OpenApiRestCall_593424
proc url_LocationsOperationsList_593980(protocol: Scheme; host: string; base: string;
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

proc validate_LocationsOperationsList_593979(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("location")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "location", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_LocationsOperationsList_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of support REST operations.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_LocationsOperationsList_593978; location: string;
          apiVersion: string = "2015-06-15"): Recallable =
  ## locationsOperationsList
  ## Returns the list of support REST operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "location", newJString(location))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var locationsOperationsList* = Call_LocationsOperationsList_593978(
    name: "locationsOperationsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/providers/Microsoft.Network.Admin/locations/{location}/operations",
    validator: validate_LocationsOperationsList_593979, base: "",
    url: url_LocationsOperationsList_593980, schemes: {Scheme.Https})
type
  Call_OperationsList_593987 = ref object of OpenApiRestCall_593424
proc url_OperationsList_593989(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593988(path: JsonNode; query: JsonNode;
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
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_OperationsList_593987; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of support REST operations.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_OperationsList_593987;
          apiVersion: string = "2015-06-15"): Recallable =
  ## operationsList
  ## Returns the list of support REST operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_593993 = newJObject()
  add(query_593993, "api-version", newJString(apiVersion))
  result = call_593992.call(nil, query_593993, nil, nil, nil)

var operationsList* = Call_OperationsList_593987(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external",
    route: "/providers/Microsoft.Network.Admin/operations",
    validator: validate_OperationsList_593988, base: "", url: url_OperationsList_593989,
    schemes: {Scheme.Https})
type
  Call_ResourceProviderStateGet_593994 = ref object of OpenApiRestCall_593424
proc url_ResourceProviderStateGet_593996(protocol: Scheme; host: string;
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

proc validate_ResourceProviderStateGet_593995(path: JsonNode; query: JsonNode;
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
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = newJString("2015-06-15"))
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_ResourceProviderStateGet_593994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an overview of the state of the network resource provider.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_ResourceProviderStateGet_593994;
          subscriptionId: string; apiVersion: string = "2015-06-15"): Recallable =
  ## resourceProviderStateGet
  ## Get an overview of the state of the network resource provider.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var resourceProviderStateGet* = Call_ResourceProviderStateGet_593994(
    name: "resourceProviderStateGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Network.Admin/adminOverview",
    validator: validate_ResourceProviderStateGet_593995, base: "",
    url: url_ResourceProviderStateGet_593996, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
