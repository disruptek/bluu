
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Operation status operation endpoints and objects.
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

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Operations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ComputeFabricOperationsGet_574663 = ref object of OpenApiRestCall_574441
proc url_ComputeFabricOperationsGet_574665(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "provider" in path, "`provider` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "computeOperationResult" in path,
        "`computeOperationResult` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/System."),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "provider"),
               (kind: ConstantSegment, value: "/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/computeOperationResults/"),
               (kind: VariableSegment, value: "computeOperationResult")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeFabricOperationsGet_574664(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the status of a compute fabric operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   computeOperationResult: JString (required)
  ##                         : Id of a compute fabric operation.
  ##   provider: JString (required)
  ##           : Name of the provider.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574838 = path.getOrDefault("subscriptionId")
  valid_574838 = validateParameter(valid_574838, JString, required = true,
                                 default = nil)
  if valid_574838 != nil:
    section.add "subscriptionId", valid_574838
  var valid_574839 = path.getOrDefault("computeOperationResult")
  valid_574839 = validateParameter(valid_574839, JString, required = true,
                                 default = nil)
  if valid_574839 != nil:
    section.add "computeOperationResult", valid_574839
  var valid_574840 = path.getOrDefault("provider")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = nil)
  if valid_574840 != nil:
    section.add "provider", valid_574840
  var valid_574841 = path.getOrDefault("location")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "location", valid_574841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574855 = query.getOrDefault("api-version")
  valid_574855 = validateParameter(valid_574855, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574855 != nil:
    section.add "api-version", valid_574855
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574878: Call_ComputeFabricOperationsGet_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the status of a compute fabric operation.
  ## 
  let valid = call_574878.validator(path, query, header, formData, body)
  let scheme = call_574878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574878.url(scheme.get, call_574878.host, call_574878.base,
                         call_574878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574878, url, valid)

proc call*(call_574949: Call_ComputeFabricOperationsGet_574663;
          subscriptionId: string; computeOperationResult: string; provider: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## computeFabricOperationsGet
  ## Get the status of a compute fabric operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   computeOperationResult: string (required)
  ##                         : Id of a compute fabric operation.
  ##   provider: string (required)
  ##           : Name of the provider.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_574950 = newJObject()
  var query_574952 = newJObject()
  add(query_574952, "api-version", newJString(apiVersion))
  add(path_574950, "subscriptionId", newJString(subscriptionId))
  add(path_574950, "computeOperationResult", newJString(computeOperationResult))
  add(path_574950, "provider", newJString(provider))
  add(path_574950, "location", newJString(location))
  result = call_574949.call(path_574950, query_574952, nil, nil, nil)

var computeFabricOperationsGet* = Call_ComputeFabricOperationsGet_574663(
    name: "computeFabricOperationsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/System.{location}/providers/{provider}/fabricLocations/{location}/computeOperationResults/{computeOperationResult}",
    validator: validate_ComputeFabricOperationsGet_574664, base: "",
    url: url_ComputeFabricOperationsGet_574665, schemes: {Scheme.Https})
type
  Call_NetworkFabricOperationsGet_574991 = ref object of OpenApiRestCall_574441
proc url_NetworkFabricOperationsGet_574993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "provider" in path, "`provider` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "networkOperationResult" in path,
        "`networkOperationResult` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/System."),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "provider"),
               (kind: ConstantSegment, value: "/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/networkOperationResults/"),
               (kind: VariableSegment, value: "networkOperationResult")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkFabricOperationsGet_574992(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the status of a network fabric operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   networkOperationResult: JString (required)
  ##                         : Id of a network fabric operation.
  ##   provider: JString (required)
  ##           : Name of the provider.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574994 = path.getOrDefault("subscriptionId")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "subscriptionId", valid_574994
  var valid_574995 = path.getOrDefault("networkOperationResult")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "networkOperationResult", valid_574995
  var valid_574996 = path.getOrDefault("provider")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "provider", valid_574996
  var valid_574997 = path.getOrDefault("location")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "location", valid_574997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574998 = query.getOrDefault("api-version")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574998 != nil:
    section.add "api-version", valid_574998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574999: Call_NetworkFabricOperationsGet_574991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the status of a network fabric operation.
  ## 
  let valid = call_574999.validator(path, query, header, formData, body)
  let scheme = call_574999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574999.url(scheme.get, call_574999.host, call_574999.base,
                         call_574999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574999, url, valid)

proc call*(call_575000: Call_NetworkFabricOperationsGet_574991;
          subscriptionId: string; networkOperationResult: string; provider: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## networkFabricOperationsGet
  ## Get the status of a network fabric operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   networkOperationResult: string (required)
  ##                         : Id of a network fabric operation.
  ##   provider: string (required)
  ##           : Name of the provider.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575001 = newJObject()
  var query_575002 = newJObject()
  add(query_575002, "api-version", newJString(apiVersion))
  add(path_575001, "subscriptionId", newJString(subscriptionId))
  add(path_575001, "networkOperationResult", newJString(networkOperationResult))
  add(path_575001, "provider", newJString(provider))
  add(path_575001, "location", newJString(location))
  result = call_575000.call(path_575001, query_575002, nil, nil, nil)

var networkFabricOperationsGet* = Call_NetworkFabricOperationsGet_574991(
    name: "networkFabricOperationsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/System.{location}/providers/{provider}/fabricLocations/{location}/networkOperationResults/{networkOperationResult}",
    validator: validate_NetworkFabricOperationsGet_574992, base: "",
    url: url_NetworkFabricOperationsGet_574993, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
