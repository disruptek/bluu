
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionClient
## version: 2015-11-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The User Subscription Management Client.
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

  OpenApiRestCall_574442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574442): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Subscriptions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionsList_574664 = ref object of OpenApiRestCall_574442
proc url_SubscriptionsList_574666(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionsList_574665(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the list of subscriptions.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574838 = query.getOrDefault("api-version")
  valid_574838 = validateParameter(valid_574838, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574838 != nil:
    section.add "api-version", valid_574838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574861: Call_SubscriptionsList_574664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of subscriptions.
  ## 
  let valid = call_574861.validator(path, query, header, formData, body)
  let scheme = call_574861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574861.url(scheme.get, call_574861.host, call_574861.base,
                         call_574861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574861, url, valid)

proc call*(call_574932: Call_SubscriptionsList_574664;
          apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsList
  ## Get the list of subscriptions.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574933 = newJObject()
  add(query_574933, "api-version", newJString(apiVersion))
  result = call_574932.call(nil, query_574933, nil, nil, nil)

var subscriptionsList* = Call_SubscriptionsList_574664(name: "subscriptionsList",
    meth: HttpMethod.HttpGet, host: "management.local.azurestack.external",
    route: "/subscriptions", validator: validate_SubscriptionsList_574665, base: "",
    url: url_SubscriptionsList_574666, schemes: {Scheme.Https})
type
  Call_SubscriptionsCreateOrUpdate_574996 = ref object of OpenApiRestCall_574442
proc url_SubscriptionsCreateOrUpdate_574998(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsCreateOrUpdate_574997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or updates a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Id of the subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574999 = path.getOrDefault("subscriptionId")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = nil)
  if valid_574999 != nil:
    section.add "subscriptionId", valid_574999
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
  ## parameters in `body` object:
  ##   newSubscription: JObject (required)
  ##                  : Subscription parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575002: Call_SubscriptionsCreateOrUpdate_574996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or updates a subscription.
  ## 
  let valid = call_575002.validator(path, query, header, formData, body)
  let scheme = call_575002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575002.url(scheme.get, call_575002.host, call_575002.base,
                         call_575002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575002, url, valid)

proc call*(call_575003: Call_SubscriptionsCreateOrUpdate_574996;
          subscriptionId: string; newSubscription: JsonNode;
          apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsCreateOrUpdate
  ## Create or updates a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Id of the subscription.
  ##   newSubscription: JObject (required)
  ##                  : Subscription parameter.
  var path_575004 = newJObject()
  var query_575005 = newJObject()
  var body_575006 = newJObject()
  add(query_575005, "api-version", newJString(apiVersion))
  add(path_575004, "subscriptionId", newJString(subscriptionId))
  if newSubscription != nil:
    body_575006 = newSubscription
  result = call_575003.call(path_575004, query_575005, nil, nil, body_575006)

var subscriptionsCreateOrUpdate* = Call_SubscriptionsCreateOrUpdate_574996(
    name: "subscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.local.azurestack.external",
    route: "/subscriptions/{subscriptionId}",
    validator: validate_SubscriptionsCreateOrUpdate_574997, base: "",
    url: url_SubscriptionsCreateOrUpdate_574998, schemes: {Scheme.Https})
type
  Call_SubscriptionsGet_574973 = ref object of OpenApiRestCall_574442
proc url_SubscriptionsGet_574975(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsGet_574974(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets details about particular subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Id of the subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574990 = path.getOrDefault("subscriptionId")
  valid_574990 = validateParameter(valid_574990, JString, required = true,
                                 default = nil)
  if valid_574990 != nil:
    section.add "subscriptionId", valid_574990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574991 = query.getOrDefault("api-version")
  valid_574991 = validateParameter(valid_574991, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574991 != nil:
    section.add "api-version", valid_574991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574992: Call_SubscriptionsGet_574973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about particular subscription.
  ## 
  let valid = call_574992.validator(path, query, header, formData, body)
  let scheme = call_574992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574992.url(scheme.get, call_574992.host, call_574992.base,
                         call_574992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574992, url, valid)

proc call*(call_574993: Call_SubscriptionsGet_574973; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsGet
  ## Gets details about particular subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Id of the subscription.
  var path_574994 = newJObject()
  var query_574995 = newJObject()
  add(query_574995, "api-version", newJString(apiVersion))
  add(path_574994, "subscriptionId", newJString(subscriptionId))
  result = call_574993.call(path_574994, query_574995, nil, nil, nil)

var subscriptionsGet* = Call_SubscriptionsGet_574973(name: "subscriptionsGet",
    meth: HttpMethod.HttpGet, host: "management.local.azurestack.external",
    route: "/subscriptions/{subscriptionId}",
    validator: validate_SubscriptionsGet_574974, base: "",
    url: url_SubscriptionsGet_574975, schemes: {Scheme.Https})
type
  Call_SubscriptionsDelete_575007 = ref object of OpenApiRestCall_574442
proc url_SubscriptionsDelete_575009(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsDelete_575008(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Id of the subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575010 = path.getOrDefault("subscriptionId")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "subscriptionId", valid_575010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575011 = query.getOrDefault("api-version")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575011 != nil:
    section.add "api-version", valid_575011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575012: Call_SubscriptionsDelete_575007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified subscription.
  ## 
  let valid = call_575012.validator(path, query, header, formData, body)
  let scheme = call_575012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575012.url(scheme.get, call_575012.host, call_575012.base,
                         call_575012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575012, url, valid)

proc call*(call_575013: Call_SubscriptionsDelete_575007; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsDelete
  ## Delete the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Id of the subscription.
  var path_575014 = newJObject()
  var query_575015 = newJObject()
  add(query_575015, "api-version", newJString(apiVersion))
  add(path_575014, "subscriptionId", newJString(subscriptionId))
  result = call_575013.call(path_575014, query_575015, nil, nil, nil)

var subscriptionsDelete* = Call_SubscriptionsDelete_575007(
    name: "subscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.local.azurestack.external",
    route: "/subscriptions/{subscriptionId}",
    validator: validate_SubscriptionsDelete_575008, base: "",
    url: url_SubscriptionsDelete_575009, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
