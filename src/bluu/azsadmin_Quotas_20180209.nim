
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-Quotas"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QuotasList_563778 = ref object of OpenApiRestCall_563556
proc url_QuotasList_563780(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QuotasList_563779(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_563942 = path.getOrDefault("subscriptionId")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "subscriptionId", valid_563942
  var valid_563943 = path.getOrDefault("location")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "location", valid_563943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563944 = query.getOrDefault("api-version")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "api-version", valid_563944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563971: Call_QuotasList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of existing Compute quotas.
  ## 
  let valid = call_563971.validator(path, query, header, formData, body)
  let scheme = call_563971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563971.url(scheme.get, call_563971.host, call_563971.base,
                         call_563971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563971, url, valid)

proc call*(call_564042: Call_QuotasList_563778; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## quotasList
  ## Get a list of existing Compute quotas.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_564043 = newJObject()
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  add(path_564043, "subscriptionId", newJString(subscriptionId))
  add(path_564043, "location", newJString(location))
  result = call_564042.call(path_564043, query_564045, nil, nil, nil)

var quotasList* = Call_QuotasList_563778(name: "quotasList",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas",
                                      validator: validate_QuotasList_563779,
                                      base: "", url: url_QuotasList_563780,
                                      schemes: {Scheme.Https})
type
  Call_QuotasCreateOrUpdate_564095 = ref object of OpenApiRestCall_563556
proc url_QuotasCreateOrUpdate_564097(protocol: Scheme; host: string; base: string;
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

proc validate_QuotasCreateOrUpdate_564096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a Compute Quota with the provided quota parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaName: JString (required)
  ##            : Name of the quota.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `quotaName` field"
  var valid_564098 = path.getOrDefault("quotaName")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "quotaName", valid_564098
  var valid_564099 = path.getOrDefault("subscriptionId")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "subscriptionId", valid_564099
  var valid_564100 = path.getOrDefault("location")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "location", valid_564100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564101 = query.getOrDefault("api-version")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "api-version", valid_564101
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

proc call*(call_564103: Call_QuotasCreateOrUpdate_564095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a Compute Quota with the provided quota parameters.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_QuotasCreateOrUpdate_564095; quotaName: string;
          apiVersion: string; subscriptionId: string; location: string;
          newQuota: JsonNode): Recallable =
  ## quotasCreateOrUpdate
  ## Creates or Updates a Compute Quota with the provided quota parameters.
  ##   quotaName: string (required)
  ##            : Name of the quota.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   newQuota: JObject (required)
  ##           : New quota to create.
  var path_564105 = newJObject()
  var query_564106 = newJObject()
  var body_564107 = newJObject()
  add(path_564105, "quotaName", newJString(quotaName))
  add(query_564106, "api-version", newJString(apiVersion))
  add(path_564105, "subscriptionId", newJString(subscriptionId))
  add(path_564105, "location", newJString(location))
  if newQuota != nil:
    body_564107 = newQuota
  result = call_564104.call(path_564105, query_564106, nil, nil, body_564107)

var quotasCreateOrUpdate* = Call_QuotasCreateOrUpdate_564095(
    name: "quotasCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_QuotasCreateOrUpdate_564096, base: "",
    url: url_QuotasCreateOrUpdate_564097, schemes: {Scheme.Https})
type
  Call_QuotasGet_564084 = ref object of OpenApiRestCall_563556
proc url_QuotasGet_564086(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QuotasGet_564085(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an existing Compute Quota.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaName: JString (required)
  ##            : Name of the quota.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `quotaName` field"
  var valid_564087 = path.getOrDefault("quotaName")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "quotaName", valid_564087
  var valid_564088 = path.getOrDefault("subscriptionId")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = nil)
  if valid_564088 != nil:
    section.add "subscriptionId", valid_564088
  var valid_564089 = path.getOrDefault("location")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "location", valid_564089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564090 = query.getOrDefault("api-version")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "api-version", valid_564090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564091: Call_QuotasGet_564084; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an existing Compute Quota.
  ## 
  let valid = call_564091.validator(path, query, header, formData, body)
  let scheme = call_564091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564091.url(scheme.get, call_564091.host, call_564091.base,
                         call_564091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564091, url, valid)

proc call*(call_564092: Call_QuotasGet_564084; quotaName: string; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## quotasGet
  ## Get an existing Compute Quota.
  ##   quotaName: string (required)
  ##            : Name of the quota.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_564093 = newJObject()
  var query_564094 = newJObject()
  add(path_564093, "quotaName", newJString(quotaName))
  add(query_564094, "api-version", newJString(apiVersion))
  add(path_564093, "subscriptionId", newJString(subscriptionId))
  add(path_564093, "location", newJString(location))
  result = call_564092.call(path_564093, query_564094, nil, nil, nil)

var quotasGet* = Call_QuotasGet_564084(name: "quotasGet", meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}",
                                    validator: validate_QuotasGet_564085,
                                    base: "", url: url_QuotasGet_564086,
                                    schemes: {Scheme.Https})
type
  Call_QuotasDelete_564108 = ref object of OpenApiRestCall_563556
proc url_QuotasDelete_564110(protocol: Scheme; host: string; base: string;
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

proc validate_QuotasDelete_564109(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing Compute quota.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaName: JString (required)
  ##            : Name of the quota.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `quotaName` field"
  var valid_564111 = path.getOrDefault("quotaName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "quotaName", valid_564111
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("location")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "location", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_QuotasDelete_564108; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing Compute quota.
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_QuotasDelete_564108; quotaName: string;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## quotasDelete
  ## Delete an existing Compute quota.
  ##   quotaName: string (required)
  ##            : Name of the quota.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(path_564117, "quotaName", newJString(quotaName))
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  add(path_564117, "location", newJString(location))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var quotasDelete* = Call_QuotasDelete_564108(name: "quotasDelete",
    meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute.Admin/locations/{location}/quotas/{quotaName}",
    validator: validate_QuotasDelete_564109, base: "", url: url_QuotasDelete_564110,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
