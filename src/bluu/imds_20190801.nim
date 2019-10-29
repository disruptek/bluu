
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: InstanceMetadataClient
## version: 2019-08-01
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "imds"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AttestedGetDocument_563761 = ref object of OpenApiRestCall_563539
proc url_AttestedGetDocument_563763(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AttestedGetDocument_563762(path: JsonNode; query: JsonNode;
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
  var valid_563937 = query.getOrDefault("api-version")
  valid_563937 = validateParameter(valid_563937, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_563937 != nil:
    section.add "api-version", valid_563937
  var valid_563938 = query.getOrDefault("nonce")
  valid_563938 = validateParameter(valid_563938, JString, required = false,
                                 default = nil)
  if valid_563938 != nil:
    section.add "nonce", valid_563938
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_563939 = header.getOrDefault("Metadata")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = newJString("true"))
  if valid_563939 != nil:
    section.add "Metadata", valid_563939
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563962: Call_AttestedGetDocument_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Attested Data for the Virtual Machine.
  ## 
  let valid = call_563962.validator(path, query, header, formData, body)
  let scheme = call_563962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563962.url(scheme.get, call_563962.host, call_563962.base,
                         call_563962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563962, url, valid)

proc call*(call_564033: Call_AttestedGetDocument_563761;
          apiVersion: string = "2018-10-01"; nonce: string = ""): Recallable =
  ## attestedGetDocument
  ## Get Attested Data for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   nonce: string
  ##        : This is a string of up to 32 random alphanumeric characters.
  var query_564034 = newJObject()
  add(query_564034, "api-version", newJString(apiVersion))
  add(query_564034, "nonce", newJString(nonce))
  result = call_564033.call(nil, query_564034, nil, nil, nil)

var attestedGetDocument* = Call_AttestedGetDocument_563761(
    name: "attestedGetDocument", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/attested/document", validator: validate_AttestedGetDocument_563762,
    base: "/metadata", url: url_AttestedGetDocument_563763,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_IdentityGetInfo_564074 = ref object of OpenApiRestCall_563539
proc url_IdentityGetInfo_564076(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetInfo_564075(path: JsonNode; query: JsonNode;
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
  var valid_564077 = query.getOrDefault("api-version")
  valid_564077 = validateParameter(valid_564077, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_564077 != nil:
    section.add "api-version", valid_564077
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_564078 = header.getOrDefault("Metadata")
  valid_564078 = validateParameter(valid_564078, JString, required = true,
                                 default = newJString("true"))
  if valid_564078 != nil:
    section.add "Metadata", valid_564078
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564079: Call_IdentityGetInfo_564074; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about AAD Metadata
  ## 
  let valid = call_564079.validator(path, query, header, formData, body)
  let scheme = call_564079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564079.url(scheme.get, call_564079.host, call_564079.base,
                         call_564079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564079, url, valid)

proc call*(call_564080: Call_IdentityGetInfo_564074;
          apiVersion: string = "2018-10-01"): Recallable =
  ## identityGetInfo
  ## Get information about AAD Metadata
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_564081 = newJObject()
  add(query_564081, "api-version", newJString(apiVersion))
  result = call_564080.call(nil, query_564081, nil, nil, nil)

var identityGetInfo* = Call_IdentityGetInfo_564074(name: "identityGetInfo",
    meth: HttpMethod.HttpGet, host: "169.254.169.254", route: "/identity/info",
    validator: validate_IdentityGetInfo_564075, base: "/metadata",
    url: url_IdentityGetInfo_564076, schemes: {Scheme.Https, Scheme.Http})
type
  Call_IdentityGetToken_564082 = ref object of OpenApiRestCall_563539
proc url_IdentityGetToken_564084(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetToken_564083(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a Token from Azure AD
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   authority: JString
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   resource: JString (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   client_id: JString
  ##            : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   object_id: JString
  ##            : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   msi_res_id: JString
  ##             : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  ##   bypass_cache: JString
  ##               : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564085 = query.getOrDefault("api-version")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_564085 != nil:
    section.add "api-version", valid_564085
  var valid_564086 = query.getOrDefault("authority")
  valid_564086 = validateParameter(valid_564086, JString, required = false,
                                 default = nil)
  if valid_564086 != nil:
    section.add "authority", valid_564086
  var valid_564087 = query.getOrDefault("resource")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "resource", valid_564087
  var valid_564088 = query.getOrDefault("client_id")
  valid_564088 = validateParameter(valid_564088, JString, required = false,
                                 default = nil)
  if valid_564088 != nil:
    section.add "client_id", valid_564088
  var valid_564089 = query.getOrDefault("object_id")
  valid_564089 = validateParameter(valid_564089, JString, required = false,
                                 default = nil)
  if valid_564089 != nil:
    section.add "object_id", valid_564089
  var valid_564090 = query.getOrDefault("msi_res_id")
  valid_564090 = validateParameter(valid_564090, JString, required = false,
                                 default = nil)
  if valid_564090 != nil:
    section.add "msi_res_id", valid_564090
  var valid_564091 = query.getOrDefault("bypass_cache")
  valid_564091 = validateParameter(valid_564091, JString, required = false,
                                 default = newJString("true"))
  if valid_564091 != nil:
    section.add "bypass_cache", valid_564091
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_564092 = header.getOrDefault("Metadata")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = newJString("true"))
  if valid_564092 != nil:
    section.add "Metadata", valid_564092
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564093: Call_IdentityGetToken_564082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Token from Azure AD
  ## 
  let valid = call_564093.validator(path, query, header, formData, body)
  let scheme = call_564093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564093.url(scheme.get, call_564093.host, call_564093.base,
                         call_564093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564093, url, valid)

proc call*(call_564094: Call_IdentityGetToken_564082; resource: string;
          apiVersion: string = "2018-10-01"; authority: string = "";
          clientId: string = ""; objectId: string = ""; msiResId: string = "";
          bypassCache: string = "true"): Recallable =
  ## identityGetToken
  ## Get a Token from Azure AD
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   authority: string
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   resource: string (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   clientId: string
  ##           : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   objectId: string
  ##           : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   msiResId: string
  ##           : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  ##   bypassCache: string
  ##              : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  var query_564095 = newJObject()
  add(query_564095, "api-version", newJString(apiVersion))
  add(query_564095, "authority", newJString(authority))
  add(query_564095, "resource", newJString(resource))
  add(query_564095, "client_id", newJString(clientId))
  add(query_564095, "object_id", newJString(objectId))
  add(query_564095, "msi_res_id", newJString(msiResId))
  add(query_564095, "bypass_cache", newJString(bypassCache))
  result = call_564094.call(nil, query_564095, nil, nil, nil)

var identityGetToken* = Call_IdentityGetToken_564082(name: "identityGetToken",
    meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/identity/oauth2/token", validator: validate_IdentityGetToken_564083,
    base: "/metadata", url: url_IdentityGetToken_564084,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_InstancesGetMetadata_564096 = ref object of OpenApiRestCall_563539
proc url_InstancesGetMetadata_564098(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InstancesGetMetadata_564097(path: JsonNode; query: JsonNode;
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
  var valid_564099 = query.getOrDefault("api-version")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_564099 != nil:
    section.add "api-version", valid_564099
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_564100 = header.getOrDefault("Metadata")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = newJString("true"))
  if valid_564100 != nil:
    section.add "Metadata", valid_564100
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564101: Call_InstancesGetMetadata_564096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Instance Metadata for the Virtual Machine.
  ## 
  let valid = call_564101.validator(path, query, header, formData, body)
  let scheme = call_564101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564101.url(scheme.get, call_564101.host, call_564101.base,
                         call_564101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564101, url, valid)

proc call*(call_564102: Call_InstancesGetMetadata_564096;
          apiVersion: string = "2018-10-01"): Recallable =
  ## instancesGetMetadata
  ## Get Instance Metadata for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_564103 = newJObject()
  add(query_564103, "api-version", newJString(apiVersion))
  result = call_564102.call(nil, query_564103, nil, nil, nil)

var instancesGetMetadata* = Call_InstancesGetMetadata_564096(
    name: "instancesGetMetadata", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/instance", validator: validate_InstancesGetMetadata_564097,
    base: "/metadata", url: url_InstancesGetMetadata_564098,
    schemes: {Scheme.Https, Scheme.Http})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
