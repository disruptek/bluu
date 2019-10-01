
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
  macServiceName = "azsadmin-OfferDelegation"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OfferDelegationsList_574663 = ref object of OpenApiRestCall_574441
proc url_OfferDelegationsList_574665(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/offerDelegations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfferDelegationsList_574664(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of offer delegations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574825 = path.getOrDefault("resourceGroupName")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "resourceGroupName", valid_574825
  var valid_574826 = path.getOrDefault("subscriptionId")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "subscriptionId", valid_574826
  var valid_574827 = path.getOrDefault("offer")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "offer", valid_574827
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574841 = query.getOrDefault("api-version")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574841 != nil:
    section.add "api-version", valid_574841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574868: Call_OfferDelegationsList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of offer delegations.
  ## 
  let valid = call_574868.validator(path, query, header, formData, body)
  let scheme = call_574868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574868.url(scheme.get, call_574868.host, call_574868.base,
                         call_574868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574868, url, valid)

proc call*(call_574939: Call_OfferDelegationsList_574663;
          resourceGroupName: string; subscriptionId: string; offer: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## offerDelegationsList
  ## Get the list of offer delegations.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offer: string (required)
  ##        : Name of an offer.
  var path_574940 = newJObject()
  var query_574942 = newJObject()
  add(path_574940, "resourceGroupName", newJString(resourceGroupName))
  add(query_574942, "api-version", newJString(apiVersion))
  add(path_574940, "subscriptionId", newJString(subscriptionId))
  add(path_574940, "offer", newJString(offer))
  result = call_574939.call(path_574940, query_574942, nil, nil, nil)

var offerDelegationsList* = Call_OfferDelegationsList_574663(
    name: "offerDelegationsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}/offerDelegations",
    validator: validate_OfferDelegationsList_574664, base: "",
    url: url_OfferDelegationsList_574665, schemes: {Scheme.Https})
type
  Call_OfferDelegationsCreateOrUpdate_575002 = ref object of OpenApiRestCall_574441
proc url_OfferDelegationsCreateOrUpdate_575004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "offerDelegationName" in path,
        "`offerDelegationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/offerDelegations/"),
               (kind: VariableSegment, value: "offerDelegationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfferDelegationsCreateOrUpdate_575003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update the offer delegation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offerDelegationName: JString (required)
  ##                      : Name of a offer delegation.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575005 = path.getOrDefault("resourceGroupName")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "resourceGroupName", valid_575005
  var valid_575006 = path.getOrDefault("subscriptionId")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "subscriptionId", valid_575006
  var valid_575007 = path.getOrDefault("offerDelegationName")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "offerDelegationName", valid_575007
  var valid_575008 = path.getOrDefault("offer")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "offer", valid_575008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575009 = query.getOrDefault("api-version")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575009 != nil:
    section.add "api-version", valid_575009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   newOfferDelegation: JObject (required)
  ##                     : New offer delegation parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575011: Call_OfferDelegationsCreateOrUpdate_575002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update the offer delegation.
  ## 
  let valid = call_575011.validator(path, query, header, formData, body)
  let scheme = call_575011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575011.url(scheme.get, call_575011.host, call_575011.base,
                         call_575011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575011, url, valid)

proc call*(call_575012: Call_OfferDelegationsCreateOrUpdate_575002;
          resourceGroupName: string; newOfferDelegation: JsonNode;
          subscriptionId: string; offerDelegationName: string; offer: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## offerDelegationsCreateOrUpdate
  ## Create or update the offer delegation.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   newOfferDelegation: JObject (required)
  ##                     : New offer delegation parameter.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offerDelegationName: string (required)
  ##                      : Name of a offer delegation.
  ##   offer: string (required)
  ##        : Name of an offer.
  var path_575013 = newJObject()
  var query_575014 = newJObject()
  var body_575015 = newJObject()
  add(path_575013, "resourceGroupName", newJString(resourceGroupName))
  add(query_575014, "api-version", newJString(apiVersion))
  if newOfferDelegation != nil:
    body_575015 = newOfferDelegation
  add(path_575013, "subscriptionId", newJString(subscriptionId))
  add(path_575013, "offerDelegationName", newJString(offerDelegationName))
  add(path_575013, "offer", newJString(offer))
  result = call_575012.call(path_575013, query_575014, nil, nil, body_575015)

var offerDelegationsCreateOrUpdate* = Call_OfferDelegationsCreateOrUpdate_575002(
    name: "offerDelegationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}/offerDelegations/{offerDelegationName}",
    validator: validate_OfferDelegationsCreateOrUpdate_575003, base: "",
    url: url_OfferDelegationsCreateOrUpdate_575004, schemes: {Scheme.Https})
type
  Call_OfferDelegationsGet_574981 = ref object of OpenApiRestCall_574441
proc url_OfferDelegationsGet_574983(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "offerDelegationName" in path,
        "`offerDelegationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/offerDelegations/"),
               (kind: VariableSegment, value: "offerDelegationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfferDelegationsGet_574982(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the specified offer delegation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offerDelegationName: JString (required)
  ##                      : Name of a offer delegation.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574993 = path.getOrDefault("resourceGroupName")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "resourceGroupName", valid_574993
  var valid_574994 = path.getOrDefault("subscriptionId")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "subscriptionId", valid_574994
  var valid_574995 = path.getOrDefault("offerDelegationName")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "offerDelegationName", valid_574995
  var valid_574996 = path.getOrDefault("offer")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "offer", valid_574996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574997 = query.getOrDefault("api-version")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_574997 != nil:
    section.add "api-version", valid_574997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574998: Call_OfferDelegationsGet_574981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified offer delegation.
  ## 
  let valid = call_574998.validator(path, query, header, formData, body)
  let scheme = call_574998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574998.url(scheme.get, call_574998.host, call_574998.base,
                         call_574998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574998, url, valid)

proc call*(call_574999: Call_OfferDelegationsGet_574981; resourceGroupName: string;
          subscriptionId: string; offerDelegationName: string; offer: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## offerDelegationsGet
  ## Get the specified offer delegation.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offerDelegationName: string (required)
  ##                      : Name of a offer delegation.
  ##   offer: string (required)
  ##        : Name of an offer.
  var path_575000 = newJObject()
  var query_575001 = newJObject()
  add(path_575000, "resourceGroupName", newJString(resourceGroupName))
  add(query_575001, "api-version", newJString(apiVersion))
  add(path_575000, "subscriptionId", newJString(subscriptionId))
  add(path_575000, "offerDelegationName", newJString(offerDelegationName))
  add(path_575000, "offer", newJString(offer))
  result = call_574999.call(path_575000, query_575001, nil, nil, nil)

var offerDelegationsGet* = Call_OfferDelegationsGet_574981(
    name: "offerDelegationsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}/offerDelegations/{offerDelegationName}",
    validator: validate_OfferDelegationsGet_574982, base: "",
    url: url_OfferDelegationsGet_574983, schemes: {Scheme.Https})
type
  Call_OfferDelegationsDelete_575016 = ref object of OpenApiRestCall_574441
proc url_OfferDelegationsDelete_575018(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "offerDelegationName" in path,
        "`offerDelegationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscriptions.Admin/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/offerDelegations/"),
               (kind: VariableSegment, value: "offerDelegationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfferDelegationsDelete_575017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified offer delegation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group the resource is located under.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offerDelegationName: JString (required)
  ##                      : Name of a offer delegation.
  ##   offer: JString (required)
  ##        : Name of an offer.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575019 = path.getOrDefault("resourceGroupName")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "resourceGroupName", valid_575019
  var valid_575020 = path.getOrDefault("subscriptionId")
  valid_575020 = validateParameter(valid_575020, JString, required = true,
                                 default = nil)
  if valid_575020 != nil:
    section.add "subscriptionId", valid_575020
  var valid_575021 = path.getOrDefault("offerDelegationName")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "offerDelegationName", valid_575021
  var valid_575022 = path.getOrDefault("offer")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "offer", valid_575022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575023 = query.getOrDefault("api-version")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = newJString("2015-11-01"))
  if valid_575023 != nil:
    section.add "api-version", valid_575023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575024: Call_OfferDelegationsDelete_575016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified offer delegation.
  ## 
  let valid = call_575024.validator(path, query, header, formData, body)
  let scheme = call_575024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575024.url(scheme.get, call_575024.host, call_575024.base,
                         call_575024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575024, url, valid)

proc call*(call_575025: Call_OfferDelegationsDelete_575016;
          resourceGroupName: string; subscriptionId: string;
          offerDelegationName: string; offer: string;
          apiVersion: string = "2015-11-01"): Recallable =
  ## offerDelegationsDelete
  ## Delete the specified offer delegation.
  ##   resourceGroupName: string (required)
  ##                    : The resource group the resource is located under.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   offerDelegationName: string (required)
  ##                      : Name of a offer delegation.
  ##   offer: string (required)
  ##        : Name of an offer.
  var path_575026 = newJObject()
  var query_575027 = newJObject()
  add(path_575026, "resourceGroupName", newJString(resourceGroupName))
  add(query_575027, "api-version", newJString(apiVersion))
  add(path_575026, "subscriptionId", newJString(subscriptionId))
  add(path_575026, "offerDelegationName", newJString(offerDelegationName))
  add(path_575026, "offer", newJString(offer))
  result = call_575025.call(path_575026, query_575027, nil, nil, nil)

var offerDelegationsDelete* = Call_OfferDelegationsDelete_575016(
    name: "offerDelegationsDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Subscriptions.Admin/offers/{offer}/offerDelegations/{offerDelegationName}",
    validator: validate_OfferDelegationsDelete_575017, base: "",
    url: url_OfferDelegationsDelete_575018, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
