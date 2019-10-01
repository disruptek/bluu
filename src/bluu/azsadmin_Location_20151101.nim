
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionsManagementClient
## version: 2015-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Subscriptions Management Client.
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
  macServiceName = "azsadmin-Location"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LocationsList_574679 = ref object of OpenApiRestCall_574457
proc url_LocationsList_574681(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsList_574680(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of all AzureStack location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574841 = path.getOrDefault("subscriptionId")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "subscriptionId", valid_574841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574855 = query.getOrDefault("api-version")
  valid_574855 = validateParameter(valid_574855, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574855 != nil:
    section.add "api-version", valid_574855
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574882: Call_LocationsList_574679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of all AzureStack location.
  ## 
  let valid = call_574882.validator(path, query, header, formData, body)
  let scheme = call_574882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574882.url(scheme.get, call_574882.host, call_574882.base,
                         call_574882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574882, url, valid)

proc call*(call_574953: Call_LocationsList_574679; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## locationsList
  ## Get a list of all AzureStack location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574954 = newJObject()
  var query_574956 = newJObject()
  add(query_574956, "api-version", newJString(apiVersion))
  add(path_574954, "subscriptionId", newJString(subscriptionId))
  result = call_574953.call(path_574954, query_574956, nil, nil, nil)

var locationsList* = Call_LocationsList_574679(name: "locationsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/locations",
    validator: validate_LocationsList_574680, base: "", url: url_LocationsList_574681,
    schemes: {Scheme.Https})
type
  Call_LocationsCreateOrUpdate_575005 = ref object of OpenApiRestCall_574457
proc url_LocationsCreateOrUpdate_575007(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/locations/"),
               (kind: VariableSegment, value: "location")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsCreateOrUpdate_575006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The AzureStack location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575017 = path.getOrDefault("subscriptionId")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "subscriptionId", valid_575017
  var valid_575018 = path.getOrDefault("location")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "location", valid_575018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575019 = query.getOrDefault("api-version")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575019 != nil:
    section.add "api-version", valid_575019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   newLocation: JObject (required)
  ##              : The new location
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575021: Call_LocationsCreateOrUpdate_575005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified location.
  ## 
  let valid = call_575021.validator(path, query, header, formData, body)
  let scheme = call_575021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575021.url(scheme.get, call_575021.host, call_575021.base,
                         call_575021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575021, url, valid)

proc call*(call_575022: Call_LocationsCreateOrUpdate_575005;
          subscriptionId: string; location: string; newLocation: JsonNode;
          apiVersion: string = "2015-11-01"): Recallable =
  ## locationsCreateOrUpdate
  ## Updates the specified location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The AzureStack location.
  ##   newLocation: JObject (required)
  ##              : The new location
  var path_575023 = newJObject()
  var query_575024 = newJObject()
  var body_575025 = newJObject()
  add(query_575024, "api-version", newJString(apiVersion))
  add(path_575023, "subscriptionId", newJString(subscriptionId))
  add(path_575023, "location", newJString(location))
  if newLocation != nil:
    body_575025 = newLocation
  result = call_575022.call(path_575023, query_575024, nil, nil, body_575025)

var locationsCreateOrUpdate* = Call_LocationsCreateOrUpdate_575005(
    name: "locationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/locations/{location}",
    validator: validate_LocationsCreateOrUpdate_575006, base: "",
    url: url_LocationsCreateOrUpdate_575007, schemes: {Scheme.Https})
type
  Call_LocationsGet_574995 = ref object of OpenApiRestCall_574457
proc url_LocationsGet_574997(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/locations/"),
               (kind: VariableSegment, value: "location")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsGet_574996(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The AzureStack location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574998 = path.getOrDefault("subscriptionId")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = nil)
  if valid_574998 != nil:
    section.add "subscriptionId", valid_574998
  var valid_574999 = path.getOrDefault("location")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = nil)
  if valid_574999 != nil:
    section.add "location", valid_574999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575000 = query.getOrDefault("api-version")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575000 != nil:
    section.add "api-version", valid_575000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575001: Call_LocationsGet_574995; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified location.
  ## 
  let valid = call_575001.validator(path, query, header, formData, body)
  let scheme = call_575001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575001.url(scheme.get, call_575001.host, call_575001.base,
                         call_575001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575001, url, valid)

proc call*(call_575002: Call_LocationsGet_574995; subscriptionId: string;
          location: string; apiVersion: string = "2015-11-01"): Recallable =
  ## locationsGet
  ## Get the specified location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The AzureStack location.
  var path_575003 = newJObject()
  var query_575004 = newJObject()
  add(query_575004, "api-version", newJString(apiVersion))
  add(path_575003, "subscriptionId", newJString(subscriptionId))
  add(path_575003, "location", newJString(location))
  result = call_575002.call(path_575003, query_575004, nil, nil, nil)

var locationsGet* = Call_LocationsGet_574995(name: "locationsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/locations/{location}",
    validator: validate_LocationsGet_574996, base: "", url: url_LocationsGet_574997,
    schemes: {Scheme.Https})
type
  Call_LocationsGetOperationsStatus_575026 = ref object of OpenApiRestCall_574457
proc url_LocationsGetOperationsStatus_575028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "operationsStatusName" in path,
        "`operationsStatusName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/operationsStatus/"),
               (kind: VariableSegment, value: "operationsStatusName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LocationsGetOperationsStatus_575027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the operation status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationsStatusName: JString (required)
  ##                       : The operation status name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The AzureStack location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operationsStatusName` field"
  var valid_575029 = path.getOrDefault("operationsStatusName")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "operationsStatusName", valid_575029
  var valid_575030 = path.getOrDefault("subscriptionId")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = nil)
  if valid_575030 != nil:
    section.add "subscriptionId", valid_575030
  var valid_575031 = path.getOrDefault("location")
  valid_575031 = validateParameter(valid_575031, JString, required = true,
                                 default = nil)
  if valid_575031 != nil:
    section.add "location", valid_575031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575032 = query.getOrDefault("api-version")
  valid_575032 = validateParameter(valid_575032, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575032 != nil:
    section.add "api-version", valid_575032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575033: Call_LocationsGetOperationsStatus_575026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the operation status.
  ## 
  let valid = call_575033.validator(path, query, header, formData, body)
  let scheme = call_575033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575033.url(scheme.get, call_575033.host, call_575033.base,
                         call_575033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575033, url, valid)

proc call*(call_575034: Call_LocationsGetOperationsStatus_575026;
          operationsStatusName: string; subscriptionId: string; location: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## locationsGetOperationsStatus
  ## Get the operation status.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   operationsStatusName: string (required)
  ##                       : The operation status name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The AzureStack location.
  var path_575035 = newJObject()
  var query_575036 = newJObject()
  add(query_575036, "api-version", newJString(apiVersion))
  add(path_575035, "operationsStatusName", newJString(operationsStatusName))
  add(path_575035, "subscriptionId", newJString(subscriptionId))
  add(path_575035, "location", newJString(location))
  result = call_575034.call(path_575035, query_575036, nil, nil, nil)

var locationsGetOperationsStatus* = Call_LocationsGetOperationsStatus_575026(
    name: "locationsGetOperationsStatus", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/locations/{location}/operationsStatus/{operationsStatusName}",
    validator: validate_LocationsGetOperationsStatus_575027, base: "",
    url: url_LocationsGetOperationsStatus_575028, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
