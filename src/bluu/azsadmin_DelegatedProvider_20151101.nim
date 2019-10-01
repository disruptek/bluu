
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

  OpenApiRestCall_582442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582442): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-DelegatedProvider"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DelegatedProvidersList_582664 = ref object of OpenApiRestCall_582442
proc url_DelegatedProvidersList_582666(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Subscriptions.Admin/delegatedProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DelegatedProvidersList_582665(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of delegatedProviders.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_582826 = path.getOrDefault("subscriptionId")
  valid_582826 = validateParameter(valid_582826, JString, required = true,
                                 default = nil)
  if valid_582826 != nil:
    section.add "subscriptionId", valid_582826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582840 = query.getOrDefault("api-version")
  valid_582840 = validateParameter(valid_582840, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_582840 != nil:
    section.add "api-version", valid_582840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582867: Call_DelegatedProvidersList_582664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of delegatedProviders.
  ## 
  let valid = call_582867.validator(path, query, header, formData, body)
  let scheme = call_582867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582867.url(scheme.get, call_582867.host, call_582867.base,
                         call_582867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582867, url, valid)

proc call*(call_582938: Call_DelegatedProvidersList_582664; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## delegatedProvidersList
  ## Get the list of delegatedProviders.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_582939 = newJObject()
  var query_582941 = newJObject()
  add(query_582941, "api-version", newJString(apiVersion))
  add(path_582939, "subscriptionId", newJString(subscriptionId))
  result = call_582938.call(path_582939, query_582941, nil, nil, nil)

var delegatedProvidersList* = Call_DelegatedProvidersList_582664(
    name: "delegatedProvidersList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/delegatedProviders",
    validator: validate_DelegatedProvidersList_582665, base: "",
    url: url_DelegatedProvidersList_582666, schemes: {Scheme.Https})
type
  Call_DelegatedProvidersGet_582980 = ref object of OpenApiRestCall_582442
proc url_DelegatedProvidersGet_582982(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "delegatedProvider" in path,
        "`delegatedProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/delegatedProviders/"),
               (kind: VariableSegment, value: "delegatedProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DelegatedProvidersGet_582981(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified delegated provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   delegatedProvider: JString (required)
  ##                    : DelegatedProvider identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `delegatedProvider` field"
  var valid_582983 = path.getOrDefault("delegatedProvider")
  valid_582983 = validateParameter(valid_582983, JString, required = true,
                                 default = nil)
  if valid_582983 != nil:
    section.add "delegatedProvider", valid_582983
  var valid_582984 = path.getOrDefault("subscriptionId")
  valid_582984 = validateParameter(valid_582984, JString, required = true,
                                 default = nil)
  if valid_582984 != nil:
    section.add "subscriptionId", valid_582984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582985 = query.getOrDefault("api-version")
  valid_582985 = validateParameter(valid_582985, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_582985 != nil:
    section.add "api-version", valid_582985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582986: Call_DelegatedProvidersGet_582980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified delegated provider.
  ## 
  let valid = call_582986.validator(path, query, header, formData, body)
  let scheme = call_582986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582986.url(scheme.get, call_582986.host, call_582986.base,
                         call_582986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582986, url, valid)

proc call*(call_582987: Call_DelegatedProvidersGet_582980;
          delegatedProvider: string; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## delegatedProvidersGet
  ## Get the specified delegated provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   delegatedProvider: string (required)
  ##                    : DelegatedProvider identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_582988 = newJObject()
  var query_582989 = newJObject()
  add(query_582989, "api-version", newJString(apiVersion))
  add(path_582988, "delegatedProvider", newJString(delegatedProvider))
  add(path_582988, "subscriptionId", newJString(subscriptionId))
  result = call_582987.call(path_582988, query_582989, nil, nil, nil)

var delegatedProvidersGet* = Call_DelegatedProvidersGet_582980(
    name: "delegatedProvidersGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/delegatedProviders/{delegatedProvider}",
    validator: validate_DelegatedProvidersGet_582981, base: "",
    url: url_DelegatedProvidersGet_582982, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
