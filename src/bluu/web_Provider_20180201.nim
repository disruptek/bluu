
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Provider API Client
## version: 2018-02-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "web-Provider"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderGetAvailableStacks_563761 = ref object of OpenApiRestCall_563539
proc url_ProviderGetAvailableStacks_563763(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderGetAvailableStacks_563762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available application frameworks and their versions
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   osTypeSelected: JString
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563924 = query.getOrDefault("api-version")
  valid_563924 = validateParameter(valid_563924, JString, required = true,
                                 default = nil)
  if valid_563924 != nil:
    section.add "api-version", valid_563924
  var valid_563938 = query.getOrDefault("osTypeSelected")
  valid_563938 = validateParameter(valid_563938, JString, required = false,
                                 default = newJString("Windows"))
  if valid_563938 != nil:
    section.add "osTypeSelected", valid_563938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563961: Call_ProviderGetAvailableStacks_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get available application frameworks and their versions
  ## 
  let valid = call_563961.validator(path, query, header, formData, body)
  let scheme = call_563961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563961.url(scheme.get, call_563961.host, call_563961.base,
                         call_563961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563961, url, valid)

proc call*(call_564032: Call_ProviderGetAvailableStacks_563761; apiVersion: string;
          osTypeSelected: string = "Windows"): Recallable =
  ## providerGetAvailableStacks
  ## Get available application frameworks and their versions
  ##   apiVersion: string (required)
  ##             : API Version
  ##   osTypeSelected: string
  var query_564033 = newJObject()
  add(query_564033, "api-version", newJString(apiVersion))
  add(query_564033, "osTypeSelected", newJString(osTypeSelected))
  result = call_564032.call(nil, query_564033, nil, nil, nil)

var providerGetAvailableStacks* = Call_ProviderGetAvailableStacks_563761(
    name: "providerGetAvailableStacks", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Web/availableStacks",
    validator: validate_ProviderGetAvailableStacks_563762, base: "",
    url: url_ProviderGetAvailableStacks_563763, schemes: {Scheme.Https})
type
  Call_ProviderListOperations_564073 = ref object of OpenApiRestCall_563539
proc url_ProviderListOperations_564075(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderListOperations_564074(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all available operations for the Microsoft.Web resource provider. Also exposes resource metric definitions
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564076 = query.getOrDefault("api-version")
  valid_564076 = validateParameter(valid_564076, JString, required = true,
                                 default = nil)
  if valid_564076 != nil:
    section.add "api-version", valid_564076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564077: Call_ProviderListOperations_564073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available operations for the Microsoft.Web resource provider. Also exposes resource metric definitions
  ## 
  let valid = call_564077.validator(path, query, header, formData, body)
  let scheme = call_564077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564077.url(scheme.get, call_564077.host, call_564077.base,
                         call_564077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564077, url, valid)

proc call*(call_564078: Call_ProviderListOperations_564073; apiVersion: string): Recallable =
  ## providerListOperations
  ## Gets all available operations for the Microsoft.Web resource provider. Also exposes resource metric definitions
  ##   apiVersion: string (required)
  ##             : API Version
  var query_564079 = newJObject()
  add(query_564079, "api-version", newJString(apiVersion))
  result = call_564078.call(nil, query_564079, nil, nil, nil)

var providerListOperations* = Call_ProviderListOperations_564073(
    name: "providerListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Web/operations",
    validator: validate_ProviderListOperations_564074, base: "",
    url: url_ProviderListOperations_564075, schemes: {Scheme.Https})
type
  Call_ProviderGetAvailableStacksOnPrem_564080 = ref object of OpenApiRestCall_563539
proc url_ProviderGetAvailableStacksOnPrem_564082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/availableStacks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProviderGetAvailableStacksOnPrem_564081(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available application frameworks and their versions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   osTypeSelected: JString
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  var valid_564099 = query.getOrDefault("osTypeSelected")
  valid_564099 = validateParameter(valid_564099, JString, required = false,
                                 default = newJString("Windows"))
  if valid_564099 != nil:
    section.add "osTypeSelected", valid_564099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564100: Call_ProviderGetAvailableStacksOnPrem_564080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available application frameworks and their versions
  ## 
  let valid = call_564100.validator(path, query, header, formData, body)
  let scheme = call_564100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564100.url(scheme.get, call_564100.host, call_564100.base,
                         call_564100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564100, url, valid)

proc call*(call_564101: Call_ProviderGetAvailableStacksOnPrem_564080;
          apiVersion: string; subscriptionId: string;
          osTypeSelected: string = "Windows"): Recallable =
  ## providerGetAvailableStacksOnPrem
  ## Get available application frameworks and their versions
  ##   apiVersion: string (required)
  ##             : API Version
  ##   osTypeSelected: string
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_564102 = newJObject()
  var query_564103 = newJObject()
  add(query_564103, "api-version", newJString(apiVersion))
  add(query_564103, "osTypeSelected", newJString(osTypeSelected))
  add(path_564102, "subscriptionId", newJString(subscriptionId))
  result = call_564101.call(path_564102, query_564103, nil, nil, nil)

var providerGetAvailableStacksOnPrem* = Call_ProviderGetAvailableStacksOnPrem_564080(
    name: "providerGetAvailableStacksOnPrem", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/availableStacks",
    validator: validate_ProviderGetAvailableStacksOnPrem_564081, base: "",
    url: url_ProviderGetAvailableStacksOnPrem_564082, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
