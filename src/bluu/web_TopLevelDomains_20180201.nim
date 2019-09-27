
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: TopLevelDomains API Client
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "web-TopLevelDomains"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TopLevelDomainsList_593630 = ref object of OpenApiRestCall_593408
proc url_TopLevelDomainsList_593632(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DomainRegistration/topLevelDomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopLevelDomainsList_593631(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get all top-level domains supported for registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593805 = path.getOrDefault("subscriptionId")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "subscriptionId", valid_593805
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593806 = query.getOrDefault("api-version")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "api-version", valid_593806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593829: Call_TopLevelDomainsList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all top-level domains supported for registration.
  ## 
  let valid = call_593829.validator(path, query, header, formData, body)
  let scheme = call_593829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593829.url(scheme.get, call_593829.host, call_593829.base,
                         call_593829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593829, url, valid)

proc call*(call_593900: Call_TopLevelDomainsList_593630; apiVersion: string;
          subscriptionId: string): Recallable =
  ## topLevelDomainsList
  ## Get all top-level domains supported for registration.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593901 = newJObject()
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  add(path_593901, "subscriptionId", newJString(subscriptionId))
  result = call_593900.call(path_593901, query_593903, nil, nil, nil)

var topLevelDomainsList* = Call_TopLevelDomainsList_593630(
    name: "topLevelDomainsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DomainRegistration/topLevelDomains",
    validator: validate_TopLevelDomainsList_593631, base: "",
    url: url_TopLevelDomainsList_593632, schemes: {Scheme.Https})
type
  Call_TopLevelDomainsGet_593942 = ref object of OpenApiRestCall_593408
proc url_TopLevelDomainsGet_593944(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DomainRegistration/topLevelDomains/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopLevelDomainsGet_593943(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get details of a top-level domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the top-level domain.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593945 = path.getOrDefault("name")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "name", valid_593945
  var valid_593946 = path.getOrDefault("subscriptionId")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "subscriptionId", valid_593946
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593947 = query.getOrDefault("api-version")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "api-version", valid_593947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593948: Call_TopLevelDomainsGet_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of a top-level domain.
  ## 
  let valid = call_593948.validator(path, query, header, formData, body)
  let scheme = call_593948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593948.url(scheme.get, call_593948.host, call_593948.base,
                         call_593948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593948, url, valid)

proc call*(call_593949: Call_TopLevelDomainsGet_593942; apiVersion: string;
          name: string; subscriptionId: string): Recallable =
  ## topLevelDomainsGet
  ## Get details of a top-level domain.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the top-level domain.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593950 = newJObject()
  var query_593951 = newJObject()
  add(query_593951, "api-version", newJString(apiVersion))
  add(path_593950, "name", newJString(name))
  add(path_593950, "subscriptionId", newJString(subscriptionId))
  result = call_593949.call(path_593950, query_593951, nil, nil, nil)

var topLevelDomainsGet* = Call_TopLevelDomainsGet_593942(
    name: "topLevelDomainsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DomainRegistration/topLevelDomains/{name}",
    validator: validate_TopLevelDomainsGet_593943, base: "",
    url: url_TopLevelDomainsGet_593944, schemes: {Scheme.Https})
type
  Call_TopLevelDomainsListAgreements_593952 = ref object of OpenApiRestCall_593408
proc url_TopLevelDomainsListAgreements_593954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DomainRegistration/topLevelDomains/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listAgreements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopLevelDomainsListAgreements_593953(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all legal agreements that user needs to accept before purchasing a domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the top-level domain.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593955 = path.getOrDefault("name")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "name", valid_593955
  var valid_593956 = path.getOrDefault("subscriptionId")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "subscriptionId", valid_593956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593957 = query.getOrDefault("api-version")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "api-version", valid_593957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   agreementOption: JObject (required)
  ##                  : Domain agreement options.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593959: Call_TopLevelDomainsListAgreements_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all legal agreements that user needs to accept before purchasing a domain.
  ## 
  let valid = call_593959.validator(path, query, header, formData, body)
  let scheme = call_593959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593959.url(scheme.get, call_593959.host, call_593959.base,
                         call_593959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593959, url, valid)

proc call*(call_593960: Call_TopLevelDomainsListAgreements_593952;
          apiVersion: string; name: string; agreementOption: JsonNode;
          subscriptionId: string): Recallable =
  ## topLevelDomainsListAgreements
  ## Gets all legal agreements that user needs to accept before purchasing a domain.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the top-level domain.
  ##   agreementOption: JObject (required)
  ##                  : Domain agreement options.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_593961 = newJObject()
  var query_593962 = newJObject()
  var body_593963 = newJObject()
  add(query_593962, "api-version", newJString(apiVersion))
  add(path_593961, "name", newJString(name))
  if agreementOption != nil:
    body_593963 = agreementOption
  add(path_593961, "subscriptionId", newJString(subscriptionId))
  result = call_593960.call(path_593961, query_593962, nil, nil, body_593963)

var topLevelDomainsListAgreements* = Call_TopLevelDomainsListAgreements_593952(
    name: "topLevelDomainsListAgreements", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DomainRegistration/topLevelDomains/{name}/listAgreements",
    validator: validate_TopLevelDomainsListAgreements_593953, base: "",
    url: url_TopLevelDomainsListAgreements_593954, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
