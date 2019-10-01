
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

  OpenApiRestCall_582441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-AcquiredPlan"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AcquiredPlansList_582663 = ref object of OpenApiRestCall_582441
proc url_AcquiredPlansList_582665(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "targetSubscriptionId" in path,
        "`targetSubscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/subscriptions/"),
               (kind: VariableSegment, value: "targetSubscriptionId"),
               (kind: ConstantSegment, value: "/acquiredPlans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AcquiredPlansList_582664(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a collection of all acquired plans that subscription has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   targetSubscriptionId: JString (required)
  ##                       : The target subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_582838 = path.getOrDefault("subscriptionId")
  valid_582838 = validateParameter(valid_582838, JString, required = true,
                                 default = nil)
  if valid_582838 != nil:
    section.add "subscriptionId", valid_582838
  var valid_582839 = path.getOrDefault("targetSubscriptionId")
  valid_582839 = validateParameter(valid_582839, JString, required = true,
                                 default = nil)
  if valid_582839 != nil:
    section.add "targetSubscriptionId", valid_582839
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582853 = query.getOrDefault("api-version")
  valid_582853 = validateParameter(valid_582853, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_582853 != nil:
    section.add "api-version", valid_582853
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582876: Call_AcquiredPlansList_582663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a collection of all acquired plans that subscription has access to.
  ## 
  let valid = call_582876.validator(path, query, header, formData, body)
  let scheme = call_582876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582876.url(scheme.get, call_582876.host, call_582876.base,
                         call_582876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582876, url, valid)

proc call*(call_582947: Call_AcquiredPlansList_582663; subscriptionId: string;
          targetSubscriptionId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## acquiredPlansList
  ## Get a collection of all acquired plans that subscription has access to.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   targetSubscriptionId: string (required)
  ##                       : The target subscription ID.
  var path_582948 = newJObject()
  var query_582950 = newJObject()
  add(query_582950, "api-version", newJString(apiVersion))
  add(path_582948, "subscriptionId", newJString(subscriptionId))
  add(path_582948, "targetSubscriptionId", newJString(targetSubscriptionId))
  result = call_582947.call(path_582948, query_582950, nil, nil, nil)

var acquiredPlansList* = Call_AcquiredPlansList_582663(name: "acquiredPlansList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/subscriptions/{targetSubscriptionId}/acquiredPlans",
    validator: validate_AcquiredPlansList_582664, base: "",
    url: url_AcquiredPlansList_582665, schemes: {Scheme.Https})
type
  Call_AcquiredPlansCreate_583000 = ref object of OpenApiRestCall_582441
proc url_AcquiredPlansCreate_583002(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "targetSubscriptionId" in path,
        "`targetSubscriptionId` is a required path parameter"
  assert "planAcquisitionId" in path,
        "`planAcquisitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/subscriptions/"),
               (kind: VariableSegment, value: "targetSubscriptionId"),
               (kind: ConstantSegment, value: "/acquiredPlans/"),
               (kind: VariableSegment, value: "planAcquisitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AcquiredPlansCreate_583001(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates an acquired plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   planAcquisitionId: JString (required)
  ##                    : The plan acquisition Identifier
  ##   targetSubscriptionId: JString (required)
  ##                       : The target subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_583003 = path.getOrDefault("subscriptionId")
  valid_583003 = validateParameter(valid_583003, JString, required = true,
                                 default = nil)
  if valid_583003 != nil:
    section.add "subscriptionId", valid_583003
  var valid_583004 = path.getOrDefault("planAcquisitionId")
  valid_583004 = validateParameter(valid_583004, JString, required = true,
                                 default = nil)
  if valid_583004 != nil:
    section.add "planAcquisitionId", valid_583004
  var valid_583005 = path.getOrDefault("targetSubscriptionId")
  valid_583005 = validateParameter(valid_583005, JString, required = true,
                                 default = nil)
  if valid_583005 != nil:
    section.add "targetSubscriptionId", valid_583005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583006 = query.getOrDefault("api-version")
  valid_583006 = validateParameter(valid_583006, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_583006 != nil:
    section.add "api-version", valid_583006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   newAcquiredPlan: JObject (required)
  ##                  : The new acquired plan.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_583008: Call_AcquiredPlansCreate_583000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an acquired plan.
  ## 
  let valid = call_583008.validator(path, query, header, formData, body)
  let scheme = call_583008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583008.url(scheme.get, call_583008.host, call_583008.base,
                         call_583008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583008, url, valid)

proc call*(call_583009: Call_AcquiredPlansCreate_583000; subscriptionId: string;
          planAcquisitionId: string; newAcquiredPlan: JsonNode;
          targetSubscriptionId: string; apiVersion: string = "2015-11-01"): Recallable =
  ## acquiredPlansCreate
  ## Creates an acquired plan.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   planAcquisitionId: string (required)
  ##                    : The plan acquisition Identifier
  ##   newAcquiredPlan: JObject (required)
  ##                  : The new acquired plan.
  ##   targetSubscriptionId: string (required)
  ##                       : The target subscription ID.
  var path_583010 = newJObject()
  var query_583011 = newJObject()
  var body_583012 = newJObject()
  add(query_583011, "api-version", newJString(apiVersion))
  add(path_583010, "subscriptionId", newJString(subscriptionId))
  add(path_583010, "planAcquisitionId", newJString(planAcquisitionId))
  if newAcquiredPlan != nil:
    body_583012 = newAcquiredPlan
  add(path_583010, "targetSubscriptionId", newJString(targetSubscriptionId))
  result = call_583009.call(path_583010, query_583011, nil, nil, body_583012)

var acquiredPlansCreate* = Call_AcquiredPlansCreate_583000(
    name: "acquiredPlansCreate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/subscriptions/{targetSubscriptionId}/acquiredPlans/{planAcquisitionId}",
    validator: validate_AcquiredPlansCreate_583001, base: "",
    url: url_AcquiredPlansCreate_583002, schemes: {Scheme.Https})
type
  Call_AcquiredPlansGet_582989 = ref object of OpenApiRestCall_582441
proc url_AcquiredPlansGet_582991(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "targetSubscriptionId" in path,
        "`targetSubscriptionId` is a required path parameter"
  assert "planAcquisitionId" in path,
        "`planAcquisitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/subscriptions/"),
               (kind: VariableSegment, value: "targetSubscriptionId"),
               (kind: ConstantSegment, value: "/acquiredPlans/"),
               (kind: VariableSegment, value: "planAcquisitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AcquiredPlansGet_582990(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the specified plan acquired by a subscription consuming the offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   planAcquisitionId: JString (required)
  ##                    : The plan acquisition Identifier
  ##   targetSubscriptionId: JString (required)
  ##                       : The target subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_582992 = path.getOrDefault("subscriptionId")
  valid_582992 = validateParameter(valid_582992, JString, required = true,
                                 default = nil)
  if valid_582992 != nil:
    section.add "subscriptionId", valid_582992
  var valid_582993 = path.getOrDefault("planAcquisitionId")
  valid_582993 = validateParameter(valid_582993, JString, required = true,
                                 default = nil)
  if valid_582993 != nil:
    section.add "planAcquisitionId", valid_582993
  var valid_582994 = path.getOrDefault("targetSubscriptionId")
  valid_582994 = validateParameter(valid_582994, JString, required = true,
                                 default = nil)
  if valid_582994 != nil:
    section.add "targetSubscriptionId", valid_582994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582995 = query.getOrDefault("api-version")
  valid_582995 = validateParameter(valid_582995, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_582995 != nil:
    section.add "api-version", valid_582995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582996: Call_AcquiredPlansGet_582989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified plan acquired by a subscription consuming the offer.
  ## 
  let valid = call_582996.validator(path, query, header, formData, body)
  let scheme = call_582996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582996.url(scheme.get, call_582996.host, call_582996.base,
                         call_582996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582996, url, valid)

proc call*(call_582997: Call_AcquiredPlansGet_582989; subscriptionId: string;
          planAcquisitionId: string; targetSubscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## acquiredPlansGet
  ## Gets the specified plan acquired by a subscription consuming the offer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   planAcquisitionId: string (required)
  ##                    : The plan acquisition Identifier
  ##   targetSubscriptionId: string (required)
  ##                       : The target subscription ID.
  var path_582998 = newJObject()
  var query_582999 = newJObject()
  add(query_582999, "api-version", newJString(apiVersion))
  add(path_582998, "subscriptionId", newJString(subscriptionId))
  add(path_582998, "planAcquisitionId", newJString(planAcquisitionId))
  add(path_582998, "targetSubscriptionId", newJString(targetSubscriptionId))
  result = call_582997.call(path_582998, query_582999, nil, nil, nil)

var acquiredPlansGet* = Call_AcquiredPlansGet_582989(name: "acquiredPlansGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/subscriptions/{targetSubscriptionId}/acquiredPlans/{planAcquisitionId}",
    validator: validate_AcquiredPlansGet_582990, base: "",
    url: url_AcquiredPlansGet_582991, schemes: {Scheme.Https})
type
  Call_AcquiredPlansDelete_583013 = ref object of OpenApiRestCall_582441
proc url_AcquiredPlansDelete_583015(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "targetSubscriptionId" in path,
        "`targetSubscriptionId` is a required path parameter"
  assert "planAcquisitionId" in path,
        "`planAcquisitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/subscriptions/"),
               (kind: VariableSegment, value: "targetSubscriptionId"),
               (kind: ConstantSegment, value: "/acquiredPlans/"),
               (kind: VariableSegment, value: "planAcquisitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AcquiredPlansDelete_583014(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes an acquired plan.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   planAcquisitionId: JString (required)
  ##                    : The plan acquisition Identifier
  ##   targetSubscriptionId: JString (required)
  ##                       : The target subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_583016 = path.getOrDefault("subscriptionId")
  valid_583016 = validateParameter(valid_583016, JString, required = true,
                                 default = nil)
  if valid_583016 != nil:
    section.add "subscriptionId", valid_583016
  var valid_583017 = path.getOrDefault("planAcquisitionId")
  valid_583017 = validateParameter(valid_583017, JString, required = true,
                                 default = nil)
  if valid_583017 != nil:
    section.add "planAcquisitionId", valid_583017
  var valid_583018 = path.getOrDefault("targetSubscriptionId")
  valid_583018 = validateParameter(valid_583018, JString, required = true,
                                 default = nil)
  if valid_583018 != nil:
    section.add "targetSubscriptionId", valid_583018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_583019 = query.getOrDefault("api-version")
  valid_583019 = validateParameter(valid_583019, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_583019 != nil:
    section.add "api-version", valid_583019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583020: Call_AcquiredPlansDelete_583013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an acquired plan.
  ## 
  let valid = call_583020.validator(path, query, header, formData, body)
  let scheme = call_583020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583020.url(scheme.get, call_583020.host, call_583020.base,
                         call_583020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583020, url, valid)

proc call*(call_583021: Call_AcquiredPlansDelete_583013; subscriptionId: string;
          planAcquisitionId: string; targetSubscriptionId: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## acquiredPlansDelete
  ## Deletes an acquired plan.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   planAcquisitionId: string (required)
  ##                    : The plan acquisition Identifier
  ##   targetSubscriptionId: string (required)
  ##                       : The target subscription ID.
  var path_583022 = newJObject()
  var query_583023 = newJObject()
  add(query_583023, "api-version", newJString(apiVersion))
  add(path_583022, "subscriptionId", newJString(subscriptionId))
  add(path_583022, "planAcquisitionId", newJString(planAcquisitionId))
  add(path_583022, "targetSubscriptionId", newJString(targetSubscriptionId))
  result = call_583021.call(path_583022, query_583023, nil, nil, nil)

var acquiredPlansDelete* = Call_AcquiredPlansDelete_583013(
    name: "acquiredPlansDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscriptions.Admin/subscriptions/{targetSubscriptionId}/acquiredPlans/{planAcquisitionId}",
    validator: validate_AcquiredPlansDelete_583014, base: "",
    url: url_AcquiredPlansDelete_583015, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
