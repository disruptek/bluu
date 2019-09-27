
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Addons Resource Provider
## version: 2018-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The service for managing third party addons.
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
  macServiceName = "addons-addons-swagger"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593646 = ref object of OpenApiRestCall_593424
proc url_OperationsList_593648(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593647(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Addons RP operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_OperationsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Addons RP operations.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_OperationsList_593646; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Addons RP operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Addons/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_SupportPlanTypesListInfo_593942 = ref object of OpenApiRestCall_593424
proc url_SupportPlanTypesListInfo_593944(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Addons/supportProviders/canonical/listSupportPlanInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportPlanTypesListInfo_593943(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the canonical support plan information for all types for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593959 = path.getOrDefault("subscriptionId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "subscriptionId", valid_593959
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593960 = query.getOrDefault("api-version")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "api-version", valid_593960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593961: Call_SupportPlanTypesListInfo_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the canonical support plan information for all types for the subscription.
  ## 
  let valid = call_593961.validator(path, query, header, formData, body)
  let scheme = call_593961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593961.url(scheme.get, call_593961.host, call_593961.base,
                         call_593961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593961, url, valid)

proc call*(call_593962: Call_SupportPlanTypesListInfo_593942; apiVersion: string;
          subscriptionId: string): Recallable =
  ## supportPlanTypesListInfo
  ## Returns the canonical support plan information for all types for the subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593963 = newJObject()
  var query_593964 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  add(path_593963, "subscriptionId", newJString(subscriptionId))
  result = call_593962.call(path_593963, query_593964, nil, nil, nil)

var supportPlanTypesListInfo* = Call_SupportPlanTypesListInfo_593942(
    name: "supportPlanTypesListInfo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/canonical/listSupportPlanInfo",
    validator: validate_SupportPlanTypesListInfo_593943, base: "",
    url: url_SupportPlanTypesListInfo_593944, schemes: {Scheme.Https})
type
  Call_SupportPlanTypesCreateOrUpdate_593989 = ref object of OpenApiRestCall_593424
proc url_SupportPlanTypesCreateOrUpdate_593991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "planTypeName" in path, "`planTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Addons/supportProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/supportPlanTypes/"),
               (kind: VariableSegment, value: "planTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportPlanTypesCreateOrUpdate_593990(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the Canonical support plan of type {type} for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planTypeName: JString (required)
  ##               : The Canonical support plan type.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `planTypeName` field"
  var valid_593992 = path.getOrDefault("planTypeName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = newJString("Essential"))
  if valid_593992 != nil:
    section.add "planTypeName", valid_593992
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  var valid_593994 = path.getOrDefault("providerName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "providerName", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_SupportPlanTypesCreateOrUpdate_593989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the Canonical support plan of type {type} for the subscription.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_SupportPlanTypesCreateOrUpdate_593989;
          apiVersion: string; subscriptionId: string; providerName: string;
          planTypeName: string = "Essential"): Recallable =
  ## supportPlanTypesCreateOrUpdate
  ## Creates or updates the Canonical support plan of type {type} for the subscription.
  ##   planTypeName: string (required)
  ##               : The Canonical support plan type.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(path_593998, "planTypeName", newJString(planTypeName))
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  add(path_593998, "providerName", newJString(providerName))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var supportPlanTypesCreateOrUpdate* = Call_SupportPlanTypesCreateOrUpdate_593989(
    name: "supportPlanTypesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes/{planTypeName}",
    validator: validate_SupportPlanTypesCreateOrUpdate_593990, base: "",
    url: url_SupportPlanTypesCreateOrUpdate_593991, schemes: {Scheme.Https})
type
  Call_SupportPlanTypesGet_593965 = ref object of OpenApiRestCall_593424
proc url_SupportPlanTypesGet_593967(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "planTypeName" in path, "`planTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Addons/supportProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/supportPlanTypes/"),
               (kind: VariableSegment, value: "planTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportPlanTypesGet_593966(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns whether or not the canonical support plan of type {type} is enabled for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planTypeName: JString (required)
  ##               : The Canonical support plan type.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `planTypeName` field"
  var valid_593981 = path.getOrDefault("planTypeName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = newJString("Essential"))
  if valid_593981 != nil:
    section.add "planTypeName", valid_593981
  var valid_593982 = path.getOrDefault("subscriptionId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "subscriptionId", valid_593982
  var valid_593983 = path.getOrDefault("providerName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "providerName", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_SupportPlanTypesGet_593965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns whether or not the canonical support plan of type {type} is enabled for the subscription.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_SupportPlanTypesGet_593965; apiVersion: string;
          subscriptionId: string; providerName: string;
          planTypeName: string = "Essential"): Recallable =
  ## supportPlanTypesGet
  ## Returns whether or not the canonical support plan of type {type} is enabled for the subscription.
  ##   planTypeName: string (required)
  ##               : The Canonical support plan type.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(path_593987, "planTypeName", newJString(planTypeName))
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  add(path_593987, "providerName", newJString(providerName))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var supportPlanTypesGet* = Call_SupportPlanTypesGet_593965(
    name: "supportPlanTypesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes/{planTypeName}",
    validator: validate_SupportPlanTypesGet_593966, base: "",
    url: url_SupportPlanTypesGet_593967, schemes: {Scheme.Https})
type
  Call_SupportPlanTypesDelete_594000 = ref object of OpenApiRestCall_593424
proc url_SupportPlanTypesDelete_594002(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "planTypeName" in path, "`planTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Addons/supportProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/supportPlanTypes/"),
               (kind: VariableSegment, value: "planTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportPlanTypesDelete_594001(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the Canonical support plan of type {type} for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planTypeName: JString (required)
  ##               : The Canonical support plan type.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `planTypeName` field"
  var valid_594003 = path.getOrDefault("planTypeName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = newJString("Essential"))
  if valid_594003 != nil:
    section.add "planTypeName", valid_594003
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  var valid_594005 = path.getOrDefault("providerName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "providerName", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_SupportPlanTypesDelete_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the Canonical support plan of type {type} for the subscription.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_SupportPlanTypesDelete_594000; apiVersion: string;
          subscriptionId: string; providerName: string;
          planTypeName: string = "Essential"): Recallable =
  ## supportPlanTypesDelete
  ## Cancels the Canonical support plan of type {type} for the subscription.
  ##   planTypeName: string (required)
  ##               : The Canonical support plan type.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(path_594009, "planTypeName", newJString(planTypeName))
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  add(path_594009, "providerName", newJString(providerName))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var supportPlanTypesDelete* = Call_SupportPlanTypesDelete_594000(
    name: "supportPlanTypesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes/{planTypeName}",
    validator: validate_SupportPlanTypesDelete_594001, base: "",
    url: url_SupportPlanTypesDelete_594002, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
