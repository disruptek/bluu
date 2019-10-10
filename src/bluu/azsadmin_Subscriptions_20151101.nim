
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_573642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573642): Option[Scheme] {.used.} =
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
  Call_OperationsList_573864 = ref object of OpenApiRestCall_573642
proc url_OperationsList_573866(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573865(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the list of Operations.
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
  var valid_574038 = query.getOrDefault("api-version")
  valid_574038 = validateParameter(valid_574038, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574038 != nil:
    section.add "api-version", valid_574038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574061: Call_OperationsList_573864; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of Operations.
  ## 
  let valid = call_574061.validator(path, query, header, formData, body)
  let scheme = call_574061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574061.url(scheme.get, call_574061.host, call_574061.base,
                         call_574061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574061, url, valid)

proc call*(call_574132: Call_OperationsList_573864;
          apiVersion: string = "2015-11-01"): Recallable =
  ## operationsList
  ## Get the list of Operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574133 = newJObject()
  add(query_574133, "api-version", newJString(apiVersion))
  result = call_574132.call(nil, query_574133, nil, nil, nil)

var operationsList* = Call_OperationsList_573864(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external",
    route: "/providers/Microsoft.Subscriptions.Admin/operations",
    validator: validate_OperationsList_573865, base: "", url: url_OperationsList_573866,
    schemes: {Scheme.Https})
type
  Call_CheckIdentityHealth_574173 = ref object of OpenApiRestCall_573642
proc url_CheckIdentityHealth_574175(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Subscriptions.Admin/checkIdentityHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckIdentityHealth_574174(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Checks the identity health
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574190 = path.getOrDefault("subscriptionId")
  valid_574190 = validateParameter(valid_574190, JString, required = true,
                                 default = nil)
  if valid_574190 != nil:
    section.add "subscriptionId", valid_574190
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574191 = query.getOrDefault("api-version")
  valid_574191 = validateParameter(valid_574191, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574191 != nil:
    section.add "api-version", valid_574191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574192: Call_CheckIdentityHealth_574173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the identity health
  ## 
  let valid = call_574192.validator(path, query, header, formData, body)
  let scheme = call_574192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574192.url(scheme.get, call_574192.host, call_574192.base,
                         call_574192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574192, url, valid)

proc call*(call_574193: Call_CheckIdentityHealth_574173; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## checkIdentityHealth
  ## Checks the identity health
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574194 = newJObject()
  var query_574195 = newJObject()
  add(query_574195, "api-version", newJString(apiVersion))
  add(path_574194, "subscriptionId", newJString(subscriptionId))
  result = call_574193.call(path_574194, query_574195, nil, nil, nil)

var checkIdentityHealth* = Call_CheckIdentityHealth_574173(
    name: "checkIdentityHealth", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/checkIdentityHealth",
    validator: validate_CheckIdentityHealth_574174, base: "",
    url: url_CheckIdentityHealth_574175, schemes: {Scheme.Https})
type
  Call_SubscriptionsCheckNameAvailability_574196 = ref object of OpenApiRestCall_573642
proc url_SubscriptionsCheckNameAvailability_574198(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsCheckNameAvailability_574197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of subscriptions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574199 = path.getOrDefault("subscriptionId")
  valid_574199 = validateParameter(valid_574199, JString, required = true,
                                 default = nil)
  if valid_574199 != nil:
    section.add "subscriptionId", valid_574199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574200 = query.getOrDefault("api-version")
  valid_574200 = validateParameter(valid_574200, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574200 != nil:
    section.add "api-version", valid_574200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nameAvailabilityDefinition: JObject (required)
  ##                             : Check name availability parameter
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574202: Call_SubscriptionsCheckNameAvailability_574196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of subscriptions.
  ## 
  let valid = call_574202.validator(path, query, header, formData, body)
  let scheme = call_574202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574202.url(scheme.get, call_574202.host, call_574202.base,
                         call_574202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574202, url, valid)

proc call*(call_574203: Call_SubscriptionsCheckNameAvailability_574196;
          subscriptionId: string; nameAvailabilityDefinition: JsonNode;
          apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsCheckNameAvailability
  ## Get the list of subscriptions.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   nameAvailabilityDefinition: JObject (required)
  ##                             : Check name availability parameter
  var path_574204 = newJObject()
  var query_574205 = newJObject()
  var body_574206 = newJObject()
  add(query_574205, "api-version", newJString(apiVersion))
  add(path_574204, "subscriptionId", newJString(subscriptionId))
  if nameAvailabilityDefinition != nil:
    body_574206 = nameAvailabilityDefinition
  result = call_574203.call(path_574204, query_574205, nil, nil, body_574206)

var subscriptionsCheckNameAvailability* = Call_SubscriptionsCheckNameAvailability_574196(
    name: "subscriptionsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/checkNameAvailability",
    validator: validate_SubscriptionsCheckNameAvailability_574197, base: "",
    url: url_SubscriptionsCheckNameAvailability_574198, schemes: {Scheme.Https})
type
  Call_SubscriptionsMoveSubscriptions_574207 = ref object of OpenApiRestCall_573642
proc url_SubscriptionsMoveSubscriptions_574209(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/moveSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsMoveSubscriptions_574208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Move subscriptions between delegated provider offers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574210 = path.getOrDefault("subscriptionId")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "subscriptionId", valid_574210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574211 = query.getOrDefault("api-version")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574211 != nil:
    section.add "api-version", valid_574211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   moveSubscriptionsDefinition: JObject (required)
  ##                              : Move subscriptions parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574213: Call_SubscriptionsMoveSubscriptions_574207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Move subscriptions between delegated provider offers.
  ## 
  let valid = call_574213.validator(path, query, header, formData, body)
  let scheme = call_574213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574213.url(scheme.get, call_574213.host, call_574213.base,
                         call_574213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574213, url, valid)

proc call*(call_574214: Call_SubscriptionsMoveSubscriptions_574207;
          moveSubscriptionsDefinition: JsonNode; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsMoveSubscriptions
  ## Move subscriptions between delegated provider offers.
  ##   moveSubscriptionsDefinition: JObject (required)
  ##                              : Move subscriptions parameter.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574215 = newJObject()
  var query_574216 = newJObject()
  var body_574217 = newJObject()
  if moveSubscriptionsDefinition != nil:
    body_574217 = moveSubscriptionsDefinition
  add(query_574216, "api-version", newJString(apiVersion))
  add(path_574215, "subscriptionId", newJString(subscriptionId))
  result = call_574214.call(path_574215, query_574216, nil, nil, body_574217)

var subscriptionsMoveSubscriptions* = Call_SubscriptionsMoveSubscriptions_574207(
    name: "subscriptionsMoveSubscriptions", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/moveSubscriptions",
    validator: validate_SubscriptionsMoveSubscriptions_574208, base: "",
    url: url_SubscriptionsMoveSubscriptions_574209, schemes: {Scheme.Https})
type
  Call_RestoreData_574218 = ref object of OpenApiRestCall_573642
proc url_RestoreData_574220(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Subscriptions.Admin/restoreData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RestoreData_574219(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores the data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574221 = path.getOrDefault("subscriptionId")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "subscriptionId", valid_574221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574222 = query.getOrDefault("api-version")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574222 != nil:
    section.add "api-version", valid_574222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574223: Call_RestoreData_574218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the data
  ## 
  let valid = call_574223.validator(path, query, header, formData, body)
  let scheme = call_574223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574223.url(scheme.get, call_574223.host, call_574223.base,
                         call_574223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574223, url, valid)

proc call*(call_574224: Call_RestoreData_574218; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## restoreData
  ## Restores the data
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574225 = newJObject()
  var query_574226 = newJObject()
  add(query_574226, "api-version", newJString(apiVersion))
  add(path_574225, "subscriptionId", newJString(subscriptionId))
  result = call_574224.call(path_574225, query_574226, nil, nil, nil)

var restoreData* = Call_RestoreData_574218(name: "restoreData",
                                        meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/restoreData",
                                        validator: validate_RestoreData_574219,
                                        base: "", url: url_RestoreData_574220,
                                        schemes: {Scheme.Https})
type
  Call_SubscriptionsList_574227 = ref object of OpenApiRestCall_573642
proc url_SubscriptionsList_574229(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Subscriptions.Admin/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsList_574228(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the list of subscriptions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574231 = path.getOrDefault("subscriptionId")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "subscriptionId", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  var valid_574233 = query.getOrDefault("$filter")
  valid_574233 = validateParameter(valid_574233, JString, required = false,
                                 default = nil)
  if valid_574233 != nil:
    section.add "$filter", valid_574233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574234: Call_SubscriptionsList_574227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of subscriptions.
  ## 
  let valid = call_574234.validator(path, query, header, formData, body)
  let scheme = call_574234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574234.url(scheme.get, call_574234.host, call_574234.base,
                         call_574234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574234, url, valid)

proc call*(call_574235: Call_SubscriptionsList_574227; subscriptionId: string;
          apiVersion: string = "2015-11-01"; Filter: string = ""): Recallable =
  ## subscriptionsList
  ## Get the list of subscriptions.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574236 = newJObject()
  var query_574237 = newJObject()
  add(query_574237, "api-version", newJString(apiVersion))
  add(path_574236, "subscriptionId", newJString(subscriptionId))
  add(query_574237, "$filter", newJString(Filter))
  result = call_574235.call(path_574236, query_574237, nil, nil, nil)

var subscriptionsList* = Call_SubscriptionsList_574227(name: "subscriptionsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/subscriptions",
    validator: validate_SubscriptionsList_574228, base: "",
    url: url_SubscriptionsList_574229, schemes: {Scheme.Https})
type
  Call_SubscriptionsCreateOrUpdate_574248 = ref object of OpenApiRestCall_573642
proc url_SubscriptionsCreateOrUpdate_574250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/subscriptions/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsCreateOrUpdate_574249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : Subscription parameter.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_574251 = path.getOrDefault("subscription")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "subscription", valid_574251
  var valid_574252 = path.getOrDefault("subscriptionId")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "subscriptionId", valid_574252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574253 = query.getOrDefault("api-version")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574253 != nil:
    section.add "api-version", valid_574253
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

proc call*(call_574255: Call_SubscriptionsCreateOrUpdate_574248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the specified subscription.
  ## 
  let valid = call_574255.validator(path, query, header, formData, body)
  let scheme = call_574255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574255.url(scheme.get, call_574255.host, call_574255.base,
                         call_574255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574255, url, valid)

proc call*(call_574256: Call_SubscriptionsCreateOrUpdate_574248;
          subscription: string; subscriptionId: string; newSubscription: JsonNode;
          apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsCreateOrUpdate
  ## Creates or updates the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscription: string (required)
  ##               : Subscription parameter.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   newSubscription: JObject (required)
  ##                  : Subscription parameter.
  var path_574257 = newJObject()
  var query_574258 = newJObject()
  var body_574259 = newJObject()
  add(query_574258, "api-version", newJString(apiVersion))
  add(path_574257, "subscription", newJString(subscription))
  add(path_574257, "subscriptionId", newJString(subscriptionId))
  if newSubscription != nil:
    body_574259 = newSubscription
  result = call_574256.call(path_574257, query_574258, nil, nil, body_574259)

var subscriptionsCreateOrUpdate* = Call_SubscriptionsCreateOrUpdate_574248(
    name: "subscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/subscriptions/{subscription}",
    validator: validate_SubscriptionsCreateOrUpdate_574249, base: "",
    url: url_SubscriptionsCreateOrUpdate_574250, schemes: {Scheme.Https})
type
  Call_SubscriptionsGet_574238 = ref object of OpenApiRestCall_573642
proc url_SubscriptionsGet_574240(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/subscriptions/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsGet_574239(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : Subscription parameter.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_574241 = path.getOrDefault("subscription")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "subscription", valid_574241
  var valid_574242 = path.getOrDefault("subscriptionId")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "subscriptionId", valid_574242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574243 = query.getOrDefault("api-version")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574243 != nil:
    section.add "api-version", valid_574243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574244: Call_SubscriptionsGet_574238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specified subscription.
  ## 
  let valid = call_574244.validator(path, query, header, formData, body)
  let scheme = call_574244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574244.url(scheme.get, call_574244.host, call_574244.base,
                         call_574244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574244, url, valid)

proc call*(call_574245: Call_SubscriptionsGet_574238; subscription: string;
          subscriptionId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsGet
  ## Get a specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscription: string (required)
  ##               : Subscription parameter.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574246 = newJObject()
  var query_574247 = newJObject()
  add(query_574247, "api-version", newJString(apiVersion))
  add(path_574246, "subscription", newJString(subscription))
  add(path_574246, "subscriptionId", newJString(subscriptionId))
  result = call_574245.call(path_574246, query_574247, nil, nil, nil)

var subscriptionsGet* = Call_SubscriptionsGet_574238(name: "subscriptionsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/subscriptions/{subscription}",
    validator: validate_SubscriptionsGet_574239, base: "",
    url: url_SubscriptionsGet_574240, schemes: {Scheme.Https})
type
  Call_SubscriptionsDelete_574260 = ref object of OpenApiRestCall_573642
proc url_SubscriptionsDelete_574262(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/subscriptions/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsDelete_574261(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : Subscription parameter.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_574263 = path.getOrDefault("subscription")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "subscription", valid_574263
  var valid_574264 = path.getOrDefault("subscriptionId")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "subscriptionId", valid_574264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574265 = query.getOrDefault("api-version")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574265 != nil:
    section.add "api-version", valid_574265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574266: Call_SubscriptionsDelete_574260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified subscription.
  ## 
  let valid = call_574266.validator(path, query, header, formData, body)
  let scheme = call_574266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574266.url(scheme.get, call_574266.host, call_574266.base,
                         call_574266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574266, url, valid)

proc call*(call_574267: Call_SubscriptionsDelete_574260; subscription: string;
          subscriptionId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsDelete
  ## Delete the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscription: string (required)
  ##               : Subscription parameter.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574268 = newJObject()
  var query_574269 = newJObject()
  add(query_574269, "api-version", newJString(apiVersion))
  add(path_574268, "subscription", newJString(subscription))
  add(path_574268, "subscriptionId", newJString(subscriptionId))
  result = call_574267.call(path_574268, query_574269, nil, nil, nil)

var subscriptionsDelete* = Call_SubscriptionsDelete_574260(
    name: "subscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/subscriptions/{subscription}",
    validator: validate_SubscriptionsDelete_574261, base: "",
    url: url_SubscriptionsDelete_574262, schemes: {Scheme.Https})
type
  Call_UpdateEncryption_574270 = ref object of OpenApiRestCall_573642
proc url_UpdateEncryption_574272(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Subscriptions.Admin/updateEncryption")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateEncryption_574271(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Update the encryption settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574273 = path.getOrDefault("subscriptionId")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "subscriptionId", valid_574273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574274 = query.getOrDefault("api-version")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574274 != nil:
    section.add "api-version", valid_574274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574275: Call_UpdateEncryption_574270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the encryption settings.
  ## 
  let valid = call_574275.validator(path, query, header, formData, body)
  let scheme = call_574275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574275.url(scheme.get, call_574275.host, call_574275.base,
                         call_574275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574275, url, valid)

proc call*(call_574276: Call_UpdateEncryption_574270; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## updateEncryption
  ## Update the encryption settings.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574277 = newJObject()
  var query_574278 = newJObject()
  add(query_574278, "api-version", newJString(apiVersion))
  add(path_574277, "subscriptionId", newJString(subscriptionId))
  result = call_574276.call(path_574277, query_574278, nil, nil, nil)

var updateEncryption* = Call_UpdateEncryption_574270(name: "updateEncryption",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/updateEncryption",
    validator: validate_UpdateEncryption_574271, base: "",
    url: url_UpdateEncryption_574272, schemes: {Scheme.Https})
type
  Call_SubscriptionsValidateMoveSubscriptions_574279 = ref object of OpenApiRestCall_573642
proc url_SubscriptionsValidateMoveSubscriptions_574281(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Subscriptions.Admin/validateMoveSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsValidateMoveSubscriptions_574280(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validate that user subscriptions can be moved between delegated provider offers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574282 = path.getOrDefault("subscriptionId")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "subscriptionId", valid_574282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574283 = query.getOrDefault("api-version")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574283 != nil:
    section.add "api-version", valid_574283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   moveSubscriptionsDefinition: JObject (required)
  ##                              : Move subscriptions parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574285: Call_SubscriptionsValidateMoveSubscriptions_574279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validate that user subscriptions can be moved between delegated provider offers.
  ## 
  let valid = call_574285.validator(path, query, header, formData, body)
  let scheme = call_574285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574285.url(scheme.get, call_574285.host, call_574285.base,
                         call_574285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574285, url, valid)

proc call*(call_574286: Call_SubscriptionsValidateMoveSubscriptions_574279;
          moveSubscriptionsDefinition: JsonNode; subscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## subscriptionsValidateMoveSubscriptions
  ## Validate that user subscriptions can be moved between delegated provider offers.
  ##   moveSubscriptionsDefinition: JObject (required)
  ##                              : Move subscriptions parameter.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_574287 = newJObject()
  var query_574288 = newJObject()
  var body_574289 = newJObject()
  if moveSubscriptionsDefinition != nil:
    body_574289 = moveSubscriptionsDefinition
  add(query_574288, "api-version", newJString(apiVersion))
  add(path_574287, "subscriptionId", newJString(subscriptionId))
  result = call_574286.call(path_574287, query_574288, nil, nil, body_574289)

var subscriptionsValidateMoveSubscriptions* = Call_SubscriptionsValidateMoveSubscriptions_574279(
    name: "subscriptionsValidateMoveSubscriptions", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/validateMoveSubscriptions",
    validator: validate_SubscriptionsValidateMoveSubscriptions_574280, base: "",
    url: url_SubscriptionsValidateMoveSubscriptions_574281,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
