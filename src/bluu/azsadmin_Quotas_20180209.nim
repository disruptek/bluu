
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Compute Admin Client
## version: 2018-02-09
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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Quotas"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QuotasList_574680 = ref object of OpenApiRestCall_574458
proc url_QuotasList_574682(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotasList_574681(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of existing Compute quotas.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574842 = path.getOrDefault("subscriptionId")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "subscriptionId", valid_574842
  var valid_574843 = path.getOrDefault("location")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "location", valid_574843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574844 = query.getOrDefault("api-version")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "api-version", valid_574844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574871: Call_QuotasList_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of existing Compute quotas.
  ## 
  let valid = call_574871.validator(path, query, header, formData, body)
  let scheme = call_574871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574871.url(scheme.get, call_574871.host, call_574871.base,
                         call_574871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574871, url, valid)

proc call*(call_574942: Call_QuotasList_574680; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## quotasList
  ## Get a list of existing Compute quotas.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_574943 = newJObject()
  var query_574945 = newJObject()
  add(query_574945, "api-version", newJString(apiVersion))
  add(path_574943, "subscriptionId", newJString(subscriptionId))
  add(path_574943, "location", newJString(location))
  result = call_574942.call(path_574943, query_574945, nil, nil, nil)

var quotasList* = Call_QuotasList_574680(name: "quotasList",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas",
                                      validator: validate_QuotasList_574681,
                                      base: "", url: url_QuotasList_574682,
                                      schemes: {Scheme.Https})
type
  Call_QuotasCreateOrUpdate_574995 = ref object of OpenApiRestCall_574458
proc url_QuotasCreateOrUpdate_574997(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "quotaName" in path, "`quotaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotasCreateOrUpdate_574996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a Compute Quota with the provided quota parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   quotaName: JString (required)
  ##            : Name of the quota.
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
  var valid_575000 = path.getOrDefault("quotaName")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = nil)
  if valid_575000 != nil:
    section.add "quotaName", valid_575000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575001 = query.getOrDefault("api-version")
  valid_575001 = validateParameter(valid_575001, JString, required = true,
                                 default = nil)
  if valid_575001 != nil:
    section.add "api-version", valid_575001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   newQuota: JObject (required)
  ##           : New quota to create.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575003: Call_QuotasCreateOrUpdate_574995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a Compute Quota with the provided quota parameters.
  ## 
  let valid = call_575003.validator(path, query, header, formData, body)
  let scheme = call_575003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575003.url(scheme.get, call_575003.host, call_575003.base,
                         call_575003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575003, url, valid)

proc call*(call_575004: Call_QuotasCreateOrUpdate_574995; apiVersion: string;
          subscriptionId: string; newQuota: JsonNode; location: string;
          quotaName: string): Recallable =
  ## quotasCreateOrUpdate
  ## Creates or Updates a Compute Quota with the provided quota parameters.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   newQuota: JObject (required)
  ##           : New quota to create.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   quotaName: string (required)
  ##            : Name of the quota.
  var path_575005 = newJObject()
  var query_575006 = newJObject()
  var body_575007 = newJObject()
  add(query_575006, "api-version", newJString(apiVersion))
  add(path_575005, "subscriptionId", newJString(subscriptionId))
  if newQuota != nil:
    body_575007 = newQuota
  add(path_575005, "location", newJString(location))
  add(path_575005, "quotaName", newJString(quotaName))
  result = call_575004.call(path_575005, query_575006, nil, nil, body_575007)

var quotasCreateOrUpdate* = Call_QuotasCreateOrUpdate_574995(
    name: "quotasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_QuotasCreateOrUpdate_574996, base: "",
    url: url_QuotasCreateOrUpdate_574997, schemes: {Scheme.Https})
type
  Call_QuotasGet_574984 = ref object of OpenApiRestCall_574458
proc url_QuotasGet_574986(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "quotaName" in path, "`quotaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotasGet_574985(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an existing Compute Quota.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   quotaName: JString (required)
  ##            : Name of the quota.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574987 = path.getOrDefault("subscriptionId")
  valid_574987 = validateParameter(valid_574987, JString, required = true,
                                 default = nil)
  if valid_574987 != nil:
    section.add "subscriptionId", valid_574987
  var valid_574988 = path.getOrDefault("location")
  valid_574988 = validateParameter(valid_574988, JString, required = true,
                                 default = nil)
  if valid_574988 != nil:
    section.add "location", valid_574988
  var valid_574989 = path.getOrDefault("quotaName")
  valid_574989 = validateParameter(valid_574989, JString, required = true,
                                 default = nil)
  if valid_574989 != nil:
    section.add "quotaName", valid_574989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574990 = query.getOrDefault("api-version")
  valid_574990 = validateParameter(valid_574990, JString, required = true,
                                 default = nil)
  if valid_574990 != nil:
    section.add "api-version", valid_574990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574991: Call_QuotasGet_574984; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an existing Compute Quota.
  ## 
  let valid = call_574991.validator(path, query, header, formData, body)
  let scheme = call_574991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574991.url(scheme.get, call_574991.host, call_574991.base,
                         call_574991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574991, url, valid)

proc call*(call_574992: Call_QuotasGet_574984; apiVersion: string;
          subscriptionId: string; location: string; quotaName: string): Recallable =
  ## quotasGet
  ## Get an existing Compute Quota.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   quotaName: string (required)
  ##            : Name of the quota.
  var path_574993 = newJObject()
  var query_574994 = newJObject()
  add(query_574994, "api-version", newJString(apiVersion))
  add(path_574993, "subscriptionId", newJString(subscriptionId))
  add(path_574993, "location", newJString(location))
  add(path_574993, "quotaName", newJString(quotaName))
  result = call_574992.call(path_574993, query_574994, nil, nil, nil)

var quotasGet* = Call_QuotasGet_574984(name: "quotasGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}",
                                    validator: validate_QuotasGet_574985,
                                    base: "", url: url_QuotasGet_574986,
                                    schemes: {Scheme.Https})
type
  Call_QuotasDelete_575008 = ref object of OpenApiRestCall_574458
proc url_QuotasDelete_575010(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "quotaName" in path, "`quotaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute.Admin/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotasDelete_575009(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing Compute quota.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  ##   quotaName: JString (required)
  ##            : Name of the quota.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575011 = path.getOrDefault("subscriptionId")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "subscriptionId", valid_575011
  var valid_575012 = path.getOrDefault("location")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "location", valid_575012
  var valid_575013 = path.getOrDefault("quotaName")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "quotaName", valid_575013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575014 = query.getOrDefault("api-version")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "api-version", valid_575014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575015: Call_QuotasDelete_575008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing Compute quota.
  ## 
  let valid = call_575015.validator(path, query, header, formData, body)
  let scheme = call_575015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575015.url(scheme.get, call_575015.host, call_575015.base,
                         call_575015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575015, url, valid)

proc call*(call_575016: Call_QuotasDelete_575008; apiVersion: string;
          subscriptionId: string; location: string; quotaName: string): Recallable =
  ## quotasDelete
  ## Delete an existing Compute quota.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   quotaName: string (required)
  ##            : Name of the quota.
  var path_575017 = newJObject()
  var query_575018 = newJObject()
  add(query_575018, "api-version", newJString(apiVersion))
  add(path_575017, "subscriptionId", newJString(subscriptionId))
  add(path_575017, "location", newJString(location))
  add(path_575017, "quotaName", newJString(quotaName))
  result = call_575016.call(path_575017, query_575018, nil, nil, nil)

var quotasDelete* = Call_QuotasDelete_575008(name: "quotasDelete",
    meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_QuotasDelete_575009, base: "", url: url_QuotasDelete_575010,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
