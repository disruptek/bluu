
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: InstanceMetadataClient
## version: 2019-06-04
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Instance Metadata Client
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

  OpenApiRestCall_573641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573641): Option[Scheme] {.used.} =
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
  macServiceName = "imds"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AttestedGetDocument_573863 = ref object of OpenApiRestCall_573641
proc url_AttestedGetDocument_573865(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AttestedGetDocument_573864(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get Attested Data for the Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   nonce: JString
  ##        : This is a string of up to 32 random alphanumeric characters.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574037 = query.getOrDefault("api-version")
  valid_574037 = validateParameter(valid_574037, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_574037 != nil:
    section.add "api-version", valid_574037
  var valid_574038 = query.getOrDefault("nonce")
  valid_574038 = validateParameter(valid_574038, JString, required = false,
                                 default = nil)
  if valid_574038 != nil:
    section.add "nonce", valid_574038
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_574039 = header.getOrDefault("Metadata")
  valid_574039 = validateParameter(valid_574039, JString, required = true,
                                 default = newJString("true"))
  if valid_574039 != nil:
    section.add "Metadata", valid_574039
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574062: Call_AttestedGetDocument_573863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Attested Data for the Virtual Machine.
  ## 
  let valid = call_574062.validator(path, query, header, formData, body)
  let scheme = call_574062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574062.url(scheme.get, call_574062.host, call_574062.base,
                         call_574062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574062, url, valid)

proc call*(call_574133: Call_AttestedGetDocument_573863;
          apiVersion: string = "2018-10-01"; nonce: string = ""): Recallable =
  ## attestedGetDocument
  ## Get Attested Data for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   nonce: string
  ##        : This is a string of up to 32 random alphanumeric characters.
  var query_574134 = newJObject()
  add(query_574134, "api-version", newJString(apiVersion))
  add(query_574134, "nonce", newJString(nonce))
  result = call_574133.call(nil, query_574134, nil, nil, nil)

var attestedGetDocument* = Call_AttestedGetDocument_573863(
    name: "attestedGetDocument", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/attested/document", validator: validate_AttestedGetDocument_573864,
    base: "/metadata", url: url_AttestedGetDocument_573865,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_IdentityGetInfo_574174 = ref object of OpenApiRestCall_573641
proc url_IdentityGetInfo_574176(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetInfo_574175(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get information about AAD Metadata
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574177 = query.getOrDefault("api-version")
  valid_574177 = validateParameter(valid_574177, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_574177 != nil:
    section.add "api-version", valid_574177
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_574178 = header.getOrDefault("Metadata")
  valid_574178 = validateParameter(valid_574178, JString, required = true,
                                 default = newJString("true"))
  if valid_574178 != nil:
    section.add "Metadata", valid_574178
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574179: Call_IdentityGetInfo_574174; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about AAD Metadata
  ## 
  let valid = call_574179.validator(path, query, header, formData, body)
  let scheme = call_574179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574179.url(scheme.get, call_574179.host, call_574179.base,
                         call_574179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574179, url, valid)

proc call*(call_574180: Call_IdentityGetInfo_574174;
          apiVersion: string = "2018-10-01"): Recallable =
  ## identityGetInfo
  ## Get information about AAD Metadata
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_574181 = newJObject()
  add(query_574181, "api-version", newJString(apiVersion))
  result = call_574180.call(nil, query_574181, nil, nil, nil)

var identityGetInfo* = Call_IdentityGetInfo_574174(name: "identityGetInfo",
    meth: HttpMethod.HttpGet, host: "169.254.169.254", route: "/identity/info",
    validator: validate_IdentityGetInfo_574175, base: "/metadata",
    url: url_IdentityGetInfo_574176, schemes: {Scheme.Https, Scheme.Http})
type
  Call_IdentityGetToken_574182 = ref object of OpenApiRestCall_573641
proc url_IdentityGetToken_574184(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetToken_574183(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a Token from Azure AD
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   object_id: JString
  ##            : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   client_id: JString
  ##            : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   resource: JString (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   bypass_cache: JString
  ##               : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  ##   authority: JString
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   msi_res_id: JString
  ##             : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  section = newJObject()
  var valid_574185 = query.getOrDefault("object_id")
  valid_574185 = validateParameter(valid_574185, JString, required = false,
                                 default = nil)
  if valid_574185 != nil:
    section.add "object_id", valid_574185
  var valid_574186 = query.getOrDefault("client_id")
  valid_574186 = validateParameter(valid_574186, JString, required = false,
                                 default = nil)
  if valid_574186 != nil:
    section.add "client_id", valid_574186
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574187 = query.getOrDefault("api-version")
  valid_574187 = validateParameter(valid_574187, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_574187 != nil:
    section.add "api-version", valid_574187
  var valid_574188 = query.getOrDefault("resource")
  valid_574188 = validateParameter(valid_574188, JString, required = true,
                                 default = nil)
  if valid_574188 != nil:
    section.add "resource", valid_574188
  var valid_574189 = query.getOrDefault("bypass_cache")
  valid_574189 = validateParameter(valid_574189, JString, required = false,
                                 default = newJString("true"))
  if valid_574189 != nil:
    section.add "bypass_cache", valid_574189
  var valid_574190 = query.getOrDefault("authority")
  valid_574190 = validateParameter(valid_574190, JString, required = false,
                                 default = nil)
  if valid_574190 != nil:
    section.add "authority", valid_574190
  var valid_574191 = query.getOrDefault("msi_res_id")
  valid_574191 = validateParameter(valid_574191, JString, required = false,
                                 default = nil)
  if valid_574191 != nil:
    section.add "msi_res_id", valid_574191
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_574192 = header.getOrDefault("Metadata")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = newJString("true"))
  if valid_574192 != nil:
    section.add "Metadata", valid_574192
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574193: Call_IdentityGetToken_574182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Token from Azure AD
  ## 
  let valid = call_574193.validator(path, query, header, formData, body)
  let scheme = call_574193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574193.url(scheme.get, call_574193.host, call_574193.base,
                         call_574193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574193, url, valid)

proc call*(call_574194: Call_IdentityGetToken_574182; resource: string;
          objectId: string = ""; clientId: string = "";
          apiVersion: string = "2018-10-01"; bypassCache: string = "true";
          authority: string = ""; msiResId: string = ""): Recallable =
  ## identityGetToken
  ## Get a Token from Azure AD
  ##   objectId: string
  ##           : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   clientId: string
  ##           : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   resource: string (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   bypassCache: string
  ##              : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  ##   authority: string
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   msiResId: string
  ##           : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  var query_574195 = newJObject()
  add(query_574195, "object_id", newJString(objectId))
  add(query_574195, "client_id", newJString(clientId))
  add(query_574195, "api-version", newJString(apiVersion))
  add(query_574195, "resource", newJString(resource))
  add(query_574195, "bypass_cache", newJString(bypassCache))
  add(query_574195, "authority", newJString(authority))
  add(query_574195, "msi_res_id", newJString(msiResId))
  result = call_574194.call(nil, query_574195, nil, nil, nil)

var identityGetToken* = Call_IdentityGetToken_574182(name: "identityGetToken",
    meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/identity/oauth2/token", validator: validate_IdentityGetToken_574183,
    base: "/metadata", url: url_IdentityGetToken_574184,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_InstancesGetMetadata_574196 = ref object of OpenApiRestCall_573641
proc url_InstancesGetMetadata_574198(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InstancesGetMetadata_574197(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Instance Metadata for the Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574199 = query.getOrDefault("api-version")
  valid_574199 = validateParameter(valid_574199, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_574199 != nil:
    section.add "api-version", valid_574199
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_574200 = header.getOrDefault("Metadata")
  valid_574200 = validateParameter(valid_574200, JString, required = true,
                                 default = newJString("true"))
  if valid_574200 != nil:
    section.add "Metadata", valid_574200
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574201: Call_InstancesGetMetadata_574196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Instance Metadata for the Virtual Machine.
  ## 
  let valid = call_574201.validator(path, query, header, formData, body)
  let scheme = call_574201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574201.url(scheme.get, call_574201.host, call_574201.base,
                         call_574201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574201, url, valid)

proc call*(call_574202: Call_InstancesGetMetadata_574196;
          apiVersion: string = "2018-10-01"): Recallable =
  ## instancesGetMetadata
  ## Get Instance Metadata for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_574203 = newJObject()
  add(query_574203, "api-version", newJString(apiVersion))
  result = call_574202.call(nil, query_574203, nil, nil, nil)

var instancesGetMetadata* = Call_InstancesGetMetadata_574196(
    name: "instancesGetMetadata", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/instance", validator: validate_InstancesGetMetadata_574197,
    base: "/metadata", url: url_InstancesGetMetadata_574198,
    schemes: {Scheme.Https, Scheme.Http})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
