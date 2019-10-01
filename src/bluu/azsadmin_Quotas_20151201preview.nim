
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Compute Admin Client
## version: 2015-12-01-preview
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
  ## Get a list of existing quotas.
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
  var valid_574857 = query.getOrDefault("api-version")
  valid_574857 = validateParameter(valid_574857, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_574857 != nil:
    section.add "api-version", valid_574857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574884: Call_QuotasList_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of existing quotas.
  ## 
  let valid = call_574884.validator(path, query, header, formData, body)
  let scheme = call_574884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574884.url(scheme.get, call_574884.host, call_574884.base,
                         call_574884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574884, url, valid)

proc call*(call_574955: Call_QuotasList_574680; subscriptionId: string;
          location: string; apiVersion: string = "2015-12-01-preview"): Recallable =
  ## quotasList
  ## Get a list of existing quotas.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_574956 = newJObject()
  var query_574958 = newJObject()
  add(query_574958, "api-version", newJString(apiVersion))
  add(path_574956, "subscriptionId", newJString(subscriptionId))
  add(path_574956, "location", newJString(location))
  result = call_574955.call(path_574956, query_574958, nil, nil, nil)

var quotasList* = Call_QuotasList_574680(name: "quotasList",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas",
                                      validator: validate_QuotasList_574681,
                                      base: "", url: url_QuotasList_574682,
                                      schemes: {Scheme.Https})
type
  Call_QuotasCreateOrUpdate_575017 = ref object of OpenApiRestCall_574458
proc url_QuotasCreateOrUpdate_575019(protocol: Scheme; host: string; base: string;
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

proc validate_QuotasCreateOrUpdate_575018(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a Quota.
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
  var valid_575020 = path.getOrDefault("subscriptionId")
  valid_575020 = validateParameter(valid_575020, JString, required = true,
                                 default = nil)
  if valid_575020 != nil:
    section.add "subscriptionId", valid_575020
  var valid_575021 = path.getOrDefault("location")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "location", valid_575021
  var valid_575022 = path.getOrDefault("quotaName")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "quotaName", valid_575022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575023 = query.getOrDefault("api-version")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_575023 != nil:
    section.add "api-version", valid_575023
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

proc call*(call_575025: Call_QuotasCreateOrUpdate_575017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a Quota.
  ## 
  let valid = call_575025.validator(path, query, header, formData, body)
  let scheme = call_575025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575025.url(scheme.get, call_575025.host, call_575025.base,
                         call_575025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575025, url, valid)

proc call*(call_575026: Call_QuotasCreateOrUpdate_575017; subscriptionId: string;
          newQuota: JsonNode; location: string; quotaName: string;
          apiVersion: string = "2015-12-01-preview"): Recallable =
  ## quotasCreateOrUpdate
  ## Creates or Updates a Quota.
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
  var path_575027 = newJObject()
  var query_575028 = newJObject()
  var body_575029 = newJObject()
  add(query_575028, "api-version", newJString(apiVersion))
  add(path_575027, "subscriptionId", newJString(subscriptionId))
  if newQuota != nil:
    body_575029 = newQuota
  add(path_575027, "location", newJString(location))
  add(path_575027, "quotaName", newJString(quotaName))
  result = call_575026.call(path_575027, query_575028, nil, nil, body_575029)

var quotasCreateOrUpdate* = Call_QuotasCreateOrUpdate_575017(
    name: "quotasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_QuotasCreateOrUpdate_575018, base: "",
    url: url_QuotasCreateOrUpdate_575019, schemes: {Scheme.Https})
type
  Call_QuotasGet_574997 = ref object of OpenApiRestCall_574458
proc url_QuotasGet_574999(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QuotasGet_574998(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an existing Quota.
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
  var valid_575009 = path.getOrDefault("subscriptionId")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = nil)
  if valid_575009 != nil:
    section.add "subscriptionId", valid_575009
  var valid_575010 = path.getOrDefault("location")
  valid_575010 = validateParameter(valid_575010, JString, required = true,
                                 default = nil)
  if valid_575010 != nil:
    section.add "location", valid_575010
  var valid_575011 = path.getOrDefault("quotaName")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "quotaName", valid_575011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575012 = query.getOrDefault("api-version")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_575012 != nil:
    section.add "api-version", valid_575012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575013: Call_QuotasGet_574997; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an existing Quota.
  ## 
  let valid = call_575013.validator(path, query, header, formData, body)
  let scheme = call_575013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575013.url(scheme.get, call_575013.host, call_575013.base,
                         call_575013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575013, url, valid)

proc call*(call_575014: Call_QuotasGet_574997; subscriptionId: string;
          location: string; quotaName: string;
          apiVersion: string = "2015-12-01-preview"): Recallable =
  ## quotasGet
  ## Get an existing Quota.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   quotaName: string (required)
  ##            : Name of the quota.
  var path_575015 = newJObject()
  var query_575016 = newJObject()
  add(query_575016, "api-version", newJString(apiVersion))
  add(path_575015, "subscriptionId", newJString(subscriptionId))
  add(path_575015, "location", newJString(location))
  add(path_575015, "quotaName", newJString(quotaName))
  result = call_575014.call(path_575015, query_575016, nil, nil, nil)

var quotasGet* = Call_QuotasGet_574997(name: "quotasGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}",
                                    validator: validate_QuotasGet_574998,
                                    base: "", url: url_QuotasGet_574999,
                                    schemes: {Scheme.Https})
type
  Call_QuotasDelete_575030 = ref object of OpenApiRestCall_574458
proc url_QuotasDelete_575032(protocol: Scheme; host: string; base: string;
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

proc validate_QuotasDelete_575031(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing quota.
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
  var valid_575033 = path.getOrDefault("subscriptionId")
  valid_575033 = validateParameter(valid_575033, JString, required = true,
                                 default = nil)
  if valid_575033 != nil:
    section.add "subscriptionId", valid_575033
  var valid_575034 = path.getOrDefault("location")
  valid_575034 = validateParameter(valid_575034, JString, required = true,
                                 default = nil)
  if valid_575034 != nil:
    section.add "location", valid_575034
  var valid_575035 = path.getOrDefault("quotaName")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "quotaName", valid_575035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575036 = query.getOrDefault("api-version")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = newJString("2015-12-01-preview"))
  if valid_575036 != nil:
    section.add "api-version", valid_575036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575037: Call_QuotasDelete_575030; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing quota.
  ## 
  let valid = call_575037.validator(path, query, header, formData, body)
  let scheme = call_575037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575037.url(scheme.get, call_575037.host, call_575037.base,
                         call_575037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575037, url, valid)

proc call*(call_575038: Call_QuotasDelete_575030; subscriptionId: string;
          location: string; quotaName: string;
          apiVersion: string = "2015-12-01-preview"): Recallable =
  ## quotasDelete
  ## Delete an existing quota.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   quotaName: string (required)
  ##            : Name of the quota.
  var path_575039 = newJObject()
  var query_575040 = newJObject()
  add(query_575040, "api-version", newJString(apiVersion))
  add(path_575039, "subscriptionId", newJString(subscriptionId))
  add(path_575039, "location", newJString(location))
  add(path_575039, "quotaName", newJString(quotaName))
  result = call_575038.call(path_575039, query_575040, nil, nil, nil)

var quotasDelete* = Call_QuotasDelete_575030(name: "quotasDelete",
    meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_QuotasDelete_575031, base: "", url: url_QuotasDelete_575032,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
